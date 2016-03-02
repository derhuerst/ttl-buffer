assert =			require 'assert'
sinon =				require 'sinon'

ttlBuffer =			require '../index.js'





describe 'ttlBuffer', ->

	clock = null
	before -> clock = sinon.useFakeTimers()
	after -> clock.restore()



	it 'uses the `initialValue` passed', ->
		b = ttlBuffer initialValue: 1
		assert.strictEqual b + 0, 1

	it 'accepts and call a custom `in` function', ->
		spy = sinon.spy()
		b = ttlBuffer in: spy
		b.push 1
		assert.strictEqual spy.callCount, 1

	it 'accepts and call a custom `out` function after the `ttl`', ->
		spy = sinon.spy()
		b = ttlBuffer out: spy, ttl: 1000
		b.push 1
		clock.tick 1000
		assert.strictEqual spy.callCount, 1

	it 'uses the return value of the `in` function as new value', ->
		b = ttlBuffer in: (-> 3), initialValue: 0
		assert.notStrictEqual b + 0, 3
		b.push 0
		assert.strictEqual b + 0, 3

	it 'uses the return value of the `out` function as new value', ->
		b = ttlBuffer out: (-> 3), initialValue: 0
		b.push 0
		assert.notStrictEqual b + 0, 3
		clock.tick 1000
		assert.strictEqual b + 0, 3

	it 'call the `in` function with the previous value & the entry', ->
		spy = sinon.spy()
		ttlBuffer(in: spy, initialValue: 1).push 2
		assert.strictEqual spy.callCount, 1
		assert.deepStrictEqual spy.firstCall.args, [1, 2]

	it 'call the `out` function with the previous value & the entry', ->
		spy = sinon.spy()
		ttlBuffer(in: (-> 2), out: spy, ttl: 300).push 1
		clock.tick 300
		assert.strictEqual spy.callCount, 1
		assert.deepStrictEqual spy.firstCall.args, [2, 1]
