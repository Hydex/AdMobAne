//
//  AdMobAne ANE Extension
//  Android Native Extension
//
//  Copyright (c) 2011-2015 Code Alchemy Inc. All rights reserved.
//

package com.codealchemy.ane.admobane;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class Extension implements FREExtension {
	public static FREContext context;
	@Override
	public FREContext createContext(String extId)
	{
		return context;
	}
	@Override
	public void dispose()
	{
		context.dispose();
		context = null;
	}
	@Override
	public void initialize() {}
}
