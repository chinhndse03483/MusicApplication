//
//  AppDelegate.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/27/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import "NowplayingViewController.h"
#define APPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>



@property (strong, nonatomic) UIWindow *window;


-(void) playMusic:(Track *)selectedSong andIndexPathDidselected:(NSInteger)indexPathDidselected andArrSong:(NSMutableArray *)songs;

-(void) downNowPlaying;



@end

