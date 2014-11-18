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

public class SetTestDeviceID implements FREFunction {
	private static final String CLASS = "SetTestDeviceID - ";

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		try {
			ExtensionContext cnt	= (ExtensionContext) context;
			cnt.log(CLASS+"call");
			String testId 		= args[0].getAsString();
			cnt.setTestDeiceID(testId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}