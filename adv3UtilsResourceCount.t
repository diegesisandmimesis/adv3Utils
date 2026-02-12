#charset "us-ascii"
//
// adv3UtilsResourceCount.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

#ifdef RESOURCE_COUNT

#include "requireCount.h"

modify Resource
	vocabLikelihood() {
		if(!isInFactory(self)) return(0);
		if(gAction && gAction.foozle) return(-100);
		//if(isType(gAction, TActionWithCount)) return(0);
		return(0);
	}

	dobjFor(TakeCount) {
		verify() {
			//if(!isInFactory(self)) illogical('');
			if(!isInFactory(self))
				nonObvious;
			dangerous;
		}
		action() {
			if(!gAction.numMatch) return;
			//aioSay('\ncount = <<gAction.numMatch.getval()>>\n ');
			//requireCount;
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

	iobjFor(TakeCountFrom) {
		verify() {}
		action() {
			local i, obj;

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

/*
DefineTActionWithCount(TakeCount);
VerbRule(TakeCount)
	( 'take' | 'pick' 'up' | 'get' ) singleDobjWithCount
	| 'pick' singleDobjWithCount 'up'
	: TakeCountAction
	verbPhrase = 'take/taking (what)'
;

DefineTIActionWithCount(TakeCountFrom);
VerbRule(TakeCountFrom)
	( 'take' | 'get' ) singleDobjWithCount
		( 'from' | 'out' 'of' | 'off' | 'off' 'of') singleIobj
	| 'remove' singleDobjWithCount 'from' singleIobj
	: TakeCountFromAction
	verbPhrase = 'take/taking (what) (from what)'
;
*/
DefineTAction(TakeCount) foozle = true;
VerbRule(TakeCount)
	( 'take' | 'pick' 'up' | 'get' ) singleNumber dobjList
	| 'pick' singleNumber dobjList 'up'
	: TakeCountAction
	verbPhrase = 'take/taking (what)'
;

DefineTIAction(TakeCountFrom) foozle = true;
VerbRule(TakeCountFrom)
	( 'take' | 'get' ) singleNumber dobjList
		( 'from' | 'out' 'of' | 'off' | 'off' 'of') singleIobj
	| 'remove' singleNumber dobjList 'from' singleIobj
	: TakeCountFromAction
	verbPhrase = 'take/taking (what) (from what)'
;

#endif // RESOURCE_COUNT
