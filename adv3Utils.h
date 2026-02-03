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

#ifndef gTurn
#define gTurn (libGlobal.currentTurn())
#endif // gTurn

#define DefineSmallWord(v) \
	v##SmallWord: SmallWord \
		word = 'v'

#define gSmallWords (_sw.smallWords)

#define isSmallWord(v) (isString(v) && (_sw.smallWords.indexOf(v.toLower()) != nil))
#define isMessageToken(obj) (obj != nil) && obj.ofKind(MessageToken)

OrdinalThing template 'vocabWords' 'name' +ordinalNumber 'ordinalVocab'? @location? "desc"?;
OrdinalThing template 'vocabWords' 'name' +ordinalNumber [ordinalVocab]? @location? "desc"?;

// Alternate Room template that allows declaration of vocabulary.
Room template 'roomName' 'destName'? 'name'? 'vocabWords'? "desc"?;

MessageToken template 'id' ->prop @obj;

#ifdef __DEBUG
#define gDebugObj(obj) (_debugObject(obj))
#else // __DEBUG
#define gDebugObj(obj)
#endif // __DEBUG


#define ADV3_UTILS_H
