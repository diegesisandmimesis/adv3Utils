#charset "us-ascii"
//
// roomVocabTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f roomVocabTest.t3m
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

startRoom: Room 'Void'
	"This is a featureless void. "
	north = middleRoom
;
+pebble: Thing 'small round pebble' 'pebble' "A small, round pebble. ";
+me: Person;

middleRoom: Room 'Middle Room'
	"This is the middle room. "
	north = northRoom
	south = startRoom
;

northRoom: Room 'North Room'
	"This is the north room. "
	south = middleRoom
;
