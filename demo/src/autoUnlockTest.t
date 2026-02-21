#charset "us-ascii"
//
// autoUnlockTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f autoUnlockTest.t3m
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
;

key01: Key '(brass) key' 'key' "A brass key. ";

class DemoDoor: LockableWithKey, AutoUnlock, Door
	keyList = static [ key01 ]
;

southRoom: Room 'South Room'
	"This is the south room. To the north is the door to the north
		room and to the east is the alternate route. "
	north = demoDoor1
	east = alternateRoom
;
+me: Person;
+demoDoor1: DemoDoor 'door' 'door'
	destination = northRoom
;

alternateRoom: Room 'Alternate Route'
	"This is the alternate route.  The north room is to the northwest
	and the south room is to the west. "
	west = southRoom
	northwest = northRoom
;

northRoom: Room 'North Room'
	"This is a the north room.  The south room is south and the alternate
	route is to the southeast. "
	south = demoDoor0
	southEast = alternateRoom
;
+demoDoor0: DemoDoor 'door' 'door'
	destination = southRoom
	masterObject = demoDoor1
;

