//
//  ShowListViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/16/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "ShowListViewController.h"
#import "TrackCell.h"
#import "Track.h"
#import "UIImageView+WebCache.h"
#import "SearchSongCellTableViewCell.h"
#import "NowplayingViewController.h"
#import "AppDelegate.h"
#import "AddTrackToFavorite.h"
@interface ShowListViewController ()
{
    NowPlayingViewController *nowPlayingViewController;
    
    
}

@end

@implementation ShowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tbvShowList.tableFooterView = [[UIView alloc]init];
    _barItem = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(btnDoneAllDidTouch)];
    self.navigationItem.rightBarButtonItem = _barItem;
    static NSString *cellId = @"SearchSongCellTableViewCell";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 66;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _trackList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"SearchSongCellTableViewCell";
    
    SearchSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SearchSongCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   

    cell.accessoryType = UITableViewCellAccessoryNone;
    
    Track *track = _trackList[indexPath.row];
    
    cell.lblName.text = track.title;
    
    cell.lblAuthor.text = track.author;
    UIImage *placeholerImage = [UIImage imageNamed:@"TrackDefault"];
    if (![track.linkImage isEqualToString:@""]) {
        [cell.imgSong sd_setImageWithURL:[NSURL URLWithString:track.linkImage]
                    placeholderImage:placeholerImage
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                           }];
    } else {
        cell.imgSong.image = placeholerImage;
    }
    [cell.btnAction setHidden:TRUE];
    
    //if (_trackList[indexPath.row])
    Track *tmp = _trackList[indexPath.row];
    //if (indexPath.row == _indexTrack)
    if ([tmp.linkStreaming isEqualToString:_playingTrack.linkStreaming])
    {
        [self setCellColor:[UIColor redColor] ForCell:cell];
    }
    cell.lblDuration.text = [_trackList[indexPath.row] timeDuration];
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:indexPath{
    // Add your Colour.
    SearchSongCellTableViewCell *cell = (SearchSongCellTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setCellColor:[UIColor redColor] ForCell:cell];
}
- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    int i = arc4random()%3;
    if(APPDELEGATE.interstitial.isReady && i == 0){
        
        [APPDELEGATE.interstitial presentFromRootViewController:self];
    }
        nowPlayingViewController = [NowPlayingViewController sharedManager];
   // nowPlayingViewController.trackList = _trackList;
    Track *selectedTrack = _trackList[indexPath.row];
    nowPlayingViewController.playingTrack = selectedTrack;
    [APPDELEGATE playMusic:selectedTrack andIndexPathDidselected:indexPath.row andArrSong:_trackList];
    _indexTrack = indexPath.row;
    [self btnCloseTouchUp:nil];
}
- (void)searchSongCellDidTouchOnActionButton : (SearchSongCellTableViewCell*) sender;
{
    NSIndexPath *indexPath = [self.tbvShowList indexPathForCell:sender];
    //NSLog(@"index Path %d", indexPath.row);
    //currentPopup = indexPath.row;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Huỷ bỏ" destructiveButtonTitle:nil otherButtonTitles:
                            @"Thêm vào Danh sách",
                            nil];
    popup.tag = indexPath.row;;
    [popup showInView:self.view];
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnTouchUp:(id)sender {
}

- (IBAction)btnCloseTouchUp:(id)sender {
    //[self ]
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
    
 
}
@end
