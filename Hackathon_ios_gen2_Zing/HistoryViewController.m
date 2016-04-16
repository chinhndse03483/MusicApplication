//
//  HistoryViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/12/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "HistoryViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DBTrack.h"
#import "Track.h"
#import "Constant.h"
#import "SearchSongCellTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NowplayingViewController.h"
#import "ParseAlbumViewController.h"
#import "AppDelegate.h"
typedef NS_ENUM(NSInteger, buttonType) {
    btnAddIndex = 0,
    btnDeleteIndex
};
@interface HistoryViewController () <NSFetchedResultsControllerDelegate>

@property(nonatomic,strong) NSFetchedResultsController *fetchedResultController;
@property(nonatomic,strong) UIBarButtonItem *barItem;
@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tbvHistory.rowHeight = 60.0f;
    _tbvHistory.emptyDataSetDelegate = self;
    _tbvHistory.emptyDataSetSource = self;
    _historyTracks = [[NSMutableArray alloc]init];
    _fetchedResultController = [DBTrack MR_fetchAllSortedBy:@"createdAt"
                                                  ascending:NO
                                              withPredicate:nil
                                                    groupBy:nil
                                                   delegate:self];
    
    [self reloadAllTracksWillReloadTableView:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self reloadAllTracksWillReloadTableView:YES];
}
#pragma mark - Tableview Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _historyTracks.count;
}
- (void)reloadAllTracksWillReloadTableView:(BOOL)willReloadTable;
{
    [_historyTracks removeAllObjects];
   
    NSArray *listHistoryTracks = [DBTrack MR_findAllSortedBy:@"createdAt"
                                                   ascending:NO];
    for (DBTrack *track in listHistoryTracks) {
        DBTrack *dbTrack = [DBTrack findFirstWithLinkStreaming:track.streamUrl];
        if(dbTrack){
            [_historyTracks addObject:dbTrack];
        }
    }
    if (willReloadTable) {
        //reload tableview
        [_tbvHistory reloadData];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"SearchSongCellTableViewCell";
    
    SearchSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SearchSongCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    DBTrack *selectedTrack = _historyTracks[indexPath.row];
    
    cell.lblName.text = selectedTrack.title;
    cell.lblAuthor.text = selectedTrack.author;
    cell.lblDuration.text = selectedTrack.duration;
    //cell.du
    //[cell.btnMore setImage:[[UIImage imageNamed:kBtnMoreImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    
    UIImage *placeholerImage = [UIImage imageNamed:@"TrackDefault"];
    if (![selectedTrack.linkImage isEqualToString:@""]) {
        [cell.imgSong sd_setImageWithURL:[NSURL URLWithString:selectedTrack.linkImage]
                    placeholderImage:placeholerImage
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                           }];
    } else {
        cell.imgSong.image = placeholerImage;
    }
    
    return cell;
}

#pragma mark - Tableview Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //if (_type == 0){
        NowPlayingViewController *nowPlayingViewController = [NowPlayingViewController sharedManager];
        Track *selectedTrack = [[Track alloc]initWithDBTrack:_historyTracks[indexPath.row]];
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < _historyTracks.count ; i++)
    {
        Track *tmpTrack = [[Track alloc]initWithDBTrack:[_historyTracks objectAtIndex:i]];
        [tmpArray addObject:tmpTrack];
    }
    
    
        if (![nowPlayingViewController.playingTrack.linkStreaming isEqual: selectedTrack.linkStreaming]) {
            [self reloadAllTracksWillReloadTableView:YES];
            [APPDELEGATE playMusic:selectedTrack andIndexPathDidselected:indexPath.row andArrSong:[tmpArray copy]];
        }
    
}
#pragma mark - DZNEmplyData
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIImage imageNamed:@"defaultImage"];
}
#pragma mark - Track Cell Delegate
- (void)buttonMoreDidTouch:(TrackCell*)sender;
{
    NSIndexPath *indexPath =  [_tbvHistory indexPathForCell:sender];
    NSLog(@"ich %ld",indexPath.row);
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Huỷ bỏ" destructiveButtonTitle:nil otherButtonTitles:
                            @"Thêm vào Danh sách",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
}
#pragma mark - NsFetchedResultControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [_tbvHistory reloadData];
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

