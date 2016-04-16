//
//  ShowListViewController.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/16/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbvShowList;
@property(nonatomic,strong) NSMutableArray *trackList;
@property(nonatomic,strong) UIBarButtonItem *barItem;
@end
