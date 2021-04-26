local Types = require(script.Parent.Types)
local Vibration = {}
Vibration.__index = Vibration

function Vibration.new(input: Enum.UserInputType, motor: Enum.VibrationMotor, sequence: Types.vibrationSequence): Types.vibration
    assert(typeof(input) == "EnumItem", "input must be a valid UserInputType!")
    assert(typeof(motor) == "EnumItem", "motor must be a valid VibrationMotor!")

    local self = setmetatable({}, Vibration)

    for index, node in pairs(sequence) do
        if node.amplitude < 0 or node.amplitude > 1 then
            error(string.format("Error in node %d: Amplitude must be between 0 and 1!", index))
        end
    end

    self.input = input
    self.motor = motor
    self._sequence = sequence

    return self
end

return Vibration