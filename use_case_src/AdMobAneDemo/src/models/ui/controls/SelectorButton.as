package models.ui.controls
{
	// Flash Includes
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	// Starling Includes
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/** 
	 * Selector Button Class<br/>
	 * The class will construct and manage the Selector Button
	 * 
	 * @author Code Alchemy
	 **/
	public class SelectorButton extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[SelectorButton] ';
		
		// State Constants
		private const LEFT_NEXT:uint	= 0;
		private const LEFT:uint			= 1;
		private const CENTER:uint		= 2;
		private const RIGHT:uint		= 3;
		private const RIGHT_NEXT:uint	= 4;
		
		// Selectable Option data
		private var mOptionsKeys:Array		= new Array();
		private var mOptionsLabels:Array	= new Array();
		private var mLeftNextOption:uint	= 0;
		
		// On complete Selection Listener Instance
		private var mListener:Function;

		/** 
		 * Selectable options keys
		 **/
		private function get optionsKeys():Array
		{ return mOptionsKeys; }
		
		/** 
		 * Selectable options localized labels
		 **/
		private function get optionsLabels():Array
		{ return mOptionsLabels; }
		
		/** 
		 * Nex option in the list
		 **/
		private function get leftNextOption():uint
		{ return mLeftNextOption; }
		private function set leftNextOption(val:uint):void
		{ mLeftNextOption = val; }
		
		/** 
		 * On Complete selection listener
		 **/
		private function get onComplete():Function
		{ return mListener; }
		
		
		/** 
		 * SelectorButton constructor
		 *   
		 * @param currOption Currently selected Options
		 * @param selectorOtpions Array of Selectable options<br/>
		 * The selected Options Need to be passed as array of Objects.<br/>
		 * Example:<br/>
		 * <code>[<br/>
		 * {key:"sys", label:"label1"},<br/>
		 * {key:"en", label:"label2"},<br/>
		 * {key:"it", label:"label3"}<br/>
		 * ]</code><br/>
		 * Object keys name must be the same<br/>
		 * @param listener Selector Event Listener Function. Optional, default = null
		 **/
		public function SelectorButton(currOption:String, selectorOtpions:Array,listener:Function=null)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Update Listener Instance
			mListener = listener;
			
			// Register all given options
			for each (var option:Object in selectorOtpions) {
				optionsKeys.push(option.key);
				optionsLabels.push(option.label);
			}
			
			// Update Options scroller indexes
			if (optionsKeys.indexOf(currOption) < CENTER){
				leftNextOption = optionsKeys.length + optionsKeys.indexOf(currOption) - CENTER;
			}else{
				leftNextOption = optionsKeys.indexOf(currOption) - CENTER;
			}
			
			// Create the button
			var selectorSprite:Sprite = createSprite();
			
			// Add the button to the stage
			addChild(selectorSprite);
		}
		
		/** 
		 * Create the Slider Sprite Object
		 *   
		 * @param value Slider Initial value
		 * @param moveListener Slider on moving Event Listener Function. Optional, default = null
		 * @param endListener Button on end move Event Listener Function. Optional, default = null
		 * 
		 * @return Sprite Object of the Slider Sprite
		 **/
		private function createSprite():Sprite
		{
			// Sprite instances
			var optBgSelector:Sprite = new Sprite();
			var optFrSelector:Sprite = new Sprite();
			
			var langBrFrame:Image = new Image(Root.assets.getTexture(Constants.IMG_SEL_BKG));
			optBgSelector.addChild(langBrFrame);
			
			var bgLangs:Vector.<TextField> = new Vector.<TextField>(5);
			var frLangs:Vector.<TextField> = new Vector.<TextField>(5);
			
			for each (var ort:uint in [LEFT_NEXT, LEFT, CENTER, RIGHT, RIGHT_NEXT])
			{
				var langText:String = optionsLabels[(mLeftNextOption + ort) % optionsLabels.length];
				
				bgLangs[ort] = new TextField(langBrFrame.width * .33, langBrFrame.height, langText);
				bgLangs[ort].x = bgLangs[ort].width * (ort - 1);
				bgLangs[ort].fontName = Constants.FONT_NAME;
				bgLangs[ort].fontSize = Constants.FONT_SIZE_SMALL;
				bgLangs[ort].bold = true;
				bgLangs[ort].name = "bgLangs" + ort;
				optBgSelector.addChild(bgLangs[ort]);
				
				frLangs[ort] = new TextField(langBrFrame.width * .33, langBrFrame.height, langText);
				frLangs[ort].x = frLangs[ort].width * (ort - 1);
				frLangs[ort].fontName = Constants.FONT_NAME;
				frLangs[ort].fontSize = Constants.FONT_SIZE_SMALL;
				frLangs[ort].bold = true;
				frLangs[ort].color = 0xffffff;
				frLangs[ort].name = "frLangs" + ort;
				optFrSelector.addChild(frLangs[ort]);
			}
			
			var langFrFrame:Image = new Image(Root.assets.getTexture(Constants.IMG_SEL_FRAME));
			langFrFrame.pivotX = langFrFrame.width * .5;
			langFrFrame.pivotY = langFrFrame.height * .5;
			
			var centerBg:Image = new Image(Root.assets.getTexture(Constants.IMG_SEL_FRAME_BKG));
			centerBg.pivotX = centerBg.width * .5;
			centerBg.pivotY = centerBg.height * .5;
			
			centerBg.x = langFrFrame.x = langBrFrame.width * .5;
			centerBg.y = langFrFrame.y = langBrFrame.height * .5;
			optFrSelector.addChildAt(centerBg, 0);
			optFrSelector.addChild(langFrFrame);
			
			optFrSelector.clipRect = new Rectangle(
				langFrFrame.x - langFrFrame.pivotX, langFrFrame.y - langFrFrame.pivotY, //
				langFrFrame.width, langFrFrame.height);
			
			optBgSelector.clipRect = new Rectangle(
				langBrFrame.x - langBrFrame.pivotX, langFrFrame.y - langFrFrame.pivotY, //
				langBrFrame.width, langFrFrame.height);
			
			optBgSelector.addChild(optFrSelector);
			
			optBgSelector.addEventListener(TouchEvent.TOUCH, function(e:TouchEvent):void
				{
					// Slider Bar Background Global Position
					var globalPoint:Point	= optBgSelector.localToGlobal(new Point(0,0));				
				
					var ended:Touch = e.getTouch(stage, TouchPhase.ENDED);
					if (!ended) return;
				
					var releativeX:Number = ended.globalX - globalPoint.x;

					if (releativeX > optBgSelector.width * .5)
						shiftLangs(bgLangs, frLangs, -1, RIGHT_NEXT);
					else
						shiftLangs(bgLangs, frLangs, 1, LEFT_NEXT);
				}
			);
			
			// Return the created Slider
			return optBgSelector;
		}
		
		/** 
		 * Shift the language<br/>
		 * Will animate the shifting of the languages in the language bar
		 *   
		 * @param bgLangs Bacground languages vector array
		 * @param frLangs Foreground languages vector array
		 * @param direction Direction to animate
		 * @param lastNo Last language number
		 **/
		private function shiftLangs(bgLangs:Vector.<TextField>, frLangs:Vector.<TextField>, direction:Number, lastNo:uint):void
		{
			const ANIMATE_TIME:Number = .4;
			stage.touchable = false;
			
			if (direction < 0)
				leftNextOption = leftNextOption < optionsKeys.length - 1 ? leftNextOption + 1 : 0;
			else
				leftNextOption = leftNextOption > 0 ? leftNextOption - 1 : optionsKeys.length - 1;
			
			var isUpdate:Boolean = false;
			for each (var langs:Vector.<TextField>in[bgLangs, frLangs])
			{
				var lastTw:Tween;
				for each (var ort:uint in[LEFT_NEXT, LEFT, CENTER, RIGHT, RIGHT_NEXT])
				{
					lastTw = new Tween(langs[ort], ANIMATE_TIME);
					lastTw.moveTo(langs[ort].x + langs[ort].width * direction, langs[ort].y);
					Starling.juggler.add(lastTw);
				}
				
				lastTw.onComplete = function(langs:Vector.<TextField>):Function
				{
					return function():void
					{
						if (direction < 0) langs.push(langs.shift());
						else langs.unshift(langs.pop());
						
						langs[lastNo].x = langs[lastNo].width * (lastNo - 1);
						langs[lastNo].text = optionsLabels[(leftNextOption + lastNo) % optionsLabels.length];
						
						if (isUpdate) return;
						
						isUpdate = true;
						
						var selOption:String = optionsKeys[(leftNextOption + CENTER) % optionsKeys.length];
						if (onComplete != null) onComplete(selOption);
						
						stage.touchable = true;
					}
				}(langs);
			}
		}		
	}
}