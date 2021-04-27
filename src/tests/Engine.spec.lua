local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
    local Engine = require(ReplicatedStorage.Haptics.Engine)

    describe("new", function()
        it("should properly construct a new Engine", function()
            expect(Engine.new()).to.be.ok()
        end)
    end)

    describe("vibrate", function()
        it("should vibrate", function()
            expect(function()
                local engine = Engine.new()
                local impact = require(ReplicatedStorage.Haptics.Presets.impact)

                engine:vibrate(impact)
            end).never.to.throw()
        end)

        it("should reject incorrect types", function()
            expect(function()
                Engine.new():vibrate(5)
            end).to.throw()

            expect(function()
                Engine.new():vibrate("blargh")
            end).to.throw()
        end)

        it("should properly fire engine signals", function()
            local engine = Engine.new()
            local impact = require(ReplicatedStorage.Haptics.Presets.impact)

            local x = 0

            engine.vibrationBegan:connect(function()
                x += 1
            end)

            engine:vibrate(impact)

            expect(x).to.equal(1)
        end)
    end)

    describe("getCapability", function()
        it("should never throw with correct usage parameters", function()
            expect(function()
                local engine = Engine.new()
                
                engine:getCapability(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Small)
            end).never.to.throw()

            expect(function()
                local engine = Engine.new()

                engine:getCapability(Enum.UserInputType.Gamepad5, Enum.VibrationMotor.LeftTrigger)
            end).never.to.throw()
        end)

        it("should throw if incorrect parameters are passed", function()
            expect(function()
                local engine = Engine.new()

                engine:getCapability(123, Enum.FriendStatus.Unknown)
            end).to.throw()

            expect(function()
                local engine = Engine.new()

                engine:getCapability("blargh", {})
            end).to.throw()
        end)
    end)
end