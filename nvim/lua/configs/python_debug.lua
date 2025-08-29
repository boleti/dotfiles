

-- Configure Python adapter for nvim-dap
local dap = require('dap')
dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

-- Function to start debug session with args
local function start_python_debug()
  -- Get input in the format "python path/to/script.py arg1 arg2..."
  local cmd_string = vim.fn.input('Command: ')
  if cmd_string == '' then
    return
  end

  -- Split the command into parts
  local parts = {}
  for part in string.gmatch(cmd_string, "%S+") do
    table.insert(parts, part)
  end

  -- Handle the case where "python" is included or not
  local program_start = 1
  if parts[1] == "python" then
    program_start = 2
  end

  -- Get the program path and args
  local program = parts[program_start]
  local args = {}
  for i = program_start + 1, #parts do
    table.insert(args, parts[i])
  end

  -- If the program path is relative, make it absolute
  if not vim.fn.match(program, "^/") == 0 then
    -- Get the current working directory
    local cwd = vim.fn.getcwd()
    program = cwd .. "/" .. program
  end

  local dap = require('dap')

  
  -- Get the active conda environment's Python path
  local function get_conda_python()
    -- Get conda info in JSON format
    local conda_info = vim.fn.system('conda info --json')
    if vim.v.shell_error ~= 0 then
      print("Error: Conda not found or not activated")
      return nil
    end
    
    local info = vim.fn.json_decode(conda_info)
    if info.active_prefix then
      return info.active_prefix .. '/bin/python'
    end
    
    print("Warning: No active conda environment found")
    return nil
  end

  -- Configure the debug launch with args
  local config = {
    type = 'python',
    request = 'launch',
    name = 'Launch file with args',
    program = program,
    args = args,
    cwd = vim.fn.getcwd(),  -- Set working directory to current directory
    pythonPath = get_conda_python(),
    env = vim.fn.environ(),  -- Pass through environment variables
  }
  
  dap.run(config)
end

return start_python_debug

