#charset "us-ascii"
//
// resourceMsg.t
//
//	Library messages for the Resource and ResourceFactory classes.
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify playerActionMessages
	// Default success message.
	okayTakeResource(src) {
		gMessageParams(src);
		return('{You/He} take{s} {an dobj/her} from
			{the src/him}. ');
	}

	okayTakeResourceCount(n) {
		return('{You/He} take{s} <<spellInt(n)>>
			<<((n == 1) ? gDobj.name : gDobj.pluralName)>>
			from {the iobj/him}. ');
	}
	
	// Factory doesn't accept anything.
	cantPutAnythingInFactory = '{You/He} can\'t put anything in
		{the iobj/him}. '

	// Factory accepts returns, but dobj isn't its resource.
	cantPutInNonResource = '{You/He} can\'t put {that dobj/him}
		in {the iobj/him}. '
;
