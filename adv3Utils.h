//
// adv3Utils.h
//

#ifndef gTurn
#define gTurn (libGlobal.currentTurn())
#endif // gTurn

// Utility define for testing an object to see if it is an instance of some
// class
#ifndef isType
#define isType(obj, cls) ((obj != nil) && obj.ofKind(cls))
#endif // isType

// Defines to test for common adv3 object types
#ifndef isActor
#define isActor(obj) (isType(obj, Actor))
#endif
#ifndef isAction
#define isAction(obj) (isType(obj, Action))
#endif
#ifndef isCollection
#define isCollection(obj) (isType(obj, Collection))
#endif
#ifndef isInteger
#define isInteger(obj) ((obj != nil) && (dataType(obj) == TypeInt))
#endif
#ifndef isString
#define isString(obj) ((obj != nil) && (dataType(obj) == TypeSString))
#endif
#ifndef isLocation
#define isLocation(obj) (isType(obj, BasicLocation))
#endif
#ifndef isObject
#define isObject(obj) ((obj != nil) && (dataType(obj) == TypeObject))
#endif
#ifndef isRoom
#define isRoom(obj) (isType(obj, Room))
#endif
#ifndef isThing
#define isThing(obj) (isType(obj, Thing))
#endif

#define DefineSmallWord(v) \
	v##SmallWord: SmallWord \
		word = 'v'

#define gSmallWords (_sw.smallWords)

#define isSmallWord(v) (isString(v) && (_sw.smallWords.indexOf(v.toLower()) != nil))

OrdinalThing template 'vocabWords' 'name' +ordinalNumber 'ordinalVocab'? @location? "desc"?;


#ifdef __DEBUG
#define gDebugObj(obj) (_debugObject(obj))
#else // __DEBUG
#define gDebugObj(obj)
#endif // __DEBUG


#define ADV3_UTILS_H
