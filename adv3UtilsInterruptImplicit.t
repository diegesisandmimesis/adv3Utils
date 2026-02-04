#charset "us-ascii"
//
// adv3UtilsInterruptImplicit.t
//
//	Use the gInterruptImplicit macro to interrupt an implicit action.
//	The return value is true on success, nil if the current action
//	is not an implicit action.
//
//		if(gInterruptImplicit == true) {
//			"Implicit action interrupted. ";
//		}
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

// Utility object for interrupting implicit actions.
interruptImplicitHandler: object
	interruptImplicitAction() {
		if(!gAction.isImplicit)
			return(nil);
		gAction.callAfterActionMain(self);
		return(true);
	}
	afterActionMain() {
		exit;
	}
;
