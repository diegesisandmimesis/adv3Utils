#charset "us-ascii"
//
// objectAnnouncement.t
//
//	Add togglable flags for different object announcement styles.
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

modify Thing
	announcementFlag =
		( ANNOUNCE_MULTI | ANNOUNCE_AMBIG | ANNOUNCE_DEFAULT )
;

modify libMessages
	announceMultiActionObject(obj, whichObj, action) {
		if(obj.announcementFlag & ANNOUNCE_MULTI)
			return(inherited(obj, whichObj, action));
		else
			return('');
	}

	announceAmbigActionObject(obj, whichObj, action) {
		if(obj.announcementFlag & ANNOUNCE_AMBIG)
			return(inherited(obj, whichObj, action));
		else
			return('');
	}

	announceDefaultObject(obj, whichObj, action, resolvedAllObjects) {
		if(obj.announcementFlag & ANNOUNCE_DEFAULT)
			return(inherited(obj, whichObj, action,
				resolvedAllObjects));
		else
			return('');
	}
;
