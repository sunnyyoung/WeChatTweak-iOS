//
//  WeChatTweak.h
//
//  Created by Sunnyyoung on 2017/01/01.
//

#import "AutoRedEnvelopesData.h"

@implementation AutoRedEnvelopesData : NSObject

+ (instancetype)sharedInstance {
    static AutoRedEnvelopesData *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AutoRedEnvelopesData alloc] init];
    });
    return sharedInstance;
}

- (void)resetData {
    self.msgType = nil;
    self.sendId = nil;
    self.channelId = nil;
    self.nickName = nil;
    self.headImg = nil;
    self.nativeUrl = nil;
    self.sessionUserName = nil;
    self.timingIdentifier = nil;
    self.needsAutoOpen = NO;
}

- (NSDictionary *)keyValues {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    dictionary[@"msgType"] = self.msgType;
    dictionary[@"sendId"] = self.sendId;
    dictionary[@"channelId"] = self.channelId;
    dictionary[@"nickName"] = self.nickName;
    dictionary[@"headImg"] = self.headImg;
    dictionary[@"nativeUrl"] = self.nativeUrl;
    dictionary[@"sessionUserName"] = self.sessionUserName;
    dictionary[@"timingIdentifier"] = self.timingIdentifier;
    return dictionary;
}

@end