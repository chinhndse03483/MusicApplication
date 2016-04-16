//
//  SearchTypeViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/27/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//
#define URLIMAGE                                      @"http://image.mp3.zdn.vn/"
#define MP3SearchSuggestionTrackUrl               @"http://mp3.zing.vn/suggest/search?term=%@"
#define MP3SearchTrackUrl                         @"http://mp3.zing.vn/suggest/search?term=%@"
#define MP3URLStreaming                         @"http://api.mp3.zing.vn/api/mobile/song/getsonginfo?keycode=fafd463e2131914934b73310aa34a23f&requestdata={\"id\":\""
#define MP3URLStreaming2                        @"\"}"
#define img             @"http://image.mp3.zdn.vn/avatars/f/a/fa1c00dde7779e35feacfb946d30c531_1445830447.jpg"
#define APIMP3 @"http://j.ginggong.com/jOut.ashx?k=%@"
#define APIMP32 @"&h=mp3.zing.vn&code=3cb698a1-3f2d-4dc0-97e7-4852dec76fc3"


#import "SearchTypeViewController.h"
#import "Suggestion.h"
#import "AFNetworking.h"
#import "Track.h"
#import "SuggestCell.h"
#import "SearchSongCellTableViewCell.h"
#import "NowplayingViewController.h"
#import "YALSunnyRefreshControl.h"
#import "AppDelegate.h"
#import "SVPullToRefresh.h"
#import "TFHpple.h"
#import "CommonFunction.h"
#import "AddTrackToFavorite.h"
@import GoogleMobileAds;
@interface SearchTypeViewController ()
{
//UIRefreshControl *refreshControl;
    int currentPopup;
}
@property(nonatomic,strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) NSMutableArray *suggestions;
@property(nonatomic, strong) NSMutableArray *track;
@property(nonatomic , assign) NSInteger curentPage;
@property(nonatomic, strong) NSMutableArray *displayArray;
@end

@implementation SearchTypeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    
    // Do any additional setup after loading the view.
    _searchBar.delegate = self;
    _suggestions = [[NSMutableArray alloc]init];
    _track = [[NSMutableArray alloc]init];
    
    self.curentPage =1;
    //setup refresh data when drag down
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [_tblSearch addSubview:_refreshControl];
    _tblSuggest.hidden = YES;
    _tblSearch.hidden = YES;
    
    __weak SearchTypeViewController *weakSelf = self;
    
    [self.tblSearch addInfiniteScrollingWithActionHandler:^{
        [weakSelf loadMore];
        
    }];
}

- (void)loadMore {
    int c = random() % 10 + 1;
    //TODO
    self.curentPage ++;
    NSString *URL = [NSString stringWithFormat:@"http://m.mp3.zing.vn/tim-kiem/bai-hat.html?q=%@&page=%d",_searchBar.text,self.curentPage];
    NSString *encoded = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"LoadCmnr");
    NSURL *tutorialsUrl = [NSURL URLWithString:encoded];
    NSData *tutorialsHtmlData = [NSData dataWithContentsOfURL:tutorialsUrl];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
    
    //NSString *tutorialsXpathQueryString = @"//div[@class='tenbh']";
    ///html/body/div[6]/div/div[1]/div[5]
    //section medium-margin-top
    //searchWithXPathQuery:@"//div[@class='section-song fn-autoload']/a"]
    NSString *tutorialsXpathQueryString = @"//div[@id='fnBodyContent']";
    ///html/body/div[6]/div/div[1]/div[5]
    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:@"//div[@class='section-song fn-autoload']/a"];
    NSMutableArray *idArray = [[NSMutableArray alloc]init];
    NSMutableArray *thArray = [[NSMutableArray alloc]init];
    for (TFHppleElement *element in tutorialsNodes)
    {
        NSString *href = [element objectForKey:@"href"];
        href = [NSString stringWithFormat:@"%@%@",@"http://mp3.zing.vn",href];
        TFHppleElement *element1 = [[element children] objectAtIndex:1];
        TFHppleElement *element2 = [[element children] objectAtIndex:3];
        NSString *name = [element1 content];
        NSString *author = [element2 content];
        Track *track = [[Track alloc]initWithTitle:name andAuthor:author andLink:href andLinkImage:nil andType:0];
    
//            
//            [[CommonFunction sharedManager] getDurationWithURL:track.linkStreaming withCompletionBlock:^(NSDictionary *result) {
//                
//                if (result) {
//                    
//                    track.timeDuration = [[CommonFunction sharedManager] formatStringWithDuration:result[@"__text"]];
//                    NSLog(@"fuckk %@",track.timeDuration);
//                    
//                    //download artwork
//                    [self.tblSearch reloadRowsAtIndexPaths:self.tblSearch.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
//                    for (SearchSongCellTableViewCell *cell in self.tblSearch.visibleCells) {
//                        [_tblSearch reloadData];
//                        
//                    }
//                    
//                }else{
//                    track.timeDuration = @"";
//                    
//                    
//                }
//                
//                
//                
//            }];
//            
      

        [thArray addObject:track];
        
    }
    
    
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    tmp = [NSMutableArray arrayWithArray:thArray];
////
            for (Track *trackss in tmp) {
                
                if (trackss){
                                    [_tblSearch beginUpdates];
                    
                                    NSIndexPath *indexPathInsert = [NSIndexPath indexPathForRow:self.track.count inSection:0];
                    
                                    [_tblSearch insertRowsAtIndexPaths:@[indexPathInsert] withRowAnimation:UITableViewRowAnimationRight];
                                    [_track addObject:trackss];
                                    
                    
                                    [_tblSearch endUpdates];
                    NSLog(@"cmm");
                    
                }
        
                
            }
    NSLog(@"dmdmdmdm %d", self.track.count);

//        }
    
    
    
    {
        
        NSLog(@"COUNTTTTTT %ld",_track.count);

    };

}
-(NSMutableArray*)getDataFromjSon:(NSString *)URL{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    
    NSString *encoded = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [httpSessionManager GET:encoded parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSString *linkStreaming = responseObject[@"source"][@"320"];
        
        NSString *url_Img_FULL = [NSString stringWithFormat:@"%@%@", URLIMAGE,responseObject[@"thumbnail"]];
        Track *track = [[Track alloc] init];
        track.title = responseObject[@"title"];
        track.author = responseObject[@"artist"];
        track.link = responseObject[@"source"][@"128"];
        track.linkStreaming = responseObject[@"source"][@"128"];
        track.linkImage = url_Img_FULL;
        
        [array addObject:track];
        NSLog(@"trackkkkk--- %@",track.title);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
    return array;
}


- (void)refresh:(UIRefreshControl *)refreshControl {
    [_track removeAllObjects];
    [_tblSearch reloadData];
    [self searchTracksWithKeyword:_searchBar.text];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
#pragma mark - SearchBar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [_searchBar becomeFirstResponder];
    [_searchBar setShowsCancelButton:YES animated:YES];
    
    if ([_searchBar.text isEqualToString:@""]) {
        _tblSuggest.hidden = YES;
    } else {
        _tblSuggest.hidden = NO;
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_searchBar setShowsCancelButton:NO animated:YES];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
  //  [_track removeAllObjects];
    if ([_searchBar.text isEqualToString:@""]) {
        _tblSuggest.hidden = YES;
        _tblSearch.hidden = YES;
        _searchBar.text = @"";
        [_suggestions removeAllObjects];
        [_tblSuggest reloadData];
    }
    [self autoCompleteWithKeyword:_searchBar.text andCompletionBlock:^(NSArray *suggestion) {
        
        NSMutableArray *tmpSuggestion = [[NSMutableArray alloc]init];
        
        for (NSDictionary *jsonDict in suggestion) {
            Suggestion *newSuggestion = [[Suggestion alloc]initWithJson:jsonDict];
            [tmpSuggestion addObject:newSuggestion];
        }
        
        _suggestions = tmpSuggestion;
        
        [_tblSuggest reloadData];
    }];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar endEditing:YES];
    [_searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    [_searchBar endEditing:YES];
    _tblSuggest.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    
    _tblSuggest.hidden = YES;
    _tblSearch.hidden = NO;
    [_searchBar endEditing:YES];
    
    //[_tblSearch triggerInfiniteScrolling];
    
    [self searchTracksWithKeyword:_searchBar.text];
}
#pragma mark - TableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tblSuggest) {
        return _suggestions.count;
    } else {
        return _track.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tblSearch) {
        static NSString *cellId = @"SearchSongCellTableViewCell";
        SearchSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SearchSongCellTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.delegate = self;
        
        Track *track = _track[indexPath.row];
        [cell displayTrack:track];
     
        return cell;
    } else {
        static NSString *cellId = @"suggestionCell";
        
        SuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SuggestCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        Suggestion *suggestion = _suggestions[indexPath.row];
        [cell displaySuggestion:suggestion];
        
        
        return cell;
    }
    
}


-(void)getDataFromjSon1:(NSString *)URL{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    
    NSString *encoded = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [httpSessionManager GET:encoded parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSString *linkStreaming = responseObject[@"source"][@"320"];
        
        NSString *url_Img_FULL = [NSString stringWithFormat:@"%@%@", URLIMAGE,responseObject[@"thumbnail"]];
        Track *track = [[Track alloc] init];
        track.title = responseObject[@"title"];
        track.author = responseObject[@"artist"];
        track.link = responseObject[@"source"][@"128"];
        track.linkStreaming = responseObject[@"source"][@"128"];
        track.linkImage = url_Img_FULL;
        
        [_track addObject:track];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            NSLog(@"%@",error);
        }
    }];
}


#pragma mark - TableView Delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (tableView == _tblSearch) {
        Track *track = _track[indexPath.row];
        NSString *TrackId = track.trackId;
        
        NSString *URL = [NSString stringWithFormat:@"%@%@%@", MP3URLStreaming, TrackId, MP3URLStreaming2];
        
        [self getDataFromjSon1:URL];
        
        NowPlayingViewController *nowPlayingViewController = [NowPlayingViewController sharedManager];
        nowPlayingViewController.trackList = _track[indexPath.row];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
        [APPDELEGATE playMusic:track andIndexPathDidselected:indexPath.row andArrSong:_track];
        
    }else{
        [_searchBar resignFirstResponder];
        Suggestion *suggest = _suggestions[indexPath.row];
        //NSLog(@"%@",selectedTrack.linkStreaming);
        NSString *TrackId = suggest.trackId;
        //NSLog(@"Track ID: %@",suggest);
        NSString *URL = [NSString stringWithFormat:@"%@%@%@", MP3URLStreaming, TrackId, MP3URLStreaming2];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
        
        NSString *encoded = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [httpSessionManager GET:encoded parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *url_Img_FULL = [NSString stringWithFormat:@"%@%@", URLIMAGE,responseObject[@"thumbnail"]];
            Track *track = [[Track alloc] init];
            track.title = responseObject[@"title"];
            track.author = responseObject[@"artist"];
            track.link = responseObject[@"source"][@"128"];
            track.linkStreaming = responseObject[@"source"][@"128"];
            track.linkImage = url_Img_FULL;
            [_track addObject:track];
            NowPlayingViewController *nowPlayingViewController = [NowPlayingViewController sharedManager];
            nowPlayingViewController.trackList = _track[indexPath.row];
            CATransition* transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromTop;
            [self.navigationController.view.layer addAnimation:transition
                                                        forKey:kCATransition];
            [APPDELEGATE playMusic:track andIndexPathDidselected:indexPath.row andArrSong:_track];
//            [nowPlayingViewController setHidesBottomBarWhenPushed:YES];
//            nowPlayingViewController.playingTrack = track;
//            [nowPlayingViewController playTrack:nowPlayingViewController.playingTrack];
//            [nowPlayingViewController animateGoingUp];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@",error);
            }
        }];
    }
    
    
    
}



#pragma mark - Class funtion

- (void)autoCompleteWithKeyword:(NSString *)keyword andCompletionBlock:(void(^)(NSArray *suggestion))completion;
{
    _tblSuggest.hidden = NO;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSString *stringUrl = [NSString stringWithFormat:MP3SearchSuggestionTrackUrl,keyword];
    //accept space
    NSString *encoded = [stringUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [httpSessionManager GET:encoded parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion && responseObject) {
            completion(responseObject[@"song"][@"list"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
        }
    }];
    
}



- (void)searchTracksWithKeyword:(NSString *)keyword ;
{
    
    _tblSuggest.hidden = YES;
    _tblSearch.hidden = NO;
    if (keyword.length > 0) {
        //[_tblSearch triggerInfiniteScrolling];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *stringUrl = [NSString stringWithFormat:APIMP3,keyword];
        NSString *stringUrl2 = [NSString stringWithFormat:@"%@%@",stringUrl,APIMP32];
        __weak SearchTypeViewController *weakSelf = self;
        NSString *encoded = [stringUrl2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [httpSessionManager GET:encoded parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            for (NSDictionary *jsonDict in responseObject) {
                Track *newTrack = [[Track alloc]initWithJson:jsonDict];
                NSLog(@"%@",newTrack.trackId);
                [_track addObject:newTrack];
                //NSLog(@"Link: %@", newTrack.linkStreaming);
            }
            
            
            
            [_tblSearch reloadData];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tblSearch.infiniteScrollingView stopAnimating];
                [weakSelf.refreshControl endRefreshing];
                weakSelf.tblSearch.showsInfiniteScrolling = (_track.count > 0);
            });
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error) {
                NSLog(@"%@",error);
            }
        }];
        
        
        
    }
}

- (void)buttonMoreDidTouch:(id)sender;
{
    
    
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        Track *track = [_track objectAtIndex:currentPopup];
        AddTrackToFavorite *addToFavoriteViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"addToPlaylistID"];
        NSLog(@"%@",track.linkStreaming);
        addToFavoriteViewController.track = track;
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition
                                                    forKey:kCATransition];
        [addToFavoriteViewController setHidesBottomBarWhenPushed:YES];
        [self presentViewController:addToFavoriteViewController animated:YES completion:nil];
//        [self.navigationController pushViewController:addToFavoriteViewController animated:NO];
    }
    
}


- (void)searchSongCellDidTouchOnActionButton : (SearchSongCellTableViewCell*) sender;
{
    NSIndexPath *indexPath = [self.tblSearch indexPathForCell:sender];
    currentPopup = indexPath.row;
    //NSLog(@"index Path %d", indexPath.row);
    UIActionSheet *popup = [[UIActionSheet alloc]                  initWithTitle:nil
                                                                        delegate:self
                                                               cancelButtonTitle:@"Huỷ bỏ"
                                                          destructiveButtonTitle:nil
                                                               otherButtonTitles:
                            @"Thêm vào Danh sách",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(tableView == _tblSearch){
        return 75;
    }else{
        return 40;
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
