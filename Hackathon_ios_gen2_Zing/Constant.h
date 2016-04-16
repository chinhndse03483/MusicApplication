//
//  Constant.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Admin on 4/3/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kAppDefaultColor                            [UIColor redColor]

#define kAppColor                                   (UIColor *)[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppColor"]]

#define kDefaultTrackImageName                      @"defaultImage"
#define kBtnRemoveAllImageName                      @"icon_delete_all"
#define kBtnMoreImageName                           @"ButtonMore"

@interface Constant : NSObject

@end
