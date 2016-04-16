//
//  SuggestCell.h
//  Hackathon_ios_gen2_Zing
//
//  Created by Chinh Nguyen on 4/5/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Suggestion.h"


@interface SuggestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imvKind;

- (void)displaySuggestion:(Suggestion *)suggestion;
@end
