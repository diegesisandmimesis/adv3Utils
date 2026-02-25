#charset "us-ascii"
//
// oneWayDoorAction.t
//
//	IMPORTANT: need to tweak the procgen one-way door classes to
//	use these after they're done:
//		procgen/src/misc/pgOneWayDoor.t
//		procgen/src/dungeon/procgenDungeon/pdFinalize.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

// Tweak to change the default implicit action report for doors that
// auto-unlock from one side.
modify OpenAction
	getImplicitPhrase(ctx) {
		if(dobjCur_.verbPhraseDobjOpen != nil)
			verbPhrase = dobjCur_.verbPhraseDobjOpen;
		return(inherited(ctx));
	}
;
