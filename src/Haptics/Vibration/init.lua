local Types = require(script.Parent.Types)
local Vibration = {}
Vibration.__index = Vibration

-- TODO HPTCS-5: Have Vibration accept multiple inputs/motors
-- TODO HPTCS-7: Have Vibrations constructible by sounds
function Vibration.new(input: Enum.UserInputType, motor: Enum.VibrationMotor, sequence: Types.vibrationSequence): Types.vibration
    assert(typeof(input) == "EnumItem", "input must be a valid UserInputType!")
    assert(typeof(motor) == "EnumItem", "motor must be a valid VibrationMotor!")

    local self = setmetatable({}, Vibration)

    for index, node in pairs(sequence) do
        if node.amplitude < 0 or node.amplitude > 1 then
            error(string.format("Error in node %d: Amplitude must be between 0 and 1.", index))
        end
        
        if node.length < 0 then
            error(string.format("Error in node %d: Node length cannot be less than 0.", index))
        end

        if node.delay and node.delay < 0 then
            error(string.format("Error in node %d: Node delay cannot be less than 0.", index))
        end
    end

    self.input = input
    self.motor = motor
    self._sequence = sequence

    return self
end

return Vibration