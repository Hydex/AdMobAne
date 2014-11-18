package utils
{
	// Flash Includes
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/** 
	 * SoundManager Class<br/>
	 * The class will construct and manage the Sound Manager
	 * 
	 * @author Code Alchemy
	 **/
	public class SoundManager
	{
		// Tag Constant for log
		static private const LOG_TAG:String ='[SoundManager] ';
		
		// Manager Proprierties
		static private var mBgm:mSoundManager;
		static private var mSe:mSoundManager;
		
		/** 
		 * Background Music Manager Instance
		 **/
		static public function get bgm():mSoundManager
		{
			// Create a new sound manager if not already available
			if (!mBgm) mBgm = new mSoundManager(Root.config.bgmEnable,Root.config.bgmVolume, int.MAX_VALUE);
			// Return the sound manager
			return mBgm;
		}
		
		/** 
		 * Sound Effects Manager Instance
		 **/
		static public function get se():mSoundManager
		{
			// Create a new sound manager if not already available
			if (!mSe) mSe = new mSoundManager(Root.config.seEnable,Root.config.seVolume, 0, 50);
			// Return the sound manager
			return mSe;
		}
	}
}

/** 
 * mSoundManager Class<br/>
 * The class will construct and manage the Sound Manager Instance
 * 
 * @author Code Alchemy
 **/
internal class mSoundManager
{
	// Flash Includes
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.media.AudioPlaybackMode;
	
	// Tag Constant for log
	private const LOG_TAG:String ='[SoundManager.mSoundManager] ';
	
	// Sound loop gap constants
	private const LOOP_GAP:uint = 80;
	
	// Sound Manager proprierties
	private var mChannels:Vector.<SoundChannel> = new Vector.<SoundChannel>();
	private var mVolume:uint = 100;
	private var mEnable:Boolean = true;
	private var mLoops:uint;
	private var mMaxSize:uint;
	
	/** 
	 * Volume Amount
	 **/
	public function set volume(volume:Number):void
	{
		// Update the volume value
		mVolume = volume;
		updateVolume();
	}
	
	/** 
	 * Enable state
	 **/
	public function set enable(enable:Boolean):void
	{
		// Update the enable state
		mEnable = enable;
		updateVolume();
	}
	
	/** 
	 * mSoundManager Constructor 
	 *  
	 * @param loops Number of time in which the sound should be looped
	 * @param maxSize Maximum number of chanels
	 **/
	public function mSoundManager(enable:Boolean, volume:Number, loops:int, maxSize:int = 1)
	{
		// Update Proprierties
		mEnable		= enable;
		mVolume		= volume;
		mLoops		= loops;
		mMaxSize	= maxSize;
		// Set the playback type mode
		SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
	}
	
	/** 
	 * Start a new sound 
	 *  
	 * @param name Name of sound to be started
	 * @param position Starting sound position. Otional, default = 0
	 * 
	 * @return Sound chanel played
	 **/
	public function start(name:String, position:uint = 0):SoundChannel
	{
		// Create the new sound
		var sound:Sound = Root.assets.getSound(name);
		
		// Do not process if the sound is not available
		if (!sound)
		{
			Root.log(LOG_TAG,"Sound not found", name);
			return null;
		}
		
		// If we have a loop add the silent gap ofset to the position
		if(mLoops>0) position += LOOP_GAP;
		
		// Create the new sound channel
		var channel:SoundChannel = Root.assets.playSound(name, position, mLoops, updateVolume());
		// Root.log(LOG_TAG,"channels length", _channels.length);

		// Check if we have already to many sound playeing
		if (mChannels.length >= mMaxSize)
		{
			// If so, remove the first sound
			var removeChannel:SoundChannel = mChannels.shift();
			if (removeChannel) removeChannel.stop();
			removeChannel = null;
		}
		
		// Add the new channel to the vector
		mChannels.push(channel);
		
		// Return the new channel
		return channel;
	}
	
	/** 
	 * Stop all sounds in the Manager 
	 *  
	 **/
	public function stop():void
	{
		// Check and stop each channel in the vector
		for each (var channel:SoundChannel in mChannels)
			if (channel) channel.stop();
	}
	
	/** 
	 * Update the volume for all channel in the Manager 
	 *  
	 * @return Adjusted Volume Transform Object
	 **/
	public function updateVolume():SoundTransform
	{
		// Create a new sound transformation
		var volumeAdjust:SoundTransform = new SoundTransform();
		// Adjust the current volume
		volumeAdjust.volume = mEnable ? mVolume / 100 : 0;
		
		// Check and update each channel in the vector
		for each (var channel:SoundChannel in mChannels)
			if (channel) channel.soundTransform = volumeAdjust;
		
		// Return the Adjusted Volume
		return volumeAdjust;
	}
}
