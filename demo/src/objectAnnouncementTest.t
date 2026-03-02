#charset "us-ascii"
//
// objectAnnouncementTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f objectAnnouncementTest.t3m
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
	cmd(txt) { return('<b>&gt;<<txt>></b>'); }
	showIntro() {
		"This is a demo of the various object annoucement toggles.
		Use <<cmd('multi')>>, <<cmd('ambig')>>, and <<cmd('default')>>
		to toggle each flag.
		<.p>
		To test multi: <<cmd('take all')>>
		<.p>
		To test ambig: <<cmd('take any pebble')>>
		<.p>
		To test default: <<cmd('drop')>>
		<.p>
		Be sure to use <<cmd('undo')>> after any command other than
		the toggles;  <<cmd('drop')>> won't work as a test if
		you're holding more than one object, for example. ";
	}
;

class Pebble: Thing '(small) (round) pebble*pebbles' 'pebble'
	"A small, round pebble. "
	isEquivalent = true
	announcementFlag = 0
;

class Rock: Thing '(ordinary) rock' 'rock'
	"An ordinary rock. "
	announcementFlag = 0
;

startRoom: Room 'Void'
	"This is a formless void. "
;
+me: Person;
++Pebble;
+Rock '(red) rock' 'red rock' "A red rock. ";
+Rock '(blue) rock' 'blue rock' "A blue rock. ";

DefineSystemAction(Multi)
	execSystemAction() {
		Pebble.announcementFlag |= ANNOUNCE_MULTI;
		Rock.announcementFlag |= ANNOUNCE_MULTI;
		defaultReport('Multi toggled. ');
	}
;
VerbRule(Multi) 'multi' : MultiAction verbPhrase = 'multi/multing';

DefineSystemAction(Ambig)
	execSystemAction() {
		Pebble.announcementFlag |= ANNOUNCE_AMBIG;
		Rock.announcementFlag |= ANNOUNCE_AMBIG;
		defaultReport('Ambig toggled. ');
	}
;
VerbRule(Ambig) 'ambig' : AmbigAction verbPhrase = 'ambig/ambigging';

DefineSystemAction(Def)
	execSystemAction() {
		Pebble.announcementFlag |= ANNOUNCE_DEFAULT;
		Rock.announcementFlag |= ANNOUNCE_DEFAULT;
		defaultReport('Default toggled. ');
	}
;
VerbRule(Def) 'default' : DefAction verbPhrase = 'default/defaulting';
