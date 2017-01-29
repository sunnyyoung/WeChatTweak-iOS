#import "KeepRunning.h"
#import "KeepRunningManager.h"

%hook MicroMessengerAppDelegate

- (void)applicationWillResignActive:(id)arg1 {
    %orig;
    BOOL isAutoRedEnvelopesKeepRunning = [[NSUserDefaults standardUserDefaults] boolForKey:@"WeChatTweakAutoRedEnvelopesKeepRunningKey"];
    if (isAutoRedEnvelopesKeepRunning) {
        [[%c(KeepRunningManager) sharedInstance] startKeepRunning];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
}

- (void)applicationDidBecomeActive:(id)arg1 {
    %orig;
    if ([KeepRunningManager sharedInstance].playing) {
        [[%c(KeepRunningManager) sharedInstance] stopKeepRunning];
        [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    }
}

%end
