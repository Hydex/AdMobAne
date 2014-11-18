//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

package com.codealchemy.ane.admobane;

import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import com.codealchemy.ane.admobane.functions.*;
import com.google.android.gms.ads.AdRequest;
import android.app.Activity;
import android.util.Log;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;
import android.widget.FrameLayout.LayoutParams;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;

public class ExtensionContext extends FREContext {
	private static final String TAG		= "[AdMobAne_JAVA]";
	private static final String CLASS	= "ExtensionContext - ";
	private Boolean mProdMode			= false;
	private Boolean mVerbose			= false;
	private RelativeLayout mAdLayout;
	private AdMobInterstitial mInterstitialAd;
	private Map<String, AdMobBanner> mBannersMap;
	private String mTestDeviceID		= "*";
	private int mGender					= 0;
	private int mBirthYear				= 0;
	private int mBirthMonth				= 0;
	private int mBirthDay				= 0;
	private Boolean mIsCDT				= false;
	public Boolean getProdMode() { return mProdMode; }
	public void setProdMode(Boolean prodMode) {
		mProdMode = prodMode;
		log(CLASS+"setProdMode: " +prodMode.toString());
	}
	public void setVerbose(Boolean verbose) {
		mVerbose = verbose;
		log(CLASS+"setVerbose: " +verbose.toString());
	}
	public void setTestDeiceID(String id) {
		mTestDeviceID = id;
		log(CLASS+"setTestDeiceID: " +id);
	}
	public void setBirthDay(int day) {
		mBirthDay = day;
		log(CLASS+"setBirthDay: " +day);
	}
	
	public void setIsCDT(Boolean cdt) {
		mIsCDT = cdt;
		log(CLASS+"setIsCDT: " +cdt);
	}
	public ExtensionContext() {
		log(CLASS+"Constructor");
		mProdMode = false;
		mBannersMap = new HashMap<String, AdMobBanner>();
	}
	public void buildLayout(Activity act) {
		log(CLASS+"buildLayout");
    	mAdLayout = new RelativeLayout(act);
    	ViewGroup fl = (ViewGroup)act.findViewById(android.R.id.content);
		fl = (ViewGroup)fl.getChildAt(0);
    }
    
	@Override
	public Map<String, FREFunction> getFunctions() {
		log(CLASS+"getFunctions");
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put(ExtensionFunctions.BANNER_CREATE,			new CreateBanner());
		functionMap.put(ExtensionFunctions.BANNER_CREATE_ABSOLUTE,	new CreateBannerAbsolute());
		functionMap.put(ExtensionFunctions.BANNER_SHOW,				new ShowBanner());
		functionMap.put(ExtensionFunctions.BANNER_HIDE,				new HideBanner());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_CREATE,		new CreateInterstitial());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_REMOVE,		new RemoveInterstitial());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_SHOW,		new ShowInterstitial());
		functionMap.put(ExtensionFunctions.INTERSTITIAL_CACHE,		new CacheInterstitial());
		functionMap.put(ExtensionFunctions.SET_MODE,				new SetMode());
		functionMap.put(ExtensionFunctions.SET_TEST_DEVICE_ID,		new SetTestDeviceID());
		functionMap.put(ExtensionFunctions.SET_VERBOSE,				new SetVerbose());
		functionMap.put(ExtensionFunctions.SET_GENDER,				new SetGender());
		functionMap.put(ExtensionFunctions.SET_BIRTHYEAR,			new SetBirthYear());
		functionMap.put(ExtensionFunctions.SET_BIRTHMONTH,			new SetBirthMonth());
		functionMap.put(ExtensionFunctions.SET_BIRTHDAY,			new SetBirthDay());
		functionMap.put(ExtensionFunctions.SET_CDT,					new SetCDT());
	    return functionMap;
	}
	public AdRequest getRequest() {
    	log("getRequest");
    	log("Request Building...");
		AdRequest.Builder requestBld = new AdRequest.Builder();
    	if (mGender>0){
    		String target = "Male";
    		if (mGender == 2) target = "Female";
        	log("Adding Gender Targeting!, Target: " + target);
    		requestBld.setGender(mGender);
    	}
    	if(mBirthYear>0){
    		int year = mBirthYear;
    		int month = 1;
    		int day = 1;
    		if(mBirthMonth>0) month = mBirthMonth;
    		if(mBirthDay>0) day = mBirthDay;
        	log("Adding Birth Date Targeting!, Birth Date = Year: " + year + " month: "+month+" day: "+day);
    		requestBld.setBirthday(new GregorianCalendar(year, month, day).getTime());
    	}
    	if(mIsCDT){
        	log("Adding Tag For Child Directed Treatment Targeting!");
    		requestBld.tagForChildDirectedTreatment(mIsCDT);
    	}
    	if (!mProdMode){
        	log("Setting the request as Test mode!");
    		requestBld.addTestDevice(AdRequest.DEVICE_ID_EMULATOR);
    		requestBld.addTestDevice(mTestDeviceID);
    	}
		AdRequest request = requestBld.build();
		return request;
	}
	@Override
	public void dispose() {
		log(CLASS+"dispose");
		for (String bannerId : mBannersMap.keySet()) {
			removeBanner(bannerId);
		}
		mBannersMap = null;
	}
	public void createBanner(Activity act,String bannerId,String adMobId,int adSize,int posType,int position) {
		log(CLASS+"createBanner");
		if(mAdLayout == null) buildLayout(act);
		mBannersMap.put(bannerId, new AdMobBanner(
				this, act, mAdLayout, bannerId, adMobId, adSize, posType, position, 0));
		mBannersMap.get(bannerId).create();
	}
	public void createBannerAbsolute(Activity act,String bannerId,String adMobId,int adSize,int posType,int positionX, int positionY) {
		log(CLASS+"createBannerAbsolute");
		if(mAdLayout == null) buildLayout(act);
		mBannersMap.put(bannerId, new AdMobBanner(
				this, act, mAdLayout, bannerId, adMobId, adSize, posType, positionX, positionY));
		mBannersMap.get(bannerId).create();
	}
	public void removeBanner(String bannerId) {
		log(CLASS+"removeBanner");
		mBannersMap.get(bannerId).remove();
		mBannersMap.remove(bannerId);
	}
	public void showBanner(String bannerId) {
		log(CLASS+"showBanner");
		mBannersMap.get(bannerId).show();
	}
	public void hideBanner(String bannerId) {
		log(CLASS+"hideBanner");
		mBannersMap.get(bannerId).hide();
	}
	public void createInterstitial(Activity act,String interstitialId) {
		mInterstitialAd =  new AdMobInterstitial(this, act, interstitialId);
	}
	public void cacheInterstitial() {
		log(CLASS+"cacheInterstitial");
		mInterstitialAd.cache();
	}
	public void removeInterstitial() {
		log(CLASS+"removeBanner");
		mInterstitialAd.remove();
		mInterstitialAd = null;
	}
	public Boolean isInterstitialLoaded() {
		log(CLASS+"isInterstitialLoaded");
		return mInterstitialAd.isLoaded();
	}
	public void showInterstitial() {
		log(CLASS+"showInterstitial");
		mInterstitialAd.show();
	}
	public void log(String msg) {
		if(mVerbose) Log.d(TAG,msg);
	}
}
