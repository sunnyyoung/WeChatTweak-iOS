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
    NSString *delaySecondsString = delaySeconds == 0 ? @"不延迟" : [NSString stringWithFormat:@"%.2f 秒", delaySeconds];

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

    // Reload Data
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    [tableViewInfo insertSection:autoRedEnvelopesSectionInfo At:0];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        // 设置自动抢红包延迟
        if (buttonIndex == 1) {
    	    CGFloat delaySeconds = [[alertView textFieldAtIndex:0].text doubleValue];
    	    [[NSUserDefaults standardUserDefaults] setFloat:delaySeconds forKey:@"WeChatTweakAutoRedEnvelopesDelaySecondsKey"];
    	    [self reloadTableData];
        }
    }
}

%end
