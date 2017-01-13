#import "CustomGame.h"

CMessageWrap *setDice(CMessageWrap *wrap, unsigned int point) {
	if (wrap.m_uiGameType == 2) {
		wrap.m_uiGameContent = point + 3;
	}
	return wrap;
}

CMessageWrap *setRPS(CMessageWrap *wrap, unsigned int type) {
	if (wrap.m_uiGameType == 1) {
		wrap.m_uiGameContent = type;
	}
	return wrap;
}

%hook GameController

+ (id)getMD5ByGameContent:(unsigned int)arg1 {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger diceNumber = [userDefaults integerForKey:@"WeChatTweakCustomDiceNumberKey"];
    NSInteger rpsResult = [userDefaults integerForKey:@"WeChatTweakCustomRPSResultKey"];
	if (arg1 > 3 && arg1 < 10) {
		if (diceNumber) {
			return %orig(diceNumber + 3);
		} else {
			return %orig;
		}
	} else if (arg1 > 0 && arg1 < 4) {
		if (rpsResult) {
			return %orig(rpsResult);
		} else {
			return %orig;
		}
	} else {
		return %orig;
	}
}

%end

%hook CMessageMgr

- (void)AddEmoticonMsg:(id)arg1 MsgWrap:(id)arg2 {
	CMessageWrap *wrap = (CMessageWrap *)arg2;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger diceNumber = [userDefaults integerForKey:@"WeChatTweakCustomDiceNumberKey"];
    NSInteger rpsResult = [userDefaults integerForKey:@"WeChatTweakCustomRPSResultKey"];
	if (wrap.m_uiGameType == 2) {
		if (diceNumber) {
			%orig(arg1, setDice(arg2, diceNumber));
		} else {
			%orig;
		}
	} else if (wrap.m_uiGameType == 1) {
		if (rpsResult) {
			%orig(arg1, setRPS(arg2, rpsResult));
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}

%end

%hook CEmoticonUploadMgr

- (void)StartUpload:(id)arg1 {
	CMessageWrap *wrap = (CMessageWrap *)arg1;
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger diceNumber = [userDefaults integerForKey:@"WeChatTweakCustomDiceNumberKey"];
    NSInteger rpsResult = [userDefaults integerForKey:@"WeChatTweakCustomRPSResultKey"];
	if (wrap.m_uiGameType == 2) {
		if (diceNumber) {
			%orig(setDice(arg1, diceNumber));
		} else {
			%orig;
		}
	} else if (wrap.m_uiGameType == 1) {
		if (rpsResult) {
			%orig(setRPS(arg1, rpsResult));
		} else {
			%orig;
		}
	} else {
		%orig;
	}
}

%end
