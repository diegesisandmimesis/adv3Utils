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
	"This is {voiddesc} with a sign on the wall. "
	vocabWords = '(featureless) (some) (odd) void/room'
	allStates = [ nonVoid, void ]
	getState() {
		return(gRevealed('void') ? void : nonVoid);
	}
	voidName() { return(getState().voidName); }
	voidDesc() { return(getState().voidDesc); }
;
+nonVoid: ThingState
	stateTokens = [ 'odd', 'some' ]
	voidName = 'Some Room'
	voidDesc = 'an odd room'
;
+void: ThingState
	stateTokens = [ 'featureless', 'void' ]
	voidName = 'Void'
	voidDesc = 'a featureless void'
;
+sign: Decoration 'sign' 'sign'
	"<q>This is the Void.</q> <.reveal void> ";
+me: Person;

MessageToken 'void' ->(&voidName) @startRoom;
MessageToken 'voidDesc' ->(&voidDesc) @startRoom;
