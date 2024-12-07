#charset "us-ascii"
//
// adv3UtilsDebug.t
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
