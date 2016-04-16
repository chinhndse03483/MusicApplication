//
//  CommonFunction.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/31/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "TFHpple.h"
#import "NowplayingViewController.h"

@interface CommonFunction : NSObject

@property(nonatomic,strong) NSString *tmpURL;
+ (id)sharedManager ;
- (void) getStringwithURL:(NSString*)url withCompletionBlock:(void(^)(NSString*result) )completion;
- (void) getDurationWithURL:(NSString*)url withCompletionBlock:(void(^)(NSDictionary *result) )completion;
- (int) convertTitletoTypewithTitle:(NSString*)nameType;
- (NSString*)convertToMobilewithLink:(NSString*)link;
- (NSString*)getStringWithStreamingURL:(NSString*)streamingURL;
- (NSString*)formatStringWithDuration:(NSString*)duration;
@end
