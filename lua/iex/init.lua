
local signal = require 'posix.signal'
local Job = require 'plenary.job'

session_name = "a1"
iex = Job:new({
	command = "iex",
	args = {},
	on_stdout = function(err, out) 
		print(err)
		print(out)
	end,
	on_exit = function(J, return_val)
		print(return_val)
		print(J:result())
	end,
})
local function iex_menu()
	signal.kill(iex.pid, signal.SIGINT)
end

local function start_iex()
	iex:start()
end

local function stop()
	iex:shutdown()
end

--@class Iex_Wrapper
--@field sessions list Session
--@field active_session Session


--@class  Session 		 : Single Iex session
--@method start() 		 : start the session
--@method stop() 		 : stop session
--@method submit(string)	 : submit a line to Iex 
--@field  PID int
--@field  output list[string]    : output of this session by line
--@field  error_log list[string]
