#charset "us-ascii"
//
// debugObjTest.t
// Version 1.0
// Copyright 2022 Diegesis & Mimesis
//
// This is a very simple demonstration "game" for the adv3Utils library.
//
// It can be compiled via the included makefile with
//
//	# t3make -f debugObjTest.t3m
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
	newGame() {
		local obj;

		obj = new Foo();
		gDebugObj(obj);

		if(obj) {}
	}
;

class Foo: object
	_foo = 1
	_bar = 2
	_baz = 3
;
