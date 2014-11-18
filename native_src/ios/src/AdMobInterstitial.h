//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobInterstitial.h
//  AdMobAne
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"
#import "FlashRuntimeExtensions.h"

@interface AdMobInterstitial : UIViewController <GADInterstitialDelegate> {
    GADInterstitial *mInterstitialView;
}
- (void) create;
- (void) remove;
- (void) cache;
- (BOOL) isInterstitialLoaded;
- (void) show;
