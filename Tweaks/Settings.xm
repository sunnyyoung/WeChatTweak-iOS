#import "Settings.h"

%hook NewSettingViewController

- (void)reloadTableData {
    %orig;

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isAutoRedEnvelopes = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesKey"];
    BOOL isAutoRedEnvelopesDelayRandomly = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesDelayRandomlyKey"];
    BOOL isAutoRedEnvelopesFromMe = [userDefaults boolForKey:@"WeChatTweakAutoRedEnvelopesFromMeKey"];
    CGFloat delaySeconds = [userDefaults doubleForKey:@"WeChatTweakAutoRedEnvelopesDelaySecondsKey"];
    NSInteger diceNumber = [userDefaults integerForKey:@"WeChatTweakCustomDiceNumberKey"];
    NSInteger rpsResult = [userDefaults integerForKey:@"WeChatTweakCustomRPSResultKey"];
    NSString *delaySecondsString = delaySeconds == 0 ? @"不延迟" : [NSString stringWithFormat:@"%.2f 秒", delaySeconds];
    NSString *diceNumberString = diceNumber == 0 ? @"不设置" : [NSString stringWithFormat:@"%@", @(diceNumber)];
    NSString *rpsResultString = ({
        NSString *string = nil;
        if (rpsResult == 1) {
            string = @"✌️";
        } else if (rpsResult == 2) {
            string = @"👊";
        } else if (rpsResult == 3) {
            string = @"✋";
        } else {
            string = @"不设置";
        }
        string;
    });

    // AutoRedEnvelopes Section
    MMTableViewSectionInfo *autoRedEnvelopesSectionInfo = [%c(MMTableViewSectionInfo) sectionInfoHeader:@"自动抢红包"];
    MMTableViewCellInfo *autoRedEnvelopesCellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchAutoRedEnvelopes:) target:self title:@"自动抢红包" on:isAutoRedEnvelopes];
    MMTableViewCellInfo *autoRedEnvelopesFromMeCellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchAutoRedEnvelopesFromMe:) target:self title:@"抢自己发出的" on:isAutoRedEnvelopesFromMe];
    MMTableViewCellInfo *autoRedEnvelopesDelayRandomlyCellInfo = [%c(MMTableViewCellInfo) switchCellForSel:@selector(switchAutoRedEnvelopesDelayRandomly:) target:self title:@"随机延迟" on:isAutoRedEnvelopesDelayRandomly];
    MMTableViewCellInfo *autoRedEnvelopesDelaySecondsCellInfo = [%c(MMTableViewCellInfo) normalCellForSel:@selector(setAutoRedEnvelopesDelay) target:self title:@"自动抢红包延迟" rightValue:delaySecondsString accessoryType:1];
    [autoRedEnvelopesSectionInfo addCell:autoRedEnvelopesCellInfo];
    [autoRedEnvelopesSectionInfo addCell:isAutoRedEnvelopes ? autoRedEnvelopesFromMeCellInfo : nil];
    [autoRedEnvelopesSectionInfo addCell:isAutoRedEnvelopes ? autoRedEnvelopesDelayRandomlyCellInfo : nil];
    [autoRedEnvelopesSectionInfo addCell:isAutoRedEnvelopes ? autoRedEnvelopesDelaySecondsCellInfo : nil];

    // CustomGame Section
    MMTableViewSectionInfo *customGameSectionInfo = [%c(MMTableViewSectionInfo) sectionInfoHeader:@"自定义游戏"];
    MMTableViewCellInfo *customDiceNumberCellInfo = [%c(MMTableViewCellInfo) normalCellForSel:@selector(setCustomDiceNumber) target:self title:@"自定义骰子数" rightValue:diceNumberString accessoryType:1];
    MMTableViewCellInfo *customRPSResultCellInfo = [%c(MMTableViewCellInfo) normalCellForSel:@selector(setCustomRPSResult) target:self title:@"自定义猜拳结果" rightValue:rpsResultString accessoryType:1];
    [customGameSectionInfo addCell:customDiceNumberCellInfo];
    [customGameSectionInfo addCell:customRPSResultCellInfo];

    // Reload Data
    MMTableViewInfo *tableViewInfo = MSHookIvar<id>(self, "m_tableViewInfo");
    [tableViewInfo insertSection:autoRedEnvelopesSectionInfo At:0];
    [tableViewInfo insertSection:customGameSectionInfo At:1];
    [[tableViewInfo getTableView] reloadData];
}

%new
- (void)switchAutoRedEnvelopes:(UISwitch *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"WeChatTweakAutoRedEnvelopesKey"];
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
- (void)setCustomDiceNumber {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"设置自定义骰子数";
    alertView.tag = 1;
    [alertView addButtonWithTitle:@"不设置"];
    [alertView addButtonWithTitle:@"1"];
    [alertView addButtonWithTitle:@"2"];
    [alertView addButtonWithTitle:@"3"];
    [alertView addButtonWithTitle:@"4"];
    [alertView addButtonWithTitle:@"5"];
    [alertView addButtonWithTitle:@"6"];
    [alertView addButtonWithTitle:@"取消"];
    [alertView show];
}

%new
- (void)setCustomRPSResult {
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"设置自定义猜拳结果";
    alertView.tag = 2;
    [alertView addButtonWithTitle:@"不设置"];
    [alertView addButtonWithTitle:@"✌️"];
    [alertView addButtonWithTitle:@"👊"];
    [alertView addButtonWithTitle:@"✋"];
    [alertView addButtonWithTitle:@"取消"];
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
    } else if (alertView.tag == 1) {
        // 设置自定义骰子数
        if (buttonIndex <= 6) {
            [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:@"WeChatTweakCustomDiceNumberKey"];
            [self reloadTableData];
        }
    } else if (alertView.tag == 2) {
        // 设置自定义猜拳结果
        if (buttonIndex <= 3) {
            [[NSUserDefaults standardUserDefaults] setInteger:buttonIndex forKey:@"WeChatTweakCustomRPSResultKey"];
            [self reloadTableData];
        }
    }
}

%end
