//
//  AppDelegate.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/27/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Constant.h"
#import <AVFoundation/AVFoundation.h>
#import "NowplayingViewController.h"
#import "Libraries/LNPopupController/LNPopupController.h"


//#import "LNPopupController.h"
@interface AppDelegate ()
@property(nonatomic,strong) NowPlayingViewController *nowPlayingviewcontroller;
@property(assign,nonatomic) NSInteger inited;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSError *setCategoryErr = nil;
    NSError *activationErr  = nil;
    _inited = 0;
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Database"];
    
    [self.window setTintColor: [UIColor redColor]];
   
    
    application.statusBarHidden = YES;
    
    return YES;
}

-(void) playMusic:(Track *)selectedSong andIndexPathDidselected:(NSInteger)indexPathDidselected andArrSong:(NSMutableArray *)songs;
{
    
    
    if (self.nowPlayingviewcontroller == nil) {
        self.nowPlayingviewcontroller = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"nowPlayingID"];
        self.nowPlayingviewcontroller.playingTrack = selectedSong;
        self.nowPlayingviewcontroller.trackList= songs;
        
    }
    else {
        
        self.nowPlayingviewcontroller.playingTrack = selectedSong;
        self.nowPlayingviewcontroller.trackList = songs;

    }
    
    
    self.nowPlayingviewcontroller.popupItem.title = self.nowPlayingviewcontroller.playingTrack.title;
    self.nowPlayingviewcontroller.popupItem.subtitle = self.nowPlayingviewcontroller.playingTrack.author;
    self.nowPlayingviewcontroller.popupItem.progress = 0.34;
    
    UIBarButtonItem *leftbutton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:nil action:@selector(btnPlayPausePopupDidTap) ];
    
    self.nowPlayingviewcontroller.popupItem.leftBarButtonItems = [NSArray arrayWithObject:leftbutton];
    [self.nowPlayingviewcontroller playTrack:selectedSong];
    
    
    if (_nowPlayingviewcontroller.status == 1)
    {
        _nowPlayingviewcontroller.status = _nowPlayingviewcontroller.getStatus;
    }
    //_nowPlayingviewcontroller.status = _nowPlayingviewcontroller.getStatus;
    if (_inited == 0)
    {
        [self.window.rootViewController presentPopupBarWithContentViewController:self.nowPlayingviewcontroller
                                                                       openPopup:YES
                                                                        animated:YES
                                                                      completion:nil];
        _inited = 1;
    }
    else
    {
        
    }
    
    
}

-(void) downNowPlaying;
{
    [self.window.rootViewController closePopupAnimated:TRUE completion:^{
        
    }];
}

-(void)btnPlayPausePopupDidTap{
    
    UIBarButtonItem *leftButtonPopup;
    
    if (!self.nowPlayingviewcontroller.btnPlay.selected) {
        leftButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(btnPlayPausePopupDidTap)];
    } else {
        leftButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(btnPlayPausePopupDidTap)];
    }
    
    self.nowPlayingviewcontroller.popupItem.leftBarButtonItems = [NSArray arrayWithObject:leftButtonPopup];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playMusic" object:self];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
