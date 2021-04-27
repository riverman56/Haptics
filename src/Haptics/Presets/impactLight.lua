local Vibration = require(script.Parent.Parent.Vibration)

local impact = Vibration.new(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, {
    {
        amplitude = 0.25,
        length = 0.07,
    },
})

return impact