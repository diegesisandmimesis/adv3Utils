#charset "us-ascii"
//
// adv3UtilsResourceCount.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

#ifdef RESOURCE_COUNT

DefineTAction(TakeCount)
	countAction = true
	objInScope(obj) { return(isInFactory(obj)); }
;
VerbRule(TakeCount)
	( 'take' | 'pick' 'up' | 'get' ) singleNumber dobjList
	| 'pick' singleNumber dobjList 'up'
	: TakeCountAction
	verbPhrase = 'take/taking (what)'
;

DefineTIAction(TakeCountFrom)
	countAction = true
	objInScope(obj) { return(isInFactory(obj)); }
;
VerbRule(TakeCountFrom)
	( 'take' | 'get' ) singleNumber dobjList
		( 'from' | 'out' 'of' | 'off' | 'off' 'of') singleIobj
	| 'remove' singleNumber dobjList 'from' singleIobj
	: TakeCountFromAction
	verbPhrase = 'take/taking (what) (from what)'
;

/*
inFactory: PreCondition
	verifyPreCondition(obj) {
		if(isInFactory(obj)) {
			logicalRank(150, 'in factory');
		} else {
			logicalRank(50, 'not in factory');
		}
	}
;
*/

modify Resource
	dobjFor(TakeCount) {
		action() {
			if(!gAction.numMatch) return;
			self.location.resourceCount = gAction.numMatch.getval();
			replaceAction(TakeCountFrom, self, self.location);
		}
	}

	dobjFor(TakeCountFrom) {
		verify() { dangerous; }
	}
;

modify ResourceFactory
	resourceCount = nil

	getResourceCount() {
		return(resourceCount ? resourceCount :
			((gAction && gAction.numMatch)
				? gAction.numMatch.getval()
				: 0));
	}

	iobjFor(TakeCountFrom) {
		verify() {}
		action() {
			local i, obj;

			resourceCount = getResourceCount();

			if(!resourceCount) return;
			for(i = 0; i < resourceCount; i++) {
				obj = createResource();
				obj.moveInto(gActor);
			}
			defaultReport(&okayTakeResourceCount, resourceCount);
			resourceCount = nil;
		}
	}
;

#endif // RESOURCE_COUNT
