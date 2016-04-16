//
//  ParseSong.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/28/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseSong : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) IBOutlet UITableView *tblSong;
@property(nonatomic,weak) NSString* urlParse;
@property(assign,nonatomic) NSInteger type;
@property(assign,nonatomic) NSUInteger *indextouch;
@property(nonatomic,strong) NSString *navigationTitle;


- (void)requestListCategories;

@end
