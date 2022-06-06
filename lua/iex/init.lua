jobstart = vim.fn.jobstart
jobstop = vim.fn.jobstop
chan_send = vim.fn.chansend
if chan_send then
	print('loaded...')
end

M = {}
M.log_entries = {}
M.command_history = {}
M.session_name = "a1"

function M:set_name(name)
	M.session_name = name
end

function M:start_iex()
	M.iex_pid = jobstart({'iex', '--sname', M.session_name}, {
		on_stdout = function(chan_id, data, name)
			print(chan_id .. " >> " .. vim.inspect(data))
			M:log_stdout({chan_id, data, name})
		end,
		on_stderr  = function(chan_id, data, name)
			M:log_stdout({chan_id, data, name})
		end,
	})
end

function M:stop_iex()
	jobstop(M.iex_pid)
end

function M:log_stdout(entry)
	table.insert(M.log_entries, entry)
end

function M:log_command(entry)
	table.insert(M.command_history, entry)
end

function M:print_log()
	for key, value in pairs(M.log_entries) do
		print(vim.inspect(value))
	end
end

-- takes a line (str) or list of strings
function M:send_lines(lines)
	M:log_command(lines)
	lines = lines .. "\n"
	chan_send(M.iex_pid, lines)
end

vim.api.nvim_create_user_command(
	"StartIEX",
	M.start_iex,
	{ nargs = 0}
)
vim.api.nvim_create_user_command(
	"StopIEX",
	M.stop_iex,
	{ nargs = 0}
)

return M
