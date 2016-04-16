//
//  FavoriteViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/13/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "FavoriteViewController.h"
#import "DBListTrack.h"
#import "Constant.h"
#import "FavoriteCell.h"
#import "FavoriteDetailViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "NowplayingViewController.h"
#import "AppDelegate.h"
@interface FavoriteViewController ()<NSFetchedResultsControllerDelegate>
@property(nonatomic,strong) NSMutableArray *playlists;
@property(nonatomic,strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //setup SearchBar
    
    _tbvListTrack.tableFooterView = [[UIView alloc]init];
    
    _fetchedResultsController = [DBListTrack MR_fetchAllSortedBy:@"listID"
                                                       ascending:NO
                                                   withPredicate:[NSPredicate predicateWithFormat:@"listID != %@",[NSNumber numberWithInt:0]]
                                                         groupBy:nil
                                                        delegate:self];
    
    [self reloadAllPlaylistsWillReloadTableView:YES];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadAllPlaylistsWillReloadTableView:YES];
}
- (void)reloadAllPlaylistsWillReloadTableView:(BOOL)willReloadTable;
{
    _playlists = [[NSMutableArray alloc]initWithArray:[DBListTrack MR_findAllSortedBy:@"listID" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"listID != %@",[NSNumber numberWithInt:0]]]];
    if (willReloadTable) {
        [_tbvListTrack reloadData];
    }
    
}

- (void)btnDeleteDidTouchAtIndexPath:(FavoriteCell *)cell;
{
    [cell.cellPlaylist deleteFavorite];
}

- (void)btnRenameDidTouchAtIndexPath:(FavoriteCell *)cell;
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rename Playlist"
                                                                   message:@"Enter a name for this playlist"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = [NSString stringWithFormat:@"%@",cell.cellPlaylist.listName];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        cell.cellPlaylist.listName = alert.textFields[0].text;
        
    }];
    
    [alert addAction:cancel];
    [alert addAction:save];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([NowPlayingViewController sharedManager].playingTrack) {
        
        //        UIImage *btnPlayingImage = [UIImage customWithTintColor:kAppColor duration:1.5];
        //
        //        UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithImage:btnPlayingImage style:UIBarButtonItemStyleBordered target:self action:@selector(btnPlayingDidTouch)];
        //        self.navigationItem.rightBarButtonItem = barItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else {
        return _playlists.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *cellId = @"FavoriteCell";
        
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FavoriteCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [cell displayBtnNewPlaylist];
        
        return cell;
    } else {
        static NSString *cellId = @"FavoriteCell";
        
        FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FavoriteCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        [cell displayPlaylist:_playlists[indexPath.row]];
        
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 60;
    }
    else {
        return 55;
    }
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"New Playlist"
                                                                       message:@"Enter a name for this playlist"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"";
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [DBListTrack createFavoriteWithTitle:alert.textFields[0].text];
            
        }];
        
        [alert addAction:cancel];
        [alert addAction:save];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        DBListTrack *selectedPlaylist = _playlists[indexPath.row];
        
        FavoriteDetailViewController *favoriteDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"playlistDetail"];
        favoriteDetailViewController.selectedPlaylist = selectedPlaylist;
        
        [self.navigationController pushViewController:favoriteDetailViewController animated:YES];
        
    }
}

#pragma mark - FetchedResultsController

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tbvListTrack beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:{
            NSInteger realIndex = [_fetchedResultsController.fetchedObjects indexOfObject:anObject];
            if (realIndex != NSNotFound) {
                NSIndexPath *realIndexPath = [NSIndexPath indexPathForRow:realIndex inSection:1];
                
                [_tbvListTrack insertRowsAtIndexPaths:@[realIndexPath]
                                     withRowAnimation:UITableViewRowAnimationLeft];
            }
            break;
        }
        case NSFetchedResultsChangeDelete:{
            NSInteger realIndex = [_playlists indexOfObject:anObject];
            if (realIndex != NSNotFound) {
                NSIndexPath *realIndexPath = [NSIndexPath indexPathForRow:realIndex inSection:1];
                
                [_tbvListTrack deleteRowsAtIndexPaths:@[realIndexPath]
                                     withRowAnimation:UITableViewRowAnimationRight];
                
            }
            break;
        }
        case NSFetchedResultsChangeUpdate:{
            NSInteger realIndex = [_fetchedResultsController.fetchedObjects indexOfObject:anObject];
            if (realIndex != NSNotFound) {
                NSIndexPath *realIndexPath = [NSIndexPath indexPathForRow:realIndex inSection:1];
                
                [_tbvListTrack reloadRowsAtIndexPaths:@[realIndexPath]
                                     withRowAnimation:UITableViewRowAnimationFade];
                
            }
            break;
        }
        case NSFetchedResultsChangeMove:{
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self reloadAllPlaylistsWillReloadTableView:NO];
    [_tbvListTrack endUpdates];
}

- (IBAction)btnDidTouchAddTrack:(id)sender {
}
@end
