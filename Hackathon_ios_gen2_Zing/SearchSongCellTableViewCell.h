//
//  SearchSongCellTableViewCell.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/27/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
#import "Suggestion.h"

@class SearchSongCellTableViewCell;

@protocol SearchSongTableCellDelegate <NSObject>

- (void)searchSongCellDidTouchOnActionButton : (SearchSongCellTableViewCell*) sender;

@end


@interface SearchSongCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDuration;
@property (nonatomic,weak) id<SearchSongTableCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblAuthor;

@property (weak, nonatomic) IBOutlet UIImageView *imgSong;

//@property (weak, nonatomic) IBOutlet UIImageView *imvArtwork;
- (void)displayTrack:(Track *)track;


@property (weak, nonatomic) IBOutlet UIButton *btnAction;
- (IBAction)btnActionTouchUpInside:(id)sender;


@end
