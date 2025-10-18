#charset "us-ascii"
//
// adv3UtilsOrdinalVocab.t
//
//	Adds a convenience method to Thing to make it easier to refer
//	to numbered/ordered objects:  the first chair, chair #1, and so on.
//
//	If you declare:
//
//		pebble01: OrdinalThing 'pebble' 'pebble number one' +1 'pebble'
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

	initializeThing() {
		inherited();
		initOrdinalVocab();
	}

	initOrdinalVocab() {
		if((ordinalNumber == nil) || (ordinalVocab == nil))
			return;
		if(!ordinalVocab.ofKind(Collection))
			ordinalVocab = [ ordinalVocab ];
		ordinalVocab.forEach({ x: addOrdinalVocab(ordinalNumber, x) });
	}

	_addWord(str, prop) {
		if(cmdDict.findWord(str, prop).subset({ x: x == self }).length
			> 0)
			return;
		cmdDict.addWord(self, str, prop);
	}
	_addWeakToken(str) {
		if((weakTokens != nil) && (weakTokens.indexOf(str) != nil))
			return;
		if(weakTokens == nil) weakTokens = [];
		weakTokens += str;
	}

	addOrdinalVocab(n, str) {
		if(weakTokens == nil) weakTokens = [];
		_addWeakToken('<<spellInt(n)>>');
		_addWeakToken('<<spellIntOrdinal(n)>>');
		_addWeakToken('number');
		_addWeakToken('#<<toString(n)>>');

		_addWord('<<spellIntOrdinal(n)>>', &adjective);
		_addWord('number', &adjective);
		_addWord('#<<toString(n)>>', &adjective);
		_addWord('<<spellInt(n)>>', &adjective);
		_addWord(str, &adjective);

		_addWord('#<<toString(n)>>', &noun);
		_addWord('<<spellInt(n)>>', &noun);
		_addWord(str, &noun);

		if(ordinalDisambig == true) {
			disambigName = '<<spellIntOrdinal(n)>> <<str>>';
			disambigPromptOrder = n;
		}
	}
;

class OrdinalThing: Ordinal, Thing;
