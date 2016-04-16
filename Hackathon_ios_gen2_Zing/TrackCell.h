//
//  TrackCell.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/12/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBTrack.h"

@protocol TrackCellDelegate <NSObject>

- (void)buttonMoreDidTouch:(id)sender;

@end

@interface TrackCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;
@property (weak, nonatomic) id<TrackCellDelegate> trackCellDelegate;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;

- (IBAction)btnMoreTouched:(id)sender;

@end