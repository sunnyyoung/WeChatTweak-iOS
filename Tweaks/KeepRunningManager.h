//
//  WeChatTweak.h
//
//  Created by Sunnyyoung on 2017/01/01.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface KeepRunningManager : NSObject

@property (nonatomic, readonly) BOOL playing;

+ (instancetype)sharedInstance;
- (void)startKeepRunning;
- (void)stopKeepRunning;

@end
