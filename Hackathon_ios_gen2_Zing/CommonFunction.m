//
//  CommonFunction.m
//  Hackathon_ios_gen2_Zing
//
//  Created by Lê Tuấn Anh on 3/31/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "CommonFunction.h"
#import <AVFoundation/AVFoundation.h>
#import "XMLDictionary.h"
@implementation CommonFunction
{
NSOperationQueue *queueHTMLParse ;
}

+ (id)sharedManager {
    static CommonFunction *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

- (int) convertTitletoTypewithTitle:(NSString*)nameType;
{
    if ([nameType isEqualToString:@"Bài Hát"]){
        return 0;
    }
    else if ([nameType isEqualToString:@"Album"]){
        return 1;
        
    }else if([nameType isEqualToString:@"MV"]){
        return 2;
    }
    return 0;
}

- (NSString*)convertToMobilewithLink:(NSString*)link;
{
    [link stringByReplacingOccurrencesOfString:@"mp3.zing.vn" withString:@"m.mp3.zing.vn"];
    return link;
}

- (void) getStringwithURL:(NSString*)url withCompletionBlock:(void(^)(NSString*result) )completion;
{
    url = [url stringByReplacingOccurrencesOfString:@"http://mp3.zing.vn" withString:@"http://m.mp3.zing.vn"];
    NSOperationQueue *queueHTMLParse = [[NSOperationQueue alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
   // NSLog(@"Link %@", url);
    
    AFHTTPRequestOperation *opretation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [opretation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         TFHpple *document= [[TFHpple alloc]initWithHTMLData:responseObject];
         NSArray *arr = [document searchWithXPathQuery:@"//*[@id='mp3Player']"] ;
         if (arr.count == 0) return;
         TFHppleElement *element = [arr objectAtIndex:0];
         NSString *jsonArray = [element objectForKey:@"xml"];
         NSURL *url = [[NSURL alloc]initWithString:jsonArray];
         [self exploreTracksWithGenre:jsonArray completionBlock:^(NSArray *tracks) {
             int c = 0;
             //xu li du lieu sau khi lay thanh cong
             for (NSDictionary *jsonDict in tracks) {
                 //    return (jsonDict[@"source"]);
                 _tmpURL = [[NSString alloc]init];
                 _tmpURL= jsonDict[@"source"];
                 completion(_tmpURL);
                 return;
             }
         }];
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Couldn't download data because : %@",error);
        
    }];
    [queueHTMLParse addOperation:opretation];
    
}

- (void) getDurationWithURL:(NSString*)url withCompletionBlock:(void(^)(NSDictionary *result) )completion;
{
   // url = [url stringByReplacingOccurrencesOfString:@"http://mp3.zing.vn" withString:@"http://m.mp3.zing.vn"];
    ////*[@id="html5player"]/div[1]/div[1]
    queueHTMLParse = [[NSOperationQueue alloc]init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    // NSLog(@"Link %@", url);
    
    AFHTTPRequestOperation *opretation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [opretation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         TFHpple *document= [[TFHpple alloc]initWithHTMLData:responseObject];
         NSArray *arr = [document searchWithXPathQuery:@"//*[@id='html5player']"];
        if (arr.count == 0) return ;
         TFHppleElement *element = [arr objectAtIndex:0];
         
         NSString *xmlUrl = [[element attributes]objectForKey:@"data-xml"];
         NSURL *urllink = [[NSURL alloc]initWithString:xmlUrl];
         NSXMLParser *xmlParse = [[NSXMLParser alloc]initWithContentsOfURL:urllink];
         
         NSDictionary *dict = [[XMLDictionaryParser alloc]dictionaryWithParser:xmlParse];
         if (dict){
             if ([dict objectForKey:@"item"]){
                 if ([[dict objectForKey:@"item"] objectForKey:@"duration"]){
                     completion([[dict objectForKey:@"item"] objectForKey:@"duration"]);
                 }
                 
             }
         }                           
         return;
     }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Couldn't download data because : %@",error);
        
    }];
    [queueHTMLParse addOperation:opretation];
}

- (void) getDuration:(NSString*)url withCompletionBlock:(void(^)(NSString*result) )completion;
{
    // Download the data.
    
    
}

- (void)exploreTracksWithGenre:(NSString *)url completionBlock:(void(^)(NSArray *tracks))completion;
{
    
       //tao session
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:configuration];
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
   // NSString *urlString = [NSString stringWithFormat:kSoundCloudExploreURL,code] ;
    NSString *urlString = url;
    
    NSURLSessionDataTask *dataTask = [httpSessionManager GET:urlString
                                                  parameters:nil
                                                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                         if (completion && responseObject) {
                                                             completion(responseObject[@"data"]);
                                                         }
                                                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                         if (error) {
                                                             NSLog(@"%@",error);
                                                         }
                                                     }];
    [dataTask resume];

}
- (NSString*)getStringWithStreamingURL:(NSURL *)streamingURL;
{
    NSURL *url = [[NSURL alloc]initWithString:streamingURL];
    AVPlayerItem *currentPlayingItem = [[AVPlayerItem alloc]initWithURL:url];
    CMTime duration = currentPlayingItem.asset.duration;
    CGFloat time = CMTimeGetSeconds(duration);
    NSInteger hours = time / 3600;
    NSInteger second = (NSInteger)time % 60;
    NSInteger minutes = (time - hours * 3600 - time) / 60;
    
    NSString *finalString = nil;
    if (hours > 0) {
        finalString = [NSString stringWithFormat:@"%ld:%02ld:%02ld", hours, minutes, (long)second];
    } else {
        finalString = [NSString stringWithFormat:@"%ld:%02ld", minutes, (long)second];
    }
    return finalString;
    //NSLog(@"duration: %.2f", seconds);
}

- (NSString*)formatStringWithDuration:(NSString*)duration;
{
    NSInteger du = [duration integerValue];
    NSInteger hour = du /3600;
    NSInteger minutes  = ((du - hour*60) / 60) % 60;
    NSInteger second = (du - hour*3600 - minutes * 60 ) ;
    if (hour > 0)
    {
        return ([NSString stringWithFormat:@"%ld:%02ld:%02ld", hour, minutes, second]);
    }
    else
    {
        return ([NSString stringWithFormat:@"%ld:%02ld", minutes, second]);
    }
}
@end
