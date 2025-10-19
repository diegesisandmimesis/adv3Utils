//
// adv3Utils.h
//

#include "isType.h"

#ifndef gTurn
#define gTurn (libGlobal.currentTurn())
#endif // gTurn

#define DefineSmallWord(v) \
	v##SmallWord: SmallWord \
		word = 'v'

#define gSmallWords (_sw.smallWords)

#define isSmallWord(v) (isString(v) && (_sw.smallWords.indexOf(v.toLower()) != nil))

OrdinalThing template 'vocabWords' 'name' +ordinalNumber 'ordinalVocab'? @location? "desc"?;
OrdinalThing template 'vocabWords' 'name' +ordinalNumber [ordinalVocab]? @location? "desc"?;


#ifdef __DEBUG
#define gDebugObj(obj) (_debugObject(obj))
#else // __DEBUG
#define gDebugObj(obj)
#endif // __DEBUG


#define ADV3_UTILS_H
