//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobBanner.h
//  AdMobAne
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GADBannerView.h"
#import "FlashRuntimeExtensions.h"

/**
 * AdMob Banner Implementation
 */
@interface AdMobBanner : UIViewController <GADBannerViewDelegate> {
    // Declare banner view instance
    GADBannerView *mBannerView;
}

// AdMob Banner Propriety
@property (nonatomic,assign) FREContext context;
@property (nonatomic,assign) CGRect viewFrame;
@property (nonatomic,assign) GADRequest *adMobRequest;
@property (nonatomic,retain) NSString *bannerId;
@property (nonatomic,retain) NSString *adMobId;
@property (nonatomic,assign) GADAdSize *adMobSize;
@property (nonatomic,assign) uint8_t positionType;
@property (nonatomic,assign) uint8_t relPosition;
@property (nonatomic,assign) uint16_t absPositionX;
@property (nonatomic,assign) uint16_t absPositionY;

// AdMob Banner Expose Methods
- (void) create;
- (void) remove;
- (void) show;
- (void) hide;

@end
