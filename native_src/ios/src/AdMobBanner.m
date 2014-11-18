//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobBanner.m
//  AdMobAne
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "AdMobAne.h"
#import "AdMobBanner.h"
#import "AdMobEvents.h"

const uint8_t POS_RELATIVE = 0;
const uint8_t POS_ABSOLUTE = 1;
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_LOADED, (uint8_t*)[bannerId UTF8String]);
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error;
{
    Log(@"Event didFailToReceiveAdWithError");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
    Log([NSString stringWithFormat:@"Error Details: %@",error]);
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_FAILED_TO_LOAD, (uint8_t*)[bannerId UTF8String]);
}
- (void)adViewWillPresentScreen:(GADBannerView *)bannerView;
{
    Log(@"Event adViewWillPresentScreen");
    Log([NSString stringWithFormat:@"Banner ID: %@",bannerId]);
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView;
{
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_AD_CLOSED, (uint8_t*)[bannerId UTF8String]);
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView;
{
    FREDispatchStatusEventAsync(self.context, (uint8_t*)BANNER_LEFT_APPLICATION, (uint8_t*)[bannerId UTF8String]);
}
- (CGPoint) getRelativePoint
{
    uint16_t relativeX = 0;
    uint16_t relativeY = 0;
    switch (relPosition)
    {
        case 1:
            relativeX = 0;
            relativeY = 0;
            break;
        default:
            relativeX = 0;
            relativeY = 0;
            break;
    }
    return CGPointMake(relativeX,relativeY);
}
- (CGPoint) getAbsolutePoint
{
    return CGPointMake(absPositionX,absPositionY);
}

- (void) buildBanner
{
    mBannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,0.0,viewFrame.size.width,viewFrame.size.height)];
    mBannerView.adUnitID = adMobId;
    mBannerView.rootViewController = self;
    mBannerView.delegate = self;
}
- (void) create
{
    CGPoint anchorPoint;
    if(positionType == POS_ABSOLUTE){
        anchorPoint = [self getAbsolutePoint];
    }else{
        anchorPoint = [self getRelativePoint];
    }
    CGSize size = CGSizeFromGADAdSize(*(adMobSize));
    viewFrame = CGRectMake(anchorPoint.x,anchorPoint.y,size.width,size.height);
    self.view.frame = viewFrame;
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow * win = [delegate window];
}
- (void) remove
{
    if(mBannerView)
    {
        mBannerView = nil;
        context = NULL;
        adMobRequest = NULL;
        bannerId = NULL;
        adMobId = NULL;
        adMobSize = NULL;
        positionType = 0;
        absPositionX = 0;
        absPositionY = 0;
    }
}

- (void) show
{
    if(mBannerView)
    {
        mBannerView.hidden = NO;
    }
}

- (void) hide
{
    if(mBannerView)
    {
        mBannerView.hidden = YES;
        self.view.userInteractionEnabled = NO;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildBanner];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload
{
    mBannerView.delegate = nil;
    mBannerView = nil;
    context = NULL;
    adMobRequest = NULL;
    bannerId = NULL;
    adMobId = NULL;
    adMobSize = NULL;
    positionType = 0;
    absPositionX = 0;
    absPositionY = 0;
}
- (void)dealloc
{
    mBannerView = nil;
    context = NULL;
    adMobRequest = NULL;
    bannerId = NULL;
    adMobId = NULL;
    adMobSize = NULL;
    positionType = 0;
    absPositionX = 0;
    absPositionY = 0;
}

@end
