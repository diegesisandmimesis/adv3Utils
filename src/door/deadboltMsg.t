#charset "us-ascii"
//
// deadboltMst.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify playerActionMessages
	// Verify failure when Deadbolt.allowImplicit is nil and the
	// action is implicit.
	cantImplicitUnlockDeadbolt = '{The dobj/he} {is dobj} locked but
		it looks like {you/he} can unlock {it dobj/him} from this
		side. '
	
	// Verify failure for >LOCK when on the other side of the door.
	cannotLockDeadboltHere = '{The dobj/he} {do dobj}n\'t appear{s dobj}
		to be lockable from this side. '
	
	// Verify failure for >UNLOCK when on the other side of the door.
	cannotUnlockDeadboltHere = '{The dobj/he} {do dobj}n\'t appear{s dobj}
		to open from this side. '

	// Obscure; this is for when cannotUnlockMsg is needed and it IS NOT
	// because of being on the wrong side of the door.  Not needed
	// for stock Deadbolt doors, might be used in things like
	// IndirectLockable deadbolt doors.
	cannotUnlockDeadbolt = '{The dobj/he} open{s dobj} from this side,
		but {you/he} {has} to do it {yourself}. '
	
	// Not used.  Theoretical alternate success message that could
	// be used in dobjFor(Unlock) { action() {} } if desired.
	okayUnlockDeadbolt = '{You/He} unlock{s} {the dobj/him} from
		this side. '
;
