#charset "us-ascii"
//
// resource.t
//
//	Provides a generic Resource class for use with ResourceFactory.
//
//	Resources are indistinguishable items that are dispensed
//	by their corresponding ResourceFactory.  Intended for things
//	like harvestable parts of plants and that kind of thing.
//
//	In general a Resource can just be subclassed without addition
//	special configuration (for the purposes of the factory
//	dispensing logic).
//
//	See the ResourceFactory class for more details.
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

class Resource: Thing
	// Custom >TAKE result message.  Note the "factory" message
	// parameter, which matches our factory object.
	resourceTakeDesc = "{You/He} take{s} {an dobj/her} from
		{the factory/him}. "

	// Tweak vocabulary likelihood so we don't show up in disambiguation
	// prompts if we're still in the factory.
	vocabLikelihood = (isInFactory(self) ? -30 : 0)

	isEquivalent = true

	hideFromAll(action) { return(isInFactory(self)); }

	dobjFor(Take) {
		action() {
			local factory;

			// Remember if we started in our factory.
			factory = nil;
			if(isInFactory(self))
				factory = location;

			// Handle the normal >TAKE logic
			inherited();

			// If we started out in our factory, replace the
			// stock take message with our custom message and
			// then tell the factory to refill itself.
			if(factory) {
				gMessageParams(factory);
				resourceTakeDesc;
				factory.refillFactory();
			}
		}
	}
;
