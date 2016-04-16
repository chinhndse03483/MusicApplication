//
//  FavoriteCell.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/12/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBListTrack.h"
#import "MGSwipeTableCell.h"
@interface FavoriteCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet UIImageView *imgTrack;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblTrackNumber;
@property (nonatomic, weak) DBListTrack *cellPlaylist;

- (void)displayPlaylist:(DBListTrack *)playlist;
- (void)displayBtnNewPlaylist;
@end
