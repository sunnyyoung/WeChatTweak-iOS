#import "Settings.h"

%hook NewSettingViewController

- (void)reloadTableData {
    %orig;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isAutoRedEnvelopes = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesKey"];
    BOOL isAutoRedEnvelopesKeepRunning = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesKeepRunningKey"];
    BOOL isAutoRedEnvelopesDelayRandomly = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesDelayRandomlyKey"];
    BOOL isAutoRedEnvelopesFromMe = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesFromMeKey"];
    CGFloat delaySeconds = [userDefaults doubleForKey:@"WeChatTweakAutoRedEnvelopesDelaySecondsKey"];
    NSUInteger customStepCount = [userDefaults integerForKey:@"WeChatTweakCustomStepCountKey"];
    NSString *delaySecondsString = delaySeconds == 0 ? @"不延迟" : [NSString stringWithFormat:@"%.2f 秒", delaySeconds];
    NSString *customStepCountString = customStepCount == 0 ? @"不设置" : [NSString stringWithFormat:@"%@ 步", @(customStepCount)];

    // AutoRedEnvelopes Section
    MMTableViewSectionInfo *autoRedEnvelopesSectionInfo = [%c(MMTableViewSectionInfo) sectionInfoHeader:@"自动抢红包"];
    MMTableViewCellInfo *autoRedEnvelopesCellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchAutoRedEnvelopes:) target:self title:@"自动抢红包" on:isAutoRedEnvelopes];
    MMTableViewCellInfo *autoRedEnvelopesKeepRunningCellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchAutoRedEnvelopesKeepRunning:) target:self title:@"后台运行" on:isAutoRedEnvelopesKeepRunning];
    MMTableViewCellInfo *autoRedEnvelopesFromMeCellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchAutoRedEnvelopesFromMe:) target:self title:@"抢自己发出的" on:isAutoRedEnvelopesFromMe];
    MMTableViewCellInfo *autoRedEnvelopesDelayRandomlyCellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchAutoRedEnvelopesDelayRandomly:) target:self title:@"随机延迟" on:isAutoRedEnvelopesDelayRandomly];
    MMTableViewCellInfo *autoRedEnvelopesDelaySecondsCellInfo = [%c(MMTableViewCellInfo) normalCellForSel:@selector(setAutoRedEnvelopesDelay) target:self title:@"自动抢红包延迟" rightValue:delaySecondsString accessoryType:1];
    [autoRedEnvelopesSectionInfo addCell:autoRedEnvelopesCellInfo];
    [autoRedEnvelopesSectionInfo addCell:isAutoRedEnvelopes ? autoRedEnvelopesKeepRunningCellInfo : nil];
    [autoRedEnvelopesSectionInfo addCell:isAutoRedEnvelopes ? autoRedEnvelopesFromMeCellInfo : nil];
    [autoRedEnvelopesSectionInfo addCell:isAutoRedEnvelopes ? autoRedEnvelopesDelayRandomlyCellInfo : nil];
    [autoRedEnvelopesSectionInfo addCell:isAutoRedEnvelopes ? autoRedEnvelopesDelaySecondsCellInfo : nil];

    // OtherSettings Section
    MMTableViewSectionInfo *otherSettingsSectionInfo = [%c(MMTableViewSectionInfo) sectionInfoHeader:@"其它设置"];
    MMTableViewCellInfo *customStepCountCellInfo = [%c(MMTableViewCellInfo) normalCellForSel:@selector(setCustomStepCount) target:self title:@"自定义步数" rightValue:customStepCountString accessoryType:1];
    [otherSettingsSectionInfo addCell:customStepCountCellInfo];

    // Reload Data
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    [tableViewInfo insertSection:autoRedEnvelopesSectionInfo At:0];
    [tableViewInfo insertSection:otherSettingsSectionInfo At:1];
    [[tableViewInfo getTableView] reloadData];
}

%new
- (void)switchAutoRedEnvelopes:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"WeChatTweakAutoRedEnvelopesKey"];
    [self reloadTableData];
}

%new
- (void)switchAutoRedEnvelopesKeepRunning:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"WeChatTweakAutoRedEnvelopesKeepRunningKey"];
    [self reloadTableData];
}

%new
- (void)switchAutoRedEnvelopesFromMe:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"WeChatTweakAutoRedEnvelopesFromMeKey"];
    [self reloadTableData];
}

%new
- (void)switchAutoRedEnvelopesDelayRandomly:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"WeChatTweakAutoRedEnvelopesDelayRandomlyKey"];
    [self reloadTableData];
}

%new
- (void)setAutoRedEnvelopesDelay {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    alertView.title = @"设置延迟";
    alertView.tag = 0;
    [alertView addButtonWithTitle:@"取消"];
    [alertView addButtonWithTitle:@"确定"];
    [alertView textFieldAtIndex:0].placeholder = @"输入延迟秒数";
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
    [alertView show];
}

%new
- (void)setCustomStepCount {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    alertView.title = @"设置步数";
    alertView.tag = 1;
    [alertView addButtonWithTitle:@"取消"];
    [alertView addButtonWithTitle:@"确定"];
    [alertView textFieldAtIndex:0].placeholder = @"输入自定义步数";
    [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
    [alertView show];
}

%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        // 设置自动抢红包延迟
        if (buttonIndex == 1) {
    	    CGFloat delaySeconds = [[alertView textFieldAtIndex:0].text doubleValue];
    	    [[NSUserDefaults standardUserDefaults] setFloat:delaySeconds forKey:@"WeChatTweakAutoRedEnvelopesDelaySecondsKey"];
        }
    } else if (alertView.tag == 1) {
        // 设置自定义步数
        if (buttonIndex == 1) {
            NSUInteger customStepCount = [[alertView textFieldAtIndex:0].text integerValue];
            [[NSUserDefaults standardUserDefaults] setInteger:customStepCount forKey:@"WeChatTweakCustomStepCountKey"];
        }
    }
    [self reloadTableData];
}

%end
