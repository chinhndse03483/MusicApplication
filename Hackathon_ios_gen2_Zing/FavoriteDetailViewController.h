//
//  FavoriteDetailViewController.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/13/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBListTrack.h"

@interface FavoriteDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property(nonatomic,strong) DBListTrack *selectedPlaylist;
@property (weak, nonatomic) IBOutlet UITableView *tbvPlaylistTracks;

@end