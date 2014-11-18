//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

package com.codealchemy.ane.admobane.functions;

import com.codealchemy.ane.admobane.ExtensionContext;
import android.app.Activity;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class CreateBannerAbsolute implements FREFunction {
	private static final String CLASS = "CreateBannerAbsolute - ";
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			ExtensionContext cnt	= (ExtensionContext) context;
			Activity act			= context.getActivity();
			cnt.createBannerAbsolute(posType,adSize,positionX,positionY,bannerId,act);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}