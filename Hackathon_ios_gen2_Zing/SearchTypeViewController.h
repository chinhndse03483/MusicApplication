//
//  SearchTypeViewController.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/27/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "ViewController.h"
#import "YALSunnyRefreshControl.h"
@import GoogleMobileAds;
@interface SearchTypeViewController : UIViewController <UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
}
@property (nonatomic,strong) YALSunnyRefreshControl *sunnyRefreshControl;
@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;
@property(nonatomic,strong) IBOutlet UITableView *tblSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblSuggest;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
