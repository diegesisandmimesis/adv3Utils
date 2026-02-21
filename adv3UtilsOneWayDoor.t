#charset "us-ascii"
//
// adv3UtilsOneWayDoor.t
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

modify playerActionMessages
	okayAutoUnlock = '{You/He} unlock{s} {the dobj/him} from
		this side. '
;

modify OpenAction
	getImplicitPhrase(ctx) {
		if(dobjCur_.verbPhraseDobjOpen != nil)
			verbPhrase = dobjCur_.verbPhraseDobjOpen;
		return(inherited(ctx));
	}
;

class AutoUnlock: Lockable
	okayAutoUnlock = &okayAutoUnlock

	autoUnlockOnOpen = true
	isLocked() {
		if(masterObject != self)
			return(nil);
		return(inherited);
	}

	dobjFor(Open) {
		action() {
			if(!gAction.isImplicit)
				defaultReport(&okayAutoUnlock);
			inherited;
		}
		verbPhrase = 'unlock/unlocking (what) from this side'
	}
;

class OneWayDoor: IndirectLockable, AutoUnlock, Door;
class AutoUnlockDoorWithKey: LockableWithKey, AutoUnlock, Door;
