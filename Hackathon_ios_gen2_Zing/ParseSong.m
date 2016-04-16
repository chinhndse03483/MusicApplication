//
//  ParseSong.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/28/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "ParseSong.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "GenreTop.h"
#import "Track.h"
#import "UIImageView+WebCache.h"
#import "SearchSongCellTableViewCell.h"
#import "CommonFunction.h"
#import "NowplayingViewController.h"
#import "ParseAlbumViewController.h"
#import "FavoriteViewController.h"
#import "AddTrackToFavorite.h"
#import "AppDelegate.h"
#import "SVPullToRefresh.h"
//#import "LNPopupController/"
#define kQueueNameHTMLParse @"kQueueNameHTMLParse"


@interface ParseSong ()
{
    UIRefreshControl *refreshControl;
    int currentPopup;

}


@property(strong, nonatomic)  NSOperationQueue *queueHTMLParse;
@property(strong,nonatomic) NSMutableDictionary *mutableDict;
@property(strong,nonatomic) NSMutableArray *listSong;




@end


NowPlayingViewController *nowPlayingViewController;

@implementation ParseSong

- (void)viewDidLoad {
    [super viewDidLoad];
    _queueHTMLParse = [[NSOperationQueue alloc]init];
    _listSong = [[NSMutableArray alloc]init];
    [self setTitle:_navigationTitle];
    
    [self.queueHTMLParse setName:kQueueNameHTMLParse];
    _mutableDict = [[NSMutableDictionary alloc]init];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tblSong addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self requestListCategories];
    
    int c = 0;
    //[_tblSong reloadData];
     //Do any additional setup after loading the view.
//    [[CommonFunction sharedManager] getDurationWithURL:@"http://mp3.zing.vn/bai-hat/Tinh-Yeu-Chap-Va-Mr-Siro/ZW7OCOO0.html" withCompletionBlock:^(NSString *result) {
//        
//      
//        
//      
//    
//    }];
}

-(void)refreshTable
{
   // [_listSong removeAllObjects];
    [self requestListCategories];
  //  [_tblSong reloadData];
    [refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)requestListCategories;
{
 //   [_listSong removeAllObjects];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlParse]];
    
    AFHTTPRequestOperation *opretation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [opretation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         TFHpple *document= [[TFHpple alloc]initWithHTMLData:responseObject];
         NSArray *listAs = [document searchWithXPathQuery:@"//div[@class='wrap-content']"];
         TFHppleElement *element1 = [listAs objectAtIndex:0];
         listAs = [element1 searchWithXPathQuery:@"//div[@class='table-body']/ul/li"] ;
         if (listAs.count == 0)
         {
             listAs = [element1 searchWithXPathQuery:@"//div[@class='table-body none-point']/ul/li"];
         }
         int count = 0;
         for (TFHppleElement *element in listAs)
         {
             TFHppleElement *href = [[element searchWithXPathQuery:@"//div[@class='e-item']/a"] objectAtIndex:0];
             //NSLog(@"link song %@", [href objectForKey:@"href"]);
             NSString *link = [href objectForKey:@"href"];
             TFHppleElement *abc= [[element searchWithXPathQuery:@"//div[@class='e-item']"] objectAtIndex:0];
             TFHppleElement *cde= [[abc searchWithXPathQuery:@"//img"] objectAtIndex:0];
             NSString *linkImage = [cde objectForKey:@"src"];
             TFHppleElement *xyz = [[abc searchWithXPathQuery:@"//h3[@class='title-item']/a"] objectAtIndex:0];
             //NSLog(@"title %@", [xyz objectForKey:@"title"]);
             
             NSString *title = [xyz objectForKey:@"title"];
             NSString *author = [[NSString alloc]init];
             if ([[abc searchWithXPathQuery:@"//h4[@class='title-sd-item txt-info']/a"] count] > 0){
                 xyz = [[abc searchWithXPathQuery:@"//h4[@class='title-sd-item txt-info']/a"] objectAtIndex:0];
                author = [[xyz objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"Nghệ sĩ " withString:@""];
             }else{
                 author = @"";
             }
             
             Track *track = [[Track alloc]initWithTitle:title andAuthor:author andLink:link andLinkImage:linkImage
                             andType:_type];
             
            if (_type == 0)
            {
                
//                [[CommonFunction sharedManager] getDurationWithURL:track.linkStreaming withCompletionBlock:^(NSDictionary *result) {
//                    
//                    if (result) {
//                        
//                        track.timeDuration = [[CommonFunction sharedManager] formatStringWithDuration:result[@"__text"]];
//                        NSLog(@"fuckk %@",track.timeDuration);
//                        
//                        //download artwork
//                        [self.tblSong reloadRowsAtIndexPaths:self.tblSong.indexPathsForVisibleRows withRowAnimation:UITableViewRowAnimationNone];
//                        for (SearchSongCellTableViewCell *cell in self.tblSong.visibleCells) {
//                            [_tblSong reloadData];
//                            
//                            
//                        }
//                        
//                    }else{
//                        track.timeDuration = @"";
//                        
//                        
//                    }
//                    
//                    
//                    
//                }];

            }
             
             track.trackId =[NSString stringWithFormat:@"1"]; //TODO
            
             if (_listSong.count >= count+1)
             {
                 [_listSong replaceObjectAtIndex:count withObject:track];
             }
             else
             {
                 [_listSong addObject:track];
             }
             count = count + 1;
         }
         [refreshControl endRefreshing];
         [_tblSong reloadData];
         
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Couldn't download data because : %@",error);
         
     }];
    [self.queueHTMLParse addOperation:opretation];
    
    
}

-(void)getDuration:(NSMutableArray*)array
{
    [self requestListCategories];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    Track *selectedTrack1 = _listSong[indexPath.row];

    if (_type == 0){
        
        nowPlayingViewController = [NowPlayingViewController sharedManager];
        nowPlayingViewController.trackList = _listSong;
        Track *selectedTrack = _listSong[indexPath.row];
        nowPlayingViewController.indexTrack = [NSIndexPath indexPathForRow:indexPath.row inSection:_type];
            nowPlayingViewController.playingTrack = selectedTrack;
        [APPDELEGATE playMusic:selectedTrack andIndexPathDidselected:indexPath.row andArrSong:_listSong];
//        UIBarButtonItem *leftbutton =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:nil action:@selector(btnPlayPausePopupDidTap) ];
//        
//  //      nowPlayingViewController.popupItem.leftBarButtonItems = [NSArray arrayWithObject:leftbutton];
    }
    else if (_type == 1){
        
        ParseAlbumViewController *parseAlbum = [self.storyboard instantiateViewControllerWithIdentifier:@"ParseAlbumViewController"];
        Track *track = [_listSong objectAtIndex:indexPath.row];

        parseAlbum.imageAlbum = track.linkImage;
        parseAlbum.navigationTitle = [[_listSong objectAtIndex:indexPath.row] title];
        parseAlbum.urlParse = [[_listSong objectAtIndex:indexPath.row] link];
        [self.navigationController pushViewController:parseAlbum animated:YES];
    }
    else if (_type == 2){
        // get video
        NowPlayingViewController *nowplayingController = [NowPlayingViewController sharedManager];
        Track *track = [[Track alloc]init];
        track.linkStreaming = @"http://channelz2.cache70.vcdn.vn/zv/2c96660a54c49b839125d391fc5be539/57050850/2016/03/17/f/8/f808cf57a013e504d5bb19588f323b33.mp4";
        [nowplayingController playTrack:track];
        [self.navigationController pushViewController:nowplayingController animated:YES];
    }
    
}
//
//- (void)reloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
//{
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"SearchSongCellTableViewCell";
    Track *track = [_listSong objectAtIndex:indexPath.row];
//    if (!track.timeDuration)
//    {
//        [_tblSong reloadRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationFade];
//    }
    //if (_listSong )
    
    
    SearchSongCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchSongCellTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    if (_type == 1)
    {
        cell.btnAction.hidden = YES;
    }
    cell.delegate = self;
    track = [_listSong objectAtIndex:indexPath.row];
    cell.lblName.text = track.title;
    cell.lblAuthor.text = track.author;
    UIImage *placeholerImage = [UIImage imageNamed:@"TrackDefault"];
    if (![track.linkImage isEqualToString:@""]) {
        [cell.imgSong sd_setImageWithURL:[NSURL URLWithString:track.linkImage]
                           placeholderImage:placeholerImage
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      
                                  }];
    } else {
        cell.imgSong = placeholerImage;
    }
    cell.lblDuration.text = track.timeDuration;
    //[cell.lblDuration setHidden:TRUE];
    if (_type == 1)
    {
      //  [cell.lblDuration setHidden:TRUE];
    }
    if(_type != 1)
    {
//        NSString *linkStream = [[CommonFunction sharedManager] getTimeWithStreamingURL:[[_listSong objectAtIndex:indexPath.row] linkStreaming]];
        //NSLog(@"linkstream %@", linkStream);
    }

    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _listSong.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 76;
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
