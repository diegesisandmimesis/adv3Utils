#charset "us-ascii"
//
// resourceFactory.t
//
//	Dispenser for Resource instances.
//
//	Interesting properties:
//
//		resourceClass		The class of Resource the factory
//					dispenses
//
//		resourceReturnable	boolean.  if true, the factory
//					will also accept returned resources
//					via >PUT [resource} IN [factory]
//					returned resources are discarded
//
//					default nil
//
//		maxResources		maximum number of resources
//					obtainable from the factory at a
//					time
//
//					default 1
//
//		refillResources		boolean.  if true the factory will
//					refill itself when its contents
//					drop below maxResources resources
//
//					default true
//
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

class ResourceFactory: Container
	// Class of resource we dispense.  Should be overidden by instances.
	resourceClass = Resource

	// Boolean.  If true we can put resource instances back in the factory.
	resourceReturnable = nil

	// The maximum number of resources available in the factory at any
	// given time.
	maxResources = 1

	// Boolean.  If true, the factory will try to always have
	// maxResources on hand.
	refillResources = true

	// We don't list our contents because we always contain a phantom
	// resource.
	contentsListed = nil
	contentsListedInExamine = nil

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
