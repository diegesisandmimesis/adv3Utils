#charset "us-ascii"
//
// thingStateDesc.t
//
//	Extends ThingState to have a stateDesc similar to ActorState.
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify ThingState
	stateDesc = ""
;

modify Thing
	examineStatus() {
		local st;

		inherited();

		if((st = getState()) != nil)
			st.stateDesc;
	}
;
