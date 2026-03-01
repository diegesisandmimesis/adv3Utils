#charset "us-ascii"
//
// doorPair.t
//
//	Logic to make it easier/less fiddly to declare doors.
//
//
// USAGE
//
//	The simplest usage is to declare a DoorPair instance and then
//	refer to it in the directional properties of the two rooms it
//	connects.  Example:
//
//		// The vocab, name, and desc will be the same on both sides.
//		myDoor: DoorPair '(wooden) door' 'door' "A wooden door. ";
//
//		southRoom: Room 'South Room'
//			"There's a door leading north. "
//			north = myDoor
//		;
//		northRoom: Room 'North Room'
//			"There's a door leading south. "
//			south = myDoor
//		;
//
//	If the doors aren't functionally identical (for purposes of locking,
//	for example) the room containing the "masterObject" of the pair
//	can be defined in the mainDoorLocation property, or using the
//	template:
//
//		// Explicitly set mainDoorLocation.
//		myDoor: DoorPair '(wooden) door' 'door'
//			"A wooden door. "
//			mainDoorLocation = northRoom
//		;
//
//		// Same as above via template.
//		myDoor: DoorPair ->northRoom '(wooden) door' 'door'
//			"A wooden door. ";
//
//	The class used when creating the doors can be specified in the
//	doorClass property.  The default is Door.
//
//		// Set the door class
//		myDoor: DoorPair '(auto) (closing) door' 'door'
//			"An auto-closing door. "
//			doorClass = AutoClosingDoor
//		;
//
//	The doorClass can be either a single class or a list:
//
//		class WoodenDoor: Door '(wooden) door' 'door' "A wooden door. ";
//		class MetalDoor: Door '(metal) door' 'door' "A metal door. ";
//
//		// The "main" door will use MetalDoor, the other side will
//		// use WoodenDoor.
//		myDoor: DoorPair ->northRoom
//			doorClass = static [ MetalDoor, WoodenDoor ]
//		;
//
//	You can also declare door instances to be used (so just using the
//	DoorPair class to handle the logic of connecting everything up).
//
//		// The "main" door will be the declared instance,
//		// and the other side will be default WoodenDoor instance.
//		// Basically the same as the example above, only the metal
//		// door gets a different description.
//		myDoor: DoorPair ->northRoom
//			doorClass = WoodenDoor
//		;
//		+MetalDoor desc = "This is a slightly different metal door. ";
//
//		// Both doors are statically declared.
//		myDoor: DoorPair ->northRoom;
//		+MetalDoor desc = "This is a slightly different metal door. ";
//		+WoodenDoor;
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

// Helper class.
class _DoorPairCfg: object
	room = nil			// Room the door is in
	dir = nil			// Direction of the door
	construct(v0, v1) {
		room = v0;
		dir = v1;
	}
;

// Preinit functions moved to a standalone object.  Because it turns out
// we want to iterate over all travel connectors and all DoorPair instances
// and we can't just do one in the other (we don't want to have to iterate
// over all TravelConnectors for each DoorPair).
doorPairPreinit: PreinitObject
	execute() {
		forEachInstance(TravelConnector, { x: x.initializeDoorPair() });
		forEachInstance(DoorPair, { x: x.initializeDoorPair() });
	}
;

// Modify TravelConnector check the instance and if it's the child of
// an DoorPair, ping it to let it know.
modify TravelConnector
	// Flag used to distinguish between connectors that are created
	// by DoorPair and ones that are declared statically.
	doorPairFlag = nil

	initializeDoorPair() {
		if(isDoorPair(location))
			location.addDoor(self);
	}
;

class DoorPair: object
	doorClass = Door	// Class of door we create

	mainDoorLocaiton = nil	// room the "masterObject" is in

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

	initializeDoorPair() {
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
				_locations.append(new _DoorPairCfg(rm, d));
			}
		});

	}

	// Logic that actually creates any door instances we need, without
	// doing any configuration.
	_createDoors() {
		// A temporary-ish vector to hold the door instances.  In
		// theory we could already have some because we now support
		// declaring them in source but if the prop is nil we're
		// starting from scratch.
		if(_definedDoors == nil)
			_definedDoors = new Vector(2);

		// We need two instances of our door class.  We might
		// have some already declared, so just add more until
		// we have enough.
		while(_definedDoors.length < 2) {
			_definedDoors.append(_getDoorClass().createInstance());

			// Set the flag that indicates the door was created
			// rather than declared.  This will prevent the
			// DoorPair overwriting the name and so on even
			// if they're declared on the DoorPair.
			_definedDoors[_definedDoors.length].doorPairFlag = true;
		}
	}

	// Get the class for a newly-created door.
	_getDoorClass() {
		// Easiest case.  If we're not an array type, just return
		// the declared class.
		if(!isCollection(doorClass))
			return(doorClass);

		// If we're here, we're in the middle of adding instances
		// to _definedDoors.  So if _defined doors is currently
		// n elements long, we want the class for the n + 1th
		// door.  If the list is that long, just return that class.
		if(doorClass.length >= _definedDoors.length + 1)
			return(doorClass[_definedDoors.length + 1]);

		// Nope, we can't map classes 1-to-1 with doors, so just
		// use the first element of the list.
		return(doorClass[1]);
	}

	// Create the "real" doors we represent.
	createDoors() {
		local d0, d1, dst, src;

		_createDoors();
		d0 = _definedDoors[1];
		d1 = _definedDoors[2];

		// Convenience variables for our saved locations.
		src = _locations[1];
		dst = _locations[2];

		// Make sure one of the doors is the "main" one.  This
		// is used to figure out which door is what adv3 calls
		// by the unfortunate name "masterObject".
		if(mainDoorLocation == nil)
			mainDoorLocation = src.room;

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
	// and cfg and otherCfg are instances of _DoorPairCfg.
	initDoor(door, cfg, otherDoor, otherCfg) {
		// Put the door in its room.
		door.moveInto(cfg.room);

		// Connect the door to the room's direction property.
		cfg.room.(cfg.dir.dirProp) = door;

		// Declare the "masterObject".
		if(cfg.room == mainDoorLocation)
			door.masterObject = door;
		else
			door.masterObject = otherDoor;

		// Set the other side.
		door.otherSide = otherDoor;
	}

	_tweakVocab(d) {
		if(d.doorPairFlag == true)
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
			d.setMethod(&desc, getMethod(&desc));
	}

	// Set the name and so on only if the door instance doesn't
	// already have one.  This is so statically-declared doors
	// lexically added to us can have different properties than
	// the class.  Really an implementation wart:  this only saves
	// effort if one of the instances wants to override the
	// DoorPair defaults for only *some* of these properties.  Because
	// if it replaces all of them, then you have a complete set
	// of declarations on the "custom" instance, and then another
	// complete set on the DoorPair instance.  Which would be the
	// same amount of effort as putting everything on the second,
	// "non-custom" instance instead of the DoorPair.  But eh.
	_tweakVocabSafe(d) {
		if((d.name == '') && (name != ''))
			d.name = name;
		if((d.vocabWords == '') && (vocabWords != ''))
			d.initializeVocabWith(vocabWords);
		if((d.propType(&desc) == TypeNil)
			&& (propType(&desc) != TypeNil))
			d.setMethod(&desc, getMethod(&desc));
	}
;

// Put a stub config method on TravelConnector;  we call it "configureDoor()"
// but we're technically happy handling any kind of travel connector.
// But "door" is a lot easier to type.
modify TravelConnector
	configureDoor(obj) {}
;

// Tweak configureDoor() on LockableWithKey to add any keylist on the
// DoorPair.
modify LockableWithKey
	configureDoor(obj) {
		if(obj.keyList)
			keyList = obj.keyList;
		inherited(obj);
	}
;
