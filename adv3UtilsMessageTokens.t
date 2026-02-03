#charset "us-ascii"
//
// adv3UtilsMessageTokens.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

class MessageToken: object
	id = nil
	prop = nil
	token = nil
	obj = nil
;

messageTokensPreinit: PreinitObject
	execAfterMe = [ MessageBuilder ]
	_messageTokens = perInstance(new Vector)

	execute() {
		initMessageTokens();
	}

	initMessageTokens() {
		forEachInstance(MessageToken, { x: addMessageToken(x) });
		
	}

	addMessageToken(obj) {
		if(!isMessageToken(obj)) return(nil);
		_messageTokens.appendUnique(obj);

#ifdef __DEBUG
		if(obj.id != obj.id.toLower()) {
			aioSay('\n===WARNING===\n ');
			aioSay('\nconverting MessageToken id <<obj.id>>
				to lower case\n ');
			aioSay('\n===WARNING===\n ');
		}
#endif // __DEBUG

		obj.id = obj.id.toLower();

		obj.token = 'token_' + obj.id;

		langMessageBuilder.paramList_
			= langMessageBuilder.paramList_.append(
				[ obj.id, obj.prop, obj.token, nil, nil ]);

		return(true);
	}
;

messageTokensInit: InitObject
	execute() {
		initMessageTokens();
	}

	initMessageTokens() {
		messageTokensPreinit._messageTokens.forEach({
			x: addMessageToken(x)
		});
	}

	addMessageToken(obj) {
		if(!isMessageToken(obj)) return(nil);

		langMessageBuilder.nameTable_[obj.token] = obj.obj;

		return(true);
	}
;
