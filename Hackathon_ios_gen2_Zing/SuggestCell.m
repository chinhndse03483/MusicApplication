//
//  SuggestCell.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Chinh Nguyen on 4/5/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "SuggestCell.h"
#define MP3SuggestTrackImageName                      @"Track1"
#define MP3SuggestUserImageName                       @"User"
@implementation SuggestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)displaySuggestion:(Suggestion *)suggestion;
{
    _lblTitle.text = suggestion.query;
    
    _imvKind.image = [UIImage imageNamed:MP3SuggestTrackImageName];
    
}

@end
