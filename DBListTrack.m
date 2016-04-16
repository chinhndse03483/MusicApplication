//
//  DBListTrack.m
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/12/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "DBListTrack.h"
#import <MagicalRecord/MagicalRecord.h>
@implementation DBListTrack

// Insert code here to add functionality to your managed object subclass
+ (DBListTrack *)createFavoriteWithTitle:(NSString *)listName;
{
    DBListTrack *newPlaylist = nil;
    
    if (listName.length > 0) {
        newPlaylist = [DBListTrack MR_createEntity];
        newPlaylist.listName = listName;
        newPlaylist.listID = [DBListTrack getNextIndex];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError* error) {
        
    }];
    
    return newPlaylist;
}
+ (NSNumber *)getNextIndex;
{
    DBListTrack *playlistWithHighestIndex = [DBListTrack MR_findFirstOrderedByAttribute:@"listID" ascending:NO];
    return [NSNumber numberWithInt:[playlistWithHighestIndex.listID intValue] + 1];
}
+ (DBListTrack *)findFirstWithLinkStreaming:(NSString *)linkStreaming; {
    DBListTrack *track = [DBListTrack MR_findFirstByAttribute:@"streamUrl" withValue:[NSString stringWithFormat:@"%@",linkStreaming]];
    return track;
}
- (void)deleteFavorite;
{
    //        DBListTrack *listTrack = [DBListTrack MR_findFirstByAttribute:@"listID" withValue:[NSString stringWithFormat:@"%@",self.listID]];
    [self deleteAllTracksInFavorite:self.listID];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError* error) {
        if (contextDidSave) {
            NSLog(@"Data in default context SAVED");
        }
        if (error) {
            NSLog(@"Data in default context ERROR %@", error);
        }
    }];
    
    [self MR_deleteEntity];
}

//+(void)addTrackToPlaylist:(DBListTrack *)listTrack andDBTrack:(DBTrack *)dbTrack;
//{
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listID = %@ AND streamUrl = %@",listTrack.listID,dbTrack.streamUrl];
//    if ([DBTrack MR_findFirstWithPredicate:predicate]) {
//        dbTrack = [DBTrack MR_findFirstWithPredicate:predicate];
//        dbTrack.createdAt = [NSDate new];
//        
//    } else {
//        dbTrack.listID = listTrack.listID;
//    }
//    //            if ([Playlist MR_countOfEntities] != 0) {
//    //                PlaylistTrack *firstInPlaylist = [PlaylistTrack MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"playlistIndex = %@",playlist.index] sortedBy:@"createdAt" ascending:YES];
//    //                DBTrack *dbTrack = [DBTrack MR_findFirstOrCreateByAttribute:@"dbTrackID" withValue:firstInPlaylist.dbTrackID];
//    //                playlist.artworkURL = dbTrack.artworkURL;
//    //            }
//    //        }
//    //
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError* error) {
//        
//    }];
//    
//}
+ (DBTrack *)addTrackToPlaylist:(DBListTrack *)playlist andDBTrack:(DBTrack *)dbTrack;
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listID = %@ AND streamUrl = %@",playlist.listID,dbTrack.streamUrl];
    DBTrack *newPlaylistTrack = nil;
    if ([DBTrack MR_countOfEntitiesWithPredicate:predicate]) {
        newPlaylistTrack = [DBTrack MR_findFirstWithPredicate:predicate];
        newPlaylistTrack.createdAt = [NSDate date];
    } else {

        dbTrack.listID = playlist.listID;
    }

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError* error) {

    }];

    return newPlaylistTrack;
}
- (void)deleteAllTracksInFavorite:(NSNumber *)listID;
{
    NSArray *playlistTrackToDelete = [DBTrack MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"listID = %@",listID]];
    
    for (DBTrack *track in playlistTrackToDelete) {
        [track MR_deleteEntity];
    }
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError* error) {
        
    }];
}
@end
