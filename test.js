'use strict'

const test = require('tape')
const sinon = require('sinon')

const ttlBuffer = require('./index')



test('uses the `initialValue` passed', (t) => {
	t.plan(1)
	const b = ttlBuffer({initialValue: 1})
	t.strictEqual(b.valueOf(), 1)
})

test('calls custom `in` function', (t) => {
	t.plan(1)
	ttlBuffer({
		in: () => t.pass('`in` called')
	}).push(1)
})

test('calls custom `out` function after the `ttl`', (t) => {
	t.plan(1)
	const clock = sinon.useFakeTimers()
	ttlBuffer({
		out: () => t.pass('`out` called'),
		ttl: 500
	}).push(1)
	clock.tick(500)
	clock.restore()
})

test('uses result of `in` as new value', (t) => {
	t.plan(1)
	const b = ttlBuffer({
		initialValue: 0,
		in: () => 3
	})
	b.push(1)
	t.strictEqual(b.valueOf(), 3)
})

test('uses result of `out` as new value', (t) => {
	t.plan(2)
	const clock = sinon.useFakeTimers()
	const b = ttlBuffer({
		initialValue: 0,
		ttl: 500,
		out: () => 3
	})
	b.push(1)
	t.notStrictEqual(b.valueOf(), 3)
	clock.tick(500)
	t.strictEqual(b.valueOf(), 3)
	clock.restore()
})

test('calls `in` with previous value & entry', (t) => {
	t.plan(2)
	ttlBuffer({
		initialValue: 1,
		in: (p, e) => {
			t.strictEqual(p, 1)
			t.strictEqual(e, 2)
		}
	}).push(2)
})

test('calls `out` with previous value & entry', (t) => {
	t.plan(2)
	const clock = sinon.useFakeTimers()
	ttlBuffer({
		ttl: 500,
		in: () => 1,
		out: (p, e) => {
			t.strictEqual(p, 1)
			t.strictEqual(e, 2)
		}
	}).push(2)
	clock.tick(500)
	clock.restore()
})
