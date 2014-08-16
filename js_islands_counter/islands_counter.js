// iland_hunter.js

// anonymous wrapper
!function(){

	// turn on strict mode
	'use strict';

	// Extending String.prototype

	// left justify by length,
	// default filler is space
	String.prototype.leftJustify = function( length, char ) {
		if (arguments.length < 2) char = " ";
		var fill = [];
		while ( fill.length + this.length < length ) {
			fill[fill.length] = char;
		}
		return fill.join('') + this;
	};

/* not need
	// right justify by length,
	// default filler is space
	String.prototype.rightJustify = function( length, char ) {
		if (arguments.length < 2) char = " ";
		var fill = [];
		while ( fill.length + this.length < length ) {
			fill[fill.length] = char;
		}
		return this + fill.join('');
	};
*/

/* not need
	String.prototype.strip = function() {
		return this.replace(/\s+/g, '');
	};
*/

	// repeats the string n times
	String.prototype.times = function(n) {
		var t, tt;
		t = tt = this;
		n = n || 1;
		while (--n) { t += tt }
		return t;
	};

	// PRIVATE ZONE

	// puts a matrix
	// mx - matrix
	// just - justify of values, def: 1
	// won - with out 0, def: false (don't show 0s)
	function putsMxValues(mx, just, won) {
		just = just || 1;
		var ml = mx[0].length,
			b = "--";
		while(ml--) b += "--" + "-".times(just);
		console.log(b);
		for (var i = 0; i < mx.length; i++) {
			var str = "|";
			for (var j = 0; j < mx[i].length; j++) {
				if (won && mx[i][j] === 0) {
					str += " " + ("").leftJustify(just) + " ";
					continue;
				}
				str += " " + ("" + mx[i][j]).leftJustify(just) + " ";
			}
			console.log(str + "|");
		};
		console.log(b);
	};

	// check it nearest (horizontal and vertical only)
	function near(i, j, mx, handler, c) {
		if (mx[i+1] && mx[i+1][j] === 1) handler(i+1, j, mx, c);
		if (mx[i-1] && mx[i-1][j] === 1) handler(i-1, j, mx, c);
		if (mx[i][j+1] === 1) handler(i, j+1, mx, c);
		if (mx[i][j-1] === 1) handler(i, j-1, mx, c);
	};

	// set it to 0
	function destroy(i, j, mx) {
		mx[i][j] = 0;
		near(i, j, mx, destroy);
	};

	// find cell it's equal to 1
	function seek(mx, handler) {
		var c = 0;
		for (var i = 0; i < mx.length; i ++)
			for (var j = 0; j < mx[0].length; j++) {
				if (mx[i][j] !== 1) continue;
				handler(i, j, mx, ++c);
			}
		return c;
	};

	// set its value to number of island
	function numify(i, j, mx, c) {
		mx[i][j] = "" + c;
		near(i, j, mx, numify, c)
	};

	// Main object

	// empty constructor
	function X() {};

	// methods
	X.prototype = {
		// info
		name: "Islands Counter",
		version: "0.0.0-alpha.0",

		// generate matrix, default 10x10
		// i: height
		// j: width
		gm: function (i, j) {
			var al = arguments.length;
			if (al < 2) j = 10;
			if (!al) i = 10;
			var mx = [], k;
			while (i--) {
				mx[i] = [];
				k = j;
				while (k--) mx[i][k] = Math.round( Math.random() );
			}
			this.mx = mx;
			return this;
		},

		// print matrix
		putsMx: function () {
			var mx = this.mx,
				ml = mx[0].length,
				b = "----";
			while(ml--) b += "--";
			console.log(b);
			for (var i = 0; i < mx.length; i++) {
				var str = "| ";
				for (var j = 0; j < mx[i].length; j++) {
					str += mx[i][j] ? "[]" : "  ";
				}
				console.log(str + " |");
			};
			console.log(b);
			return this;
		},

		// return its matrix
		take: function() { return this.mx; },

		// return false
		stop: function() { return false; },

		// count islands
		count: function() {
			var mx = this.cpMx();
			this.c = seek(mx, destroy);
			return this.c;
		},

		// clone this object
		clone: function() {
			var n = new X();
			n.setMx(this.cpMx());
			return n;
		},

		// return copy of its matrix
		cpMx: function() {
			var t = [],
				mx = this.mx,
				i = mx.length,
				j = mx[0].length,
				k;
			while (i--) {
				t[i] = [];
				k = j;
				while (k--) t[i][k] = mx[i][k];
			}
			return t;
		},

		// set its matrix to mx
		// mx: matrix
		setMx: function(mx) { this.mx = mx; return this; },

		// print islands with its numbers
		// j: justify, def: 1
		// w: without 0, def: true
		putsNums: function(j, w) {
			var al = arguments.length;
			if (al < 2) w = true;
			if (!al) j = 2
			var mx = this.cpMx(),
				c = 0;
			c = seek(mx, numify);
			console.log("total: " + c);
			putsMxValues(mx, j, w);
			return this;
		},

		// print matrix as is
		putsMxValues: function(j, w) {
			j = j || 1;
			putsMxValues(this.mx, j, w);
			return this;
		},

		// print island no n;
		// n: number of island, required
		// jst: justify, def: 2
		// w: without 0, def: true
		putsNo: function(n, jst, w) {
			var mx = this.cpMx(),
				c = seek(mx, numify);
			if (n > c || !n) {
				console.log('Beyond');
				return this;
			}
			var al = arguments.length;
			if (al < 3) w = true;
			if (al < 2) jst = 2
			console.log("no: " + n);
			for (var i = 0; i < mx.length; i++)
				for (var j = 0; j < mx[0].length; j++) {
					if (mx[i][j] != n) mx[i][j] = ' ';
				}
			putsMxValues(mx, jst, w);
			return this;
		}

	};

	// create object
	var x = new X();

	// bind object to global context
	if (typeof define === "function" && define.amd) define(x);
	else if (typeof module === "object" && module.exports) module.exports = x;
  	else this.x = x;

}();
