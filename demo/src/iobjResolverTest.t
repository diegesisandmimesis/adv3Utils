#charset "us-ascii"
//
// iobjREsolverTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f iobjREsolverTest.t3m
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
gameMain: GameMainDef initialPlayerChar = me;

startRoom: Room 'Void' "This is a featureless void. ";
+me: Person;
+pebble: Thing '(small) (round) pebble' 'pebble' "A small, round pebble. ";

tea: Thing 'tea' 'tea' "Technically not no tea. "
	iobjFor(Foozle) {
		action() {
			defaultReport('The tea foozles the <<gDobj.name>>
				beautifully. ');
		}
	}
;


// Nonsense verb.
// You can >FOOZLE PEBBLE WITH TEA, even though the tea is out of scope,
// but you can't >FOOZLE TEA WITH PEBBLE.
DefineTIAction(Foozle)
	iobjInScope(obj) {
		if(objInScope(obj)) return(true);
		return(obj == tea);
	}
;
VerbRule(Foozle)
	'foozle' singleDobj 'with' singleIobj
	: FoozleAction
	verbPhrase = 'foozle/foozling (what) (with what)'
;
