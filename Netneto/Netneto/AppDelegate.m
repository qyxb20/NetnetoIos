//
//  AppDelegate.m
//  Netneto
//
//  Created by 才诗琦 on 2024/9/12.
//

#import "AppDelegate.h"
static UIBackgroundTaskIdentifier bgTask;
@interface AppDelegate ()
@property(nonatomic, strong)UIAlertView *alertView;
@property(nonatomic, strong)UIAlertView *alertTi;
@end

@implementation AppDelegate

+ (instancetype)sharedDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
   
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[ViewController alloc] init];
    [self.window makeKeyWindow];
   
    [SQIPInAppPaymentsSDK setSquareApplicationID:SQIAPPID];

    // Override point for customization after application launch.
    return YES;
}
#pragma mark - 检查版本更新
-(void)checkVersionUpdate{
    [NetwortTool getAppVersionWithParm:@{@"appType":@"1",@"appVersion":versionNum} Success:^(id  _Nonnull responseObject) {
        NSLog(@"输出app版本信息:%@",responseObject);
        if ([responseObject[@"forcedUpdate"] isEqual:@(1)]) {
            NSString *mes = [NSString stringWithFormat:@"%@%@,%@",TransOutput(@"发现最新版本"),responseObject[@"newAppVersion"],TransOutput(@"需更新后才能继续使用")];
            
            if (self.alertTi) {
                [self.alertView setHidden:YES];
                [self.alertView show];
            }else{
                self.alertView = [[UIAlertView alloc] initWithTitle:TransOutput(@"提示") message:mes delegate:self cancelButtonTitle:nil otherButtonTitles:TransOutput(@"确定"), nil];
                self.alertView.tag = 1001;
                [self.alertView show];
            }
           

                
        }else{
            if ([responseObject[@"update"] isEqual:@(1)]) {
                NSString *mes = [NSString stringWithFormat:@"%@%@,%@",TransOutput(@"发现最新版本"),responseObject [@"newAppVersion"],TransOutput(@"是否更新?")];
                
                if (self.alertTi) {
                    [self.alertTi setHidden:YES];
                    [self.alertTi show];
                }else{
                    self.alertTi = [[UIAlertView alloc] initWithTitle:TransOutput(@"提示") message:mes delegate:self cancelButtonTitle:TransOutput(@"取消") otherButtonTitles:TransOutput(@"确定"), nil];
                    self.alertTi.tag = 1002;
                    [self.alertTi show];
                }
            }
        }
            
    } failure:^(NSError * _Nonnull error) {
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/6737018234"] options:@{} completionHandler:^(BOOL res) {
           //
                           }];
        }
    }
    if (alertView.tag == 1002) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/app/6737018234"] options:@{} completionHandler:^(BOOL res) {
           
                           }];
        }
    }
}
#pragma mark - 进入前台
-(void)applicationDidBecomeActive:(UIApplication *)application{
    [self checkVersionUpdate];

    if (![Socket sharedSocketTool].autoReconnect) {
        [[Socket sharedSocketTool] initSocket];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [self getBackgroundTask];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self endBackgroundTask];
}

//获取后台任务
- (void)getBackgroundTask {
    
    NSLog(@"getBackgroundTask");
    UIBackgroundTaskIdentifier tempTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //后台任务
    }];
    
    if (bgTask != UIBackgroundTaskInvalid) {
        [self endBackgroundTask];
    }
    
    bgTask = tempTask;
    
    [self performSelector:@selector(getBackgroundTask) withObject:nil afterDelay:120];
}

//结束后台任务
- (void)endBackgroundTask {
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
}
@end
