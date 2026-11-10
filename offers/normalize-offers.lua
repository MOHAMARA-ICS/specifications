local function text(value)
  local normalized = pandoc.utils.stringify(value):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  return normalized
end

local function append_blocks(target, blocks)
  for _, block in ipairs(blocks) do
    if block.t == "BlockQuote" then
      append_blocks(target, block.content)
    else
      target:insert(block)
    end
  end
end

local function markdown_table(headers, rows)
  local lines = {"| " .. table.concat(headers, " | ") .. " |"}
  local separators = {}
  for _ in ipairs(headers) do table.insert(separators, "---") end
  table.insert(lines, "| " .. table.concat(separators, " | ") .. " |")
  for _, row in ipairs(rows) do
    local cells = {}
    for _, cell in ipairs(row) do
      local escaped = cell:gsub("|", "&#124;")
      table.insert(cells, escaped)
    end
    table.insert(lines, "| " .. table.concat(cells, " | ") .. " |")
  end
  return pandoc.read(table.concat(lines, "\n"), "markdown").blocks[1]
end

local function cover_data(cover)
  local history = {}
  local mode = "protection"
  local signing = pandoc.List()
  for _, body in ipairs(cover.bodies) do
    for _, row in ipairs(body.body) do
      local values = {}
      for _, cell in ipairs(row.cells) do table.insert(values, text(cell.contents)) end
      local value = table.concat(values, " "):gsub("%s+$", "")
      if value == "VERSIONS HISTORY" then
        mode = "history"
      elseif value == "DOCUMENT ESTABLISHED UNDER THE RESPONSIBILITY OF SIGNING" then
        mode = "signing"
      elseif mode == "history" and value ~= "" and not value:match("^INDICE") then
        local cells = {}
        for _, cell in ipairs(row.cells) do table.insert(cells, text(cell.contents)) end
        if cells[1] ~= "" then
          table.insert(history, cells)
        elseif #history > 0 then
          for index, cell in ipairs(cells) do
            if cell ~= "" then
              local previous = history[#history][index]
              history[#history][index] = previous == "" and cell or previous .. " " .. cell
            end
          end
        end
      elseif mode == "signing" and value ~= "" then
        for _, cell in ipairs(row.cells) do append_blocks(signing, cell.contents) end
      end
    end
  end
  local signatures = {}
  for index = 1, 3 do
    signatures[index] = text(signing[2 * index + 2]) .. "<br>" .. text(signing[2 * index + 3]) .. "<br>" .. text(signing[index + 9])
  end
  return {
    history = history,
    signing = markdown_table({text(signing[1]), text(signing[2]), text(signing[3])}, {signatures})
  }
end

local levels = {
  ["datamodel-specific-to-the-bouquet-type"] = 5,
  ["using-metadata-for-the-ui-interface"] = 5,
  ["datamodel-specific-to-the-application-type"] = 5,
  ["user-journey"] = 5,
  ["management-of-fluid-and-non-fluid-offers."] = 5,
  ["datamodel-specific-to-the-unmanaged_application-type"] = 5
}

local function sentence_case(header)
  local preserved = {
    API = true, UI = true, CUP = true,
    BOUQUET = true, APPLICATION = true, UNMANAGED_APPLICATION = true,
    SERVICE = true, MULTIOFFER = true,
    D = true, DORCEL = true, Canal = true, nPVR = true
  }
  local first_word = true
  header = header:walk({
    Str = function(inline)
      inline.text = inline.text:gsub("[%a_][%w_]*", function(word)
        local normalized = preserved[word] and word or word:lower()
        if first_word and not preserved[word] then
          normalized = normalized:gsub("^%a", string.upper)
        end
        first_word = false
        return normalized
      end)
      return inline
    end
  })
  local last = header.content[#header.content]
  if last and last.t == "Str" then
    last.text = last.text:gsub("[%.:]+$", "")
    if last.text == "" then header.content:remove(#header.content) end
  end
  return header
end

function Pandoc(document)
  local blocks = pandoc.List()
  local control
  local started = false
  for _, block in ipairs(document.blocks) do
    if not started and block.t == "Table" then
      control = cover_data(block)
    elseif block.t == "Header" then
      started = true
      if text(block.content) ~= "" then
        block.level = levels[block.identifier] or block.level
        blocks:insert(sentence_case(block))
      elseif #block.content > 0 then
        blocks:insert(pandoc.Para(block.content))
      end
    elseif started then
      blocks:insert(block)
    end
  end
  assert(control, "Missing document control table")
  local reference_blocks = pandoc.List()
  local technical_blocks = pandoc.List()
  local in_references = false
  for _, block in ipairs(blocks) do
    if block.t == "Header" and block.level == 1 then
      in_references = block.identifier == "references"
    end
    if in_references then
      if block.t ~= "Header" then reference_blocks:insert(block) end
    else
      technical_blocks:insert(block)
    end
  end
  local contents = {"- [1. Références](#references)"}
  local counters = {0, 0, 0, 0, 0, 0}
  counters[1] = 1
  for _, block in ipairs(technical_blocks) do
    if block.t == "Header" then
      counters[block.level] = counters[block.level] + 1
      for level = block.level + 1, 6 do counters[level] = 0 end
      local numbers = {}
      for level = 1, block.level do table.insert(numbers, tostring(counters[level])) end
      local label = text(block.content):gsub("%[", "\\["):gsub("%]", "\\]")
      if block.level <= 3 then
        table.insert(contents, string.rep("    ", block.level - 1) .. "- [" .. table.concat(numbers, ".") .. ". " .. label .. "](#" .. block.identifier .. ")")
      end
    end
  end
  local template_file = assert(io.open("../template/template-specification.md", "r"))
  local template_source = template_file:read("*a")
  template_file:close()
  local template = pandoc.read(template_source, "markdown-smart-markdown_in_html_blocks")
  local history_headers = {"INDICE", "DATE", "LIST OF MODIFICIATIONS", "WRITING", "VERIF.", "APPRO."}
  template = template:walk({
    RawBlock = function(block)
      if block.format == "html" then
        if block.text:match("^<!%-%-") then return {} end
        block.text = block.text:gsub("%[TITRE DU DOCUMENT%]", "STBL - nPFS - DALI<br>Subscriptions Offers")
          :gsub("%[VERSION%]", "2.1"):gsub("%[JJ/MM/AAAA%]", "06/10/2026")
      end
      return block
    end,
    Div = function(block)
      if block.classes:includes("versions") then
        block.content[2] = markdown_table(history_headers, control.history)
      elseif block.classes:includes("signing") then
        block.content[2] = control.signing
      elseif block.classes:includes("references") then
        local updated = pandoc.List()
        for _, child in ipairs(block.content) do
          if child.t == "Header" then
            child.content = pandoc.Inlines({pandoc.Str("Références")})
            child.identifier = "references"
            updated:insert(child)
          elseif child.t == "Table" then
            updated:extend(reference_blocks)
          else
            updated:insert(child)
          end
        end
        block.content = updated
      elseif block.classes:includes("next-page") then
        block.classes:insert("spec-contents")
        for _, child in ipairs(block.content) do
          if child.t == "Header" then
            child.classes:insert("unnumbered")
            child.classes:insert("unlisted")
            child.attributes.style = "text-align: left;"
          end
        end
        block.content:extend(pandoc.read(table.concat(contents, "\n"), "markdown").blocks)
      end
      return block
    end
  })
  for _, block in ipairs(template.blocks) do
    if block.t == "Div" and (block.classes:includes("data-protection") or block.classes:includes("versions") or block.classes:includes("signing")) then
      block.content[1].classes:insert("unnumbered")
      block.content[1].classes:insert("unlisted")
    end
  end
  local header
  for _, block in ipairs(template.blocks) do
    if block.t == "RawBlock" and block.text:match('<header class="document%-header">') then
      header = block
      break
    end
  end
  assert(header, "Missing template header")
  local section
  for _, block in ipairs(technical_blocks) do
    if block.t == "Header" and block.level == 1 then
      section = pandoc.Div({header:clone()}, pandoc.Attr("", {"next-page", "technical-content"}))
      template.blocks:insert(section)
    end
    assert(section, "Technical content must start with a heading")
    section.content:insert(block)
  end
  template.blocks:insert(pandoc.RawBlock("html", [[<style>
.versions th:nth-child(-n+2), .versions td:nth-child(-n+2) { text-align: center; }
.spec-contents ul { list-style: none; padding-left: 5mm; margin: 1mm 0; }
.spec-contents > ul { padding-left: 0; }
.spec-contents li { font-size: 9pt; margin-bottom: 1mm; }
.technical-content h1, .references h1 { margin: 0 0 6mm; font-size: 16pt; }
.technical-content h2 { margin: 6mm 0 3mm; padding: 0; font-size: 13pt; text-align: left; }
.technical-content h3 { margin: 5mm 0 3mm; font-size: 11pt; }
.technical-content h4, .technical-content h5, .technical-content h6 { margin: 4mm 0 2mm; font-size: 10pt; }
.technical-content h1, .technical-content h2, .technical-content h3, .technical-content h4, .technical-content h5, .technical-content h6 { break-after: avoid; padding: 0; font-weight: bold; font-style: normal; text-align: left; line-height: 1.25; }
.technical-content .header-section-number, .references .header-section-number { display: inline-block; margin-right: 0.75em; }
.technical-content table { margin: 3mm 0 5mm; font-size: 8pt; line-height: 1.3; }
.technical-content th, .technical-content td { padding: 1.2mm 1.6mm; vertical-align: top; }
.technical-content td p, .technical-content th p { margin: 0 0 0.8mm; }
.technical-content td p:last-child, .technical-content th p:last-child { margin-bottom: 0; }
.technical-content td ul, .technical-content td ol { margin: 0.5mm 0; padding-left: 4mm; }
.technical-content td blockquote { margin: 0; padding: 0; border: 0; }
.technical-content code { font-family: "DejaVu Sans Mono", monospace; font-size: 8pt; white-space: normal; overflow-wrap: anywhere; }
.technical-content pre { margin: 3mm 0; padding: 2.5mm; background: #f3f4f4; border: 0.5pt solid #c5cbcb; font-size: 8pt; line-height: 1.35; }
.technical-content pre code { white-space: pre-wrap; }
.technical-content img { max-width: 100%; max-height: 205mm; height: auto !important; object-fit: contain; }
.technical-content .document-header img { width: 34mm; }
.technical-content blockquote { margin: 3mm 0 3mm 4mm; }
.technical-content pre { white-space: pre-wrap; overflow-wrap: anywhere; }
.technical-content p { orphans: 3; widows: 3; }
.technical-content .mark, .technical-content mark { background: transparent; color: inherit; }
</style>]]))
  document.meta = pandoc.Meta({
    title = pandoc.MetaString("STBL - nPFS - DALI - Subscriptions Offers - v2.1"),
    lang = pandoc.MetaString("en")
  })
  document.blocks = template.blocks
  return document
end