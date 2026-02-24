#charset "us-ascii"
//
// adv3UtilsEasyDoor.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

// Helper class.
class _EasyDoorCfg: object
	room = nil			// Room the door is in
	dir = nil			// Direction of the door
	construct(v0, v1) {
		room = v0;
		dir = v1;
	}
;

class EasyDoor: PreinitObject
	doorClass = Door	// Class of door we create

	mainDoor = nil		// room the "masterObject" is in

	name = ''
	vocabWords = ''
	desc = nil

	_locations = nil	// Internal use only

	// Preinit method.
	execute() {
		// List for all the locations we're mentioned in.
		_locations = new Vector();

		// Iterate over all rooms.
		forEachInstance(Room, { x: checkRoom(x) });

		// If we're not in exactly two locations something's wrong,
		// give up.
		if(_locations.length != 2)
			return;

		// Set up the "real" doors.
		initDoor();

		// Done with the locations list.
		_locations = nil;
	}

	// See if we're in the given room.
	checkRoom(rm) {

		// Check all direction properties on the room to see if
		// any of them point to us.
		Direction.allDirections.forEach(function(d) {
			local dst;

			if((dst = rm.(d.dirProp)) == nil)
				return;

			// Remember that this 
			if(dst == self) {
				_locations.append(new _EasyDoorCfg(rm, d));
			}
		});

	}

	// Create the "real" doors we represent.
	initDoor() {
		local d0, d1, dst, src;

		// We need to instances of our door class.
		d0 = doorClass.createInstance();
		d1 = doorClass.createInstance();

		/*
		if(keyList) {
			d0.keyList = keyList;
			d1.keyList = keyList;
		}
		*/

		// Convenience variables for our saved locations.
		src = _locations[1];
		dst = _locations[2];

		// Make sure one of the doors is the "main" one.  This
		// is used to figure out which door is what adv3 calls
		// by the unfortunate name "masterObject".
		if(mainDoor == nil)
			mainDoor = src.room;

		// Basic setup.  This is where we move the doors into
		// their rooms, hook them up to the direction properties,
		// and set their destination/otherSide.
		_initDoor(d0, src, d1, dst);
		_initDoor(d1, dst, d0, src);

		_tweakVocab(d0);
		_tweakVocab(d1);

		// Final configuration.  This is so individual door classes
		// can implement their own setup methods.  We do this
		// after both doors have done _initDoor() above so each
		// instance knows about its other half.
		d0.configureDoor(self);
		d1.configureDoor(self);
	}

	// Basic setup.  door and otherDoor are instances of doorClass,
	// and cfg and otherCfg are instances of _EasyDoorCfg.
	_initDoor(door, cfg, otherDoor, otherCfg) {
		// Put the door in its room.
		door.moveInto(cfg.room);

		// Connect the door to the room's direction property.
		cfg.room.(cfg.dir.dirProp) = door;

		// Declare the "masterObject".
		if(cfg.room == mainDoor)
			door.masterObject = door;
		else
			door.masterObject = otherDoor;

		// Set the other side.
		door.otherSide = otherDoor;
	}

	// Set the name, vocabulary, and description on a door instance
	// if a) the door class doesn't come with one or b) we have one
	// set.
	_tweakVocab(d) {
		if((d.name == '') || (name != ''))
			d.name = name;
		if((d.vocabWords == '') || (vocabWords != ''))
			d.initializeVocabWith(vocabWords);
		if((d.propType(&desc) != TypeNil)
			|| (propType(&desc) != TypeNil))
			d.setMethod(&desc, {: "<<desc>>" });

	}
;

// Put a stub config method on ThroughPassage;  we call it "configureDoor()"
// but we're technically happy handling any kind of travel connector.
// But "door" is a lot easier to type.
modify ThroughPassage
	configureDoor(obj) {}
;
