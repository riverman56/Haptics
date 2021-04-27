local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
    local Vibration = require(ReplicatedStorage.Haptics.Vibration)

    describe("new", function()
        it("should throw if incorrect parameters are passed", function()
            expect(function()
                Vibration.new(0, 5, {})
            end).to.throw()
        end)

        it("should construct a Vibration successfully if the correct paremeters are passed", function()
            expect(function()
                Vibration.new(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, {
                    {
                        amplitude = 0.3,
                        length = 1,
                    },
                })
            end).never.to.throw()
        end)

        it("should throw if length or delay times are negative, or if amplitude is outside 0-1", function()
            expect(function()
                Vibration.new(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, {
                    {
                        amplitude = 1,
                        length = -0.5,
                    },
                })
            end).to.throw()

            expect(function()
                Vibration.new(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, {
                    {
                        amplitude = 1.1,
                        length = 0.5,
                    },
                })
            end).to.throw()

            expect(function()
                Vibration.new(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.LeftTrigger, {
                    {
                        amplitude = 0.5,
                        length = 0.25,
                        delay = -1,
                    },
                })
            end).to.throw()
        end)
    end)
end