#charset "us-ascii"
//
// thingStateTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f thingStateTest.t3m
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

startRoom: Room 'Void' "This is a featureless void. ";
+me: Person;

// A pebble that is a weird artifact if isWeird is true, and is an alien
// artifact if isAlien is true
+pebble: Thing '(small) (round) (weird) (alien) pebble/artifact' 'pebble'
	"A small, round pebble. "
	isWeird = nil
	isAlien = nil
	allStates = [ bland, weird, alien ]
	getState() {
		if(isAlien) return(alien);
		if(isWeird) return(weird);
		return(bland);
	}
;

// Default state that doesn't change any of the pebble's stock behaviors.
++bland: ThingState;

// The "weird" state.
++weird: ThingState
	stateDesc = "It seems to be some kind of weird artifact. "
	order = 1
	active = (pebble.isWeird == true)
	stateTokens = [ 'weird', 'artifact' ]
;

// The "alien" state.
++alien: ThingState
	stateDesc = "It is apparently an alien artifact. "
	order = 2
	active = (pebble.isAlien == true)
	stateTokens = [ 'alien', 'artifact' ]
;

// Action that toggles the "weird" state.
DefineSystemAction(Foo)
	execSystemAction() {
		pebble.isWeird = !pebble.isWeird;
		defaultReport('The pebble is now
			<<(pebble.isWeird ? '' : 'not')>> weird. ');
	}
;
VerbRule(Foo) 'foo' : FooAction verbPhrase = 'foo/fooing';

// Action that toggles the "alien" state.
DefineSystemAction(Bar)
	execSystemAction() {
		pebble.isAlien = !pebble.isAlien;
		defaultReport('The pebble is now
			<<(pebble.isAlien ? '' : 'not')>> alien. ');
	}
;
VerbRule(Bar) 'bar' : BarAction verbPhrase = 'bar/barring';

