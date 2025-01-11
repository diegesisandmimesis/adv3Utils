#charset "us-ascii"
//
// adv3UtilsFindMaxValue.t
//
//	Tweak libGlobal for gTurn to work
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

// Function to help find the maximum value of an arbitrary callback function
// that will not throw an exception.
// This is intended to help determine max array sizes, max lookup table
// sizes, and so on.
// Arguments are:
//
//	v0		lowest integer value to try
//
//	v1		highest integer value to try
//
//	cb		callback function.  it will be repeatedly called with
//			a single argument, which will be an integer between
//			v0 and v1
//
//	maxTries	if given, function will return nil after this many
//			tries if a solution hasn't been found.  defaults
//			to 65535
//
function findMaxValue(v0, v1, cb, maxTries?) {
	local i, j, n;

	// Set a default value if necessary.
	maxTries = ((maxTries != nil) ? maxTries : 65535);

	// Try counter.
	n = 0;

	// Initial guess is the max value.
	i = v1;
	while(1) {
		// See if we've run out of tries.
		if(n >= maxTries)
			return(nil);

		// Remember the current guess.
		j = i;

		// Increment the try counter.
		n += 1;

		try {
			// Call the callback.  If it throws an
			// exception controll will pass to the catch()
			// stanza below.
			cb(i);

			// If we're here, there was no exception.  That means
			// the current guess is a valid number.
			// So we check to see if it's greater than our
			// current lower bound.  If so, we can increase the
			// lower bound to the current guess.
			if(i > v0)
				v0 = i;
			i = (v1 + v0) / 2;

			// If we're about to make the same guess we just
			// made, we're done.
			if(i == j)
				return(i);
		}
		catch(Exception e) {
			// We got an exception, so that means the current
			// guess is invalid.  Make it the upper bound.
			v1 = i;
			i = (v1 + v0) / 2;
		}
	}
}
