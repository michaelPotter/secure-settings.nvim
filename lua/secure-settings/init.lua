local _ = require('secure-settings.underscore')

local M = {}

local default_settings = {
	file_patterns = {
		"~/.ssh/*",
		"~/.aws/*",
	},
	notify = true,
}

M.configured_settings = default_settings

-- This function secures the current buffer
M.secure_buffer = function(bufnr)
	bufnr = bufnr or 0
	vim.api.nvim_buf_call(bufnr, function()
		if vim.b.secured_buffer then
			return
		end
		-- Buffer settings
		vim.bo.swapfile = false
		vim.bo.undofile = false
		vim.b.copilot_enabled = false

		vim.b.secured_buffer = true

		if M.configured_settings.notify then
			vim.notify("Buffer local secure settings applied.", vim.log.levels.WARN,
				{ title = "Buffer Secure Settings Applied" })
		end
	end)
end

-- Set certain global settings to secure the session. This may not be desired
-- when editing other non-secret files in the same session, as the settings
-- here may increase risk of data loss.
M.secure_session = function(opts)
	if vim.g.secured_session then
		return
	end
	opts = opts or {}

	vim.o.backup = false
	vim.o.writebackup = false
	vim.o.shada = ""

	vim.g.secured_session = true
	if M.configured_settings.notify then
		vim.notify(
			"Vim session is secured. Certain session settings have been applied that may interfere with modifying other files.",
			vim.log.levels.WARN, { title = "Session Secure Settings Applied" })
	end
end

M.setup = function(opts)
	M.configured_settings = vim.tbl_extend("force", default_settings, opts or {})
	local file_patterns = _.join(M.configured_settings.file_patterns, ",")

	-- vim.notify(vim.inspect(files))

	vim.cmd(string.format("autocmd VimEnter %s :lua require('secure-settings').secure_session()", file_patterns))
	vim.cmd(string.format("autocmd BufEnter %s :lua require('secure-settings').secure_buffer()", file_patterns))
end

return M
