//
//  ParseAlbumViewController.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 4/6/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseAlbumViewController : UIViewController<UITableViewDataSource,UITableViewDataSource,UIActionSheetDelegate>
@property(nonatomic,weak) NSString* urlParse;
@property(nonatomic,strong) NSString* navigationTitle;
- (void)exploreTracksWithGenre:(NSString *)url completionBlock:(void(^)(NSArray *tracks))completion;
@property (weak, nonatomic) IBOutlet UITableView *tblSong;
@property(strong,nonatomic) NSString *imageAlbum;

@end
