assert =			require 'assert'
sinon =				require 'sinon'

TtlBuffer =			require '../index.js'





describe 'TtlBuffer', ->

	b = null
	beforeEach -> b = Object.create TtlBuffer



	describe '::init', ->

		it 'should set the ttl', ->
			b.init 100, 10
			assert.strictEqual b.ttl, 100

		it 'should set the inital value', ->
			b.init 100, 10
			assert.strictEqual b.valueOf(), 10

		it 'should return the instance', ->
			result = b.init 100, 10
			assert.strictEqual result, b



	describe '::add', ->

		it 'should call `in` with the passed value', ->
			b.init 100, 'foo'
			b.in = sinon.spy (value, entry) -> value # noop reducer

			b.add 'bar'
			assert.strictEqual b.in.callCount, 1
			assert.deepStrictEqual b.in.firstCall.args, ['foo', 'bar']

		it 'should use the return value of `in` as new value', ->
			secret = Math.random()
			b.init 100, 10
			b.in = -> secret

			b.add 'foo'
			assert.strictEqual b.valueOf(), secret

		it 'should return the instance', ->
			b.init 100, 'foo'
			result = b.add 'bar'
			assert.strictEqual result, b



	describe '::in (default reducer)', ->

		it 'should add the entry to the value', ->
			result = b.in 1, 2
			assert.strictEqual result, 3

	describe '::out (default reducer)', ->

		it 'should subtract the entry from the value', ->
			result = b.out 3, 2
			assert.strictEqual result, 1



	describe '::valueOf', ->

		clock = null
		before -> clock = sinon.useFakeTimers()
		after -> clock.restore()

		it 'should return the value', ->
			b.init 100, 'foo'
			assert.strictEqual b.valueOf(), 'foo'

		it 'should throw out outdated entries', ->
			b.init 1000, 10
			b.add 1
			b.add 2
			clock.tick 500
			b.add 3

			clock.tick 400
			assert.strictEqual b.valueOf(), 10 + 1 + 2 + 3
			clock.tick 200 # `1` & `2` get thrown out
			assert.strictEqual b.valueOf(), 10 + 3
			clock.tick 500 # `3` gets thrown out
			assert.strictEqual b.valueOf(), 10
