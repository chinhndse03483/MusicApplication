//
//  MoreViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Nguyễn Đức Chính on 4/16/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "MoreViewController.h"
#define APP_URL_STRING  @"https://itunes.apple.com/us/app/Facebook/id284882215?mt=8"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"More";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor redColor]}];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"icon_rate"];
            cell.textLabel.text = @"Rate App";
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"icon_share"];
            cell.textLabel.text = @"Share App";
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"icon_feedback"];
            cell.textLabel.text = @"Feedback";
            break;
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *shareText = @"http://techkids.edu.vn";
    NSArray *itemToShare = @[shareText];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:itemToShare applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[];
    
    
    //Send email support
    NSString *emailTitle = @"FeedBack";
    // Email Content email
    NSString *messageBody = @"FeedBack";
    // To address email
    NSArray *toRecipents = [NSArray arrayWithObjects:@"ABC@gmail.com",nil];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    switch (indexPath.row) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: APP_URL_STRING]];
            break;
        case 1:
            [self presentViewController:activityVC animated:YES completion:nil];
            break;
        case 2:
            [self presentViewController:mc animated:YES completion:nil];
            break;
        default:
            break;
    }
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end