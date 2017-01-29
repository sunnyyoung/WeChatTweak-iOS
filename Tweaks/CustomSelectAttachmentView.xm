#import "CustomSelectAttachmentView.h"

%hook SelectAttachmentViewController

- (unsigned int)numberOfAttachment {
    return %orig + 2;
}

- (id)getTextAtIndex:(unsigned long)arg1 {
    if (arg1 == [self numberOfAttachment] - 1) {
        return @"猜拳";
    } else if (arg1 == [self numberOfAttachment] - 2) {
        return @"骰子";
    } else {
        return %orig;
    }
}

- (id)getImageAtIndex:(unsigned long)arg1 {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (arg1 == [self numberOfAttachment] - 1) {
        NSInteger rpsResult = [userDefaults integerForKey:@"WeChatTweakCustomRPSResultKey"];
        if (rpsResult == 1) {
            return [UIImage imageNamed:@"JSB_J.pic"];
        } else if (rpsResult == 2) {
            return [UIImage imageNamed:@"JSB_S.pic"];
        } else if (rpsResult == 3) {
            return [UIImage imageNamed:@"JSB_B.pic"];
        } else {
            return [UIImage imageNamed:@"JSB.pic"];
        }
    } else if (arg1 == [self numberOfAttachment] - 2) {
        NSInteger diceNumber = [userDefaults integerForKey:@"WeChatTweakCustomDiceNumberKey"];
        NSString *diceImageName = diceNumber == 0 ? @"dice.pic" : [NSString stringWithFormat:@"dice_%@.pic", @(diceNumber)];
        return [UIImage imageNamed:diceImageName];
    } else {
        return %orig;
    }
}

- (void)OnAttachmentClicked:(UIButton *)arg1 {
    NSInteger buttonIndex = arg1.tag % 18000;
    if (buttonIndex == [self numberOfAttachment] -1) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.tag = 0;
        alertView.title = @"设置自定义猜拳结果";
        [alertView addButtonWithTitle:@"不设置"];
        [alertView addButtonWithTitle:@"✌️"];
        [alertView addButtonWithTitle:@"👊"];
        [alertView addButtonWithTitle:@"✋"];
        [alertView addButtonWithTitle:@"取消"];
        [alertView show];
    } else if (buttonIndex == [self numberOfAttachment] - 2) {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        alertView.delegate = self;
        alertView.tag = 1;
        alertView.title = @"设置自定义骰子数";
        [alertView addButtonWithTitle:@"不设置"];
        [alertView addButtonWithTitle:@"1"];
        [alertView addButtonWithTitle:@"2"];
        [alertView addButtonWithTitle:@"3"];
        [alertView addButtonWithTitle:@"4"];
        [alertView addButtonWithTitle:@"5"];
        [alertView addButtonWithTitle:@"6"];
        [alertView addButtonWithTitle:@"取消"];
        [alertView show];
    } else {
        %orig;
    }
}

%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        // 设置自定义猜拳结果
        if (buttonIndex <= 3) {
            [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:@"WeChatTweakCustomRPSResultKey"];
            [self updateView];
        }
    } else if (alertView.tag == 1) {
        // 设置自定义骰子数
        if (buttonIndex <= 6) {
            [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:@"WeChatTweakCustomDiceNumberKey"];
            [self updateView];
        }
    }
}

%end