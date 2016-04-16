//
//  AddTrackToFavorite.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/14/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"
@interface AddTrackToFavorite : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblPlaylists;
@property (nonatomic,strong) Track *track;

@end
