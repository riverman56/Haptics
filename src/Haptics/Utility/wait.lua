local RunService = game:GetService("RunService")

local function wait(seconds: number)
    while seconds > 0 do
        seconds -= RunService.Heartbeat:Wait()
    end
end

return wait