-- TODO: make pr to nvim-treesitter to add proper types

---@class TSNode
---@field parent function
---@field root function(idx?: number): TSNode | nil
---@field child function(idx?: number): TSNode | nil
---@field type function(): string
---@field range function(): string
