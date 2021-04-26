local HapticService = game:GetService("HapticService")

local Types = require(script.Parent.Types)
local wait = require(script.Parent.Utility.wait)
local signal = require(script.Parent.Utility.signal)

local Engine = {}
Engine.__index = Engine

function Engine.new()
    local self = setmetatable({}, Engine)

    local hardwareCapabilities = {}

    for _, inputType in pairs(Enum.UserInputType:GetEnumItems()) do
            if HapticService:IsVibrationSupported(inputType) then
                local supportedVibrations = {}

                for _, vibration in pairs(Enum.VibrationMotor:GetEnumItems()) do
                    if HapticService:IsMotorSupported(inputType, vibration) then
                        table.insert(supportedVibrations, vibration)
                    end
                end

                if #supportedVibrations > 0 then
                    hardwareCapabilities[inputType] = supportedVibrations
                end
            end
    end

    self.vibrationBegan = signal.new()
    self.vibrationCompleted = signal.new()

    self.hardwareCapabilities = hardwareCapabilities

    return self
end

function Engine:getCapability(input: Enum.UserInputType, motor: Enum.VibrationMotor): boolean
    return HapticService:IsMotorSupported(input, motor)
end

function Engine:vibrate(vibration: Types.vibration)
    self._isRunning = true

    if not self:getCapability(vibration.input, vibration.motor) then
        return
    end

    self.vibrated:_fire()

    coroutine.wrap(function()
        for _, node in pairs(vibration._sequence) do
            if self._isRunning then
                HapticService:SetMotor(vibration.input, vibration.motor, node.amplitude)
                wait(node.length)

                if node.delay and node.delay > 0 then
                    HapticService:SetMotor(vibration.input, vibration.motor, 0)
                    wait(node.delay)
                end
            end
        end

        HapticService:SetMotor(vibration.input, vibration.motor, 0)

        self.vibrationCompleted:_fire()

        self._isRunning = false
    end)()
end

function Engine:destroy()
    self._isRunning = false
end

return Engine