#charset "us-ascii"
//
// resourceTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f resourceTest.t3m
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
#include "requireCount.h"

versionInfo: GameID;
gameMain: GameMainDef initialPlayerChar = me;

class Pebble: Resource '(small) (round) pebble*pebbles' 'pebble'
	"A small, round pebble. "
;

class Rock: Thing '(ordinary) rock*rocks' 'rock'
	"An ordinary rock. "
	isEquivalent = true
;

startRoom: Room 'Void'
	"This is a formless void containing a bucket of infinite pebbles. "
;
+me: Person;
+Rock;
+Rock;
+Rock;
+bucket: Fixture, ResourceFactory '(infinite) (pebbles) bucket' 'bucket'
	"It contains...let's see...looks like an infinite number of
	pebbles. "
	resourceClass = Pebble
	resourceReturnable = true
	//countKludge = nil

	/*
	iobjFor(TakeCountFrom) {
		verify() {}
		action() {
			"Okay. (<<toString(countKludge)>>) ";
			countKludge = nil;
		}
	}
	*/
;

/*
DefineTActionWithCount(TakeCount);
VerbRule(TakeCount)
	( 'take' | 'pick' 'up' | 'get' ) singleDobjWithCount
	| 'pick' singleDobjWithCount 'up'
	: TakeCountAction
	verbPhrase = 'take/taking (what)'
;

DefineTIActionWithCount(TakeCountFrom);
VerbRule(TakeCountFrom)
	( 'take' | 'get' ) singleDobjWithCount
		( 'from' | 'out' 'of' | 'off' | 'off' 'of') singleIobj
	| 'remove' singleDobjWithCount 'from' singleIobj
	: TakeCountFromAction
	verbPhrase = 'take/taking (what) (from what)'
;
*/
