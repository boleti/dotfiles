
-- Terminal
local function toggle_term_height()
  local current_win = vim.api.nvim_get_current_win()
  local current_height = vim.api.nvim_win_get_height(current_win)
  
  if current_height < vim.o.lines - 4 then
    -- Maximize: Set height to almost full screen
    vim.api.nvim_win_set_height(current_win, vim.o.lines - 4)
  else
    -- Restore: Set back to default NvChad terminal height
    vim.api.nvim_win_set_height(current_win, math.floor(vim.o.lines * 0.4))
  end
end

return toggle_term_height
