//
//  DBTrack+CoreDataProperties.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Admin on 4/8/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "DBTrack.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBTrack (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *linkImage;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *duration;
@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *streamUrl;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *author;
@property (nullable, nonatomic, retain) NSNumber *listID;

@end

NS_ASSUME_NONNULL_END