//
//  FavoriteViewController.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/13/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface FavoriteViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}
@property (weak, nonatomic) IBOutlet UITableView *tbvListTrack;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTrack;
- (IBAction)btnDidTouchAddTrack:(id)sender;

@property(nonatomic,strong) Track *addTrack;
@end
