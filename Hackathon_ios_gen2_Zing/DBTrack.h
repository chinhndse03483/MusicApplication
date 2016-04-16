//
//  DBTrack.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Admin on 4/8/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Track.h"

NS_ASSUME_NONNULL_BEGIN
@class Track;
@interface DBTrack : NSManagedObject

+ (DBTrack *)createDBTrackFromTrack:(Track *)track;
+ (DBTrack *)findFirstWithLinkStreaming:(NSString *)linkStreaming;
@end



NS_ASSUME_NONNULL_END

#import "DBTrack+CoreDataProperties.h"
