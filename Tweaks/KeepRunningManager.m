//
//  WeChatTweak.h
//
//  Created by Sunnyyoung on 2017/01/01.
//

#import "KeepRunningManager.h"

@interface KeepRunningManager ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation KeepRunningManager

+ (instancetype)sharedInstance {
    static KeepRunningManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[KeepRunningManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"pstncall" withExtension:@".mp3"];
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        self.audioPlayer.numberOfLoops = -1;
    }
    return self;
}

- (void)startKeepRunning {
    if (!self.audioPlayer.playing) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        [self.audioPlayer play];
    }
}

- (void)stopKeepRunning {
    if (self.audioPlayer.playing) {
        [self.audioPlayer stop];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
}

- (BOOL)playing {
    return self.audioPlayer.playing;
}

@end