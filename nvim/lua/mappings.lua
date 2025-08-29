require "nvchad.mappings"

local start_python_debug = require "configs.python_debug"
local toggle_term_height = require "configs.term_maximize"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Debug
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Toggle Breakpoint" })
map("n", "<leader>dc", "<cmd> DapContinue <CR>", { desc = "Continue Debug" })
map("n", "<leader>dt", "<cmd> DapTerminate <CR>", { desc = "Terminate Debug" })
map("n", "<leader>df", "<cmd> DapStepOut <CR>", { desc = "Step out Debug" })
map("n", "<leader>di", "<cmd> DapStepInto <CR>", { desc = "Step into Debug" })
map("n", "<leader>do", "<cmd> DapStepOver <CR>", { desc = "Step over Debug" })

map("n", "<leader>dn", start_python_debug, { desc = "New Debug Session with Args" })
map("n", "<leader>dd", "<cmd>Telescope diagnostics<CR>", { desc = "Show Diagnostics" })

-- Terminal mode mapping
map("t", "<A-m>", toggle_term_height, { desc = "Toggle maximize horizontal terminal" })
