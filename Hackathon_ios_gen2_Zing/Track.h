//
//  Track.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/30/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBTrack.h"
@class DBTrack;
@interface Track : NSObject
@property (nonatomic, strong) NSString *artist;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *author;
@property(nonatomic,strong) NSString *linkStreaming;
@property(nonatomic,strong) NSString *link;
@property(nonatomic,strong) NSString *linkImage;
@property(nonatomic,strong) NSString *URLImage;
@property(nonatomic,copy) NSString *trackId;
@property(nonatomic,strong) NSString *linkStreamImage;
@property(assign,nonatomic) NSInteger type;
@property(nonatomic,strong) NSString *timeDuration;


- (instancetype)initWithJson:(NSDictionary *)jsonDict;

-(instancetype)initWithTitle:(NSString*)title
                   andAuthor:(NSString*)author
                     andLink:(NSString*)link
               andLinkImage : (NSString*)linkImage
                     andType: (NSInteger)type;
- (instancetype)initWithDBTrack:(DBTrack *)dbTrack;

@end
