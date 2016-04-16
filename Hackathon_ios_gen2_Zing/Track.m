//
//  Track.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/30/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "Track.h"
#import "CommonFunction.h"

@implementation Track
-(instancetype)initWithTitle:(NSString*)title
                   andAuthor:(NSString*)author
                     andLink:(NSString*)link
               andLinkImage : (NSString*)linkImage
                     andType: (NSInteger)type;
{
    Track *track = [[Track alloc]init];
    track.title = title;
    track.author = author;
    track.link = link;
    track.linkStreaming = link;
    linkImage = [linkImage stringByReplacingOccurrencesOfString:@"94_94" withString:@"240_240"];
    linkImage = [linkImage stringByReplacingOccurrencesOfString:@"/thumb/240_240" withString:@""];
    track.linkImage = linkImage;
    track.type = type;
    //[[CommonFunction sharedManager] getStringwithURL:link];
    //track.link = [CommonFunction sharedManager] tmpURL;
    
    if (_type == 0){
        
        
        [[CommonFunction sharedManager] getStringwithURL:track.linkStreaming withCompletionBlock:^(NSString *result) {
            track.linkStreaming = result;
           // track.timeDuration =[[CommonFunction sharedManager] getStringWithStreamingURL:track.linkStreaming];
        }];
        
        
    }
    
    
    return track;
}

- (instancetype)initWithJson:(NSDictionary *)jsonDict;
{
    self = [super init];
    
    if (self) {
        
        _title = jsonDict[@"Title"];
        _title = [_title stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
        _trackId = jsonDict[@"SiteId"];
        _author = jsonDict[@"artist"];
        _linkImage = jsonDict[@"Avatar"];
        _linkStreaming = jsonDict[@"UrlJunDownload"];
    }
    
    return self;
}

- (instancetype)initWithDBTrack:(DBTrack *)dbTrack;
{
    self = [self init];
    
    if (self) {
        self.title = dbTrack.title;
        self.linkImage = dbTrack.linkImage;
        // self.author = dbTrack.author;
        self.linkStreaming = dbTrack.streamUrl;
    }
    
    return self;
}
@end
