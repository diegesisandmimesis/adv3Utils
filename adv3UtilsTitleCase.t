#charset "us-ascii"
//
// adv3UtilsTitleCase.t
//
//	Function to convert a string into title case.  That is, capitalize
//	the first letter of each word, optionally not capitalizing "small"
//	words (a, an, of, the, and to by default).
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

class SmallWord: PreinitObject
	word = nil
	execute() { _sw.smallWords.append(word); }
;

_sw: object smallWords = static new Vector();

DefineSmallWord(a);
DefineSmallWord(an);
DefineSmallWord(of);
DefineSmallWord(the);
DefineSmallWord(to);

titleCase(txt, skipSmallWords?) {
	if(txt == nil) return('');
	return(rexReplace('%<(<alphanum|squote>+)%>', txt,
		function(s, idx) {
			// Skip capitalization if:
			//	-the skipSmallWords flag is set,
			//	-we're not at the very start of the string
			//	-we're in the list of skippable words.
			if((skipSmallWords == true) && (idx > 1) &&
				isSmallWord(s))
				return(s);

			// Capitalize the first letter.
			return(s.substr(1, 1).toTitleCase()
				+ s.substr(2));
		}, ReplaceAll)
	);
}
