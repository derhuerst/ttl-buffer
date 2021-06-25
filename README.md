# ttl-buffer ⌛️

*ttl-buffer* is a data structure that represents a **series of values, which can be map-reduced to a result, each having a time to live** (TTL), after which they are removed again. Like [roll-reduce](https://github.com/raineorshine/roll-reduce#roll-reduce), but time-based.

[![npm version](https://img.shields.io/npm/v/ttl-buffer.svg)](https://www.npmjs.com/package/ttl-buffer)
[![build status](https://img.shields.io/travis/derhuerst/ttl-buffer.svg)](https://travis-ci.org/derhuerst/ttl-buffer)
[![dev dependency status](https://img.shields.io/david/dev/derhuerst/ttl-buffer.svg)](https://david-dm.org/derhuerst/ttl-buffer#info=devDependencies)
![ISC-licensed](https://img.shields.io/github/license/derhuerst/ttl-buffer.svg)
[![support me via GitHub Sponsors](https://img.shields.io/badge/support%20me-donate-fa7664.svg)](https://github.com/sponsors/derhuerst)
[![chat with me on Twitter](https://img.shields.io/badge/chat%20with%20me-on%20Twitter-1da1f2.svg)](https://twitter.com/derhuerst)


## Installing

```
npm install ttl-buffer
```


## Example

```javascript
const ttlBuffer = require('ttl-buffer')

const sumOfLastSecond = ttlBuffer({
	ttl:          1000, // time in milliseconds
	initialValue: 0,
	// This function will be called once you `push` a value.
	in:           (before, entry) => before + entry,
	// This function will be called once a value's TTL is over.
	out:          (before, entry) => before - entry
})

sumOfLastSecond.push(1).push(2)
sumOfLastSecond.valueOf() // -> 3

// 500ms later
sumOfLastSecond.push(3)
sumOfLastSecond.valueOf() // -> 6

// 600ms later, TTL of `1` and `2` is over
sumOfLastSecond.valueOf() // -> 3

// 500ms later, TTL of `3` is over
sumOfLastSecond.valueOf() // -> 0
```



## Contributing

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/derhuerst/ttl-buffer/issues).
