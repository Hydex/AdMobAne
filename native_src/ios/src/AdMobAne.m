//
//  AdMob ANE Extension
//  iOS Native Extension
//
//  AdMobAne.m
//  AdMobAneExtension
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import "AdMobAne.h"
#import "AdMobFunctions.h"
#import "AdMobBanner.h"
#import "AdMobInterstitial.h"

FREContext mContext;
BOOL mProdMode;
AdMobInterstitial *mInterstitialAd;
NSMutableDictionary *mBannersMap;
NSString *mTestDeviceID;
uint8_t mGender;
uint16_t mBirthYear;
BOOL mIsCDT;
void addStoredBanner(id object, NSString *bannerId)
{
    Log(@"addStoredBanner");
    [mBannersMap setValue:object forKey:bannerId];
}
id getStoredBanner(NSString *key)
{
    Log(@"getStoredBanner");
    id object = [mBannersMap valueForKey:key];
    Log(@"Got something?");
    if (object) Log(@"has Object!");
    return object;
}
void removeStoredBanner(NSString *bannerId)
{
    Log(@"removeStoredBanner");
    [mBannersMap setValue:nil forKey:bannerId];
}
GADRequest* getRequest()
{
    GADRequest *request = [GADRequest request];
    if (mGender>0){
        Log([NSString stringWithFormat:@"Adding Gender Targeting!, Target: %@", NSStringFromGender(mGender)]);
        if(mGender == 1) request.gender = kGADGenderMale;
        else request.gender = kGADGenderFemale;
    }
    if(mBirthDay>0){
        Log([NSString stringWithFormat:@"Adding Birth Date Targeting!, Birth Date = Year: %u month: %u day: %u", year,month,day]);
        [request setBirthdayWithMonth:month day:day year:year];
    }
    if(mIsCDT){
        [request tagForChildDirectedTreatment:(mIsCDT)];
    }
    return request;
}

void createBanner(FREContext context, NSString *bannerId, NSString *adMobId, GADAdSize adSize, uint32_t posType, uint32_t position)
{
    AdMobBanner *banner = [[AdMobBanner alloc] init];
    banner.context = context;
    banner.adMobRequest = getRequest();
    banner.bannerId = bannerId;
    banner.adMobId = adMobId;
    banner.adMobSize = &adSize;
    banner.positionType = posType;
    banner.relPosition = position;
    addStoredBanner(banner, bannerId);
}
void createBannerAbsolute(FREContext context, NSString *bannerId, NSString *adMobId, GADAdSize adSize, uint32_t posType, uint32_t positionX, uint32_t positionY)
{
    AdMobBanner *banner = [[AdMobBanner alloc] init];
    banner.context = context;
    banner.adMobRequest = getRequest();
    banner.bannerId = bannerId;
    banner.adMobId = adMobId;
    banner.adMobSize = &adSize;
    banner.positionType = posType;
    banner.absPositionX = positionX;
    banner.absPositionY = positionY;
    [banner create];
}
void showBanner(NSString *bannerId)
{
    AdMobBanner *banner = getStoredBanner(bannerId);
    [banner show];
}
void hideBanner(NSString *bannerId)
{
    [banner hide];
}
void removeBanner(NSString *bannerId)
{
    AdMobBanner *banner = getStoredBanner(bannerId);
    [banner remove];
    banner = nil;
    removeStoredBanner(bannerId);
}
void createInterstitial(FREContext context, NSString *interstitialId)
{
    mInterstitialAd = [[AdMobInterstitial alloc] init];
    mInterstitialAd.context = context;
    mInterstitialAd.adMobRequest = getRequest();
    mInterstitialAd.adMobId = interstitialId;
}
void removeInterstitial()
{
    if(mInterstitialAd) {
        if(mInterstitialAd) [mInterstitialAd remove];
    }
}
void clearInterstitialInstance()
{
    if(mInterstitialAd) {
        [mInterstitialAd release];
    }
}

void showInterstitial()
{
    if(mInterstitialAd) {
        [mInterstitialAd show];
    }
}
void cacheInterstitial()
{
    Log(@"Called cacheInterstitial");
    if(mInterstitialAd) {
        Log(@"Chaching...");
        [mInterstitialAd cache];
    }
}
BOOL isInterstitialLoaded()
{
    Log(@"Called isInterstitialLoaded");
    Log([NSString stringWithFormat:@"Response: %@", NSStringFromBOOL(mIsInterstitialLoaded)]);
    return mIsInterstitialLoaded;
}
FREObject FRECreateBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    Log(@"Called FRECreateBanner");
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    uint32_t adMobIdlength = 0;
    const uint8_t *adMobIdVal = NULL;
    NSString *adMobId;
    uint32_t adSizeVal;
    uint32_t posType;
    uint32_t position;
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    FREGetObjectAsUTF8( argv[1], &adMobIdlength, &adMobIdVal );
    adMobId = [NSString stringWithUTF8String: (char*) adMobIdVal];
    FREGetObjectAsUint32(argv[2], &adSizeVal);
    FREGetObjectAsUint32(argv[3], &posType);
    FREGetObjectAsUint32(argv[4], &position);
    
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    Log([NSString stringWithFormat:@"Given AdMob Id: %@",adMobId]);
    Log([NSString stringWithFormat:@"Given AdSize type: %d",adSizeVal]);
    Log([NSString stringWithFormat:@"Given Position Type: %d",posType]);
    Log([NSString stringWithFormat:@"Given Position Anchor type: %d",position]);
    createBanner(ctx, bannerId, adMobId, adSize, posType, position);
    return NULL;
}

FREObject FRECreateBannerAbsolute(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    uint32_t adMobIdlength = 0;
    const uint8_t *adMobIdVal = NULL;
    NSString *adMobId;
    uint32_t adSizeVal;
    uint32_t posType;
    uint32_t positionX;
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    FREGetObjectAsUTF8( argv[1], &adMobIdlength, &adMobIdVal );
    adMobId = [NSString stringWithUTF8String: (char*) adMobIdVal];
    FREGetObjectAsUint32(argv[2], &adSizeVal);
    FREGetObjectAsUint32(argv[3], &posType);
    FREGetObjectAsUint32(argv[4], &positionX);
    FREGetObjectAsUint32(argv[5], &positionY);
    // Return
    return NULL;
}
FREObject FREShowBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    NSString *bannerId;
    FREGetObjectAsUTF8( argv[0], &bannerIdlength, &bannerIdVal );
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    Log([NSString stringWithFormat:@"Given Banner Id: %@",bannerId]);
    showBanner(bannerId);
    return NULL;
}

FREObject FREHideBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    return NULL;
}
FREObject FRERemoveBanner(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t bannerIdlength = 0;
    const uint8_t *bannerIdVal = NULL;
    bannerId = [NSString stringWithUTF8String: (char*) bannerIdVal];
    removeBanner(bannerId);
    return NULL;
}

FREObject FRECreateInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t interstitialIdlength = 0;
    const uint8_t *interstitialIdVal = NULL;
    FREGetObjectAsUTF8( argv[0], &interstitialIdlength, &interstitialIdVal );
    interstitialId = [NSString stringWithUTF8String: (char*) interstitialIdVal];
    createInterstitial(ctx, interstitialId);
    return NULL;
}
FREObject FRERemoveInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    removeInterstitial();
}
FREObject FREShowInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    showInterstitial();
}
FREObject FRECacheInterstitial(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    cacheInterstitial();
}
FREObject FREIsInterstitialLoaded(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t retValue = isInterstitialLoaded();
    FREObject result;
    // Create and Validate the returning result
    if ( FRENewObjectFromBool(retValue, &result ) == FRE_OK )
    {
        return result;
    }
    return result;
}
FREObject FRESetMode(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t isProdMode;
    if( FREGetObjectAsBool(argv[0], &isProdMode) == FRE_OK)
        if (isProdMode) mProdMode = YES;
    mProdMode = NO;
    return NULL;
}
FREObject FRESetVerbose(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t isVerbose;
    return NULL;
}

FREObject FRESetTestDeviceId(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t deviceIdlength = 0;
    const uint8_t *deviceIdVal = NULL;
    FREGetObjectAsUTF8( argv[0], &deviceIdlength, &deviceIdVal );
    mTestDeviceID = [NSString stringWithUTF8String: (char*) deviceIdVal];
    return NULL;
}
FREObject FRESetGender(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t genderVal;
    if( FREGetObjectAsUint32(argv[0], &genderVal) == FRE_OK)
    {
        mGender = genderVal;
    }
    return NULL;
}
FREObject FRESetBirthDay(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t dayVal;
    if( FREGetObjectAsUint32(argv[0], &dayVal) == FRE_OK)
        mBirthDay = dayVal;
    return NULL;
}
FREObject FRESetCDT(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[] )
{
    uint32_t isCDTVal;
    Log([NSString stringWithFormat:@"Is Tag For Child Directed Treatment: %@", NSStringFromBOOL(mIsCDT)]);
    return NULL;
}
void AdMobAneContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    Log(@"Context Initializer - Setting Functions Names");
    *numFunctionsToTest = ctxType;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
	func[0].name = (const uint8_t*) BANNER_CREATE;
    func[0].function = &FRECreateBanner;
    
	func[1].name = (const uint8_t*) BANNER_CREATE_ABSOLUTE;
    func[1].function = &FRECreateBannerAbsolute;
    
	func[2].name = (const uint8_t*) BANNER_SHOW;
    func[2].function = &FREShowBanner;
    
	func[3].name = (const uint8_t*) BANNER_HIDE;
    func[3].function = &FREHideBanner;
    
	func[4].name = (const uint8_t*) BANNER_REMOVE;
    func[4].function = &FRERemoveBanner;
    
	func[5].name = (const uint8_t*) INTERSTITIAL_CREATE;
    func[5].function = &FRECreateInterstitial;
    
	func[6].name = (const uint8_t*) INTERSTITIAL_REMOVE;
    func[6].function = &FRERemoveInterstitial;
    
	func[7].name = (const uint8_t*) INTERSTITIAL_SHOW;
    func[7].function = &FREShowInterstitial;
    
	func[8].name = (const uint8_t*) INTERSTITIAL_CACHE;
    func[8].function = &FRECacheInterstitial;
    
	func[9].name = (const uint8_t*) INTERSTITIAL_IS_LOADED;
    func[9].function = &FREIsInterstitialLoaded;
    mContext = ctx;
    mProdMode = false;
    mVerbose = false;
    mGender = 0;
    mBirthYear = 0;
    mBirthMonth = 0;
    mBirthDay = 0;
    mIsCDT = false;
}
void AdMobAneContextFinalizer(FREContext ctx)
{
    for (NSString *key in mBannersMap) {
        removeBanner(key);
    };
    
    [mBannersMap removeAllObjects];
    [mBannersMap release];
    mBannersMap = NULL;
    mInterstitialAd = NULL;
    return;
}
void AdMobAneExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                            FREContextFinalizer* ctxFinalizerToSet)
{
    Log(@"Extension Initializer");
    *ctxInitializerToSet = &AdMobAneContextInitializer;
    *ctxFinalizerToSet = &AdMobAneContextFinalizer;
}
void AdMobAneExtFinalizer(void* extData)
{
    return;
}
void Log(NSString *msg) {
    NSLog(@"%@ %@",TAG,msg);
}