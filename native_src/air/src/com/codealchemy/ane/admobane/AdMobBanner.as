//
//  AdMobAne ANE Extension
//  Actionscript Interface
//
//  Copyright (c) 2011-2015 Code Alchemy inc. All rights reserved.
//

package com.codealchemy.ane.admobane
{
	public class AdMobBanner
	{
        public static const POS_RELATIVE:int		= 0;
        public static const POS_ABSOLUTE:int		= 1;
        private var mBannerId:String;
        private var mAdSize:int;
        private var mAdPositionType:int;
        private var mAdPosition:int;
        private var mAdPositionCoord:Array;
        private var mAdMobId:String;
        private var mAutoShow:Boolean;
		public function AdMobBanner(_adSize:int,_adPositionType:int,_adPosition:Array,_bannerId:String,_adMobId:String,_autoShow:Boolean)
		{
			mBannerId		= _bannerId;
			mAdSize			= _adSize;
			mAdPositionType	= _adPositionType;
			mAdMobId		= _adMobId;
			mAutoShow		= _autoShow;
		}
	}
}