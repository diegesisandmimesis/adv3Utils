#charset "us-ascii"
//
// ordinalTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f ordinalTest.t3m
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

#include "intMath.h"

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

class Pebble: OrdinalThing
	vocabWords = 'pebble' 
	desc = "There's a <<spellInt(ordinalNumber)>> painted on it. "
;

Pebble template +ordinalNumber;

class Rock: RomanOrdinalThing
	vocabWords = 'rock'
	desc = "There's a <<toRoman(ordinalNumber)>> engraved on it. "
;

Rock template +ordinalNumber;

startRoom: Room 'Void' "This is a featureless void. ";
+me: Person;
+pebble01: Pebble +1;
+pebble02: Pebble +2;
+pebble03: Pebble +3;
+Rock +1;
+Rock +2;
+Rock +3;

