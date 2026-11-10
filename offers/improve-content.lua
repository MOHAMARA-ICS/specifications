local function text(value)
  local result = pandoc.utils.stringify(value):gsub("\194\160", " ")
  return result
end

local function json_block(value)
  local formatted = pandoc.pipe("node", {"-e", [[
const fs = require('node:fs');
try {
  process.stdout.write(JSON.stringify(JSON.parse(fs.readFileSync(0, 'utf8')), null, 2));
} catch {
  process.exit(1);
}
]]}, value)
  return pandoc.CodeBlock(formatted, pandoc.Attr("", {"json"}))
end

local function paragraph(block)
  local value = text(block)
  if value == "It will deta" then return {} end
  local method, path, remainder = value:match("^API%s*:%s*(%u+)%s+(%S+)(.*)$")
  if method and (method == "GET" or method == "POST" or method == "PUT" or method == "DELETE" or method == "PATCH") then
    local result = pandoc.List({pandoc.CodeBlock(method .. " " .. path, pandoc.Attr("", {"http"}))})
    local example = remainder:match("Example:%s*({.*})%s*$")
    if example then
      result:insert(pandoc.Para({pandoc.Str("Example:")}))
      result:insert(json_block(example))
    elseif remainder:match("%S") then
      result:insert(pandoc.Para({pandoc.Str(remainder:gsub("^%s+", ""))}))
    end
    return result
  end
  if value:lower():match("^http code %d+$") then
    return pandoc.Para({pandoc.Code(value)})
  end
end

local function compact(blocks)
  local result = pandoc.List()
  for _, block in ipairs(blocks) do
    if block.t == "Para" or block.t == "Plain" then
      if text(block):match("%S") then result:insert(block) end
    else
      result:insert(block)
    end
  end
  return result
end

local function format_table(value)
  local heading = value.head.rows[1]
  if not heading then return nil end
  local first = text(heading.cells[1].contents)
  if first == "" or first == "Ref" then return nil end
  if #value.colspecs == 1 and first:match("RESPONSE") then
    local blocks = pandoc.List()
    for _, row in ipairs(value.head.rows) do
      for _, cell in ipairs(row.cells) do blocks:extend(compact(cell.contents)) end
    end
    for _, body in ipairs(value.bodies) do
      for _, row in ipairs(body.body) do
        for _, cell in ipairs(row.cells) do blocks:extend(compact(cell.contents)) end
      end
    end
    return pandoc.Div(blocks, pandoc.Attr("", {"api-response"}))
  end
  local fields = first == "Key in JSONbody.data" or first == "Field"
  local parameters = first == "Parameter" or first == "Param"
  local widths
  if fields and #value.colspecs == 4 then
    widths = {0.30, 0.12, 0.07, 0.51}
  elseif parameters and #value.colspecs == 3 then
    widths = first == "Parameter" and {0.24, 0.38, 0.38} or {0.24, 0.23, 0.53}
  elseif first == "PFSPxyCode" and #value.colspecs == 5 then
    widths = {0.13, 0.10, 0.22, 0.22, 0.33}
  end
  if widths then
    for index, width in ipairs(widths) do value.colspecs[index] = {value.colspecs[index][1], width} end
  end
  for _, body in ipairs(value.bodies) do
    local rows = pandoc.List()
    for _, row in ipairs(body.body) do
      local populated = false
      for index, cell in ipairs(row.cells) do
        cell.contents = compact(cell.contents)
        if parameters and index > 1 then
          local grouped = pandoc.List()
          for _, block in ipairs(cell.contents) do
            local previous = grouped[#grouped]
            local label = text(block)
            if previous and (previous.t == "Para" or previous.t == "Plain") and (block.t == "Para" or block.t == "Plain") and (label:match('^"') or label:match("^category=")) then
              previous.content:insert(pandoc.Space())
              previous.content:extend(block.content)
            else
              grouped:insert(block)
            end
          end
          cell.contents = grouped
        end
        local label = text(cell.contents)
        if label:match("%S") then populated = true end
        if (fields or parameters) and index == 1 and label:match("%S") and not label:match("^See ") then
          cell.contents = pandoc.Blocks({pandoc.Plain({pandoc.Code(label)})})
        elseif fields and index == 2 and #cell.contents == 1 then
          cell.contents = pandoc.Blocks({pandoc.Plain({pandoc.Code(label)})})
        end
      end
      if populated then rows:insert(row) end
    end
    body.body = rows
  end
  return value
end

local function json_sequences(blocks)
  local result = pandoc.List()
  local index = 1
  while index <= #blocks do
    local block = blocks[index]
    if (block.t == "Para" or block.t == "Plain") and text(block) == "{" then
      local lines = {}
      local last = index
      local parsed
      while last <= #blocks do
        local part = blocks[last]
        if part.t ~= "Para" and part.t ~= "Plain" then break end
        table.insert(lines, text(part))
        if text(part):match("}%s*$") then
          local success, candidate = pcall(json_block, table.concat(lines, "\n"))
          if success then parsed = candidate; break end
        end
        last = last + 1
      end
      assert(parsed, "Unable to parse the source JSON example; preserve and inspect the source before exporting")
      result:insert(parsed)
      index = last + 1
    else
      result:insert(block)
      index = index + 1
    end
  end
  return result
end

return {
  {
    Span = function(span)
      if span.classes:includes("mark") then return span.content end
    end,
    Para = paragraph,
    Table = format_table
  },
  {Blocks = json_sequences}
}