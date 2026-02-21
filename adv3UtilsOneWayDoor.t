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
	cantUnlockOneWay = '{The dobj/he} {do dobj}n\'t appear{s dobj}
		to open from this side. '
	needToUnlockOneWay = '{The dobj/he} open{s dobj} from this side,
		but {you/he} {has} to do it {yourself}. '
	okayAutoUnlock = '{You/He} unlock{s} {the dobj/him} from
		this side. '
;

// Tweak to change the default implicit action report for doors that
// auto-unlock from one side.
modify OpenAction
	getImplicitPhrase(ctx) {
		if(dobjCur_.verbPhraseDobjOpen != nil)
			verbPhrase = dobjCur_.verbPhraseDobjOpen;
		return(inherited(ctx));
	}
;

// Mixin class for doors that auto-unlock when tried from one side.
class AutoUnlock: Lockable
	//okayAutoUnlock = &okayAutoUnlock


	// IMPORTANT/CONFUSING:  If this isn't true then we don't get
	// our custom messages unless the locking mechanism is apparent.
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

class OneWayDoor: IndirectLockable, AutoUnlock, Door
	cannotUnlockMsg = ((masterObject == self)
		? &cantUnlockOneWay : &needToUnlockOneWay)
;

class AutoUnlockDoorWithKey: LockableWithKey, AutoUnlock, Door;
