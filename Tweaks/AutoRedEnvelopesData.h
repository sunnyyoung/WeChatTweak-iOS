//
//  WeChatTweak.h
//
//  Created by Sunnyyoung on 2017/01/01.
//

#import <Foundation/Foundation.h>

@interface AutoRedEnvelopesData : NSObject

@property (nonatomic, copy) NSString *msgType;
@property (nonatomic, copy) NSString *sendId;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *headImg;
@property (nonatomic, copy) NSString *nativeUrl;
@property (nonatomic, copy) NSString *sessionUserName;
@property (nonatomic, copy) NSString *timingIdentifier;

@property (nonatomic, assign) BOOL needsAutoOpen;

+ (instancetype)sharedInstance;
- (void)resetData;
- (NSDictionary *)keyValues;

@end
