#charset "us-ascii"
//
// adv3UtilsOrdinalVocab.t
//
//	Adds a convenience method to Thing to make it easier to refer
//	to numbered/ordered objects:  the first chair, chair #1, and so on.
//
//	If you declare:
//
//		pebble01: OrdinalThing 'pebble' 'pebble number one' +1
//			"There's a one painted on it. "
//		;
//
//	...then all of the following will work:
//
//		>X FIRST PEBBLE
//		>X PEBBLE NUMBER ONE
//		>X PEBBLE #1
//		>X #1 PEBBLE
//		>X NUMBER ONE PEBBLE
//
//	...and disambiguation with a similiarly-declared object with
//	a different ordinal number will look like:
//
//		>X PEBBLE 
//		Which pebble do you mean, the first pebble, or the
//		second pebble?
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

class Ordinal: object
	ordinalNumber = nil		// n for the nth object
	ordinalVocab = nil		// list of single-quoted nouns
	ordinalDisambig = true		// use ordinal for disambiguation?
	ordinalName = true		// set name if not set

	// The ordinal forms we add.  All of these get added as adjectives
	// and weak tokens, and the ones with a true in there are added
	// as nouns as well.
	// Format of the function is that it takes a numeric argument
	// and returns a corresponding vocabulary word.
	_ordinalForms = static [
		// "one"
		[ function(x) { return('<<spellInt(x)>>'); }, true ],
		// "#1"
		[ function(x) { return('#<<toString(x)>>'); }, true ],
		// "1"
		[ function(x) { return('<<toString(x)>>'); }, true ],
		// "first"
		[ function(x) { return('<<spellIntOrdinal(x)>>'); }, nil ],
		// "number"
		[ function(x) { return('number'); }, nil ]
	]

	// Add ordinal vocab setup to standard initialization.
	initializeThing() {
		inherited();
		initOrdinalVocab();
	}

	initOrdinalVocab() {
		local l;

		// Make sure we have a number defined.
		if(!isInteger(ordinalNumber))
			return;

		// If we have no ordinalVocab, we use the object's existing
		// noun property, which should be a list of nouns.
		if(ordinalVocab == nil) {
			l = noun;
		} else {
			// We DO have ordinalVocab, now we make sure we're
			// working with an list-like thing.
			if(ordinalVocab.ofKind(Collection))
				l = ordinalVocab;
			else
				l = [ ordinalVocab ];
		}

		// If we didn't come away from the above with a list-like
		// thing, something went horribly wrong and we bail.
		if(!isCollection(l) || (l.length < 1))
			return;

		// Add all the number-related vocabulary
		addOrdinalVocab(ordinalNumber);

		// Add all the nouns as &noun and &adjective.
		l.forEach({ x: _addOrdinalNoun(x) });

		// If we don't have an explicitly defined name and the
		// ordinalName flag is set, then we set our name to be
		// the ordinal version of the first noun in our list
		// from above.
		// This will be something like "first pebble".
		if(((name == nil) || (name.length < 1))
			&& (ordinalName == true))
			name = '<<spellIntOrdinal(ordinalNumber)>> <<l[1]>>';

		// If the ordinalDisambig flag is set, we set the
		// disambiguation name to be the ordinal form of the first
		// noun, and set the disambiguation prompt order to be
		// our number.
		// This means disambiguation will be something like
		// "Which pebble do you mean, the first pebble, the second
		// pebble, or the third pebble?".
		if(ordinalDisambig == true) {
			disambigName =
				'<<spellIntOrdinal(ordinalNumber)>> <<l[1]>>';
			disambigPromptOrder = ordinalNumber;
		}
	}

	// Add string str to the command dictionary as part of speech prop.
	// The value add in the method is that it checks to see if the
	// word is already defined for this object before trying to add it.
	_addWord(str, prop) {
		if(cmdDict.findWord(str, prop).subset({ x: x == self }).length
			> 0)
			return;
		cmdDict.addWord(self, str, prop);
	}

	// Add the given weak token.
	_addWeakToken(str) {
		// If this string is already in the weak tokens list, bail.
		if((weakTokens != nil) && (weakTokens.indexOf(str) != nil))
			return;

		// Init the weak tokens list if it doesn't exist.
		if(weakTokens == nil) weakTokens = [];

		// Add our token to the list.
		weakTokens += str;
	}

	_addWeakWord(str, prop) {
		_addWord(str, prop);
		_addWeakToken(str);
	}

	// Add the given string as a noun and an adjective for this object
	// in the command dictionary.  This is needed for constructions
	// like "pebble number three" to match.
	_addOrdinalNoun(str) {
		_addWord(str, &noun);
		_addWord(str, &adjective);
	}

	// Set up the ordinal vocabulary for a given number and noun.
	//addOrdinalVocab(n, str) {
	addOrdinalVocab(n) {
		// Go through all the ordinal forms we have defined...
		_ordinalForms.forEach(function(x) {
			// ...add each as a weak token.
			_addWeakToken((x[1])(n));
			// ...and an adjective.
			_addWord((x[1])(n), &adjective);
			// ...and add SOME of them as nouns as well.
			if(x[2] == true)
				_addWord((x[1])(n), &noun);
		});
	}
;

class OrdinalThing: Ordinal, Thing;
