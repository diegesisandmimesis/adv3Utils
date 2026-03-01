#charset "us-ascii"
//
// deadbolt.t
//
//	Class of lockable objects only unlockable from one side.
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

// Class of lockable objects that can only be unlocked from one side.
// Really only makes sense for things like doors that have a "masterObject",
// which will be the side the lock can be locked and unlocked from.
class Deadbolt: Lockable
	// By default we allow ourselves to be unlocked via implicit
	// action (when unlocking is otherwise possible).  If nil
	// then an explicit >UNLOCK action will be required.
	allowImplicitUnlock = true

	cannotUnlockMsg = ((masterObject == self)
		? &cannotUnlockDeadbolt : &cannotUnlockDeadboltHere)

	// Returns boolean true if this is the side the deadbolt is on.
	isDeadboltReachable() {
		return(masterObject == self);
	}

	dobjFor(Lock) {
		verify() {
			// Custom failure when trying to lock the door
			// from the non-deadbolt side.
			if(!isLocked() && !isDeadboltReachable())
				illogical(&cannotLockDeadboltHere);
			inherited();
		}
	}

	dobjFor(Unlock) {
		verify() {
			if(isLocked()) {
				// If we're locked and we're the deadbolt
				// side we skip verification, allowing the
				// action to succeed.
				if(isDeadboltReachable())
					return;

				// If we're locked and not on the deadbolt
				// side we use a deadbolt-specific failure
				// message.
				illogical(&cannotUnlockDeadboltHere);
					return;
			}
			inherited();
		}
	}

	dobjFor(Open) {
		verify() {
			// Special case when we could theoretically
			// implicitly unlock the door but allowImplicitUnlock
			// is not true.
			if(isLocked() && isDeadboltReachable
				&& gAction.isImplicit && !allowImplicitUnlock)
				illogicalNow(&cantImplicitUnlockDeadbolt);
			inherited();
		}
	}
;

class DeadboltDoor: Deadbolt, Door;
class DeadboltDoorWithKey: LockableWithKey, DeadboltDoor;
