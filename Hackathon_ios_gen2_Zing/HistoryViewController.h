//
//  HistoryViewController.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/12/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "TrackCell.h"
@interface HistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tbvHistory;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property(strong,nonatomic) NSMutableArray *historyTracks;
@property(assign,nonatomic) NSInteger *type;

@end

