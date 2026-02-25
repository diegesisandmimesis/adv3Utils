#charset "us-ascii"
//
// thingStateRoom.t
//
//	Extends ThingState to work with rooms.
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify ThingState
	// Description properties that will be called on the current state
	// when the corresponding property on the parent Room would be
	// displayed.
	roomDesc = ""
	roomFirstDesc { roomDesc; }
	roomDarkDesc = ""
	roomRemoteDesc(actor) {}
;

modify Thing
	// More or less equivalent to the logic of the stock method, only
	// calling the desc methods on the state instead of the parent
	// Thing.
	// NOTE:  This will ALSO output the relevant desc on the parent
	//	object as well;  if you want ONLY the state desc methods
	//	to be used, the corresponding value on the parent object
	//	should be "".
	lookAroundWithinDesc(actor, illum) {
		local pov, st;

		inherited(actor, illum);

		if((st = getState()) == nil)
			return;
		if(illum > 1) {
			pov = getPOVDefault(actor);
			if(!actor.isIn(self) || (actor != pov)) {
				st.roomRemoteDesc(actor);
			} else if(actor.hasSeen(self)) {
				st.roomDesc;
			} else {
				st.roomFirstDesc;
			}
		} else {
			st.roomDarkDesc;
		}
	}
;
