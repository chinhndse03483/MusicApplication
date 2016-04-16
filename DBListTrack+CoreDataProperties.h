//
//  DBListTrack+CoreDataProperties.h
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/15/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBListTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBListTrack (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *listCount;
@property (nullable, nonatomic, retain) NSNumber *listID;
@property (nullable, nonatomic, retain) NSString *listName;

@end

NS_ASSUME_NONNULL_END
