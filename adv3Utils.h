//
// adv3Utils.h
//

#ifndef gTurn
#define gTurn (libGlobal.currentTurn())
#endif // gTurn

// Utility define for testing an object to see if it is an instance of some
// class
#define isType(obj, cls) ((obj != nil) && obj.ofKind(cls))

// Defines to test for common adv3 object types
#define isActor(obj) (isType(obj, Actor))
#define isAction(obj) (isType(obj, Action))
#define isCollection(obj) (isType(obj, Collection))
#define isInteger(obj) ((obj != nil) && (dataType(obj) == TypeInt))
#define isLocation(obj) (isType(obj, BasicLocation))
#define isObject(obj) ((obj != nil) && (dataType(obj) == TypeObject))
#define isRoom(obj) (isType(obj, Room))
#define isThing(obj) (isType(obj, Thing))

#define ADV3_UTILS_H
