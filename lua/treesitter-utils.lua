local M = {}

---@param node TSNode
---@param bufnr number | nil
---@return number, number, number, number
local get_node_range = function(node, bufnr)
  local bufnr = bufnr or 0
  local sr, sc, er, ec = node:range()
  local last_row = vim.api.nvim_buf_line_count(bufnr) - 1
  -- If the node is the last node in the buffer, then its end row and column might need
  -- to be adjusted to avoid out-of-bounds error when calling nvim_buf_[set|get]_text
  if er > last_row then
    er = last_row
    ec = #vim.api.nvim_buf_get_lines(bufnr, last_row, last_row + 1, false)[1]
  end
  return sr, sc, er, ec
end

--- Find parent node of given type.
---@param node TSNode
---@param type string
---@return TSNode | nil
M.find_parent_node = function(node, type)
  if (node == node:root()) then return nil end
  if (node:type() == type) then return node end
  return M.find_parent_node(node:parent(), type)
end

--- Find child node of given type.
---@param node TSNode
---@param type string
---@return TSNode | nil
M.find_child_node = function(node, type)
  local child = node:child(0)
  while child do
    if (child:type() == type) then return child end
    child = child:next_sibling()
  end
  return nil
end

--- Set text of given node.
---@param node TSNode
---@param text string | table
---@param bufnr number | nil
M.set_node_text = function(node, text, bufnr)
  local sr, sc, er, ec = get_node_range(node, bufnr)
  local content = { text }
  if (type(text) == 'table') then content = text end
  vim.api.nvim_buf_set_text(bufnr or 0, sr, sc, er, ec, content)
end

--- Get text of given node.
---@param node TSNode
---@param bufnr number | nil
---@return string[]
M.get_node_text = function(node, bufnr)
  local sr, sc, er, ec = get_node_range(node, bufnr)
  return vim.api.nvim_buf_get_text(bufnr or 0, sr, sc, er, ec, {})
end

return M
