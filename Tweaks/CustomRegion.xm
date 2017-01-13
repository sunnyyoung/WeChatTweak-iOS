#import "CustomRegion.h"

%hook MMRegionPickerViewController

- (void)viewDidLoad {
    %orig;

    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"自定义" style:UIBarButtonItemStylePlain target:self action:@selector(setCustomRegion)]];
}

%new
- (void)setCustomRegion {
    UIAlertView *alert = [[UIAlertView alloc] init];
    alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    alert.delegate = self;
    alert.title = @"设置自定义地区";
    [alert addButtonWithTitle:@"取消"];
    [alert addButtonWithTitle:@"确定"];
    [alert textFieldAtIndex:0].secureTextEntry = NO;
    [alert textFieldAtIndex:0].placeholder = @"国家";
    [alert textFieldAtIndex:0].keyboardType = UIKeyboardTypeDefault;
    [alert textFieldAtIndex:1].secureTextEntry = NO;
    [alert textFieldAtIndex:1].placeholder = @"地区";
    [alert textFieldAtIndex:1].keyboardType = UIKeyboardTypeDefault;
    [alert show];
}

%new
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSString *country = [alertView textFieldAtIndex:0].text;
        NSString *province = [alertView textFieldAtIndex:1].text;
        [[self delegate] MMRegionPickerDidChoosRegion:@[@"", country, province]];
    }
}

%end
