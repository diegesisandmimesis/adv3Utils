#charset "us-ascii"
//
// adv3UtilsResource.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify playerActionMessages
	// Default success message.
	okayTakeResource = '{You/He} take{s} {an dobj/her} from
		{the iobj/him}. '

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

class Resource: Thing
	// Tweak vocabulary likelihood so we don't show up in disambiguation
	// prompts if we're still in the factory.
	vocabLikelihood = (isInFactory(self) ? -30 : 0)

	isEquivalent = true

	hideFromAll(action) { return(isInFactory(self)); }

	// The factory handles things for >TAKE [resource] FROM [factory],
	// but we also have to handle >TAKE [resource] by itself when
	// there's no other instance in scope besides the one in the
	// factory.
	dobjFor(Take) {
		verify() {
		//aioSay('\nlen = <<toString(gDobjCount)>>\n ');
			if(isInFactory(self))
				logicalRank(50, 'factory');
			inherited();
		}
		action() {
			if(isInFactory(self))
				replaceAction(TakeFrom, self, self.location);
			inherited();
		}
	}
;

class ResourceFactory: Container
	// Class of resource we dispense.  Should be overidden by instances.
	resourceClass = Resource

	// We don't list our contents because we always contain a phantom
	// resource.
	contentsListed = nil
	contentsListedInExamine = nil

	// Boolean.  If true we can put resource instances back in the factory.
	resourceReturnable = nil

	// Actual resource dispensing logic.
	iobjFor(TakeFrom) {
		action() {
			local obj;

			obj = createResource();
			obj.moveInto(gActor);
			defaultReport(&okayTakeResource);
			exit;
		}
	}

	// Handle returns.
	iobjFor(PutIn) {
		verify() {
			// If we don't accept returls, fail.
			if(!resourceReturnable)
				illogical(&cantPutAnythingInFactory);

			// We accept returns but the dobj isn't our
			// resource.
			if(!isResource(gDobj) || !gDobj.ofKind(resourceClass))
				illogical(&cantPutInNonResource);
		}

		// To do a return we do the default stuff--display message,
		// remove object from actor's inventory--and then we move
		// the object into nil;  we don't try to cache instances,
		// just dump and create a new one if we have to.
		action() {
			inherited();
			gDobj.moveInto(nil);
		}
	}

	// Resource creation method.  By default we just create an instance
	// of our resource class, but subclasses can fancy this up if
	// needed.
	createResource() {
		return(resourceClass.createInstance());
	}

	initializeThing() {
		inherited();
		initializeFactory();
	}

	// Factory initialization.  We create an instance of our resource
	// and add it to ourselves.  This is what saves us from
	// >TAKE [resource] failing with "You see no [resource] here. ".
	initializeFactory() {
		if(contains({ x: x.ofKind(resourceClass) }))
			return;
		createResource().moveInto(self);
	}
;
