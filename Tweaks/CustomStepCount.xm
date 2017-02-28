#import "CustomStepCount.h"

%hook WCDeviceStepObject

- (unsigned long)m7StepCount {
    NSUInteger customStepCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"WeChatTweakCustomStepCountKey"];
    return customStepCount == 0 ? %orig : customStepCount;
}

%end
