# ttl-buffer

***ttl-buffer* is a buffer that remove its entries after a certain time.** Furthermore, it map-reduces all of its values to a single value.

[![npm version](https://img.shields.io/npm/v/ttl-buffer.svg)](https://www.npmjs.com/package/ttl-buffer)
[![build status](https://img.shields.io/travis/derhuerst/ttl-buffer.svg)](https://travis-ci.org/derhuerst/ttl-buffer)
[![dev dependency status](https://img.shields.io/david/dev/derhuerst/ttl-buffer.svg)](https://david-dm.org/derhuerst/ttl-buffer#info=devDependencies)


## Installing

```
npm install ttl-buffer
```


## Example

```javascript
var TtlBuffer = require('./index.js');

var sumOfLastSecond = Object.create(TtlBuffer);
sumOfLastSecond.init(1000, 0); // 1s ttl; 0 as initial value

sumOfLastSecond.in = function (before, entry) { return before + entry };
sumOfLastSecond.out = function (before, entry) { return before - entry };

sumOfLastSecond.add(1);
sumOfLastSecond.add(2);

setTimeout(function () {
	sumOfLastSecond.add(3);
}, 500);

setTimeout(function () {
	sumOfLastSecond.valueOf(); // -> 6
}, 900);
setTimeout(function () {
	sumOfLastSecond.valueOf(); // -> 3
}, 1100);
setTimeout(function () {
	sumOfLastSecond.valueOf(); // -> 0
}, 1600);
```



## Contributing

If you **have a question**, **found a bug** or want to **propose a feature**, have a look at [the issues page](https://github.com/derhuerst/ttl-buffer/issues).
