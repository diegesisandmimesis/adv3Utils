#charset "us-ascii"
//
// maxValueTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f maxValueTest.t3m
//
// ...or the equivalent, depending on what TADS development environment
// you're using.
//
// This "game" is distributed under the MIT License, see LICENSE.txt
// for details.
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		local v;

		// Call the findMaxValue() for (some) values between
		// 1 and 65535.  The callback creates a lookup table
		// with n entries, where n is the value being tested.
		// The thing we're testing is how big the table can
		// be before keysToList() throws an exception.  This
		// should be 13106--a table with 13106 keys is fine,
		// one with 13107 will throw an exception on
		// keysToList().
		v = findMaxValue(1, 65535, function(n) {
			local i, l, table;

			// Create a lookup table
			table = new LookupTable();

			// Add n arbitrary elements to it.
			for(i = 0; i < n; i++) table[i] = i;

			// Get the keys as a list.  This has an upper
			// bound of 13106, for some reason.
			l = table.keysToList();

			// Meaningless conditional so the compiler doesn't
			// complain that we assigned a value to l and then
			// didn't do anything with it.
			if(l.length()) {}
		});

		// Should be 13106.
		aioSay('\nmax value = <<toString(v)>>\n ');
	}
;
