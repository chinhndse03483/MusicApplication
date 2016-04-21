//
//  DBTrack.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Admin on 4/8/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "DBTrack.h"
#import "Track.h"
#import <MagicalRecord/MagicalRecord.h>

@implementation DBTrack

+ (DBTrack *)createDBTrackFromTrack:(Track *)track;
{
    DBTrack *newDBTrack = nil;
    //    DBTrack *dbTrack = [DBTrack MR_findFirstByAttribute:@"streamUrl" withValue:[NSString stringWithFormat:@"%@",track.linkStreaming]];
    
    if ([DBTrack findFirstWithLinkStreaming:track.linkStreaming]) {
        newDBTrack = [DBTrack MR_findFirstByAttribute:@"streamUrl" withValue:[NSString stringWithFormat:@"%@",track.linkStreaming]];
        newDBTrack.createdAt = [NSDate new];
    } else {
        newDBTrack = [DBTrack MR_createEntity];
        newDBTrack.streamUrl = track.linkStreaming;
        newDBTrack.author = track.author;
        newDBTrack.linkImage = track.linkImage;
        newDBTrack.title = track.title;
        //newDBTrack.duration = track.timeDuration;
        newDBTrack.createdAt = [NSDate new];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
    }];
    return newDBTrack;
}
+ (DBTrack *)findFirstWithLinkStreaming:(NSString *)linkStreaming; {
    DBTrack *track = [DBTrack MR_findFirstByAttribute:@"streamUrl" withValue:[NSString stringWithFormat:@"%@",linkStreaming]];
    return track;
}
@end