//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobInterstitial.m
//  AdMobAne
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "AdMobAne.h"
#import "AdMobInterstitial.h"
#import "AdMobEvents.h"

@implementation AdMobInterstitial
const NSString *INTER_ID = @"InterstitialAd";
@synthesize context;
@synthesize adMobRequest;
@synthesize adMobId;
- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    mIsInterstitialLoaded = YES;
    FREDispatchStatusEventAsync(self.context, (UTF8String)INTERSTITIAL_LOADED, (uint8_t*)[INTER_ID UTF8String]);
}
- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error;
{
    Log(@"Event didFailToReceiveAdWithError");
    Log([NSString stringWithFormat:@"Error Details: %@",error]);
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_FAILED_TO_LOAD, (uint8_t*)[INTER_ID UTF8String]);
    clearInterstitial();
}

+ (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial;
{
    Log(@"Event interstitialWillPresentScreen");
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_AD_OPENED, (uint8_t*)[INTER_ID UTF8String]);
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial;
{
    Log(@"Event interstitialDidDismissScreen");
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_AD_CLOSED, (uint8_t*)[INTER_ID UTF8String]);
    clearInterstitial();
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)interstitial;
{
    FREDispatchStatusEventAsync(self.context, (uint8_t*)INTERSTITIAL_LEFT_APPLICATION, (uint8_t*)[INTER_ID UTF8String]);
}
- (void) clearInterstitial
{
    Log(@"clearInterstitial");
    self.view = nil;
    mInterstitialView = nil;
    context = NULL;
    adMobRequest = NULL;
    adMobId = NULL;
    clearInterstitialInstance();
}

- (void) buildInterstitial
{
    mInterstitialView = [[GADInterstitial alloc] init];
    mInterstitialView.adUnitID = adMobId;
    mIsInterstitialLoaded = NO;
    Log(@"isLoaded set to: NO");
    [mInterstitialView loadRequest:adMobRequest];
    Log(@"Creation Completed");
}
- (void) create
{
    if(mInterstitialView) return;
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow * win = [delegate window];
}

- (void) remove
{
    Log(@"remove");
    if(mIsInterstitialLoaded)
    {
        [self clearInterstitial];
    }
}
- (BOOL) isInterstitialLoaded
{
    Log(@"isInterstitialLoaded");
}

- (void) show
{
    Log(@"Show Interstitial");
    [mInterstitialView presentFromRootViewController:self];
}
- (void)viewDidLoad
{
    Log(@"interstitial viewDidLoad");
    [self buildInterstitial];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    Log(@"interstitial viewDidUnload");
    mInterstitialView = nil;
    mInterstitialView.delegate = nil;
    context = NULL;
    adMobRequest = NULL;
    adMobId = NULL;
}
