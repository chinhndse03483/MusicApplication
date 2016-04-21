//
//  ParseAlbumViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 4/6/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "ParseAlbumViewController.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "GenreTop.h"
#import "Track.h"
#import "UIImageView+WebCache.h"
#import "SearchSongCellTableViewCell.h"
#import "CommonFunction.h"
#import "NowplayingViewController.h"
#define kQueueNameHTMLParse @"kQueueNameHTMLParse"
#import "AppDelegate.h"
#import "AddTrackToFavorite.h"
@interface ParseAlbumViewController ()
@property(strong, nonatomic)  NSOperationQueue *queueHTMLParse;
@property(strong,nonatomic) NSMutableDictionary *mutableDict;
@property(strong,nonatomic) NSMutableArray *listSong;
@property(strong,nonatomic) NSString *xmlPath;

@end
//UIRefreshControl *refreshControl;

@implementation ParseAlbumViewController
{
    int currentPopup;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _queueHTMLParse = [[NSOperationQueue alloc]init];
    _listSong = [[NSMutableArray alloc]init];
    [self setTitle:_navigationTitle];
    [self.queueHTMLParse setName:kQueueNameHTMLParse];
    _mutableDict = [[NSMutableDictionary alloc]init];
    [self requestListCategories];

}

-(void)refreshTable
{
//    // [_listSong removeAllObjects];
//    [self requestListCategories];
//    //  [_tblSong reloadData];
//    [refreshControl endRefreshing];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)exploreTracksWithGenre:(NSString *)url completionBlock:(void(^)(NSArray *tracks))completion;
{
    
    //tao session
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    // NSString *urlString = [NSString stringWithFormat:kSoundCloudExploreURL,code] ;
    NSString *urlString = url;
    
    NSURLSessionDataTask *dataTask = [httpSessionManager GET:urlString
                                                  parameters:nil
                                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                         if (completion && responseObject) {
                                                             completion(responseObject[@"data"]);
                                                         }
                                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                         if (error) {
                                                             NSLog(@"%@",error);
                                                         }
                                                     }];
    [dataTask resume];
    
}


- (void)requestListCategories;
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlParse]];
    
    AFHTTPRequestOperation *opretation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [opretation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         TFHpple *document= [[TFHpple alloc]initWithHTMLData:responseObject];
         NSArray *listAs = [document searchWithXPathQuery:@"//*[@id='playlistItems']/ul/li"];
         for (TFHppleElement *element in listAs)
         {             
             ////*[@id="songZW7OF67W"]/div[1]
             TFHppleElement *href1 = [[element searchWithXPathQuery:@"//div[@class='item-song']/h3/a"] objectAtIndex:0];
             NSString *link = [href1 objectForKey:@"href"];
             NSString *title = [href1 content];
             ////*[@id="songZW7OF67W"]/div[1]/div
            href1 = [[element searchWithXPathQuery:@"//div[@class='inline ellipsis']/div/h4/a"] objectAtIndex:0];
             NSString *author = [href1 content];
             Track *track = [[Track alloc]initWithTitle:title andAuthor:author andLink:link andLinkImage:_imageAlbum
                             andType:0];
             [[CommonFunction sharedManager] getDurationWithURL:track.linkStreaming withCompletionBlock:^(NSDictionary *result) {
                 
                 
                 
                 
                 
                 if (result) {
                     
                     track.timeDuration = [[CommonFunction sharedManager] formatStringWithDuration:result[@"__text"]];
                     NSLog(@"fuckk %@",track.timeDuration);
                     
                     //download artwork
                     [self.tblSong reloadRowsAtIndexPaths:self.tblSong.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
                     for (SearchSongCellTableViewCell *cell in self.tblSong.visibleCells) {
                         [_tblSong reloadData];
                         
                         
                     }
                     
                 }else{
                     track.timeDuration = @"";
                     
                     
                 }
                 
             }];
             

             [_listSong addObject:track];
         }
         [_tblSong reloadData];
       
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Couldn't download data because : %@",error);
         
     }];
    [self.queueHTMLParse addOperation:opretation];
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SearchSongCellTableViewCell";
    SearchSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchSongCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    Track *track = [_listSong objectAtIndex:indexPath.row];
    cell.lblName.text = track.title;
    cell.lblAuthor.text = track.author;
    UIImage *placeholerImage = [UIImage imageNamed:@"TrackDefault"];
    if (![_imageAlbum isEqualToString:@""]) {
        [cell.imgSong sd_setImageWithURL:[NSURL URLWithString:_imageAlbum]
                        placeholderImage:placeholerImage
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   
                               }];
    } else {
        cell.imgSong = placeholerImage;
    
    }
    cell.lblDuration.text = [[_listSong objectAtIndex:indexPath.row] timeDuration];
    return cell;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 76;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"listSong %d", _listSong.count);
    return (_listSong.count);
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
//    int i = arc4random()%3;
//    if(APPDELEGATE.interstitial.isReady && i == 0){
//        
//        [APPDELEGATE.interstitial presentFromRootViewController:self];
//    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
        NowPlayingViewController *nowPlayingViewController = [NowPlayingViewController sharedManager];
        nowPlayingViewController.trackList = _listSong;
        Track *selectedTrack = _listSong[indexPath.row];
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [APPDELEGATE playMusic:selectedTrack andIndexPathDidselected:indexPath.row andArrSong:_listSong];
}


- (void)searchSongCellDidTouchOnActionButton : (SearchSongCellTableViewCell*) sender;
{
    NSIndexPath *indexPath = [self.tblSong indexPathForCell:sender];
    //NSLog(@"index Path %d", indexPath.row);
    currentPopup = indexPath.row;
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Huỷ bỏ" destructiveButtonTitle:nil otherButtonTitles:
                            @"Thêm vào Danh sách",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
}



- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        Track *track = [_listSong objectAtIndex:currentPopup];
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
        //[self presentViewController:addToFavoriteViewController animated:YES completion:nil];
        [self.navigationController pushViewController:addToFavoriteViewController animated:NO];
    }
    
}



@end
