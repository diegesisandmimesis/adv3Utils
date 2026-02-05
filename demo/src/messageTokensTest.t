#charset "us-ascii"
//
// messageTokensTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f messageTokensTest.t3m
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

startRoom: Room '{void}'
	""
	vocabWords = '(featureless) (some) (odd) void/room'
	allStates = [ nonVoid, void ]
	getState() {
		return(gRevealed('void') ? void : nonVoid);
	}
	voidName() { return(getState().voidName); }
;
+nonVoid: ThingState
	order = 1
	active = true
	stateTokens = [ 'odd' ]
	roomDesc = "This is an odd room with a sign on the wall. "
	voidName = 'Some Room'
;
+void: ThingState
	order = 2
	active = (gRevealed('void'))
	stateTokens = [ 'featureless', 'void' ]
	roomDesc = "This is a featureless void with a sign on the wall that
		totally doesn't count as a feature. "
	voidName = 'Void'
;
+sign: Decoration 'sign' 'sign'
	"<q>This is the Void.</q> <.reveal void> ";
+me: Person;

MessageToken 'void' ->(&voidName) @startRoom;
