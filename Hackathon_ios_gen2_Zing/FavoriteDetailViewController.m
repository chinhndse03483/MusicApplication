//
//  FavoriteDetailViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/13/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "FavoriteDetailViewController.h"
#import "Constant.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DBTrack.h"
#import "Track.h"
#import "TrackCell.h"
#import "NowplayingViewController.h"
#import "NowPlayingViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSInteger, buttonType) {
    btnAddIndex = 0,
    btnDeleteIndex
};
@interface FavoriteDetailViewController ()<NSFetchedResultsControllerDelegate,TrackCellDelegate>
@property(nonatomic,strong) NSMutableArray *tracks;
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation FavoriteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = _selectedPlaylist.listName;
    
    _tbvPlaylistTracks.tableFooterView = [[UIView alloc]init];
    
    //setup SearchBar
    
    _tracks = [[NSMutableArray alloc]init];
    
    _tbvPlaylistTracks.rowHeight = 60.0f;
    
//    UIImage *image = [[UIImage imageNamed:kBtnRemoveAllImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    //    _barItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleBordered target:self action:@selector(btnRemoveAllDidTouch)];
    
    _fetchedResultsController = [DBTrack MR_fetchAllSortedBy:@"listID"
                                                   ascending:YES
                                               withPredicate: [NSPredicate predicateWithFormat:@"listID = %@",_selectedPlaylist.listID]
                                                     groupBy:nil
                                                    delegate:self];
    
    [self reloadAllTracksWillReloadTableView:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadAllTracksWillReloadTableView:YES];
}
//- (void)btnRemoveAllDidTouch;{
//
//    [PlaylistTrack deleteAllPlaylistTracksInPlaylist:_selectedPlaylist];
//}


- (void)reloadAllTracksWillReloadTableView:(BOOL)willReloadTable;
{
    [_tracks removeAllObjects];
    NSArray *playlistTracks = [DBTrack MR_findAllSortedBy:@"listID" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"listID = %@",_selectedPlaylist.listID]];
    for (DBTrack *track in playlistTracks) {
        if(track){
            [_tracks addObject:track];
        }
    }
    if (willReloadTable) {
        //reload tableview
        [_tbvPlaylistTracks reloadData];
    }
    if (_tracks.count == 1) {
        _selectedPlaylist = [_tracks objectAtIndex:0];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    //[self viewWillAppear:animated];
    
}
- (void)btnPlayingDidTouch;
{
    NowPlayingViewController *nowPlayingViewController = [NowPlayingViewController sharedManager];
    CATransition* transition = [CATransition animation];
    
    transition.duration = 0.3f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    [nowPlayingViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:nowPlayingViewController animated:NO];
}



#pragma mark - TableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"TrackCell";
    
    TrackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"TrackCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    DBTrack *track = _tracks[indexPath.row];
    cell.lblTitle.text = track.title;
    
    cell.lblAuthor.text = track.author;
    UIImage *placeholerImage = [UIImage imageNamed:@"TrackDefault"];
    if (![track.linkImage isEqualToString:@""]) {
        [cell.img sd_setImageWithURL:[NSURL URLWithString:track.linkImage]
                    placeholderImage:placeholerImage
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                           }];
    } else {
        cell.img.image = placeholerImage;
    }
    // cell.trackCellDelegate = self;
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    NowPlayingViewController *nowPlayingViewController = [NowPlayingViewController sharedManager];
    Track *selectedTrack = [[Track alloc]initWithDBTrack:_tracks[indexPath.row]];
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < _tracks.count ; i++)
    {
        Track *tmpTrack = [[Track alloc]initWithDBTrack:[_tracks objectAtIndex:i]];
        [tmpArray addObject:tmpTrack];
    }
    
    
    if (![nowPlayingViewController.playingTrack.linkStreaming isEqual: selectedTrack.linkStreaming]) {
        [APPDELEGATE playMusic:selectedTrack andIndexPathDidselected:indexPath.row andArrSong:tmpArray];
    }

}

#pragma mark - Track Cell Delegate

- (void)buttonMoreDidTouch:(id)sender;
{
    TrackCell *cell = (TrackCell *)sender;
    NSIndexPath *indexPath =  [_tbvPlaylistTracks indexPathForCell:cell];
    
    //show Action Sheet
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add",@"Delete",nil];
    
    //Change color button
//    SEL selector = NSSelectorFromString(@"_alertController");
//    if ([actionSheet respondsToSelector:selector])
//    {
//        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
//        if ([alertController isKindOfClass:[UIAlertController class]])
//        {
//            alertController.view.tintColor = kAppColor;
//            
//        }
//    }
//    else
//    {
//        // use other methods for iOS 7 or older.
//        for (UIView *subview in actionSheet.subviews) {
//            if ([subview isKindOfClass:[UIButton class]]) {
//                UIButton *button = (UIButton *)subview;
//                button.titleLabel.textColor = kAppColor;
//            }
//        }
//    }
    actionSheet.tag = indexPath.row;
    [actionSheet showInView:self.view];
}


#pragma mark - FetchedResultsController

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tbvPlaylistTracks beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:{
            NSInteger realIndex = [_fetchedResultsController.fetchedObjects indexOfObject:anObject];
            
            if (realIndex != NSNotFound) {
                NSIndexPath *realIndexPath = [NSIndexPath indexPathForRow:realIndex inSection:0];
                
                [_tbvPlaylistTracks insertRowsAtIndexPaths:@[realIndexPath]
                                          withRowAnimation:UITableViewRowAnimationLeft];
            }
            //[self reloadAllTracksWillReloadTableView:NO];
            break;
        }
        case NSFetchedResultsChangeDelete:{
            [_tbvPlaylistTracks deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
            //[self reloadAllTracksWillReloadTableView:NO];
            break;
        }
        case NSFetchedResultsChangeUpdate:{
            [self reloadAllTracksWillReloadTableView:YES];
            break;
        }
        case NSFetchedResultsChangeMove:{
            break;
        }
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self reloadAllTracksWillReloadTableView:NO];
    [_tbvPlaylistTracks endUpdates];
}


#pragma mark - ActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //
    //    if (buttonIndex == btnAddIndex) {
    //        AddToPlaylistViewController *addToPlaylistViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addToPlaylistID"];
    //        addToPlaylistViewController.track = [[Track alloc]initWithDBTrack:[_tracks objectAtIndex:actionSheet.tag]];
    //        CATransition* transition = [CATransition animation];
    //        transition.duration = 0.3f;
    //        transition.type = kCATransitionMoveIn;
    //        transition.subtype = kCATransitionFromTop;
    //        [self.navigationController.view.layer addAnimation:transition
    //                                                    forKey:kCATransition];
    //        [addToPlaylistViewController setHidesBottomBarWhenPushed:YES];
    //        [self.navigationController pushViewController:addToPlaylistViewController animated:NO];
    //    } else if (buttonIndex == btnDeleteIndex) {
    //        NSArray *playlistTracks = [PlaylistTrack MR_findAllSortedBy:@"createdAt" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"playlistIndex = %@",_selectedPlaylist.index]];
    //        PlaylistTrack *playlistTrackDelete = playlistTracks[actionSheet.tag];
    //
    //        [playlistTrackDelete deletePlaylistTrack];
    //    }
    
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
