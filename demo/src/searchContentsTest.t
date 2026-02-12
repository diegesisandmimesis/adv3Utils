#charset "us-ascii"
//
// searchContentsTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f searchContentsTest.t3m
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

class Foo: Thing;
class Bar: Thing;
box: Container 'box' 'box' "A box. ";
+Foo;
+Thing;
+pebble: Thing '(small) (round) pebble' 'pebble' "A small, round pebble. ";

versionInfo: GameID;
gameMain: GameMainDef
	newGame() {
		"contains Foo:
			<<toString(box.contains({ x: x.ofKind(Foo) }))>>\n ";
		"contains Bar:
			<<toString(box.contains({ x: x.ofKind(Bar) }))>>\n ";
		"contains pebble:
			<<toString(box.contains({ x: x == pebble }))>>\n ";
	}
;
