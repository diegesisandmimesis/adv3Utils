#charset "us-ascii"
//
// adv3UtilsThingStateMulti.t
//
//
#include <adv3.h>
#include <en_us.h>

#include "adv3Utils.h"

// Duplicated from adv3Pathches, in case it isn't being used.
modify ThingState
	// Returns bookean true if our state tokens list contains the
	// given token, matched case-insensitively, and matching possessives.
	matchStateToken(tok) {
		tok = tok.toLower();

		return(stateTokens.indexWhich(function(o) {
			// Make it lower case.
			o = o.toLower();

			// If it's a possessive, chop of the
			// apostrophe-S ending.
			if(o.endsWith('\'s'))
				o = o.substr(1, o.length() - 2);

			// See if it matches.
			return(o == tok);
		}) != nil);
	}
;

modify ThingState
	active = nil
	order = -1

	// If we have an order defined, we're active if the active flag
	// is true.  If we DON'T have an order defined we're always active
	// (which is basically a fall-through to the base ThingState
	// behavior).
	isActive() { return(isMulti() ? (active == true) : true); }
	isMulti() { return(order > -1); }

	stateDesc = ""
	roomRemoteDesc(actor) {}
	roomDesc = ""
	roomFirstDesc { roomDesc; }
	roomDarkDesc = ""

	matchName(obj, origTokens, toks, states) {
		local i, l, len, tok;

		if(!isActive())
			return(nil);

		len = toks.length();
		for(i = 1; i <= len; i+= 2) {
			tok = toks[i];

			// If the token is in our stateTokens list, move
			// on to the next token.
			if(matchStateToken(tok))
				continue;

			// Get a list of all other states that match
			// this token
			l = states.subset({
				x: x.matchStateToken(tok) != nil
			});

			// If the match is in an active multi state
			// then we can match the token.
			if(l.indexWhich({ x: x.isMulti() && x.isActive() })
				!= nil)
				continue;

			// If we have a match that ISN'T an active multi
			// state, then since we already know the token
			// isn't in our state list it is specific to that
			// other state, so we fail.
			if(l.length > 0)
				return(nil);
		}

		return(obj);
	}
;

modify Thing
	examineStatus() {
		local st;

		inherited();

		if((st = getState()) != nil)
			st.stateDesc;
	}

	lookAroundWithinDesc(actor, illum) {
		local pov, st;

		if(illum > 1) {
			pov = getPOVDefault(actor);
			st = getState();
			if(!actor.isIn(self) || (actor != pov)) {
				roomRemoteDesc(actor);
				if(st) st.roomRemoteDesc(actor);
			} else if(actor.hasSeen(self)) {
				roomDesc;
				if(st) st.roomDesc;
			} else {
				roomFirstDesc;
				if(st) st.roomFirstDesc;
			}
		} else {
			roomDarkDesc;
			if(st) st.roomDarkDesc;
		}
	}
;
