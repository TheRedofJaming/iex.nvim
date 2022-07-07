--- NVIM IEX ---
-- TODO Follow Documentation Style https://github.com/lunarmodules/LDoc





local signal = require 'posix.signal'
local Job = require 'plenary.job'

session_name = "a1"

--- Single IEX Session.
-- Enables writing to, and reading from iex
--@field  process : IEX process
--@field  PID 
--@field  output : output of this session by line
--@field  error_log

local IEX_Session = {}
IEX_Session.__index = IEX_Session


function IEX_Session:new(options)





	local new_iex_session = {}
	new_iex_session.process = Job:new({
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
	return setmetatable(new_iex_session, self)
end

function IEX_Session:start_iex()
	self.iex:start()
end

function IEX_Session:stop()
	self.iex:shutdown()
end


--@class IEX_Wrapper
--@field sessions list Session
--@field active_session Session



--@class  IEX_gui
--@method iex_menu 		 : control the IEX menu (shutdown, dump ...)
--@method option_helper		 : window to set new options for IEX sessions
--				   -v and -h are unnessacerry here
function IEX_gui:iex_menu(pid)
	signal.kill(pid, signal.SIGINT)
end

function IEX_gui:option_helper()
--- Options
-- ## General options
-- 
  -- -e "COMMAND"                 Evaluates the given command (*)
  -- -r "FILE"                    Requires the given files/patterns (*)
  -- -S SCRIPT                    Finds and executes the given script in $PATH
  -- -pr "FILE"                   Requires the given files/patterns in parallel (*)
  -- -pa "PATH"                   Prepends the given path to Erlang code path (*)
  -- -pz "PATH"                   Appends the given path to Erlang code path (*)
-- 
  -- --app APP                    Starts the given app and its dependencies (*)
  -- --erl "SWITCHES"             Switches to be passed down to Erlang (*)
  -- --eval "COMMAND"             Evaluates the given command, same as -e (*)
  -- --logger-otp-reports BOOL    Enables or disables OTP reporting
  -- --logger-sasl-reports BOOL   Enables or disables SASL reporting
  -- --no-halt                    Does not halt the Erlang VM after execution
  -- --werl                       Uses Erlang's Windows shell GUI (Windows only)
-- 
-- Options given after the .exs file or -- are passed down to the executed code.
-- Options can be passed to the Erlang runtime using $ELIXIR_ERL_OPTIONS or --erl.
-- 
-- ## Distribution options
-- 
-- The following options are related to node distribution.
-- 
  -- --cookie COOKIE              Sets a cookie for this distributed node
  -- --hidden                     Makes a hidden node
  -- --name NAME                  Makes and assigns a name to the distributed node
  -- --rpc-eval NODE "COMMAND"    Evaluates the given command on the given remote node (*)
  -- --sname NAME                 Makes and assigns a short name to the distributed node
-- 
-- ## Release options
-- 
-- The following options are generally used under releases.
-- 
  -- --boot "FILE"                Uses the given FILE.boot to start the system
  -- --boot-var VAR "VALUE"       Makes $VAR available as VALUE to FILE.boot (*)
  -- --erl-config "FILE"          Loads configuration in FILE.config written in Erlang (*)
  -- --pipe-to "PIPEDIR" "LOGDIR" Starts the Erlang VM as a named PIPEDIR and LOGDIR
  -- --vm-args "FILE"             Passes the contents in file as arguments to the VM
end

