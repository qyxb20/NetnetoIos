//
//  LoginViewController.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/18.
//

#import "LoginViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UITextField *userTF;
@property (weak, nonatomic) IBOutlet UITextField *passTF;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *codeLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *reginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;
@property (weak, nonatomic) IBOutlet UITextView *agreeTx;

@end

@implementation LoginViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [Socket sharedSocketTool].autoReconnect = NO;
    [self.tabBarController.tabBar removeBadgeOnItemIndex:2];
}
-(void)initData{
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
       [leftButtonView addSubview:returnBtn];
       [returnBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
       [returnBtn addTarget:self action:@selector(returnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:leftButtonView];
      self.navigationItem.leftBarButtonItem = leftCunstomButtonView;

    
}
-(void)returnClick{
    if ([self.isCancel isEqual:@"1"]) {
        [account loadRootController];
    }
   else if ([self.isCancel isEqual:@"2"]) {
        [account loadRootController];
    }
    else{
        [self popViewControllerAnimate];
    }
}
-(void)CreateView{
    self.loginBtn.backgroundColor = [UIColor gradientColorWithWidth:WIDTH - 62 color:MainColorArr];
    [self.loginBtn setTitle:TransOutput(@"登录") forState:UIControlStateNormal];
    
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@",TransOutput(@"已阅读并同意"),TransOutput(@"《用户协议》"),TransOutput(@"与"),TransOutput(@"《隐私政策》"),TransOutput(@"政策")];
    NSMutableAttributedString *attstring = [[NSMutableAttributedString alloc] initWithString:str];
   
    NSString *valueString = [[NSString stringWithFormat:@"firstPerson://1"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *valueString1 = [[NSString stringWithFormat:@"secondPerson://2"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSRange rang1 =NSMakeRange(TransOutput(@"已阅读并同意").length, TransOutput(@"《用户协议》").length);
    
    NSRange rang2 =NSMakeRange(str.length - TransOutput(@"《隐私政策》").length - TransOutput(@"政策").length, TransOutput(@"《隐私政策》").length);
    
    [attstring addAttribute:NSLinkAttributeName value:valueString range:rang1];
    [attstring addAttribute:NSLinkAttributeName value:valueString1 range:rang2];
    
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:rang1];
     
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:rang1];
    // 设置下划线
    [attstring addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:rang2];
     
    // 设置颜色
    [attstring addAttribute:NSForegroundColorAttributeName value:MainColorArr range:rang2];
    self.agreeTx.delegate = self;
    self.agreeTx.attributedText =attstring;
    self.agreeTx.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0); // 上 左 下 右
    self.agreeTx.textAlignment = NSTextAlignmentCenter; // 设置文本居中
    self.agreeTx.editable = NO; // 如果你不希望用户编辑文本，设置为NO
    @weakify(self);
    [self.view addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        [self returnKeyBord];
    }];
    self.userTF.delegate = self;
    self.userTF.placeholder = TransOutput(@"ユーザーID");
    self.passTF.placeholder = TransOutput(@"パスワード");
    [self.codeLoginBtn setTitle:TransOutput(@"验证码登录") forState:UIControlStateNormal];
    [self.reginBtn setTitle:TransOutput(@"用户注册") forState:UIControlStateNormal];
    [self.forgetBtn setTitle:TransOutput(@"忘记密码") forState:UIControlStateNormal];
    [self.reginBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ResginViewController *vc = [[ResginViewController alloc] init];
        [self pushController:vc];
    }];
    [self.forgetBtn addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        ForgetViewController *vc = [[ForgetViewController alloc] init];
        [self pushController:vc];
    }];
    [self.view addTapAction:^(UIView * _Nonnull view) {
        @strongify(self);
        if ([self.userTF isFirstResponder]) {
            [self.userTF resignFirstResponder];
        }
        else if ([self.passTF isFirstResponder]){
            [self.passTF resignFirstResponder];
        }
    }];
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    
    if([deviceType isEqualToString:@"iPad"]) {
        self.codeLoginBtn.hidden = YES;
        self.reginBtn.hidden = YES;
        self.forgetBtn.hidden = YES;
    }
}
- (BOOL)textView:(UITextView*)textView shouldInteractWithURL:(NSURL*)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
 
    if ([[URL scheme] isEqualToString:@"firstPerson"]) {
        [self handleTap];
        return NO;
    } else if ([[URL scheme] isEqualToString:@"secondPerson"]) {
        [self handleTapY];
        return NO;
    }
 
    return YES;
 
}
-(void)handleTapY{
  
    
    MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];

  
    
        vc.url = @"http://agree.netneto.jp/privacy_policy.html";
       
   
    
    [self  pushController:vc];
}
-(void)handleTap{
  
    MineWebKitViewController *vc = [[MineWebKitViewController alloc] init];
   
  
        vc.url = @"http://agree.netneto.jp/user_protocol.html";
       
   
    
    [self  pushController:vc];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSUInteger newLength = textField.text.length + string.length - range.length;
   
    return newLength <= 50;
}
- (IBAction)codeClick:(id)sender {
    CodeViewController *vc = [[CodeViewController alloc] init];
    [self pushController:vc];
    
}
-(void)returnKeyBord{
    if ([self.userTF isFirstResponder]) {
        [self.userTF resignFirstResponder];
        
    }
    else  if ([self.passTF isFirstResponder]) {
        [self.passTF resignFirstResponder];
    }
}

- (IBAction)eyeClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected =YES;
       
        self.passTF.secureTextEntry = NO;
    }else{
        sender.selected = NO;
        self.passTF.secureTextEntry = YES;
    }
}

- (IBAction)loginClick:(id)sender {
    if (self.userTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入账号"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    if (self.passTF.text.length == 0) {
        ToastShow(TransOutput(@"请输入密码"),@"矢量 20",RGB(0xFF830F));
        return;
    }
    NSString *passStr = [NSString stringWithFormat:@"%@%@",[Tool getCurrentTimeNumber],self.passTF.text];
 
    NSString *str = [AESManager encrypt:passStr key:AESKEY] ;
    NSLog(@"加密字符串：%@",str);
    [HudView showHudForView:self.view];
    
//    [LoadingView showLoadingAction];
    [NetwortTool loginWithUserName:@{@"userName":self.userTF.text,@"passWord":str} Success:^(id  _Nonnull responseObject) {
        
        account.user = [userModel mj_objectWithKeyValues:responseObject];
        [account loadResource];
        [account loadBank];

        [self getuserInfo];

//
        
      
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
//        [LoadingView dismissLoadingAction];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      }];
}
-(void)getuserInfo{
    [NetwortTool getUserInfoSuccess:^(id  _Nonnull responseObject) {
        account.userInfo = [UserInfoModel mj_objectWithKeyValues:responseObject];
        if (![Socket sharedSocketTool].autoReconnect && ![Socket sharedSocketTool].isLogin) {
            [[Socket sharedSocketTool] initSocket];
        }
        if ([Socket sharedSocketTool].autoReconnect && ![Socket sharedSocketTool].isLogin) {
            //已连接 未登录
            [[Socket sharedSocketTool] loginSocket];
        }
        [HudView hideHudForView:self.view];
//        [LoadingView dismissLoadingAction];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"uploadUserInfo" object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataShopNumber" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updataCoupon" object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"loadData" object:nil userInfo:nil];
        
        if ([self.isCancel isEqual:@"1"]) {
            [account loadRootController];
        }
        else{
            [self popViewControllerAnimate];
        }
    } failure:^(NSError * _Nonnull error) {
        [HudView hideHudForView:self.view];
//        [LoadingView dismissLoadingAction];
        ToastShow(error.userInfo[@"httpError"],@"矢量 20",RGB(0xFF830F));
      
    }];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
