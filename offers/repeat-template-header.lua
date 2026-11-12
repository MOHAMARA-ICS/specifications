local function is_document_header(block)
  return block.t == "RawBlock"
    and block.format == "html"
    and block.text:match('<header class="document%-header">')
end

local function wrapper_style()
  return pandoc.RawBlock("html", [[<style>
table.repeating-document {
  display: table;
  width: 100%;
  margin: 0;
  border: 0;
  border-collapse: collapse;
  table-layout: fixed;
}
table.repeating-document > thead { display: table-header-group; }
table.repeating-document > tbody {
  display: table-row-group;
  margin: 0;
  border: 0;
}
table.repeating-document > thead > tr > td,
table.repeating-document > tbody > tr > td {
  padding: 0;
  border: 0;
  vertical-align: top;
}
table.repeating-document > thead > tr { break-inside: avoid; }
</style>]])
end

function Pandoc(document)
  local blocks = pandoc.List()
  local found_header = false
  for _, block in ipairs(document.blocks) do
    if is_document_header(block) then
      if not found_header then
        found_header = true
        blocks:insert(wrapper_style())
        blocks:insert(pandoc.RawBlock("html", '<table class="repeating-document"><thead><tr><td>'))
        blocks:insert(block)
        blocks:insert(pandoc.RawBlock("html", '</td></tr></thead><tbody><tr><td>'))
      end
    else
      blocks:insert(block)
    end
  end
  assert(found_header, "The template document-header table was not found")
  blocks:insert(pandoc.RawBlock("html", '</td></tr></tbody></table>'))
  document.blocks = blocks
  return document
end