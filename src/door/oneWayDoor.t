#charset "us-ascii"
//
// oneWayDoor.t
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
	cantAutoOpenImplicit = '{The dobj/he} {is dobj} locked but
		it looks like {you/he} can unlock {it dobj/him} from this
		side. '
	cantUnlockOneWay = '{The dobj/he} {do dobj}n\'t appear{s dobj}
		to open from this side. '
	needToUnlockOneWay = '{The dobj/he} open{s dobj} from this side,
		but {you/he} {has} to do it {yourself}. '
	okayAutoUnlock = '{You/He} unlock{s} {the dobj/him} from
		this side. '
	okayAutoLock = '{You/He} lock{s} {the dobj/him} from this side. '
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
	// IMPORTANT/CONFUSING:  If this isn't true then we don't get
	// our custom messages unless the locking mechanism is apparent.
	autoUnlockOnOpen = true

	allowImplicit = true

	isUnlockable() {
		if(masterObject != self)
			return(nil);
		return(true);
	}

	dobjFor(Unlock) {
		verify() {
			if(isLocked() && isUnlockable())
				return;
			inherited();
		}
	}

	dobjFor(Open) {
		verify() {
			if(isLocked() && gAction.isImplicit
				&& !allowImplicit)
				illogicalNow(&cantAutoOpenImplicit);
			inherited();
		}
		action() {
			if(!gAction.isImplicit)
				defaultReport(&okayAutoUnlock);
			inherited();
		}
		verbPhrase = (allowImplicit
			? 'unlock/unlocking (what) from this side'
			: 'open/opening (what)')
	}
;

class OneWayDoor: IndirectLockable, AutoUnlock, Door
	cannotUnlockMsg = ((masterObject == self)
		? &cantUnlockOneWay : &needToUnlockOneWay)
;

class AutoUnlockDoorWithKey: LockableWithKey, AutoUnlock, Door
	dobjFor(Lock) {
		verify() {
			if(!isLocked() && isUnlockable())
				return;
			inherited();
		}
		action() {
			makeLocked(nil);
			defaultReport(&okayAutoLock);
		}
	}
	dobjFor(Unlock) {
		verify() {
			if(isLocked() && isUnlockable())
				return;
			inherited();
		}
		action() {
			if(!gAction.isImplicit) {
				makeLocked(nil);
				defaultReport(&okayAutoUnlock);
				return;
			}
			inherited();
		}
	}
;
