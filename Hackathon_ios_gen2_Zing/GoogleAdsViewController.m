//
//  GoogleAdsViewController.m
//  Hackathon_ios_gen2_Zing
//
//  Created by IchIT on 4/16/16.
//  Copyright © 2016 Lê Tuấn Anh. All rights reserved.
//

#import "GoogleAdsViewController.h"

@interface GoogleAdsViewController ()

@property(nonatomic, strong) GADInterstitial *interstitial;

@end

@implementation GoogleAdsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
}
@end
