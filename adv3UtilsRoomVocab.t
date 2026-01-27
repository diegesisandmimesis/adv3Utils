#charset "us-ascii"
//
// adv3UtilsRoomVocab.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify playerActionMessages
	// Generic failure message for trying actions on an adjacent
	// room.
	roomUnseenAdjacent(obj) {
		return('If {you/he} want{s} to do anything with
			<<obj.destName>>, {you/he} need to go there first. ');
	}
;

// Preinit object that sets up vocabulary for rooms (if they don't already
// have vocabulary defined)
roomVocabPreinit: PreinitObject
	execute() {
		forEachInstance(Room, function(o) {
			// Check to see if we're supposed to initialize
			// the vocabulary for this room.
			if(o.initializeVocab != true)
				return;

			// Make sure the room doesn't already have vocabulary
			// defined.
			if(o.vocabWords.length > 1)
				return;

			// Default to the roomName and the literal "room".
			o.initializeVocabWith(o.roomName + '/room');
		});
	}
;

modify Room
	// If this is true on an instance, we'll set up vocabulary for it
	// doing preinit.
	initializeVocab = true

	// By default, we use the room's destination name as its disambig
	// name.
	disambigName = destName

	// A room's vocabularly likelihood is normal if the player is
	// adjacent to the room, low otherwise.
	vocabLikelihood = (isAdjacent(self, gActor) ? 0 : -30)

	// Add all the rooms adjacent to this room to the scope list.
	getExtraScopeItems(actor) {
		local v;

		v = new Vector();
		exitList(actor).forEach(function(o) {
			if(v.indexOf(o.dest_) == nil)
				v.append(o.dest_);
		});

		return(v.toList());
	}

	// Custom-ish failure message for rooms.
	// This is used by action preconditions (objVisible and
	// TouchObjCondition, for example) and here we just do something
	// less confusing than the default "You cannot see that", which
	// is awkward for adjacent rooms.
	mustBeVisibleMsg() {
		if(isAdjacent(gActor.location, gActor))
			return(&roomUnseenAdjacent);
		else
			return(&mustBeVisibleMsg);
	}
;
