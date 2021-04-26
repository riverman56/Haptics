local ReplicatedStorage = game:GetService("ReplicatedStorage")

return function()
	local signal
    local createSpy

    it("should load successfully", function()
        signal = require(ReplicatedStorage.Haptics.Utility.signal)
        createSpy = require(ReplicatedStorage.tests.helpers.createSpy)
    end)

	it("should construct a signal from nothing", function()
		local newSignal = signal.new()

		expect(newSignal).to.be.ok()
	end)

	it("should fire and disconnect connections", function()
		local newSignal = signal.new()
		local spy = createSpy()

		local connection = newSignal:connect(spy.value)

		expect(spy.callCount).to.equal(0)

		local a = 123
		local b = {}
		local c = "blargh"

		newSignal:_fire(a, b, c)

		expect(spy.callCount).to.equal(1)
		spy:assertCalledWith(a, b, c)

		connection:disconnect()

		newSignal:_fire(c, b, a)

		expect(spy.callCount).to.equal(1)
	end)

	it("should throw if a connection is disconnected more than once", function()
	    local newSignal = signal.new()

		local connection = newSignal:connect(function()
		end)

		expect(function()
			connection:disconnect()
		end).never.to.throw()

		expect(function()
			connection:disconnect()
		end).to.throw()
	end)

	it("should fire connections in order", function()
		local newSignal = signal.new()

		local x = 0
		local y = 0

		callback1 = function()
			expect(x).to.equal(0)
			expect(y).to.equal(0)

			x += 1
		end

		callback2 = function()
			expect(x).to.equal(1)
			expect(y).to.equal(0)

			y += 1
		end

		newSignal:connect(callback1)
		newSignal:connect(callback2)
		newSignal:_fire()

		expect(x).to.equal(1)
		expect(y).to.equal(1)
	end)

	it("should continue firing in order despite mid-event disconnection", function()
		local newSignal = signal.new()

		local x = 0
		local y = 0

		local connection
		connection = newSignal:connect(function()
			connection:disconnect()
			x += 1
		end)

		newSignal:connect(function()
			y += 1
		end)

		newSignal:_fire()

		expect(x).to.equal(1)
		expect(y).to.equal(1)
	end)

	it("should skip listeners that were disconnected during firing", function()
		local newSignal = signal.new()

		local x = 0
		local y = 0

		local connection

		newSignal:connect(function()
			x += 1
			connection:disconnect()
		end)

		connection = newSignal:connect(function()
			y += 1
		end)

		newSignal:_fire()

		expect(x).to.equal(1)
		expect(y).to.equal(0)
	end)
end
