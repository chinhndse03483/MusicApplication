//
//  NowplayingViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Admin on 4/3/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "NSNumber+Mp3.h"
#import <AVFoundation/AVFoundation.h>
#import "DBTrack.h"
#import "ShowListViewController.h"
#import "Libraries/LNPopupController/LNPopupController.h"


#define kTracksKey              @"tracks"
#define kStatusKey              @"status"
#define kRateKey                @"rate"
#define kPlayableKey            @"playable"
#define kCurrentItemKey         @"currentItem"
#define kTimedMetadataKey       @"currentItem.timedMetadata"
#define kLoadedTimeRanges       @"currentItem.loadedTimeRanges"
#define kPlaybackBufferEmpty    @"playbackBufferEmpty"
#define kPlaybackKeepUp         @"playbackLikelyToKeepUp"
#define MP3DefaultTrackImageName                      @"TrackDefault.jpg"
#define kDurationAnimateSliding 0.5f


typedef enum {
    
    PLAYER_STATE_HIDDEN = 0,
    PLAYER_STATE_FULLSCREEN = 1,
    PLAYER_STATE_HEADER,
    
    
} PLAYER_STATE;

@interface NowPlayingViewController ()<UIGestureRecognizerDelegate>
{
    id timeObserver;
    CGFloat percentage;
    CGFloat percentageBuffering;
    
    Boolean sliderProgressEditing;
    Boolean requesting;
}
@property(nonatomic, assign) CGPoint startPoint;

@end

@implementation NowPlayingViewController
@synthesize slider;
- (void)viewDidLoad {
    [super viewDidLoad];
       // Do any additional setup after loading the view.
    //_lbTitleTrack.marqueeType = MLContinuous;
    //_lbTitleTrack.animationDelay = 2.0f;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    _sliderBufferring.userInteractionEnabled = NO;
    
    sliderProgressEditing = NO;
    
    UIImage *image = [[UIImage imageNamed:@"MoreButton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_btnListView setImage:image forState:UIControlStateNormal];
   // _trackList.tintColor = kAppColor;
    
    
    UIImage *imageShuffle = [[UIImage imageNamed:@"audio_shuffle_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_btnShuffle setImage:imageShuffle forState:UIControlStateSelected];
    //_btnShuffle.tintColor = kAppColor;
    
    UIImage *imageRepeat = [[UIImage imageNamed:@"repeat_one"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_btnRepeat setImage:imageRepeat forState:UIControlStateSelected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(btnPlayDidTouch:)
                                                 name:@"playMusic"
                                               object:nil];
    //_btnRepeat.tintColor = kAppColor;
    // Do any additional setup after loading the view.
    
    [self playTrack:_playingTrack];
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)sliderAction:(id)sender
{
    _player.volume=slider.value;
}

+ (NowPlayingViewController *)sharedManager
{
    static NowPlayingViewController *shaderManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        shaderManager = [storyboard instantiateViewControllerWithIdentifier:@"nowPlayingID"];
        
    });
    return shaderManager;
}
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    UIEventSubtype rc = event.subtype;
    if (rc == UIEventSubtypeRemoteControlTogglePlayPause) {
        if (!requesting) {
            if (self.btnPlay.selected) {
                //music playing
                //now pause
                [self play];
            } else {
                [self pause];
            }
        }
    } else if (rc == UIEventSubtypeRemoteControlPlay) {
        [self play];
    } else if (rc == UIEventSubtypeRemoteControlPause) {
        [self pause];
    } else if (rc == UIEventSubtypeRemoteControlNextTrack) {
        if (_btnShuffle.selected) {
            _playingTrack = _trackList[arc4random() % _trackList.count];
            [self playTrack:_playingTrack];
        } else {
            _playingTrack = _trackList[[_trackList indexOfObject:_playingTrack] + 1];
            [self playTrack:_playingTrack];
        }
    } else if (rc == UIEventSubtypeRemoteControlPreviousTrack){
        if (_btnShuffle.selected) {
            _playingTrack = _trackList[arc4random() % _trackList.count];
            [self playTrack:_playingTrack];
        } else {
            _playingTrack = _trackList[[_trackList indexOfObject:_playingTrack] - 1];
            [self playTrack:_playingTrack];
        }
    }
}

- (NSString *)formatTime:(CGFloat)time;
{
    NSInteger hours = time / 3600;
    NSInteger seconds = (NSInteger)time % 60;
    NSInteger minutes = (time - hours * 3600 - seconds) / 60;
    
    NSString *finalString = nil;
    if (hours > 0) {
        finalString = [NSString stringWithFormat:@"%ld:%02ld:%02ld", hours, minutes, (long)seconds];
    } else {
        finalString = [NSString stringWithFormat:@"%ld:%02ld", minutes, (long)seconds];
    }
    
    
    return finalString;
    
}
- (void)playURL:(NSURL *)streamingURL;
{
    AVPlayerItem *newItem = [AVPlayerItem playerItemWithURL:streamingURL];
    self.currentPlayingItem = newItem;
    
    if (self.player == nil) {
        self.player = [[AVPlayer alloc]initWithPlayerItem:self.currentPlayingItem];
        
        [self.player addObserver:self forKeyPath:kLoadedTimeRanges
                         options:NSKeyValueObservingOptionNew
                         context:NULL];
        
        [self.player addObserver:self
                      forKeyPath:kCurrentItemKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:nil];
        
        [self.player addObserver:self
                      forKeyPath:kRateKey
                         options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                         context:nil];
        
        
        
    } else {
        
        [self.player replaceCurrentItemWithPlayerItem:self.currentPlayingItem];
    }
    
    [self.currentPlayingItem addObserver:self forKeyPath:kStatusKey options:NSKeyValueObservingOptionNew context:nil];
    /* Observer buffer status */
    [self.currentPlayingItem addObserver:self forKeyPath:kPlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    [self.currentPlayingItem addObserver:self forKeyPath:kPlaybackKeepUp options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayingItem];
    
    
    __weak NowPlayingViewController *weakSelf = self;
    
    timeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0f, 1.0f) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currentTime = CMTimeGetSeconds(time);
        
        if (weakSelf.currentPlayingItem) {
            
            percentage = currentTime / CMTimeGetSeconds(_currentPlayingItem.duration);
            [weakSelf updateGUI];
            
        }
        
    }];
    
    
    [self.player play];
    
    
}
- (void)updateGUI;
{
    if (_currentPlayingItem) {
        
        if (!sliderProgressEditing) {
            _sliderProgress.enabled = YES;
            
            requesting = NO;
            
            //update slider progress
            self.sliderProgress.value = percentage;
            self.popupItem.progress = percentage;
            //update time text
            CGFloat playedTime = percentage * CMTimeGetSeconds(_currentPlayingItem.duration);
            self.lblCurentTime.text = [self formatTime:playedTime];
            
            CGFloat remainingTime = CMTimeGetSeconds(_currentPlayingItem.duration) - playedTime;
            self.lblDuration.text = [NSString stringWithFormat:@"-%@",[self formatTime:remainingTime]];
        } else {
            
            CGFloat playedTime = _sliderProgress.value * CMTimeGetSeconds(_currentPlayingItem.duration);
            self.lblCurentTime.text = [self formatTime:playedTime];
            
            CGFloat remainingTime = CMTimeGetSeconds(_currentPlayingItem.duration);
            self.lblDuration.text = [NSString stringWithFormat:@"-%@",[self formatTime:remainingTime]];
        }
    } else {
        self.sliderProgress.value = 0;
        
        self.lblCurentTime.text = @"--:--";
        self.lblDuration.text = @"--:--";
    }
    
    //update play/pause status
    if ([self isPlaying]) {
        [self.btnPlay setSelected:NO];
    } else {
        [self.btnPlay setSelected:YES];
    }
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.currentPlayingItem) {
        if ([keyPath isEqualToString:kStatusKey]) {
            if (self.currentPlayingItem.status == AVPlayerItemStatusFailed) {
                
                
                NSLog(@"------player item failed:%@",self.currentPlayingItem.error);
                [self itemDidFailedToPlay:nil];
                
            } else if (self.currentPlayingItem.status == AVPlayerItemStatusReadyToPlay){
                NSLog(@"AVPlayerItemStatusReadyToPlay");
                
                //[self itemWillPlaying];
                
            } else {
                // Unknow
            }
            ///Ngu nguoi
//        }else if ([keyPath isEqualToString:kPlaybackBufferEmpty]){
//            [self itemDidBufferEmpty];
//            
//        }else if ([keyPath isEqualToString:kPlaybackKeepUp]){
////            || self.currentPlayingItem.playbackBufferFull
//            if (self.currentPlayingItem.playbackLikelyToKeepUp )
//            {
//                NSLog(@"CONTINUE PLAY...");
//                [self itemDidKeepUp];
//            }
//            else
//            {
//                NSLog(@"BUFFERRING...");
//            }
        }
    }
    else if ([keyPath isEqualToString:kLoadedTimeRanges]) {
        
        NSArray *timeRanges = (NSArray *)[change objectForKey:NSKeyValueChangeNewKey];
        if (timeRanges && ![timeRanges isKindOfClass:[NSNull class]] && [timeRanges count] > 0)
        {
            CMTimeRange timerange = [[timeRanges objectAtIndex:0] CMTimeRangeValue];
            percentageBuffering = CMTimeGetSeconds(CMTimeAdd(timerange.start, timerange.duration)) / CMTimeGetSeconds(_currentPlayingItem.duration);
            
            NSLog(@"percentageBuffering: %.2f", percentageBuffering);
            
            
            if (isnan(percentageBuffering) || isinf(percentageBuffering)) {
                return;
            }
            
            [self updateGUI];
            
        }
        
    }
}
- (void)play;
{
    _btnPlay.selected =FALSE;
    [self.player play];
}
- (void)pause;
{
    _btnPlay.selected = TRUE;
    [self.player pause];
}
- (void)itemDidFailedToPlay:(NSNotification *)notification{
    ////show status to fail
    
}

- (void)itemDidBufferEmpty {
    
}

- (void)itemDidKeepUp {
    if (self.currentPlayingItem.playbackLikelyToKeepUp || self.currentPlayingItem.playbackBufferFull) {
        [self play];
        
    }
}
- (BOOL)isPlaying;
{
    if (self.player && self.currentPlayingItem && self.player.rate != 0.0f) {
        return YES;
    }
    
    return NO;
    
}


-(void)setBarButtonPopUp{
    UIBarButtonItem *leftButtonPopup;
    
    if (self.btnPlay.selected) {
        leftButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(btnPlayDidTouch:)];
    } else {
        leftButtonPopup = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(btnPlayDidTouch:)];
    }
    self.popupItem.leftBarButtonItems = [NSArray arrayWithObject:leftButtonPopup];
    
}



- (void)playTrack:(Track *)playingTrack;
{
    
    [self resetPlayer];
    
    self.popupItem.title = playingTrack.title;
    self.popupItem.subtitle = playingTrack.author;
    
    UIImage *image = [UIImage imageNamed:MP3DefaultTrackImageName];
  //  [_imgTrack setTintColor:[UIColor redColor]];
//    _imgTrack = [UIImage imageNamed:MP3DefaultTrackImageName];
    
    
    if ([playingTrack.linkStreaming isEqualToString:@""]) {
        _imgTrack.image = image;
    } else {
        
        UIImageView *placeholder = [[UIImageView alloc]init];
        [placeholder sd_setImageWithURL:[NSURL URLWithString:playingTrack.linkImage] placeholderImage:image];
        NSLog(@"ich %@",playingTrack.linkStreamImage);
//        NSString *artworkString = [playingTrack.linkStreaming stringByReplacingOccurrencesOfString:@"large" withString:@"crop"];
        NSString *artworkString = playingTrack.linkImage ;
        [_imgTrack sd_setImageWithURL:[NSURL URLWithString:artworkString]
                       placeholderImage:placeholder.image
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                              }];
    }
    
    _lblTrackAuthor.text = playingTrack.author;
    _lbTitleTrack.text = playingTrack.title;    
    _sliderProgress.value = 0;
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@",playingTrack.linkStreaming];
    
       DBTrack *track = [DBTrack createDBTrackFromTrack:playingTrack];
    
    [self playURL:[NSURL URLWithString:stringUrl]];
}
- (void)playTrackHistory:(Track *)playingTrack;
{
    
    [self resetPlayer];
    
    UIImage *image = [[UIImage imageNamed:kDefaultTrackImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_imgTrack setTintColor:[UIColor redColor]];
    
    if ([playingTrack.linkStreaming isEqualToString:@""]) {
        _imgTrack.image = image;
    } else {
        UIImageView *placeholder = [[UIImageView alloc]init];
        [placeholder sd_setImageWithURL:[NSURL URLWithString:playingTrack.linkImage] placeholderImage:image];
        
        NSString *artworkString = [playingTrack.linkStreaming stringByReplacingOccurrencesOfString:@"large" withString:@"crop"];
        
        [_imgTrack sd_setImageWithURL:[NSURL URLWithString:artworkString]
                     placeholderImage:placeholder.image
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            }];
    }
    
    _lblTrackAuthor.text = playingTrack.author;
    //_lblUserName.textColor = kAppColor;
    _lbTitleTrack.text = playingTrack.title;
    //_lblTitle.textColor = kAppColor;
    //_lblDuration.text = [NSString stringWithFormat:@"-%@",[playingTrack.duration timeValue]];
    _sliderProgress.value = 0;
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@",playingTrack.linkStreaming];
    
    [self playURL:[NSURL URLWithString:stringUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)resetPlayer
{
    // Remove timeobserver if exist
    if (timeObserver)
    {
        if (self.player) {
            [self.player removeTimeObserver:timeObserver];
        }
        timeObserver = nil;
    }
    
    // Replace currentItem with nil
    if (self.player) {
        [self.player pause];
        [self.player setRate:0.0f];
        
        [self.player removeObserver:self forKeyPath:kLoadedTimeRanges];
        [self.player removeObserver:self forKeyPath:kCurrentItemKey];
        [self.player removeObserver:self forKeyPath:kRateKey];
        
        self.player = nil;
        
        
        
    }
    
    if (self.currentPlayingItem) {
        
        [self.currentPlayingItem removeObserver:self forKeyPath:kStatusKey];
        [self.currentPlayingItem removeObserver:self forKeyPath:kPlaybackBufferEmpty];
        [self.currentPlayingItem removeObserver:self forKeyPath:kPlaybackKeepUp];
        
        [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayingItem];
        
        self.currentPlayingItem = nil;
    }
    
    
    //reset GUI
    self.sliderProgress.value = 0.0f;
    
    percentage = 0;
    
    self.lblCurentTime.text = @"--:--";
    self.lblDuration.text = @"--:--";
    
    [self updateGUI];
    
    _sliderProgress.enabled = NO;
    
    requesting = YES;
    
}

- (NSInteger) posOfTrack:(Track*)track1;
{
    for (int i = 0 ; i < _trackList.count ; i++)
    {
        //if ([_trackList objectAtIndex:i])
        Track *track = [_trackList objectAtIndex:i];
        
        if ([track.linkStreaming isEqualToString:track1.linkStreaming])
        {
            return i;
        }
        
    }
    return -1;
}

- (IBAction)btnNextDidTouch:(id)sender {
    
        
    if (_btnShuffle.selected) {
        _playingTrack = _trackList[arc4random() % _trackList.count];
        [self playTrack:_playingTrack];
    }
    else {
            int pos = [self posOfTrack:_playingTrack];
            if (pos == [_trackList count] -1 )
            {
                pos = 0;
            }
            else pos = pos + 1;
            Track *tmpDbTrack = [_trackList objectAtIndex:pos];
            //_playingTrack = [[Track alloc]initWithDBTrack:tmpDbTrack];
        _playingTrack = tmpDbTrack;
            [self playTrack:_playingTrack];
        }
}

- (IBAction)btnPreviousDidTouch:(id)sender {
    if (_btnShuffle.selected) {
        _playingTrack = _trackList[arc4random() % _trackList.count];
        [self playTrack:_playingTrack];
    } else {
        int pos = [self posOfTrack:_playingTrack];
        if (pos == 0)
        {
            pos = _trackList.count - 1;
        }
        else pos = pos - 1;
        DBTrack *tmpDbTrack = [_trackList objectAtIndex:pos];
        _playingTrack = [[Track alloc]initWithDBTrack:tmpDbTrack];
        [self playTrack:_playingTrack];
    }
}
- (IBAction)btnPlayDidTouch:(id)sender {
    if (!requesting) {
        [self setBarButtonPopUp];
        if (self.btnPlay.selected) {
            
            //music playing
            //now pause
            [self play];
        } else {
            [self pause];
        }
    }
}

- (IBAction)SliderProgessValueChange:(id)sender {
}

- (IBAction)sliderProgressDidChangeValue:(id)sender;
{
    
    //get new progress
    CGFloat newProgress = self.sliderProgress.value;
    
    CGFloat newPercentage = newProgress / (self.sliderProgress.maximumValue - self.sliderProgress.minimumValue);
    
    
    //seek player to new time
    CGFloat newCurrentTime = newPercentage * CMTimeGetSeconds(_currentPlayingItem.duration);
    
    //seel
    [self.player seekToTime:CMTimeMakeWithSeconds(newCurrentTime, 1.0f)];
    
    
    
    
}
- (void)itemDidFinishPlaying:(NSNotification *)notification {
    
    
    if (_btnRepeat.selected) {
        [self playTrack:_playingTrack];
    } else {
        if (_btnShuffle.selected) {
            _playingTrack = _trackList[arc4random() % _trackList.count];
            [self playTrack:_playingTrack];
        } else {
            if ([[_trackList lastObject] isEqual:_playingTrack]) {
                [self playTrack:_trackList[0]];
            } else {
                _playingTrack = _trackList[[_trackList indexOfObject:_playingTrack] + 1];
                [self playTrack:_playingTrack];
            }
        }
    }
}
- (IBAction)sliderProgressDidTouchDown:(id)sender {
    sliderProgressEditing = YES;
    [self.player pause];
}

- (IBAction)sliderProgressDidTouchUp:(id)sender {
    sliderProgressEditing = NO;
    [self.player play];
    
}
- (IBAction)btnRepeatDidTouch:(id)sender {
    
    if (_btnRepeat.selected) {
        _btnRepeat.selected = FALSE;
    } else {
        _btnRepeat.selected = TRUE;
    }
}
- (IBAction)btnShuffleDidTouch:(id)sender {
    if (_btnShuffle.selected) {
        _btnShuffle.selected = FALSE;
    } else {
        _btnShuffle.selected = TRUE;
    }
}
- (IBAction)btnListViewDidTouch:(id)sender {
 
    ShowListViewController *showListViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowListViewController"];
    showListViewController.trackList = _trackList;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [showListViewController setHidesBottomBarWhenPushed:YES];
    [showListViewController setTitle:@"fuck"];
    
    [self presentViewController:showListViewController animated:YES completion:nil];
    //[self.navigationController pushViewController:showListViewController animated:NO];
    
}

- (NSInteger)getStatus;
{
    CGRect playerFrame = self.view.frame;
    if (playerFrame.origin.y == 0)
    {
        return 1;
    }
    else return 0;
}
- (void)animateGoingUp;
{
    
    //animate going up
    [UIView animateWithDuration:kDurationAnimateSliding animations:^{
        
        CGRect playerFrame = self.view.frame;
        
        playerFrame.origin.y = [self originYFullscreen];
        
        self.view.frame = playerFrame;
        
    } completion:^(BOOL finished) {
        
        self.playerState = PLAYER_STATE_FULLSCREEN; //TODO
    }];
    
}

- (CGFloat)originYFullscreen;
{
    return -self.viewHeader.frame.size.height;
}

- (CGFloat)originYHeader
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    return mainScreen.bounds.size.height + [self originYFullscreen] ;
}

- (void)animateGoingDown;
{
    
    //animate going up
    [UIView animateWithDuration:kDurationAnimateSliding animations:^{
        
        CGRect playerFrame = self.view.frame;
        playerFrame.origin.y = [self originYHeader] - 50;
        
        self.view.frame = playerFrame;
        
    } completion:^(BOOL finished) {
        
        self.playerState = PLAYER_STATE_HEADER;
    }];
    
}

- (IBAction)btnCancelDidTouch:(id)sender {
        //[self animateGoingDown];

}

- (void)configGestures;
{
    //pan gesture -> moving player up and down
    //add to gesture view
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPan:)];
    
    panGesture.delegate = self;
    [self.viewGestures addGestureRecognizer:panGesture];
    
    //swipe to next/previous
    UISwipeGestureRecognizer *swipeRightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    UISwipeGestureRecognizer *swipeLeftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    swipeRightGesture.delegate = self;
    swipeLeftGesture.delegate = self;
    
    [self.viewGestures addGestureRecognizer:swipeRightGesture];
    
    [self.viewGestures addGestureRecognizer:swipeLeftGesture];
    
}


- (void)didSwipe:(UISwipeGestureRecognizer *)gesture;
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        //next
        //[self btnNextDidTap:self.btnNext];
        //TODO playnext
    } else {
        //previous
        //[self btnPreviousDidTap:self.btnPrevious];
        //TODO playback
    }
    
}


- (void)movePlayerByDistance:(CGFloat)distanceY;
{
    
    CGRect playerFrame = self.view.frame;
    
    if (self.playerState == PLAYER_STATE_FULLSCREEN) {
        
        playerFrame.origin.y = [self originYFullscreen] + distanceY;
        
    } else if (self.playerState == PLAYER_STATE_HEADER) {
        
        playerFrame.origin.y = [self originYHeader] + distanceY;
    }
    
    
    self.view.frame = playerFrame;
    
}


- (void)didPan:(UIPanGestureRecognizer *)gesture;
{
    //    NSLog(@"viewgesture did PAN");
    
    CGPoint translationPoint = [gesture translationInView:gesture.view];
    //    NSLog(@"point: %@", NSStringFromCGPoint(translationPoint));
    
    CGFloat distanceY = translationPoint.y - self.startPoint.y;
    NSLog(@"distanceY: %f", distanceY);
    
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            self.startPoint = translationPoint;
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            //calculate distance
            
            
            
            [self movePlayerByDistance:translationPoint.y];
            
            //            [gesture setTranslation:CGPointZero inView:gesture.view];
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            [gesture setTranslation:CGPointZero inView:gesture.view];
            
            self.startPoint = CGPointZero;
            ///either goingn up fullscreen or down to header state
            NSLog(@"self.view.frame.origin.y: %f", self.view.frame.origin.y);
            if (self.view.frame.origin.y > self.view.frame.size.height / 3) {
                [self animateGoingDown];
            } else {
                [self animateGoingUp];
            }
            
            
        }
            break;
            
        default:
            break;
    }

}



- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
