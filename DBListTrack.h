//
//  DBListTrack.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/12/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Track.h"
#import "DBTrack.h"

@class DBListTrack;
NS_ASSUME_NONNULL_BEGIN

@interface DBListTrack : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
+ (void)createDBListTrackFromTrack:(Track *)track;
//+ (DBListTrack *)findFirstListTrackWithLinkStreaming:(NSString *)linkStreaming;
- (void)deleteFavorite;
+ (DBListTrack *)createFavoriteWithTitle:(NSString *)listName;
//+ (void)addTrackToPlaylist:(DBListTrack *)listTrack andDBTrack:(DBTrack *)track;
+ (DBTrack *)addTrackToPlaylist:(DBListTrack *)playlist andDBTrack:(DBTrack *)dbTrack;
@end

NS_ASSUME_NONNULL_END

#import "DBListTrack+CoreDataProperties.h"
