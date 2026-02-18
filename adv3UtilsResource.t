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

class ResourceFactory: Container
	// Class of resource we dispense.  Should be overidden by instances.
	resourceClass = Resource

	// We don't list our contents because we always contain a phantom
	// resource.
	contentsListed = nil
	contentsListedInExamine = nil

	// Boolean.  If true we can put resource instances back in the factory.
	resourceReturnable = nil

	// The maximum number of resources available in the factory at any
	// given time.
	maxResources = 1

	// Boolean.  If true, the factory will try to always have
	// maxResources on hand.
	refillResources = true

	getResourceCount() {
		return(searchContents({ x: isType(x, resourceClass) }).length);
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

	// Refill the factory.  Optional arg is boolean.  By default
	// we don't refill unless the refillResource flag is true.  If
	// the force arg is true we refill regardless.
	refillFactory(force?) {
		local obj;

		if((refillResources != true) && (force != true))
			return;

		while(getResourceCount() < maxResources) {
			obj = createResource();
			obj.moveInto(self);
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
		refillFactory(true);
	}
;
