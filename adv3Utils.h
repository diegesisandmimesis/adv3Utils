//
// adv3Utils.h
//

#include "isType.h"

#ifdef ROMAN_ORDINAL
#include "intMath.h"
#ifndef INT_MATH_H
#error "When compiled with -D ROMAN_ORDINAL this module requires the intMath module."
#error "https://github.com/diegesisandmimesis/intMath"
#error "It should be in the same parent directory as this module.  So if"
#error "adv3Utils is in /home/user/tads/adv3Utils, then"
#error "intMath should be in /home/user/tads/intMath ."
#endif // INT_MATH_H
#endif // ROMAN_ORDINAL

#ifdef gTurn
#undef gTurn
#endif // gTurn
#ifndef gTurn
#define gTurn (libGlobal.currentTurn())
#endif // gTurn

#define gInterruptImplicit \
        (interruptImplicitHandler.interruptImplicitAction)

#define DefineSmallWord(v) \
	v##SmallWord: SmallWord \
		word = 'v'

#define gSmallWords (_sw.smallWords)

#define isSmallWord(v) (isString(v) && (_sw.smallWords.indexOf(v.toLower()) != nil))
#define isMessageToken(obj) (obj != nil) && obj.ofKind(MessageToken)
#define isResource(obj) isType(obj, Resource)
#define isResourceFactory(obj) isType(obj, ResourceFactory)
#define isInFactory(obj) (isResource(obj) && isResourceFactory(obj.location) \
		&& (obj.ofKind(obj.location.resourceClass)))


#define isEasyDoor(obj) isType(obj, EasyDoor)
#define isAutoUnlock(obj) isType(obj, AutoUnlock)

OrdinalThing template 'vocabWords' 'name' +ordinalNumber 'ordinalVocab'? @location? "desc"?;
OrdinalThing template 'vocabWords' 'name' +ordinalNumber [ordinalVocab]? @location? "desc"?;

EasyDoor template ->mainDoor? 'vocabWords'? 'name'? "desc"?;

// Alternate Room template that allows declaration of vocabulary.
Room template 'roomName' 'destName'? 'name'? 'vocabWords'? "desc"?;

MessageToken template 'id' ->prop @obj;

#define gDobjCount ((gAction && gAction.dobjList_) ? gAction.dobjList_.length : 0)

#ifdef __DEBUG
#define gDebugObj(obj) (_debugObject(obj))
#else // __DEBUG
#define gDebugObj(obj)
#endif // __DEBUG

#define SetActionType(name, t) \
	modify name##Action actionType = t;

#define ADV3_UTILS_H
