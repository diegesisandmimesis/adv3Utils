#charset "us-ascii"
//
// ordinalThing.t
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
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

class Ordinal: object
	ordinalNumber = nil		// n for the nth object
	ordinalVocab = nil		// list of single-quoted nouns
	ordinalDisambig = true		// use ordinal for disambiguation?
	ordinalName = true		// set name if not set

	// By default use theName instead of aName for ordinal objects:
	// "the first pebble" instead of "a first pebble".
	listName = (theName)

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
		// ordinalName flag is set, then we set one based on
		// our ordinal number.
		if(((name == nil) || (name.length < 1))
			&& (ordinalName == true))
			initOrdinalName(l[1]);

		// If the ordinalDisambig flag is set, we tweak the
		// disambiguation name and order.

		if(ordinalDisambig == true)
			initOrdinalDisambig(l[1]);
	}

	// Set our name to be the ordinal form of the given noun.
	// This will be something like "first pebble".
	initOrdinalName(str) {
		name = '<<spellIntOrdinal(ordinalNumber)>> <<str>>';
	}

	// Set the disambiguation name to be the ordinal form of the given
	// noun, and use our ordinal number for the disambiguation prompt
	// order.
	// This means disambiguation will be something like
	// "Which pebble do you mean, the first pebble, the second
	// pebble, or the third pebble?".
	initOrdinalDisambig(str) {
		disambigName = '<<spellIntOrdinal(ordinalNumber)>> <<str>>';
		disambigPromptOrder = ordinalNumber;
	}

	// Add the given string as a noun and an adjective for this object
	// in the command dictionary.  This is needed for constructions
	// like "pebble number three" to match.
	_addOrdinalNoun(str) {
		addWord(str, &noun);
		addWord(str, &adjective);
	}

	// Set up the ordinal vocabulary for a given number and noun.
	//addOrdinalVocab(n, str) {
	addOrdinalVocab(n) {
		// Go through all the ordinal forms we have defined...
		_ordinalForms.forEach(function(x) {
			// ...add each as a weak token.
			addWeakToken((x[1])(n));
			// ...and an adjective.
			addWord((x[1])(n), &adjective);
			// ...and add SOME of them as nouns as well.
			if(x[2] == true)
				addWord((x[1])(n), &noun);
		});
	}
;

class OrdinalThing: Ordinal, Thing;


// RomanOrdinalThing:  extend OrdinalThing to include Roman numerals.
// Using this, if >X PEBBLE NUMBER THREE would work, >X PEBBLE III will
// as well.
#ifdef ROMAN_ORDINAL

class RomanOrdinalThing: OrdinalThing
	isProperName = true

	_ordinalForms = (inherited + [
		[ function(x) { return('<<toRoman(x)>>'); }, true ]
	] )

	// Set our name to be something like "pebble IV".
	initOrdinalName(str) {
		name = '<<str>> <<toRoman(ordinalNumber)>>';
	}

	// Set disambig prompt to be something like "pebble IV".
	initOrdinalDisambig(str) {
		disambigName = '<<str>> <<toRoman(ordinalNumber)>>';
		disambigPromptOrder = ordinalNumber;
	}
;

#endif // ROMAN_ORDINAL
