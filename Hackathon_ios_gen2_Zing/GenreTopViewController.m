//
//  GenreTopViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/27/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "GenreTopViewController.h"
#import "AFNetworking.h"
#import "TFHpple.h"
#import "GenreTop.h"
#import "ParseSong.h"
#import "ListSongViewController.h"
#import "CommonFunction.h"
#import "UIImageView+WebCache.h"
#define kQueueNameHTMLParse @"kQueueNameHTMLParse"
#define kSongVietNam @"http://mp3.zing.vn/bang-xep-hang/bai-hat-Viet-Nam/IWZ9Z08I.html"
#define kAlbumVietNam @"http://mp3.zing.vn/bang-xep-hang/album-Viet-Nam/IWZ9Z08O.html"
#define kSongAumy @"http://mp3.zing.vn/bang-xep-hang/bai-hat-Au-My/IWZ9Z0BW.html"
#define kAlbumAuMy @"http://mp3.zing.vn/bang-xep-hang/album-Au-My/IWZ9Z0B6.html"
#define kSongHQQ @"http://mp3.zing.vn/bang-xep-hang/bai-hat-Han-Quoc/IWZ9Z0BO.html"
#define kAlbumHQ @"http://mp3.zing.vn/bang-xep-hang/album-Han-Quoc/IWZ9Z0B7.html"
#define kSong @"Bài Hát"
#define kAlbum @"Album"
#define kHeaderName @"Bảng Xếp Hạng"
#

@interface GenreTopViewController ()
@property(strong, nonatomic)  NSOperationQueue *queueHTMLParse;
@property(strong,nonatomic) NSMutableDictionary *mutableDict;
@property(strong,nonatomic) NSMutableArray *linkImage;
@property(strong,nonatomic)  NSMutableArray *linkAll;
@end

@implementation GenreTopViewController
- (void)viewWillAppear:(BOOL)animated
{
    _linkAll = [[NSMutableArray alloc]init];
    _linkImage = [[NSMutableArray alloc]init];
    
    [_linkAll addObject:kSongAumy];
    [_linkAll addObject:kAlbumAuMy];
    
    
    
    [_linkAll addObject:kSongVietNam];
    [_linkAll addObject:kAlbumVietNam];
    
    [_linkAll addObject:kSongHQQ];
    [_linkAll addObject:kAlbumHQ];
    
    
    
    
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:kHeaderName];
    _queueHTMLParse = [[NSOperationQueue alloc]init];
    [self.queueHTMLParse setName:kQueueNameHTMLParse];
    _mutableDict = [[NSMutableDictionary alloc]init];
   // _linkImage = [[NSMutableArray alloc]init];
    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc]init];
    NSMutableArray *listLink = [[NSMutableArray alloc]init];
    NSMutableArray *listTitle = [[NSMutableArray alloc]init];
    [listLink addObject:kSongVietNam];
    [listLink addObject:kAlbumVietNam];
    
    
    [listTitle addObject:kSong];
    [listTitle addObject:kAlbum];
    
    
    [dictTmp setObject:[listLink copy] forKey:@"link"];
    [dictTmp setObject:[listTitle copy] forKey:@"title"];
    [_mutableDict setValue:[dictTmp copy] forKey:@"VIỆT NAM"];
    
    [listLink removeAllObjects];
    [listLink addObject:kSongHQQ];
    [listLink addObject:kAlbumHQ];
    
    [dictTmp removeAllObjects];
    [dictTmp setObject:[listLink copy] forKey:@"link"];
    [dictTmp setObject:[listTitle copy] forKey:@"title"];
    
    
    [_mutableDict setValue:[dictTmp copy] forKey:@"HÀN QUỐC"];
    
    
    [listLink removeAllObjects];
    [listLink addObject:kSongAumy];
    [listLink addObject:kAlbumAuMy];
    
    [dictTmp removeAllObjects];
    [dictTmp setObject:[listLink copy] forKey:@"link"];
    [dictTmp setObject:[listTitle copy] forKey:@"title"];
    
    
    [_mutableDict setValue:[dictTmp copy] forKey:@"ÂU MỸ"];
    
    
   // self.tblGenre.separatorColor = [UIColor clearColor];
    
    
    
    
    
    //[self getLink];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) getLinkWith:(NSString*)url completionBlock:(void(^)(NSString *urlImage))completion;
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
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
         TFHppleElement *element = [listAs objectAtIndex:0];
             TFHppleElement *href = [[element searchWithXPathQuery:@"//div[@class='e-item']/a"] objectAtIndex:0];
             //NSLog(@"link song %@", [href objectForKey:@"href"]);             
             TFHppleElement *abc= [[element searchWithXPathQuery:@"//div[@class='e-item']"] objectAtIndex:0];
             TFHppleElement *cde= [[abc searchWithXPathQuery:@"//img"] objectAtIndex:0];
             NSString *linkImage = [cde objectForKey:@"src"];
         completion(linkImage);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Couldn't download data because : %@",error);
         
     }];
    [self.queueHTMLParse addOperation:opretation];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    //NSLog(@"count section %d", [[_mutableDict allKeys] count]);
    return [[_mutableDict allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [[[_mutableDict objectForKey:[[_mutableDict allKeys] objectAtIndex:section]]objectForKey:@"link"] count] ;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_mutableDict allKeys] objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *identifier = @"GenreTop";
    
    GenreTop *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GenreTop" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *country = [[_mutableDict allKeys] objectAtIndex:indexPath.section];
    NSDictionary *dict = [_mutableDict objectForKey:country];
    NSString *title = [[dict objectForKey:@"title"] objectAtIndex:indexPath.row];
    cell.lblName.text = title;
   // NSLog(@"Title %@", title);
    UIImage *placeholerImage = [UIImage imageNamed:@"TrackDefault"];
//    NSString *ImageUrl = [_linkImage objectAtIndex:(indexPath.section-1)*2 + indexPath.row];
//    if (![ImageUrl isEqualToString:@""]) {
//        [cell.img sd_setImageWithURL:[NSURL URLWithString:ImageUrl]
//                        placeholderImage:placeholerImage
//                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                   
//                               }];
//    } else {
//        cell.img = placeholerImage;
//    }
    
        
    
            NSString *url = [_linkAll objectAtIndex:(indexPath.section*2 + indexPath.row)];
            [self getLinkWith:url completionBlock:^(NSString *urlImage) {
                [cell.img sd_setImageWithURL:[NSURL URLWithString:urlImage]
                                         placeholderImage:placeholerImage
                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

                
                
            }];
            }];
            
    
    

    

    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ParseSong *parseSongViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListSongViewController"];
    //[_mutableDict objectForKey:<#(nonnull id)#>
    NSString *country = [[_mutableDict allKeys] objectAtIndex:indexPath.section];
    NSDictionary *dict = [_mutableDict objectForKey:country];
    NSString *link = [[dict objectForKey:@"link"] objectAtIndex:indexPath.row];
    parseSongViewController.navigationTitle = [[[dict objectForKey:@"title"] objectAtIndex:indexPath.row] copy];
    parseSongViewController.urlParse = link;
    parseSongViewController.type = indexPath.row;
    if (self.navigationController){
        [self.navigationController pushViewController:parseSongViewController animated:YES];
    }
    else{
        NSLog(@"Null");
    }
}


@end
