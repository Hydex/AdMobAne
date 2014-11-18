//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

package com.codealchemy.ane.admobane;

import android.app.Activity;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.InterstitialAd;

public class AdMobInterstitial {
	private static final String CLASS = "AdMobInterstitial - ";
	public static final String INTER_ID	= "InterstitialAd";
	private ExtensionContext mContext;
	private Activity mActivity;
	private InterstitialAd mInterstitialAd;
    private String mInterstitialId;
	public ExtensionContext getContext() { return mContext; }
	public Activity getActivity() { return mActivity; }
    public AdMobInterstitial(ExtensionContext ctx, Activity act, String interstitialId)
    {
    	mContext		= ctx;
    	mInterstitialId	= interstitialId;
    }
    
	public void create() {
    	mContext.log(CLASS+"create interstitial");
		mInterstitialAd = new InterstitialAd(mActivity);
		mInterstitialAd.setAdUnitId(mInterstitialId);
		AdRequest request = mContext.getRequest();
    	mContext.log(CLASS+"load interstitial Request");
		mInterstitialAd.loadAd(request);
	}
	
	public void remove() {
    	mContext.log(CLASS+"remove");
    	mActivity		= null;
    	mInterstitialId	= null;
	}
	public void cache() {
    	mContext.log(CLASS+"cache interstitial");
    	mContext.log(CLASS+"set interstitial Request");
		AdRequest request = mContext.getRequest();
    	mContext.log(CLASS+"load interstitial Request");
		mInterstitialAd.loadAd(request);
	}
	public Boolean isLoaded() {
    	mContext.log(CLASS+"isLoaded: "+mInterstitialAd.isLoaded());
		return mInterstitialAd.isLoaded();
	}
	public void show() {
    	mContext.log(CLASS+"show");
		mInterstitialAd.show();
	}
}
