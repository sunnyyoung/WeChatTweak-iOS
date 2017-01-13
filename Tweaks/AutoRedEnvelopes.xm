#import "AutoRedEnvelopes.h"
#import "AutoRedEnvelopesData.h"

%hook CMessageMgr

- (void)AsyncOnAddMsg:(NSString *)msg MsgWrap:(CMessageWrap *)wrap {
    %orig;
    switch(wrap.m_uiMessageType) {
    case 49: {
        CContactMgr *contactManager = [[%c(MMServiceCenter) defaultCenter] getService:[%c(CContactMgr) class]];
        CContact *selfContact = [contactManager getSelfContact];

        if ([wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound) {
            // 是否打开红包开关
            BOOL isAutoRedEnvelopes = [[NSUserDefaults standardUserDefaults] boolForKey:@"WeChatTweakAutoRedEnvelopesKey"];
            // 是否抢自己发出的
            BOOL isAutoRedEnvelopesFromMe = [[NSUserDefaults standardUserDefaults] boolForKey:@"WeChatTweakAutoRedEnvelopesFromMeKey"];
            // 群聊
            BOOL isChatRoom = ([wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound) || ([wrap.m_nsToUsr rangeOfString:@"@chatroom"].location != NSNotFound);
            // 自己发红包
            BOOL isFromMe = [wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName];

            if (isAutoRedEnvelopes && isChatRoom && (isAutoRedEnvelopesFromMe && isFromMe)) {
                NSString *parametersString = [wrap.m_oWCPayInfoItem.m_c2cNativeUrl stringByReplacingOccurrencesOfString:@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" withString:@""];
                NSDictionary *parametersDictionary = [%c(WCBizUtil) dictionaryWithDecodedComponets:parametersString separator:@"&"];

                AutoRedEnvelopesData *data = [AutoRedEnvelopesData sharedInstance];
                data.nickName = [selfContact getContactDisplayName] ?: @"";
				data.headImg = [selfContact m_nsHeadImgUrl] ?: @"";
                data.msgType = parametersDictionary[@"msgtype"] ?: @"1";
				data.sendId = parametersDictionary[@"sendid"] ?: @"";
				data.channelId = parametersDictionary[@"channelid"] ?: @"1";
                data.nativeUrl = wrap.m_oWCPayInfoItem.m_c2cNativeUrl ?: @"";
				data.sessionUserName = isFromMe ? wrap.m_nsToUsr : wrap.m_nsFromUsr;
                data.needsAutoOpen = YES;

                NSMutableDictionary *receiverQuery = [NSMutableDictionary dictionary];
				receiverQuery[@"agreeDuty"] = @"0";
                receiverQuery[@"inWay"] = @"0";
                receiverQuery[@"nativeUrl"] = wrap.m_oWCPayInfoItem.m_c2cNativeUrl ?: @"";
				receiverQuery[@"channelId"] = parametersDictionary[@"channelid"] ?: @"1";
				receiverQuery[@"msgType"] = parametersDictionary[@"msgtype"] ?: @"1";
				receiverQuery[@"sendId"] = parametersDictionary[@"sendid"] ?: @"";
                WCRedEnvelopesLogicMgr *logicMgr = [[%c(MMServiceCenter) defaultCenter] getService:[%c(WCRedEnvelopesLogicMgr) class]];
				[logicMgr ReceiverQueryRedEnvelopesRequest:receiverQuery];
            }
        }
        break;
    }
    default:
        break;
    }
}

%end

%hook WCRedEnvelopesLogicMgr

- (void)OnWCToHongbaoCommonResponse:(HongBaoRes *)arg1 Request:(id)arg2 {
    %orig;
	NSString *responseString = [[NSString alloc] initWithData:arg1.retText.buffer encoding:NSUTF8StringEncoding];
	NSDictionary *responseDicrionary = [responseString JSONDictionary];
    NSString *timingIdentifier = responseDicrionary[@"timingIdentifier"];
    NSInteger receiveStatus = [responseDicrionary[@"receiveStatus"] integerValue];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AutoRedEnvelopesData *data = [AutoRedEnvelopesData sharedInstance];
    BOOL isAutoRedEnvelopes = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesKey"];
    BOOL isAutoRedEnvelopesDelayRandomly = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesDelayRandomlyKey"];
    CGFloat delaySeconds = [userDefaults doubleForKey:@"WeChatTweakAutoRedEnvelopesDelaySecondsKey"];
    CGFloat ramdomly = (double)(arc4random()/0x100000000);

	if (isAutoRedEnvelopes && timingIdentifier.length && receiveStatus != 2 && data.needsAutoOpen) {
        data.timingIdentifier = timingIdentifier;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((isAutoRedEnvelopesDelayRandomly ? (ramdomly*delaySeconds) : delaySeconds) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            WCRedEnvelopesLogicMgr *logicMgr = [[%c(MMServiceCenter) defaultCenter] getService:[%c(WCRedEnvelopesLogicMgr) class]];
            [logicMgr OpenRedEnvelopesRequest:[data keyValues]];
            [data resetData];
        });
    }
}

%end
