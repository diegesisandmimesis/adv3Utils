#charset "us-ascii"
//
// easyDoor.t
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

// Preinit functions moved to a standalone object.  Because it turns out
// we want to iterate over all travel connectors and all EasyDoor instances
// and we can't just do one in the other (we don't want to have to iterate
// over all TravelConnectors for each EasyDoor).
easyDoorPreinit: PreinitObject
	execute() {
		forEachInstance(TravelConnector, { x: x.initializeEasyDoor() });
		forEachInstance(EasyDoor, { x: x.initializeEasyDoor() });
	}
;

// Modify TravelConnector check the instance and if it's the child of
// an EasyDoor, ping it to let it know.
modify TravelConnector
	// Flag used to distinguish between connectors that are created
	// by EasyDoor and ones that are declared statically.
	easyDoorFlag = nil

	initializeEasyDoor() {
		if(isEasyDoor(location))
			location.addDoor(self);
	}
;

class EasyDoor: object
	doorClass = Door	// Class of door we create

	mainDoor = nil		// room the "masterObject" is in

	name = ''
	vocabWords = ''
	desc = nil

	_locations = nil	// Internal use only
	_definedDoors = nil

	// Called by any travel connector that is our lexical child,
	// during preinit.  We add it to a list so we know to create
	// fewer door instances later.
	addDoor(obj) {
		if(!isTravelConnector(obj))
			return(nil);
		if(_definedDoors == nil)
			_definedDoors = new Vector(2);
		_definedDoors.append(obj);
		return(true);
	}

	initializeEasyDoor() {
		// List for all the locations we're mentioned in.
		_locations = new Vector();

		// Iterate over all rooms.
		forEachInstance(Room, { x: checkRoom(x) });

		// If we're not in exactly two locations something's wrong,
		// give up.
		if(_locations.length != 2)
			return;

		// Set up the "real" doors.
		createDoors();

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
	createDoors() {
		local d0, d1, dst, src;

		if(_definedDoors == nil)
			_definedDoors = new Vector(2);

		// We need two instances of our door class.  We might
		// have some already declared, so just add more until
		// we have enough.
		while(_definedDoors.length < 2) {
			_definedDoors.append(doorClass.createInstance());
			_definedDoors[_definedDoors.length].easyDoorFlag = true;
		}

		d0 = _definedDoors[1];
		d1 = _definedDoors[2];

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
		initDoor(d0, src, d1, dst);
		initDoor(d1, dst, d0, src);

		_tweakVocab(d0);
		_tweakVocab(d1);

		// Final configuration.  This is so individual door classes
		// can implement their own setup methods.  We do this
		// after both doors have done initDoor() above so each
		// instance knows about its other half.
		d0.configureDoor(self);
		d1.configureDoor(self);
	}

	// Basic setup.  door and otherDoor are instances of doorClass,
	// and cfg and otherCfg are instances of _EasyDoorCfg.
	initDoor(door, cfg, otherDoor, otherCfg) {
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

	_tweakVocab(d) {
		if(d.easyDoorFlag == true)
			_tweakVocabDefault(d);
		else
			_tweakVocabSafe(d);
	}

	// Set the name, vocabulary, and description on a door instance
	// if a) the door class doesn't come with one or b) we have one
	// set.
	_tweakVocabDefault(d) {
		if((d.name == '') || (name != ''))
			d.name = name;
		if((d.vocabWords == '') || (vocabWords != ''))
			d.initializeVocabWith(vocabWords);
		if((d.propType(&desc) == TypeNil)
			|| (propType(&desc) != TypeNil))
			d.setMethod(&desc, {: "<<desc>>" });
	}

	// Set the name and so on only if the door instance doesn't
	// already have one.  This is so statically-declared doors
	// lexically added to us can have different properties than
	// the class.  Really an implementation wart:  this only saves
	// effort if one of the instances wants to override the
	// EasyDoor defaults for only *some* of these properties.  Because
	// if it replaces all of them, then you have a complete set
	// of declarations on the "custom" instance, and then another
	// complete set on the EasyDoor instance.  Which would be the
	// same amount of effort as putting everything on the second,
	// "non-custom" instance instead of the EasyDoor.  But eh.
	_tweakVocabSafe(d) {
		if((d.name == '') && (name != ''))
			d.name = name;
		if((d.vocabWords == '') && (vocabWords != ''))
			d.initializeVocabWith(vocabWords);
		if((d.propType(&desc) == TypeNil)
			&& (propType(&desc) != TypeNil))
			d.setMethod(&desc, {: "<<desc>>" });
	}
;

// Put a stub config method on ThroughPassage;  we call it "configureDoor()"
// but we're technically happy handling any kind of travel connector.
// But "door" is a lot easier to type.
modify ThroughPassage
	configureDoor(obj) {}
;

// Tweak configureDoor() on LockableWithKey to add any keylist on the
// EasyDoor.
modify LockableWithKey
	configureDoor(obj) {
		if(obj.keyList)
			keyList = obj.keyList;
		inherited(obj);
	}
;
