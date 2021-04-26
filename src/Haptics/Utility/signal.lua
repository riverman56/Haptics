local Types = require(script.Parent.Parent.Types)

local signal = {}
local connection = {}
signal.__index = signal
connection.__index = connection

local function addToMap(map: table, addKey: any, addValue: any): table
	local new = {}

	for key, value in pairs(map) do
		new[key] = value
	end

	new[addKey] = addValue

	return new
end

local function removeFromMap(map: table, removeKey: any): table
	local new = {}

	for key, value in pairs(map) do
		if key ~= removeKey then
			new[key] = value
		end
	end

	return new
end

function signal.new()
    local self = {
        connections = {},
    }

    setmetatable(self, signal)

    return self
end

function signal:_fire(...)
    for callback, _connection in pairs(self.connections) do
        if _connection.connected == true then
            callback(...)
        end
    end
end

function signal:connect(callback: () -> any)
    local newConnection = connection.new(callback)

    self.connections = addToMap(self.connections, callback, newConnection)

    return newConnection
end

function connection.new(callback: () -> any, signal)
    local self = {
        connected = true,
        callback = callback,
        signal = signal,
    }

    setmetatable(self, connection)

    return self
end

function connection:disconnect()
    assert(self.connected, "Connections may only be disconnected once")

    self.connected = false
    self.signal.connections = removeFromMap(self.callback)
end

return signal