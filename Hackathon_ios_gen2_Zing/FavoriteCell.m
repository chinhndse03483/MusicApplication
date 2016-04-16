//
//  FavoriteCell.m
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/12/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "FavoriteCell.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import <MagicalRecord/MagicalRecord.h>
#import "DBTrack.h"
@implementation FavoriteCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)displayPlaylist:(DBListTrack *)playlist;
{
    _cellPlaylist = playlist;
    
    _lblTitle.text = playlist.listName;
    int trackNumber = (int)[DBTrack MR_countOfEntitiesWithPredicate:[NSPredicate predicateWithFormat:@"listID = %@",playlist.listID]];
    
    NSLog(@"trackNumber %d",trackNumber);
    _lblTrackNumber.text = [NSString stringWithFormat:@"%d track",trackNumber];
    
    UIImage *placeholerImage = [UIImage imageNamed:@"TrackDefault"];
    DBTrack *track = [DBTrack MR_findFirstByAttribute:@"listID" withValue:[NSString stringWithFormat:@"%@",playlist.listID]];
    if (![track.linkImage isEqualToString:@""]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:track.linkImage]
                    placeholderImage:placeholerImage
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                               
                           }];
    } else {
        self.imageView.image = placeholerImage;
    }

    
}

- (void)displayBtnNewPlaylist;
{
    self.accessoryType = UITableViewCellAccessoryNone;
    UIImage *image = [[UIImage imageNamed:@"add_folder"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _imgTrack.image = image;
    _lblTrackNumber.text = @"";
    [_lblTitle setFont:[UIFont systemFontOfSize:20]];
    _lblTitle.text = @"Add";
}

@end
