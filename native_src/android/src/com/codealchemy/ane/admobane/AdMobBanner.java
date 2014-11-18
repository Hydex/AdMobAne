//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

package com.codealchemy.ane.admobane;

import android.app.Activity;
import android.os.Build;
import android.view.View;
import android.widget.RelativeLayout;
import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdSize;
import com.google.android.gms.ads.AdView;

public class AdMobBanner {
	private static final String CLASS = "AdMobBanner - ";
	private static int POS_ABSOLUTE		= 1;
	private ExtensionContext mContext;
	private Activity mActivity;	
	private RelativeLayout mAdLayout;
	private AdView mAdView;	
    private String mBannerId="";
    private String mAdMobId="";
    private AdSize mAdMobSize;
    private int mAdPositionType=0;
    private int mAdRelPosition=0;
    private int mAdAbsPositionX=0;
    private int mAdAbsPositionY=0;
	
	public ExtensionContext getContext() { return mContext; }
	
	public Activity getActivity() { return mActivity; }
	
	public AdView getAdView() { return mAdView; }

    public AdMobBanner(
    		ExtensionContext ctx, Activity act, RelativeLayout lay, 
    		String bannerId, String adMobId, int adSize, 
    		int posType, int position1, int position2)
    {
    	mContext	= ctx;
    	mActivity	= act;
    	mContext.log(CLASS+"Constructor");
        mAdMobId		= adMobId;
        mAdMobSize		= getAdSize(adSize);
        mAdPositionType	= posType;
        mAdRelPosition	= mAdAbsPositionX = position1;
        mAdAbsPositionY = position2;
    }
    
	public void create() {
    	mContext.log(CLASS+"create adview");
		mAdView = new AdView(mActivity);
		mAdView.setAdUnitId(mAdMobId);
		mAdView.setAdSize(mAdMobSize);
    	if (Build.VERSION.SDK_INT >= 11) {
    		mAdView.setLayerType(View.LAYER_TYPE_HARDWARE, null);
    	}
    	mContext.log(CLASS+"set adview Listeners");
		mAdView.setAdListener(new AdListener() {
            @Override
            public void onAdLoaded() {
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_LOADED, mBannerId);
            }
            @Override
            public void onAdFailedToLoad(int error) {
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_FAILED_TO_LOAD, mBannerId);
            }
            @Override
            public void onAdOpened() {
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_AD_OPENED, mBannerId);
            }
            @Override
            public void onAdClosed() {
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_AD_CLOSED, mBannerId);
            }
            @Override
            public void onAdLeftApplication() {
            	mContext.dispatchStatusEventAsync(ExtensionEvents.BANNER_LEFT_APPLICATION, mBannerId);
            }
        });
		
		mAdView.setVisibility(View.GONE);
    	mContext.log(CLASS+"set adview Layout");
		
		RelativeLayout.LayoutParams layoutParams;
		if(mAdPositionType == POS_ABSOLUTE){
			layoutParams = getAbsoluteParams();
		}else{
			layoutParams = getRelativeParams();
		}
    	mContext.log(CLASS+"set adview Request");
		AdRequest request = mContext.getRequest();
    	mContext.log(CLASS+"load adview Request");
		mAdView.loadAd(request);
	}
	
	public void remove() {
    	mContext.log(CLASS+"remove");
		if(mAdLayout != null)
			mAdLayout.removeView(mAdView);
			mAdView = null;
	}
	
	public void show() {
    	mContext.log(CLASS+"show");
		mAdView.setVisibility(View.VISIBLE);
	}
	
	public void hide() {
    	mContext.log(CLASS+"hide");
		mAdView.setVisibility(View.GONE);
	}

	private RelativeLayout.LayoutParams getAbsoluteParams() {
    	mContext.log(CLASS+"getAbsoluteParams");
		RelativeLayout.LayoutParams params;
		int bannerWidth = mAdMobSize.getWidth();
		int bannerHeight = mAdMobSize.getHeight();
		params = new RelativeLayout.LayoutParams (-2, -2);
		params.leftMargin = mAdAbsPositionX;
		params.topMargin = mAdAbsPositionY;
		
        return params;
	}
	
	private RelativeLayout.LayoutParams getRelativeParams() {
    	mContext.log(CLASS+"getRelativeParams");
        int firstVerb;
        int secondVerb;
        int anchor = RelativeLayout.TRUE;
		RelativeLayout.LayoutParams params;
		
		params = new RelativeLayout.LayoutParams (-2, -2);
        
        switch(mAdRelPosition)
        {
        case 1:veLayout.ALIGN_PARENT_TOP;
        	secondVerb	= RelativeLayout.ALIGN_PARENT_LEFT;
            break;
        default:
        	firstVerb	= RelativeLayout.ALIGN_PARENT_TOP;
        	secondVerb	= RelativeLayout.CENTER_HORIZONTAL;
            break;
        }
    	params.addRule(firstVerb,anchor);
    	params.addRule(secondVerb,anchor);
    	mContext.log(CLASS+"Relative Params = first Verb: "+firstVerb+", second Verb: "+secondVerb+", anchor: "+anchor);
        return params;
	}
	
	private AdSize getAdSize(int idx) {
    	mContext.log(CLASS+"getAdSize, idx: "+idx);
		if(idx == 0)		return AdSize.BANNER;
        else if(idx == 1)	return AdSize.MEDIUM_RECTANGLE;
        else if(idx == 2)	return AdSize.FULL_BANNER;
        else if(idx == 3)	return AdSize.LEADERBOARD;
        else if(idx == 4)	return AdSize.WIDE_SKYSCRAPER;
        else if(idx == 5)	return AdSize.SMART_BANNER;
        else if(idx == 6)	return AdSize.SMART_BANNER;
        else if(idx == 7)	return AdSize.SMART_BANNER;
        return AdSize.BANNER;
	}
}
