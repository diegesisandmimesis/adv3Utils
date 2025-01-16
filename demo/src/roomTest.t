#charset "us-ascii"
//
// roomTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f roomTest.t3m
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
gameMain: GameMainDef
	initialPlayerChar = me
	newGame() {
		logExits(northRoom);
		logExits(middleRoom);
		logExits(southRoom);
		logAdjacent(northRoom, middleRoom);
		logAdjacent(northRoom, southRoom);
	}

	logExits(rm) {
		"\n<<rm.roomName>> exits:\n";
		rm.destinationList(me).forEach(function(o) {
			"\n\t<<o.roomName>>\n ";
		});
	}

	logAdjacent(rm0, rm1) {
		"\nIs <<rm0.roomName>> adjacent to <<rm1.roomName>>?
			<<toString(rm0.isAdjacent(rm1))>>\n ";
	}
;

southRoom: Room 'South Room'
	"This is the south room. "
	north = middleRoom
;
+me: Person;

middleRoom: Room 'Middle Room'
	"This is the middle room. "
	north = northRoom
	south = southRoom
;

northRoom: Room 'North Room'
	"This is a the north room. "
	south = middleRoom
;
