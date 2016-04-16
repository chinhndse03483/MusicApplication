//
//  Suggestion.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Chinh Nguyen on 4/5/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "Suggestion.h"

@implementation Suggestion

- (instancetype)initWithJson:(NSDictionary *)jsonDict;
{
    self = [super init];
    
    if (self) {
        
        _query = jsonDict[@"name"];
        _query = [_query stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        _trackId = jsonDict[@"object_id"];
        _artit = jsonDict[@"artist"];
        
    }
    
    return self;
    
}

@end
