local Haptics = require(script.Parent.Parent)

local impact = Haptics.Vibration.new(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, {
    {
        amplitude = 0.5,
        length = 0.1,
    },
})

return impact