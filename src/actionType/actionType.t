#charset "us-ascii"
//
// actionType.t
//
//	Adds an actionType property to Action.  Intended to make it
//	easier to group actions for allowing/blocking/modifying.
//
//	Current tags are:
//
//		sense_t		sensing actions, like looking
//
//		travel_t	travel actions
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

enum sense_t, travel_t;

modify Action actionType = nil;

SetActionType(Examine, sense_t);
SetActionType(Look, sense_t);
SetActionType(ListenTo, sense_t);
SetActionType(Taste, sense_t);
SetActionType(Feel, sense_t);
SetActionType(SenseImplicit, sense_t);

SetActionType(Travel, travel_t);
SetActionType(TravelVia, travel_t);
