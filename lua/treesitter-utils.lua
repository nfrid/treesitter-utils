require('treesitter-utils.types')

local M = {}

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
---@param text string
---@param bufnr number | nil
M.set_node_text = function(node, text, bufnr)
  local sr, sc, er, ec = node:range()
  vim.api.nvim_buf_set_text(bufnr or 0, sr, sc, er, ec, { text })
end

return M
