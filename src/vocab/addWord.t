#charset "us-ascii"
//
// addWord.t
//
//	Adds a couple methods to VocabObject to make it slightly
//	easier to tweak tokens.
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify VocabObject
	// Add string str to the command dictionary as part of speech prop.
	// The value add in the method is that it checks to see if the
	// word is already defined for this object before trying to add it.
	addWord(str, prop) {
		if(cmdDict.findWord(str, prop)
			.subset({ x: x == self }).length > 0)
			return;
		cmdDict.addWord(self, str, prop);
	}

	// Add the given weak token.
	addWeakToken(str) {
		// If this string is already in the weak tokens list, bail.
		if((weakTokens != nil) && (weakTokens.indexOf(str) != nil))
			return;

		// Init the weak tokens list if it doesn't exist.
		if(weakTokens == nil) weakTokens = [];

		// Add our token to the list.
		weakTokens += str;
	}

	// Add a weak word.  Handles both tweaking the cmdDict and
	// this object's weak tokens.
	addWeakWord(str, prop) {
		addWord(str, prop);
		addWeakToken(str);
	}
;
