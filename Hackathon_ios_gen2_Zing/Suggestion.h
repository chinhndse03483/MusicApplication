//
//  Suggestion.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Chinh Nguyen on 4/5/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Suggestion : NSObject
@property (nonatomic, strong) NSString *query;
@property (nonatomic, strong) NSString *kind;
@property (nonatomic, strong) NSString *trackId;
@property (nonatomic, strong) NSString *artit;

- (instancetype)initWithJson:(NSDictionary *)jsonDict;
@end
