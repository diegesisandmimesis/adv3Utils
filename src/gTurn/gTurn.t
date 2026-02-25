#charset "us-ascii"
//
// gTurn.t
//
//	Tweak libGlobal for gTurn to work
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify libGlobal
	currentTurn() {
		return(gAction ? (totalTurns + gAction.actionTime)
			: totalTurns);
	}
;
