#charset "us-ascii"
//
// debug.t
//
//	Provides a _debugObject() method that enumerates the properties
//	on a given object.  Enabled only when t3make is called with
//	the debugging flag.
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

#ifdef __DEBUG

_debugObject(obj) {
	if(obj == nil) return;
	aioSay('\n===<<toString(obj)>> start===\n ');
	obj.getPropList().sort(nil,
		{ a, b: toString(a).compareTo(toString(b)) })
		.forEach(function(o) {
			if(!obj.propDefined(o, PropDefDirectly)) return;
			aioSay('\n\t<<toString(o)>>:
				<<toString((obj).(o))>>\n ');
	});
	aioSay('\n===<<toString(obj)>> end===\n ');
}

#endif // __DEBUG
