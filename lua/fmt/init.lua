local M = {}

local config = {
	formatters = {},
}

local format = function(formatter)
	local input = vim.api.nvim_buf_get_lines(0, 0, -1, true)
	local output = vim.fn.systemlist(formatter, input)

	if vim.v.shell_error ~= 0 then
		vim.notify(table.concat(output, '\n'), vim.log.levels.ERROR)
		return
	end

	vim.api.nvim_buf_set_lines(0, 0, -1, false, output)
end

M.setup = function(c)
	assert(c, 'no config provided')
	config.formatters = vim.tbl_extend('force', config.formatters, c.formatters)

	local o = c.options or {}
	if o.create_autocmd then
		vim.api.nvim_create_autocmd('BufWritePre', {
			group = vim.api.nvim_create_augroup('fmt_on_buf_write_pre', { clear = true }),
			callback = function(opts)
				local filetype = vim.bo[opts.buf].filetype
				local formatter = config.formatters[filetype]
				if formatter == nil then return end

				format(formatter)
			end,
		})
	end
end

M.format = function()
	local filetype = vim.bo.filetype
	local formatter = config.formatters[filetype]
	if formatter == nil then
		vim.notify('No formatter is registered for filetype ' .. filetype, vim.log.levels.ERROR)
		return
	end

	format(formatter)
end

return M
