# ttl-buffer

*ttl-buffer* is a data structure that represents a **series of values, which can be map-reduced to a result, each having a time to live** (TTL), after which they are removed again. It is [MIT-licensed](LICENSE) and [tested](test/index.coffee).

[![npm version](https://img.shields.io/npm/v/ttl-buffer.svg)](https://www.npmjs.com/package/ttl-buffer)
[![build status](https://img.shields.io/travis/derhuerst/ttl-buffer.svg)](https://travis-ci.org/derhuerst/ttl-buffer)
[![dev dependency status](https://img.shields.io/david/dev/derhuerst/ttl-buffer.svg)](https://david-dm.org/derhuerst/ttl-buffer#info=devDependencies)


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
sumOfLastSecond.valueOf(); // -> 3

// 500ms later
sumOfLastSecond.push(3)
sumOfLastSecond.valueOf(); // -> 6

// 600ms later, TTL of `1` and `2` is over
sumOfLastSecond.valueOf(); // -> 3

// 500ms later, TTL of `3` is over
sumOfLastSecond.valueOf(); // -> 0
```



## Contributing

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/derhuerst/ttl-buffer/issues).
