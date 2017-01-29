//
//  WeChatTweak.h
//
//  Created by Sunnyyoung on 2017/01/01.
//

@interface SelectAttachmentViewController : NSObject

- (unsigned int)numberOfAttachment;
- (id)getTextAtIndex:(unsigned long)arg1;
- (id)getImageAtIndex:(unsigned long)arg1;
- (void)OnAttachmentClicked:(id)arg1;
- (void)updateView;

@end
