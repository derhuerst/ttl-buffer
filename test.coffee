sinon =				require 'sinon'

ttlBuffer =			require './index.js'





clock = null

module.exports =

	setUp:    (cb) -> clock = sinon.useFakeTimers(); cb()
	tearDown: (cb) -> clock.restore();               cb()



	'uses the `initialValue` passed': (test) ->
		b = ttlBuffer initialValue: 1
		test.strictEqual b + 0, 1
		test.done()

	'accepts and call a custom `in` function': (test) ->
		spy = sinon.spy()
		b = ttlBuffer in: spy
		b.push 1
		test.strictEqual spy.callCount, 1
		test.done()

	'accepts and call a custom `out` function after the `ttl`': (test) ->
		spy = sinon.spy()
		b = ttlBuffer out: spy, ttl: 1000
		b.push 1
		clock.tick 1000
		test.strictEqual spy.callCount, 1
		test.done()

	'uses the return value of the `in` function as new value': (test) ->
		b = ttlBuffer in: (-> 3), initialValue: 0
		test.notStrictEqual b + 0, 3
		b.push 0
		test.strictEqual b + 0, 3
		test.done()

	'uses the return value of the `out` function as new value': (test) ->
		b = ttlBuffer out: (-> 3), initialValue: 0
		b.push 0
		test.notStrictEqual b + 0, 3
		clock.tick 1000
		test.strictEqual b + 0, 3
		test.done()

	'call the `in` function with the previous value & the entry': (test) ->
		spy = sinon.spy()
		ttlBuffer(in: spy, initialValue: 1).push 2
		test.strictEqual spy.callCount, 1
		test.strictEqual spy.firstCall.args[0], 1
		test.strictEqual spy.firstCall.args[1], 2
		test.done()

	'call the `out` function with the previous value & the entry': (test) ->
		spy = sinon.spy()
		ttlBuffer(in: (-> 2), out: spy, ttl: 300).push 1
		clock.tick 300
		test.strictEqual spy.callCount, 1
		test.strictEqual spy.firstCall.args[0], 2
		test.strictEqual spy.firstCall.args[1], 1
		test.done()
