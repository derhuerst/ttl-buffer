module.exports = {



	init: function (ttl, initialValue) {
		this.ttl = ttl;
		this._entries = [];
		this._timestamps = [];
		this._value = initialValue;

		return this;
	},



	add: function (entry) {
		this._timestamps.push(Date.now());
		this._entries.push(entry);
		this._value = this.in(this._value, entry);

		return this;
	},



	in: function (value, entry) { return value + entry },
	out: function (value, entry) { return value - entry },



	valueOf: function () {
		var now = Date.now();
		var i = 0;
		while (i < this._entries.length && now >= (this._timestamps[i] + this.ttl)) {
			this._value = this.out(this._value, this._entries[i]);
			this._timestamps.shift();
			this._entries.shift();
		}

		return this._value;
	}



};
