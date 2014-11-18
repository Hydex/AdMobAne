//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

package com.codealchemy.ane.admobane.functions;

import com.codealchemy.ane.admobane.ExtensionContext;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

public class HideBanner implements FREFunction {
	private static final String CLASS = "HideBanner - ";

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			cnt.hideBanner(bannerId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}