local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node

-- Get Neovim config directory
local config_dir = vim.fn.stdpath "config"

-- Get snippet type from current folder name
local current_file_path = debug.getinfo(1, "S").source:sub(2)
local snippet_type = vim.fn.fnamemodify(current_file_path, ":h:t")

-- Create paths to search for snippets
local main_dir = config_dir .. "/lua/lua_snippets/" .. snippet_type
local custom_dir = config_dir .. "-custom/lua/lua_snippets/" .. snippet_type

-- File type to search for
local file_type = "md"

-- Function to load snippets from a directory
local function load_snippets_from_dir(base_dir, snippets_table)
  local handle = io.popen('find "' .. base_dir .. '/simple" -name "*.' .. file_type .. '" -type f 2>/dev/null')

  if handle then
    for filepath in handle:lines() do
      local filename = filepath:match "([^/\\]+)$"
      local base_name = filename:match "([^%.]+)"

      -- Extract directory name relative to simple/
      local relative_path = filepath:match "/simple/(.+)/[^/]+$"
      local dir_name = relative_path and relative_path:gsub("/", "_") or ""

      -- Combine directory name with filename
      local name = dir_name ~= "" and (dir_name .. "_" .. base_name) or base_name

      local file = io.open(filepath, "r")
      if file then
        local content = file:read "*all"
        file:close()

        if content and content ~= "" then
          local lines = {}
          for line in content:gmatch "([^\n]*)\n?" do
            if line ~= "" or #lines > 0 then
              table.insert(lines, line)
            end
          end
          table.insert(snippets_table, s(name, t(lines)))
        end
      end
    end

    handle:close()
  end
end

-- Load all files as snippets
local snippets = {}

-- Load from main directory
load_snippets_from_dir(main_dir, snippets)

-- Load from custom directory
load_snippets_from_dir(custom_dir, snippets)

return snippets
