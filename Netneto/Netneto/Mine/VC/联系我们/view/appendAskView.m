//
//  appendAskView.m
//  Netneto
//
//  Created by apple on 2025/4/3.
//

#import "appendAskView.h"
@interface appendAskView ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTX;
@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end
@implementation appendAskView
+ (instancetype)initViewNIB {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = TransOutput(@"咨询内容");
    [self.contentTX setPlaceholderWithText:TransOutput(@"请输入咨询内容(500字以内)") Color:RGB(0xBBB8B8)];
    self.contentTX.delegate = self;
    [self.sureBtn setTitle:TransOutput(@"确认") forState:UIControlStateNormal];
    @weakify(self);
    [self.sureBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        if (self.contentTX.text.length == 0) {
            ToastShow(TransOutput(@"请输入咨询内容"), errImg,RGB(0xFF830F));
            return;
        }
        ExecBlock(self.sureClickBlock,self.contentTX.text);
    }];
    
    [self.backView addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self removeFromSuperview];
    }];
    
    // Initialization code
}
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = textView.text.length + text.length - range.length;
   
   
    
    return newLength <= 500;
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
