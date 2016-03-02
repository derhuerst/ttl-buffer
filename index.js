'use strict'

const add      = (value, entry) => value + entry
const subtract = (value, entry) => value - entry



const ttlBuffer = function (options) {
	if ('object' !== typeof options) options = {}

	const onIn  = ('function' === typeof options.in)  ? options.in           : add
	const onOut = ('function' === typeof options.out) ? options.out          : subtract
	const ttl   = (options.ttl > 0)                   ? options.ttl          : 1000
	let   value = (options.initialValue != null)      ? options.initialValue : 0

	return {

		push: function (entry) {
			value = onIn(value, entry)
			setTimeout(function () { value = onOut(value, entry) }, ttl)
			return this
		},

		valueOf: function () { return value }

	}
}



module.exports = ttlBuffer
