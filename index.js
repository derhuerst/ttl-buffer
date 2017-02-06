'use strict'

const defaults = {
	  ttl: 1000, initialValue: 0
	, in: (value, entry) => value + entry
	, out: (value, entry) => value - entry
}

const ttlBuffer = (opt) => {
	const onIn = opt.in || defaults.in
	const onOut = opt.out || defaults.out
	const ttl = 'ttl' in opt ? opt.ttl : defaults.ttl
	let value = 'initialValue' in opt ? opt.initialValue : defaults.initialValue

	const buffer = {
		push: (entry) => {
			value = onIn(value, entry)
			setTimeout(() => { value = onOut(value, entry) }, ttl)
			return buffer
		},
		valueOf: () => value
	}
	return buffer
}

module.exports = ttlBuffer
