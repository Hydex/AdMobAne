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
public class ShowBanner implements FREFunction {
	private static final String CLASS = "ShowBanner - ";
	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			context.showBanner();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}