//
//  SearchSongCellTableViewCell.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/27/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#define MP3BtnMoreImageName                           @"ButtonMore"
#import "SearchSongCellTableViewCell.h"
#define MP3DefaultTrackImageName                      @"Track1"
#define URLIMAGE                                      @"http://image.mp3.zdn.vn/"
#import "Track.h"
#import "UIImageView+WebCache.h"

@implementation SearchSongCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)displayTrack:(Track *)track;
{
    
    NSString *myString = [NSString stringWithFormat:track.title];
    NSRange range = [myString rangeOfString:@"-"];
    NSString *name = @"";
    NSString *author = @"";
    if (range.length != 0)
    {
        name = [myString substringToIndex:range.location];
        author = [myString substringFromIndex:range.location+1];

    }
    if([track.URLImage isEqualToString:@""]){
        _imgSong.image = [UIImage imageNamed:MP3DefaultTrackImageName];
    }else {
        [_imgSong sd_setImageWithURL:[NSURL URLWithString:track.linkImage] placeholderImage:[UIImage imageNamed:MP3DefaultTrackImageName]];
    }
    if ([name isEqualToString:@""])
    {
        name = track.title;
    }
    if ([author isEqualToString:@""])
    {
        author = track.author;
    }
    _lblName.text = name;
    _lblAuthor.text = author;
    _lblDuration.text = track.timeDuration;
}


- (IBAction)btnActionTouchUpInside:(id)sender {
    //    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Sharing option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
    //                            @"Them vao Danh Sach",
    //                            @"Chia se",
    //                            nil];
    //    popup.tag = 1;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchSongCellDidTouchOnActionButton:)]){
        [self.delegate searchSongCellDidTouchOnActionButton:self];
    } 
}


@end
