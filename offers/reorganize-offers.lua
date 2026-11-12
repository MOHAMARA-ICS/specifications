local function find_header(blocks, identifier)
  for index, block in ipairs(blocks) do
    if block.t == "Header" and block.identifier == identifier then return index end
  end
end

local function section_end(blocks, start)
  local level = blocks[start].level
  for index = start + 1, #blocks do
    local block = blocks[index]
    if block.t == "Header" and block.level <= level then return index end
  end
  return #blocks + 1
end

local function extract_section(blocks, identifier)
  local start = find_header(blocks, identifier)
  assert(start, "Missing section: " .. identifier)
  local finish = section_end(blocks, start)
  local before, section, after = pandoc.List(), pandoc.List(), pandoc.List()
  for index = 1, start - 1 do before:insert(blocks[index]) end
  for index = start, finish - 1 do section:insert(blocks[index]) end
  for index = finish, #blocks do after:insert(blocks[index]) end
  return before, section, after
end

local function flatten(blocks, target)
  for _, block in ipairs(blocks) do target:insert(block) end
end

local function logo_data_uri()
  local file = io.open("assets/bouygues-telecom.png", "rb")
    or io.open("offers/assets/bouygues-telecom.png", "rb")
  assert(file, "Missing Bouygues Telecom logo asset")
  local content = file:read("*a")
  file:close()
  return "data:image/png;base64," .. pandoc.pipe("base64", {"-w", "0"}, content)
end

local function remove_section(blocks, identifier)
  local before, section, after = extract_section(blocks, identifier)
  local rest = pandoc.List()
  flatten(before, rest)
  flatten(after, rest)
  return rest, section
end

local function set_heading(blocks, level, title, identifier)
  local heading = blocks[1]
  assert(heading and heading.t == "Header")
  heading.level = level
  heading.content = pandoc.Inlines({pandoc.Str(title)})
  heading.identifier = identifier
  return blocks
end

local function visit_headers(blocks, callback)
  for _, block in ipairs(blocks) do
    if block.t == "Header" then
      callback(block)
    elseif block.t == "Div" and not block.classes:includes("spec-contents") then
      visit_headers(block.content, callback)
    elseif block.t == "BlockQuote" then
      visit_headers(block.content, callback)
    elseif block.t == "BulletList" or block.t == "OrderedList" then
      for _, item in ipairs(block.content) do visit_headers(item, callback) end
    end
  end
end

local function collect_old_numbers(document, numbers)
  document:walk({
    Link = function(link)
      local label = pandoc.utils.stringify(link.content)
      local number = label:match("^(%d[%d%.]*)")
      if number then number = number:gsub("%.$", "") end
      local identifier = link.target:match("^#(.+)$")
      if number and identifier then numbers[number] = identifier end
      return link
    end
  })
end

local function numbered_headers(blocks)
  local numbers, counters = {}, {0, 0, 0, 0, 0, 0}
  visit_headers(blocks, function(block)
    if block.level <= 3 and not block.classes:includes("unnumbered")
      and not block.classes:includes("unlisted") then
      counters[block.level] = counters[block.level] + 1
      for level = block.level + 1, 6 do counters[level] = 0 end
      local parts = {}
      for level = 1, block.level do table.insert(parts, tostring(counters[level])) end
      numbers[block.identifier] = table.concat(parts, ".")
    end
  end)
  return numbers
end

local function make_contents(blocks)
  local lines, counters = {}, {0, 0, 0, 0, 0, 0}
  visit_headers(blocks, function(block)
    if block.level <= 3 and not block.classes:includes("unnumbered")
      and not block.classes:includes("unlisted") then
      counters[block.level] = counters[block.level] + 1
      for level = block.level + 1, 6 do counters[level] = 0 end
      local parts = {}
      for level = 1, block.level do table.insert(parts, tostring(counters[level])) end
      local label = pandoc.utils.stringify(block.content):gsub("([%[%]])", "\\%1")
      table.insert(lines, string.rep("    ", block.level - 1) .. "- ["
        .. table.concat(parts, ".") .. ". " .. label .. "](#" .. block.identifier .. ")")
    end
  end)
  return pandoc.read(table.concat(lines, "\n"), "markdown").blocks
end

local function update_reference_number(link, old_numbers, new_numbers)
  local identifier = link.target:match("^#(.+)$")
  if not identifier then return link end
  local old_label = pandoc.utils.stringify(link.content)
  local new_number = new_numbers[identifier]
  if not new_number then return link end
  local prefix, old_number, suffix = old_label:match("^(.-)(%d[%d%.]*)(.*)$")
  if old_number and not old_numbers[old_number] then old_number = old_number:gsub("%.$", "") end
  if old_number and old_numbers[old_number] == identifier then
    link.content = pandoc.Inlines({pandoc.Str(prefix .. new_number .. suffix)})
  end
  return link
end

local function update_plain_section_refs(block, old_numbers, new_numbers)
  local inlines = block.content
  for index, inline in ipairs(inlines) do
    if inline.t == "Str" and inline.text:lower():match("section$") then
      local next_index = index + 1
      while inlines[next_index] and inlines[next_index].t == "Space" do next_index = next_index + 1 end
      local following = inlines[next_index]
      if following and following.t == "Str" then
        local number, suffix = following.text:match("^(%d[%d%.]*)(.*)$")
        if number and not old_numbers[number] then number = number:gsub("%.$", "") end
        local identifier = number and old_numbers[number]
        if identifier and new_numbers[identifier] then following.text = new_numbers[identifier] .. suffix end
      end
    end
  end
  block.content = inlines
  return block
end

local function content_div(document, identifier)
  for index, block in ipairs(document.blocks) do
    if block.t == "Div" and block.classes:includes("technical-content") then
      for _, child in ipairs(block.content) do
        if child.t == "Header" and child.identifier == identifier then return block, index end
      end
    end
  end
end

function Pandoc(document)
  local old_numbers = {}
  collect_old_numbers(document, old_numbers)

  local introduction_div, introduction_index = content_div(document, "introduction")
  local use_cases_div, use_cases_index = content_div(document, "uses-cases")
  assert(introduction_div and use_cases_div, "Missing technical page sections")
  local header_template = introduction_div.content[1]
  if header_template.format == "html" then
    header_template.text = header_template.text:gsub("STBL %- nPFS %- DALI<br>Subscriptions Offers", "STBL - Subscriptions Offers")
  end

  local intro_content = pandoc.List()
  for index = 2, #introduction_div.content do intro_content:insert(introduction_div.content[index]) end
  local intro_before, solution, intro_after = extract_section(intro_content, "solution-concept")
  local solution_work = pandoc.List()
  flatten(solution, solution_work)
  local global_architecture
  solution_work, global_architecture = remove_section(solution_work, "global-architecture")
  local lifecycle
  solution_work, lifecycle = remove_section(solution_work, "life-cycle-of-an-offer")
  local global_management
  solution_work, global_management = remove_section(solution_work, "global-management")
  local access_items
  solution_work, access_items = remove_section(solution_work, "access-to-offer-items")

  local service = pandoc.List()
  intro_before[1].content = pandoc.Inlines({pandoc.Str("Service overview")})
  intro_before[1].identifier = "introduction"
  flatten(intro_before, service)
  solution_work[1].level = 2
  solution_work[1].content = pandoc.Inlines({pandoc.Str("Architecture and responsibilities")})
  solution_work[1].identifier = "solution-concept"
  flatten(solution_work, service)
  flatten(global_architecture, service)
  flatten(access_items, service)
  set_heading(lifecycle, 2, "Offer lifecycle", "life-cycle-of-an-offer")
  flatten(lifecycle, service)
  flatten(intro_after, service)

  local use_content = pandoc.List()
  for index = 2, #use_cases_div.content do use_content:insert(use_cases_div.content[index]) end
  local use_prefix, retrieval, user_content = extract_section(use_content, "retrieving-the-offer-list")
  local retrieval_work = pandoc.List()
  flatten(retrieval, retrieval_work)
  local partner_journey
  retrieval_work, partner_journey = remove_section(retrieval_work, "user-journey")
  local fluid_offers
  retrieval_work, fluid_offers = remove_section(retrieval_work, "management-of-fluid-and-non-fluid-offers.")
  local display_examples
  retrieval_work, display_examples = remove_section(retrieval_work, "using-metadata-for-the-ui-interface-1")

  local api = pandoc.List({pandoc.Header(1, "Offer retrieval and data model", pandoc.Attr("uses-cases"))})
  set_heading(global_management, 2, "Shared DALI request headers", "global-management")
  flatten(global_management, api)
  for index = 2, #use_prefix do api:insert(use_prefix[index]) end
  retrieval_work[1].level = 2
  retrieval_work[1].content = pandoc.Inlines({pandoc.Str("Retrieve the offer list")})
  retrieval_work[1].identifier = "retrieving-the-offer-list"
  flatten(retrieval_work, api)
  set_heading(display_examples, 3, "Display metadata and illustrative examples", "using-metadata-for-the-ui-interface-1")
  flatten(display_examples, api)

  local user_journeys = pandoc.List({pandoc.Header(1, "User journeys", pandoc.Attr("user-journeys"))})
  flatten(user_content, user_journeys)
  local partner_blocks = pandoc.List({pandoc.Header(2, "Partner application activation", pandoc.Attr("partner-application-activation"))})
  set_heading(partner_journey, 3, "Activation status and partner journey", "user-journey")
  set_heading(fluid_offers, 3, "Fluid and non-fluid offers", "management-of-fluid-and-non-fluid-offers.")
  flatten(partner_journey, partner_blocks)
  flatten(fluid_offers, partner_blocks)
  local partner_insert = #user_journeys + 1
  for index, block in ipairs(user_journeys) do
    if block.t == "Header" and block.identifier == "customer-journey-adaptation-after-subscription" then
      partner_insert = index
      break
    end
  end
  for index = #partner_blocks, 1, -1 do user_journeys:insert(partner_insert, partner_blocks[index]) end

  local blocks = pandoc.List()
  for index = 1, introduction_index - 1 do
    local block = document.blocks[index]
    if block.t == "Div" and block.classes:includes("technical-content") then
      for child_index, child in ipairs(block.content) do
        if child.t == "Header" and child.identifier == "purpose-of-the-document" then
          local notice = pandoc.Div({pandoc.Para({pandoc.Str("Reorganization draft for review. This copy changes the document structure and section references; functional rules remain unchanged. Open clarification notes are retained. Screen and UI illustrations are examples only.")})}, pandoc.Attr("", {"review-note"}))
          block.content:insert(child_index + 1, notice)
          break
        end
      end
    end
    blocks:insert(block)
  end
  service:insert(1, header_template:clone())
  blocks:insert(pandoc.Div(service, pandoc.Attr("", {"next-page", "technical-content"})))
  blocks:insert(pandoc.Div(api, pandoc.Attr("", {"next-page", "technical-content"})))
  blocks:insert(pandoc.Div(user_journeys, pandoc.Attr("", {"next-page", "technical-content"})))
  for index = use_cases_index + 1, #document.blocks do blocks:insert(document.blocks[index]) end
  local metadata_grid = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" preserveAspectRatio="none"><path d="M0 25.5H100 M0 50.5H100 M0 75.5H100" fill="none" stroke="#000" stroke-width="0.8"/></svg>'
  local metadata_grid_uri = metadata_grid:gsub("([^A-Za-z0-9%-%._~])", function(character)
    return string.format("%%%02X", string.byte(character))
  end)
  local title_grid = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 440 100" preserveAspectRatio="none"><rect x="0.5" y="0.5" width="439" height="99" fill="white" stroke="black" stroke-width="1"/><path d="M0 25.5H440" stroke="black" stroke-width="0.8"/><text x="220" y="12.5" text-anchor="middle" dominant-baseline="middle" font-family="Arial" font-weight="700" font-size="14">Spécifications Fonctionnelles</text><text x="220" y="62.5" text-anchor="middle" dominant-baseline="middle" font-family="Arial" font-weight="700" font-size="20">STBL - Subscriptions Offers</text></svg>'
  local title_grid_uri = title_grid:gsub("([^A-Za-z0-9%-%._~])", function(character)
    return string.format("%%%02X", string.byte(character))
  end)
  local running_header = [[
  @top-left {
    content: "";
    width: 35mm;
    height: 25mm;
    vertical-align: middle;
    background-image: url("]] .. logo_data_uri() .. [[");
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    border: 1px solid black;
  }
  @top-center {
    content: "";
    width: auto;
    height: 25mm;
    background-image: url("data:image/svg+xml,]] .. title_grid_uri .. [[");
    background-size: 100% 100%;
    background-repeat: no-repeat;
  }
  @top-right {
    content: "\A DPPS\A V2.2\A 10/11/2026";
    white-space: pre;
    width: 35mm;
    height: 25mm;
    font: bold 8pt/6mm Arial, sans-serif;
    text-align: center;
    vertical-align: middle;
    border: 1px solid black;
    background-image: url("data:image/svg+xml,]] .. metadata_grid_uri .. [[");
    background-size: 100% 100%;
    background-repeat: no-repeat;
  }
]]
  local running_footer = [[
  @bottom-left {
    content: "Propriété de Bouygues Telecom - Diffusion INTERNE";
    font: bold 8pt Arial, sans-serif;
    border-top: 1px solid black;
  }
  @bottom-right {
    content: "Page " counter(page) " sur " counter(pages);
    font: bold 8pt Arial, sans-serif;
    border-top: 1px solid black;
  }
]]
  local running_style = [[<style>
@page {
  size: A4;
  margin: 40mm 15mm 18mm;
]] .. running_header .. running_footer .. [[}
@page technical {
  size: A4;
  margin: 40mm 15mm 18mm;
]] .. running_header .. running_footer .. [[}
@media print {
  .technical-content { page: technical; }
  .document-header { display: none !important; }
}
</style>]]
  blocks:insert(pandoc.RawBlock("html", running_style))

  local structure = pandoc.Pandoc(blocks, document.meta)
  structure = structure:walk({
    Header = function(header)
      if header.identifier == "using-metadata-for-the-ui-interface" then
        header.content = pandoc.Inlines({pandoc.Str("BOUQUET display metadata and examples")})
      end
      return header
    end
  })
  local new_numbers = numbered_headers(structure.blocks)
  structure = structure:walk({
    Link = function(link) return update_reference_number(link, old_numbers, new_numbers) end,
    Para = function(block) return update_plain_section_refs(block, old_numbers, new_numbers) end,
    Plain = function(block) return update_plain_section_refs(block, old_numbers, new_numbers) end,
    Div = function(block)
      if block.classes:includes("spec-contents") then
        local contents = pandoc.List()
        for _, child in ipairs(block.content) do
          if child.t == "Header" then contents:insert(child) end
        end
        flatten(make_contents(structure.blocks), contents)
        block.content = contents
        return block
      end
    end
  })
  structure.meta.title = pandoc.MetaString("STBL - Subscriptions Offers - v2.2 Reorganization Draft")
  return structure
end