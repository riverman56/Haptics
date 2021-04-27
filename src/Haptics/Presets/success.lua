local Vibration = require(script.Parent.Parent.Vibration)

local impact = Vibration.new(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, {
    {
        amplitude = 0.5,
        length = 0.07,
        delay = 0.02
    },
    {
        amplitude = 0.75,
        length = 0.15,
    },
})

return impact