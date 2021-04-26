--[[
    Adapted from https://github.com/Roblox/rodux/blob/45c106f09c58f706a7ea458c6ff17914dd9a22c6/src/Signal.lua

    Adapted from Roblox Corporation. Licensed under the MIT license.

    "A limited, simple implementation of a Signal.

	Handlers are fired in order, and (dis)connections are properly handled when
	executing an event."
]]

local function immutableAppend(list: table, ...: any)
	local new = {}
	local len = #list

	for key = 1, len do
		new[key] = list[key]
	end

	for i = 1, select("#", ...) do
		new[len + i] = select(i, ...)
	end

	return new
end

local function immutableRemoveValue(list: table, removeValue: any)
	local new = {}

	for i = 1, #list do
		if list[i] ~= removeValue then
			table.insert(new, list[i])
		end
	end

	return new
end

local Signal = {}

Signal.__index = Signal

function Signal.new()
	local self = {
		_listeners = {}
	}

	setmetatable(self, Signal)

	return self
end

function Signal:connect(callback: () -> any)
	local listener = {
		callback = callback,
		disconnected = false,
	}

	self._listeners = immutableAppend(self._listeners, listener)

	local function disconnect()
        assert(not listener.disconnected, "You may only disconnest listeners once.")

		listener.disconnected = true
		self._listeners = immutableRemoveValue(self._listeners, listener)
	end

	return {
		disconnect = disconnect
	}
end

function Signal:_fire(...: any)
	for _, listener in ipairs(self._listeners) do
		if not listener.disconnected then
			listener.callback(...)
		end
	end
end

return Signal