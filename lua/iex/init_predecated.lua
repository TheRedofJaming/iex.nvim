local jobstart = vim.fn.jobstart
local jobstop = vim.fn.jobstop
local chan_send = vim.fn.chansend

local signal = require('posix.signal')

if chan_send then
	print('loaded...')
end

M = {
	active_sessions = {}
}

-- use nui.nvim
-- use plenary.job.nvim

local function new_session(name)
	return {
		log_entries = {},
		command_history = {},
		session_name = "a1",

		set_name = function(self, name)
			self.session_name = name
		end,

		start_iex = function(self)
			self.iex_pid = jobstart({'iex', '--sname', self.session_name}, {
				on_stdout = function(chan_id, data, name)
					print(chan_id .. " >> " .. vim.inspect(data))
					self.log_stdout({chan_id, data, name})
				end,
				on_stderr  = function(chan_id, data, name)
					self.log_stdout({chan_id, data, name})
			end,
			})
		end,

		stop_iex = function(self)
			jobstop(self.iex_pid)
		end,

		log_stdout = function(self)
			table.insert(self.log_entries, entry)
		end,

		log_command = function(self, entry)
			table.insert(self.command_history, entry)
		end,

		print_log = function(self)
			for key, value in pairs(self.log_entries) do
				print(vim.inspect(value))
			end
		end,

		-- takes a str or list of strings
		send_lines = function(self, lines)
			self.log_command(lines)
			if not lines[-1] == "\n" then
				lines = lines .. "\n"
			end

			chan_send(self.iex_pid, lines)
		end,
	}
end

function M:create_session(name)
	session = new_session(name)
	table.insert(M.active_sessions, session)
end

function M:start_all()
	for _, session in pairs(self.active_sessions) do
		session:start_iex()
	end
	print("started all")
end

function M:close_all()
	for _, session in pairs(self.active_sessions) do
		if session.iex_pid == nil then
			error("Attempted to stop not-started iex session")
			return
		end
		session:stop_iex()
	end
	self.active_sessions = {}
	print("closed all")
end

function M:list_sessions()
	for i, session in ipairs(self.active_sessions) do
		print(string.format("%d: %s", i, session.session_name))
	end
end

function M:test()
	M:create_session("1")
	M:create_session("2")
	M:start_all()
	M:list_sessions()
	M:close_all()
end

-- vim.api.nvim_create_user_command(
	-- "StartIEX",
	-- M.start_iex,
	-- { nargs = 0}
-- )
-- vim.api.nvim_create_user_command(
	-- "StopIEX",
	-- M.stop_iex,
	-- { nargs = 0}
-- )

return M
