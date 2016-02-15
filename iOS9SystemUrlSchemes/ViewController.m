//
//  ViewController.m
//  iOS9SystemUrlSchemes
//
//  Created by hstdt on 16/2/14.
//  Copyright © 2016年 tdt. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

#define Version_IOS9 ([[UIDevice currentDevice].systemVersion doubleValue]>=9.0)

@interface ViewController ()<CLLocationManagerDelegate>
@property (copy, nonatomic) NSArray *settingsUrlSchemeArray;
@property (copy, nonatomic) NSArray *localizedStringArray;
@property (strong, nonatomic) CLLocationManager *location;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSAssert(!TARGET_IPHONE_SIMULATOR, @"It should run on iphone/ipad, not simulator");
    
    self.localizedStringArray = @[
                              @"Settings",
                              @"Settings-Airplane Mode",
                              @"Settings-WLAN",
                              @"Settings-Bluetooth",
                              @"Settings-Cellular",
                              @"Settings-Personal Hotspot",
                              @"Settings-VPN",
                              @"Settings-Carrier",
                              @"Settings-Notifications",
                              @"Settings-Control Center",
                              @"Settings-Do Not Disturb",
                              @"Settings-General",
                              @"Settings-General-About",
                              @"Settings-General-Software Update",
                              @"Settings-General-Siri",
                              @"Settings-General-Accessibiilty",
                              @"Settings-General-Backgound App Refresh",
                              @"Settings-General-AutoLock",
                              @"Settings-General-Date&Time",
                              @"Settings-General-Keyboards",
                              @"Settings-General-Keyboards-Keyboards",
                              @"Settings-General-Language&Region",
                              @"Settings-General-VPN",
                              @"Settings-General-Profiles",
                              @"Settings-General-Reset",
                              @"Settings-Display&Brightness",
                              @"Settings-Wallpaper",
                              @"Settings-Sounds",
                              @"Settings-Sounds-Ringtone",
                              @"Settings-Touch ID&Passcode",
                              @"Settings-Battery",
                              @"Settings-Privacy",
                              @"Settings-Privacy-Location Services",
                              @"Settings-iCloud",
                              @"Settings-iCloud-Storage",
                              @"Settings-iTunes&App Stores",
                              @"Settings-Mail,Contacts,Calendars",
                              @"Settings-Notes",
                              @"Settings-Reminders",
                              @"Settings-Phone",
                              @"Settings-Phone-Show My Caller ID",
                              @"Settings-Messages",
                              @"Settings-FaceTime",
                              @"Settings-Maps",
                              @"Settings-Compass",
                              @"Settings-Safari",
                              @"Settings-Music",
                              @"Settings-Videos",
                              @"Settings-Photos&Camera",
                              @"Settings-Game Center",
                              @"Settings-Twitter",
                              @"Settings-Flickr",
                              UIApplicationOpenSettingsURLString,//->@"app-settings:",App Authorization Setting Page(at least 1 authorize requested)
                              ];
    
    self.settingsUrlSchemeArray = @[
                        @"prefs:root",//Settings 设置(equals to@"prefs:" )
                            @"prefs:root=AIRPLANE_MODE",//Settings-Airplane Mode 设置-飞行模式 Switch to airplane mode(It seems not working well on iOS9.2.1)
                            @"prefs:root=WIFI",//Settings-WLAN 设置-无线局域网
                            @"prefs:root=Bluetooth",//Settings-Bluetooth 设置-蓝牙
                            @"prefs:root=MOBILE_DATA_SETTINGS_ID",//Settings-Cellular 设置-蜂窝移动网络
                            @"prefs:root=INTERNET_TETHERING",//Settings-Personal Hotspot 设置-个人热点
                            @"prefs:root=VPN",//Settings-VPN 设置-VPN (同样也是 设置-通用-VPN)
                            @"prefs:root=Carrier",//Settings-Carrier 设置-运营商
                            @"prefs:root=NOTIFICATIONS_ID",//Settings-Notifications 设置-通知
                            @"prefs:root=ControlCenter",//Settings-Control Center 设置-控制中心
                            @"prefs:root=DO_NOT_DISTURB",//Settings-Do Not Disturb 设置-勿扰模式
                            @"prefs:root=General",//Settings-General  设置-通用
                                @"prefs:root=General&path=About",//Settings-General-About 设置-通用-关于本机
                                @"prefs:root=General&path=SOFTWARE_UPDATE_LINK",//Settings-General-Software Update 设置-通用-软件更新
                                @"prefs:root=General&path=SIRI",//Settings-General-Siri 设置-通用-Siri
                                //@"prefs:root=General&path=Spotlight_Search",
                                //@"prefs:root=General&path=Spotlight検索",//Googled this,not working.
                                @"prefs:root=General&path=ACCESSIBILITY",//Settings-General-Accessibiilty 设置-通用-辅助功能
                                @"prefs:root=General&path=AUTO_CONTENT_DOWNLOAD",//Settings-General-Backgound App Refresh 设置-通用-后台应用刷新
                                @"prefs:root=General&path=AUTOLOCK",//Settings-General-(Auto-Lock) 设置-通用-自动锁定
                                @"prefs:root=General&path=DATE_AND_TIME",//Settings-General-Date&Time 设置-通用-日期与时间
                                @"prefs:root=General&path=Keyboard",//Settings-General-Keyboards 设置-通用-键盘
                                    @"prefs:root=General&path=Keyboard/KEYBOARDS",//Settings-General-Keyboards-Keyboards 设置-通用-键盘-键盘
                                @"prefs:root=General&path=INTERNATIONAL",//Settings-General-Language&Region 设置-通用-语言与地区
                                @"prefs:root=General&path=VPN",//Settings-General-VPN 设置-通用-VPN
                                @"prefs:root=General&path=ManagedConfigurationList",//Settings-General-Profiles 设置-通用-描述文件
                                @"prefs:root=General&path=Reset",//Settings-General-Reset 设置-通用-还原
                            @"prefs:root=DISPLAY",//Settings-Display&Brightness 设置-显示和亮度
                            @"prefs:root=Wallpaper",//Settings-Wallpaper  设置-墙纸
                            @"prefs:root=Sounds",//Settings-Sounds  设置-声音
                                @"prefs:root=Sounds&path=Ringtone",//Settings-Sounds-Ringtone  设置-声音-电话铃声
                            @"prefs:root=TOUCHID_PASSCODE",//Settings-Touch ID&Passcode  设置-Touch ID与密码
                            @"prefs:root=BATTERY_USAGE",//Settings-Battery 设置-电池
                            @"prefs:root=Privacy",//Settings-Privacy 设置-隐私
                                @"prefs:root=LOCATION_SERVICES",//Settings-Privacy-Location Services 设置-隐私-定位服务
                            @"prefs:root=CASTLE",//Settings-iCloud  设置-iCloud
                                @"prefs:root=CASTLE&path=STORAGE_AND_BACKUP",//Settings-iCloud-Storage 设置-iCloud-储存空间
                            @"prefs:root=STORE",//Settings-iTunes&App Stores  设置-iTunes Store与App Store
                            @"prefs:root=ACCOUNT_SETTINGS",//Settings-Mail,Contacts,Calendars 设置-邮件、通讯录、日记
                            @"prefs:root=NOTES",//Settings-Notes 设置-备忘录
                            @"prefs:root=REMINDERS",//Settings-Reminders 设置-提醒事项
                            @"prefs:root=Phone",//Settings-Phone  设置-电话
                                @"prefs:root=Phone&path=CallerID",//Settings-Phone-Show My Caller ID 设置-电话-在被叫方显示本机号码
                            @"prefs:root=MESSAGES",//Settings-Messages 设置-信息
                            @"prefs:root=FACETIME",//Settings-FaceTime 设置-Facetime
                            @"prefs:root=MAPS",//Settings-Maps 设置-地图
                            @"prefs:root=COMPASS",//Settings-Compass 设置-指南针
                            @"prefs:root=SAFARI",//Settings-Safari 设置-Safari
                            @"prefs:root=MUSIC",//Settings-Music 设置-音乐
                            @"prefs:root=VIDEO",//Settings-Videos 设置-视频
                            @"prefs:root=Photos",//Settings-Photos&Camera 设置-照片与相机
                            @"prefs:root=GAMECENTER",//Settings-Game Center 设置-Game Center
                            @"prefs:root=TWITTER",//Settings-Twitter 设置-Twitter
                            @"prefs:root=FLICKR",//Settings-Flickr 设置-Flickr
                            UIApplicationOpenSettingsURLString,//->@"app-settings:",App Authorization Setting Page(at least 1 authorize requested)
                        ];
    //ios8?
    //@"prefs:root=General&path=STORAGE_AND_BACKUP",//设置-后台应用刷新
    //@"prefs:root=General&path=Assistant",//设置-通用-Siri
    //@"prefs:root=General&path=USAGE/CELLULAR_USAGE",//设置-用量
    //@"prefs:root=MUSIC&path=com.apple.Music.EQ",//设置-音乐-均衡器
    //@"prefs:root=MUSIC&path=com.apple.Music.VolumeLimit",//设置-音乐-均衡器
    //@"prefs:root=MUSIC&path=EQ",//设置-音乐-均衡器
    //@"prefs:root=MUSIC&path=VolumeLimit",//设置-音乐
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            if ([self.location respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.location requestWhenInUseAuthorization];
            }
            break;
        }
        case kCLAuthorizationStatusRestricted: {
            break;
        }
        case kCLAuthorizationStatusDenied: {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //equals to:
//          NSURL *url = [NSURL URLWithString:@"app-settings:"];
            [[UIApplication sharedApplication]openURL:url];
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways: {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //equals to:
            //          NSURL *url = [NSURL URLWithString:@"app-settings:"];
            [[UIApplication sharedApplication]openURL:url];
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            //equals to:
            //          NSURL *url = [NSURL URLWithString:@"app-settings:"];
            [[UIApplication sharedApplication]openURL:url];
            break;
        }
        // deprecated
//      case kCLAuthorizationStatusAuthorized: {
//          break;
//      }
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingsUrlSchemeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = NSLocalizedString(self.localizedStringArray[indexPath.row], nil);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"urlScheme = %@",self.settingsUrlSchemeArray[indexPath.row]);

    NSAssert(Version_IOS9, @"It works well on iOS9");
    
    
    if ([self.settingsUrlSchemeArray[indexPath.row] isEqualToString:UIApplicationOpenSettingsURLString]) {
        self.location = [[CLLocationManager alloc] init];
        self.location.delegate = self;
        [self.location requestWhenInUseAuthorization];
        return;
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.settingsUrlSchemeArray[indexPath.row]]];
    
    //    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    //    [[UIApplication sharedApplication]openURL:url];
}

@end
