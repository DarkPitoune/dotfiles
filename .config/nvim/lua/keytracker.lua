-- Keypress Tracker for Neovim
-- Logs all keypresses to a file for later analysis

local M = {}

M.config = {
  enabled = false,
  log_file = vim.fn.stdpath("data") .. "/keytracker.log",
  include_timestamps = true,
  include_mode = true,
  buffer_size = 50, -- flush to disk every N keypresses
}

local buffer = {}
local ns_id = nil

local mode_names = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  R = "REPLACE",
  s = "SELECT",
  S = "S-LINE",
  t = "TERMINAL",
  o = "OP-PENDING",
}

local function get_mode_name()
  local mode = vim.fn.mode()
  return mode_names[mode] or mode
end

local function format_key(key)
  -- Convert special keys to readable format
  local special = vim.fn.keytrans(key)
  if special ~= "" then
    return special
  end
  return key
end

local function flush_buffer()
  if #buffer == 0 then
    return
  end

  local file = io.open(M.config.log_file, "a")
  if file then
    for _, entry in ipairs(buffer) do
      file:write(entry .. "\n")
    end
    file:close()
  end
  buffer = {}
end

local function log_key(key)
  if not M.config.enabled then
    return
  end

  local formatted_key = format_key(key)
  if formatted_key == "" then
    return
  end

  local entry = formatted_key

  if M.config.include_mode then
    entry = string.format("[%s] %s", get_mode_name(), entry)
  end

  if M.config.include_timestamps then
    entry = string.format("%s %s", os.date("%Y-%m-%d %H:%M:%S"), entry)
  end

  table.insert(buffer, entry)

  if #buffer >= M.config.buffer_size then
    flush_buffer()
  end
end

function M.start()
  if ns_id then
    vim.notify("Keytracker already running", vim.log.levels.WARN)
    return
  end

  M.config.enabled = true
  ns_id = vim.on_key(function(key)
    log_key(key)
  end)

  -- Flush buffer on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = flush_buffer,
    once = true,
  })

  vim.notify("Keytracker started. Logging to: " .. M.config.log_file, vim.log.levels.INFO)
end

function M.stop()
  if not ns_id then
    vim.notify("Keytracker not running", vim.log.levels.WARN)
    return
  end

  M.config.enabled = false
  vim.on_key(nil, ns_id)
  ns_id = nil
  flush_buffer()

  vim.notify("Keytracker stopped", vim.log.levels.INFO)
end

function M.toggle()
  if ns_id then
    M.stop()
  else
    M.start()
  end
end

function M.status()
  local status = ns_id and "running" or "stopped"
  vim.notify(string.format("Keytracker: %s | Log: %s", status, M.config.log_file), vim.log.levels.INFO)
end

function M.clear_log()
  local file = io.open(M.config.log_file, "w")
  if file then
    file:close()
    vim.notify("Keytracker log cleared", vim.log.levels.INFO)
  end
end

function M.open_log()
  vim.cmd("edit " .. M.config.log_file)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Create user commands
  vim.api.nvim_create_user_command("KeytrackerStart", M.start, {})
  vim.api.nvim_create_user_command("KeytrackerStop", M.stop, {})
  vim.api.nvim_create_user_command("KeytrackerToggle", M.toggle, {})
  vim.api.nvim_create_user_command("KeytrackerStatus", M.status, {})
  vim.api.nvim_create_user_command("KeytrackerClear", M.clear_log, {})
  vim.api.nvim_create_user_command("KeytrackerOpen", M.open_log, {})
end

return M
