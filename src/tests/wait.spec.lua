local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
    local wait

    it("should load successfully", function()
        wait = require(ReplicatedStorage.Haptics.Utility.wait)
    end)

    it("should yield", function()
        local co = coroutine.create(function()
            wait(3)
        end)

        coroutine.resume(co)

        expect(coroutine.status(co)).never.to.equal("dead")
    end)

    it("should not yield if seconds is 0", function()
        local co = coroutine.create(function()
            wait(0)
        end)

        coroutine.resume(co)

        expect(coroutine.status(co)).to.equal("dead")
    end)
end