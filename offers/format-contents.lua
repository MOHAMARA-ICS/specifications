local pages = {}
local destinations = os.getenv("CONTENTS_DESTINATIONS")
local source = destinations and io.open(destinations, "r")
if source then
  for line in source:lines() do
    local page, identifier = line:match('^%s*(%d+)%s+%[.-%]%s+"(.*)"%s*$')
    if page then pages[identifier] = page end
  end
  source:close()
end

local function entries(list, level, rows)
  for _, item in ipairs(list.content) do
    for _, block in ipairs(item) do
      if block.t == "BulletList" then
        if level < 3 then entries(block, level + 1, rows) end
      elseif block.t == "Plain" or block.t == "Para" then
        for _, inline in ipairs(block.content) do
          if inline.t == "Link" then
            local identifier = inline.target:match("^#(.*)$")
            assert(identifier, "Contents entry must link to a heading")
            assert(not source or pages[identifier], "Missing PDF destination: " .. identifier)
            local link = inline:clone()
            link.content = pandoc.Inlines({
              pandoc.Span(inline.content, pandoc.Attr("", {"toc-label"})),
              pandoc.Span({}, pandoc.Attr("", {"toc-leader"})),
              pandoc.Span(pandoc.Inlines({pandoc.Str(pages[identifier] or "0")}), pandoc.Attr("", {"toc-page"}))
            })
            local html = pandoc.write(pandoc.Pandoc({pandoc.Plain({link})}), "html")
            table.insert(rows, '<li class="toc-level-' .. level .. '">' .. html .. '</li>')
          end
        end
      end
    end
  end
end

function Header(header)
  if header.level > 3 then
    if not header.classes:includes("unnumbered") then header.classes:insert("unnumbered") end
    if not header.classes:includes("unlisted") then header.classes:insert("unlisted") end
  end
  return header
end

function Div(block)
  if not block.classes:includes("spec-contents") then return nil end
  local content = pandoc.List()
  for _, child in ipairs(block.content) do
    if child.t == "Header" then
      child.attributes.style = "text-align: left;"
      content:insert(child)
    elseif child.t == "BulletList" then
      local rows = {}
      entries(child, 1, rows)
      content:insert(pandoc.RawBlock("html", '<nav class="latex-contents" aria-label="Table of contents"><ol>\n' .. table.concat(rows, "\n") .. '\n</ol></nav>'))
    else
      content:insert(child)
    end
  end
  content:insert(pandoc.RawBlock("html", [[<style>
.spec-contents .latex-contents ol { list-style: none; padding: 0; margin: 0; }
.spec-contents .latex-contents li { margin: 0 0 2mm; font-size: 10pt; line-height: 1.35; break-inside: avoid; }
.latex-contents a { display: flex; align-items: baseline; gap: 2mm; color: black; text-decoration: none; text-align: left; }
.latex-contents .toc-label { flex: 0 1 auto; min-width: 0; }
.latex-contents .toc-leader { flex: 1 0 5mm; border-bottom: 1px dotted black; }
.latex-contents .toc-page { flex: 0 0 3ch; text-align: right; font-variant-numeric: tabular-nums; }
.latex-contents .toc-level-1 { font-weight: bold; }
.latex-contents .toc-level-2 { padding-left: 6mm; }
.latex-contents .toc-level-3 { padding-left: 12mm; }
</style>]]))
  block.content = content
  return block
end