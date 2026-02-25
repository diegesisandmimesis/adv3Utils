#charset "us-ascii"
//
// iobjScope.t
//
//	Implements the equivalent of objInScop() for indirect objects.
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify Action
	iobjInScope = nil
	iobjScopeList = nil
;

modify IobjResolver
	objInScope(obj) {
		if(action_.propType(&iobjInScope) != TypeNil)
			return(action_.iobjInScope(obj));
		return(inherited(obj));
	}

	getScopeList() {
		if(action_.propType(&iobjScopeList) != TypeNil)
			return(action_.iobjScopeList());
		return(inherited());
	}
;
