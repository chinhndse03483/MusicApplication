//
//  NowplayingViewController.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Admin on 4/3/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
@interface NowPlayingViewController : UIViewController
@property(nonatomic,strong) NSMutableArray *trackList;
@property(strong,nonatomic) Track *playingTrack;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;
@property (weak, nonatomic) IBOutlet UISlider *sliderProgress;
@property(nonatomic,strong) NSString *linkStreaming;
@property (weak, nonatomic) IBOutlet UISlider *sliderBufferring;
@property (weak, nonatomic) IBOutlet UILabel *lblCurentTime;
@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIImageView *imgTrack;
@property (weak, nonatomic) IBOutlet UILabel *lbTitleTrack;
@property (weak, nonatomic) IBOutlet UILabel *lblTrackAuthor;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnRepeat;
@property (weak, nonatomic) IBOutlet UIButton *btnShuffle;
@property (weak, nonatomic) IBOutlet UIButton *btnListView;
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property(nonatomic, assign) NSInteger playerState;
@property (weak, nonatomic) IBOutlet UIView *viewGestures;
@property(assign,nonatomic) NSInteger sizOfNavigationBar;
@property(assign,nonatomic) NSInteger status;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property(assign,nonatomic) NSIndexPath *indexTrack;

- (IBAction)sliderAction:(id)sender;
- (IBAction)btnCancelDidTouch:(id)sender;
- (IBAction)btnPlayDidTouch:(id)sender;
- (IBAction)btnNextDidTouch:(id)sender;
- (IBAction)btnPreviousDidTouch:(id)sender;
- (IBAction)btnRepeatDidTouch:(id)sender;
- (IBAction)btnShuffleDidTouch:(id)sender;
- (IBAction)btnListViewDidTouch:(id)sender;
- (void)animateGoingUp;
- (NSInteger)getStatus;

@property(nonatomic, strong) AVPlayer *player;
@property(nonatomic, strong) AVPlayerItem *currentPlayingItem;
+ (NowPlayingViewController *)sharedManager;
-(void)playTrack:(Track *)playingTrack;
- (void)playTrackHistory:(Track *)playingTrack;
@end
