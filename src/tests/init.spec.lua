local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
    it("should load successfully", function()
        require(ReplicatedStorage.Haptics)
    end)
end