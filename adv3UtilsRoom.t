#charset "us-ascii"
//
// adv3UtilsRoom.t
//
//	The Room class definition is extended to have a couple of
//	utility methods:
//
//		isAdjacent(rm, actor?)
//			Returns boolean true if there's an exit leading
//			this room to the given room
//
//		exitList(actor?, cb?)
//			Returns a list of all the exits currently apparent
//			to the given actor (defaulting to gActor if none is
//			specified).
//
//			The second argument is an optional test fuction taking
//			two arguments:  the direction and destination of
//			a candidate exit.  A return value of true indicates
//			the exit should be added to the exitList() return
//			value.
//
//			Each entry in the return value is an instance
//			of DestInfo.
//
//		destinationList(actor?, cb?)
//			Like exitList() (above), but returns a list of
//			destinations (probably Rooms) instead of DestInfo
//			instances.
//			
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify Room
	// Make sure we have an actor.
	_canonicalizeActor(actor?) {
		if(!isActor(actor)) actor = gActor;
		if(!isActor(actor)) actor = gameMain.initialPlayerChar;
		if(!isActor(actor)) return(nil);
		return(actor);
	}

	// Returns boolean true if the given room is adjacent to this
	// room as far as the given actor is concerned.
	isAdjacent(rm, actor?, cb?) {
		if((actor = _canonicalizeActor(actor)) == nil)
			return(nil);

		if(!isRoom(rm))
			return(nil);

		return(destinationList(actor, cb).indexOf(rm) != nil);
	}

	// Get all of the exits available to the given actor from this room.
	// Second arg is an optional callback.  See allDirectionsExitList() for
	// details.
	// As written this is just a wrapper for allDirectionsExitList(), but
	// it's still a separate function to make it easier to write
	// extensions that include non-directional exits.
	exitList(actor?, cb?) {
		return(allDirectionsExitList(actor, cb));
	}

	// Like exitList, but include just the destinations for each exit.
	destinationList(actor?, cb?) {
		local r;

		r = new Vector();
		exitList(actor, cb).forEach({ x: r.append(x.dest_) });

		return(r);
	}

	// Returns a list of all the exits from this room that are apparent to
	// the given actor, that correspond to the canonical directions.
	// Second arg is an optional arg to be used as a test function.  If
	// given, the callback will be called with the direction and
	// destination of each candidate exit, and exits will only be added to
	// the return vector if the callback returns true.
	allDirectionsExitList(actor?, cb?) {
		local c, dst, r;

		r = new Vector(Direction.allDirections.length());

		if((actor = _canonicalizeActor(actor)) == nil)
			return(r);

		// Iterate through all directions.
		Direction.allDirections.forEach(function(d) {
			// Get the connector for the given actor, in the
			// given direction.
			if((c = getTravelConnector(d, actor)) == nil)
				return;

			// If the connector isn't apparent to the actor,
			// skip it.
			if(!c.isConnectorApparent(self, actor))
				return;

			// Get the connector's destination.
			if((dst = c.getDestination(self, actor)) == nil)
				return;

			// If we have a callback, call it with the direction
			// and destination and bail if the return value is
			// not boolean true.
			if((cb != nil) && ((cb)(d, dst) != true))
				return;

			// Add the destination to the return vector.
			r.append(new DestInfo(d, dst, nil, nil));
		});

		return(r);
	}
;
