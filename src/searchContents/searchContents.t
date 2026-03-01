#charset "us-ascii"
//
// searchContents.t
//
//	Convenience methods for searching an object's contents.
//
//		contains(fn)		returns boolean true if the contents
//					contains an object that satisfies the
//					argument test function
//
//		searchContents(fn)	returns the subset of the contents
//					that satisfy the argument test function
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify Thing
	contains(fn) { return(searchContents(fn).length > 0); }

	searchContents(fn) {
		local l;

		l = new Vector(contents.length);
		addAllContents(l);
		return(l.subset(fn));
	}

	// Return the first matching item in the contents, or nil if there
	// are none.
	matchContents(fn) {
		local r;

		r = searchContents(fn);
		return((r.length < 1) ? nil : r[1]);
	}
;
