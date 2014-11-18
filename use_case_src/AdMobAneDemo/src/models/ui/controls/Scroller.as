package models.ui.controls
{
	// Feathers Includes
	import feathers.controls.IScrollBar;
	import feathers.controls.List;
	import feathers.controls.ScrollContainer;
	import feathers.controls.SimpleScrollBar;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	// Starling Includes
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	/** 
	 * Scroller Class<br/>
	 * The class will construct and manage the Scroller
	 * 
	 * @author Code Alchemy
	 **/
	public class Scroller extends List
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[Scroller] ';
		
		// Scroll Scene Proprierties
		private var mBackgroundBar:Quad;
		private var mEnableBar:Quad;
		private var mRealHeight:Number;
		private var mCollection:ListCollection;
		
		/** 
		 * Scroll Scene constructor
		 * 
		 * @param items Vectro list of display objects to be included in the Scroll list
		 **/
		public function Scroller(items:Vector.<DisplayObject>)
		{
			// Do not process if there is no items available
			if (!items || items.length < 1) return;
			
			// Create a new collection list
			mCollection = new ListCollection();
			dataProvider = mCollection;
			
			// Create the new scroll layout
			var vLayout:VerticalLayout = new VerticalLayout();
			vLayout.gap = 4;
			vLayout.hasVariableItemDimensions = true;
			layout = vLayout;
			
			// Set the item renderer field
			itemRendererProperties.accessoryField = "item";
			
			mRealHeight = 0;
			// Process each Item in the list
			for each (var item:DisplayObject in items)
			{
				// Add the item to the collection
				mCollection.push({item: item});
				// Update the total height of the container
				mRealHeight += item.height;
			}
			
			// Update the total height of the container
			scrollBarDisplayMode = ScrollContainer.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			verticalScrollBarFactory = verticalScrollBarFactoryFunction(6);
			
			// Add scene event listeners
			addEventListener(Event.REMOVED_FROM_STAGE, clean);
		}
		
		/** 
		 * Clean the scene<br/>
		 * Dispose of all children in the scene
		 * 
		 **/
		public function clean():void
		{
			// Get the last item in the collection
			var pop:Object = mCollection.pop();
			// Process each item in the collection
			while (pop)
			{
				// Dispose the element
				if (pop.item as DisplayObject)
					(pop.item as DisplayObject).removeFromParent(true);
				// Get the last item in the collection
				pop = mCollection.pop();
			}
		}
		
		/** 
		 * Push an item in the container list
		 * Dispose of all children in the scene
		 * 
		 * @param item Item to be added to the collection
		 **/
		public function push(item:Object):void
		{ mCollection.push(item); }
		
		/** 
		 * Scroll Bar Updater
		 * 
		 **/
		public function updateScrollBar():void
		{
			// Do not process if the Bar background is not available
			if (!mBackgroundBar) return;
			
			// Do not process if the Bar is not enable
			if (!mEnableBar) return;
			
			// Update scroll bar size and position
			mBackgroundBar.height = height;
			mEnableBar.height = height * height / mRealHeight;
			mEnableBar.y = 0;
		}
		
		/** 
		 * Create the vertical scroll bar
		 * 
		 * @param width Scroll bar width
		 * 
		 * @return Scroll bar Constructor Function
		 **/
		private function verticalScrollBarFactoryFunction(width:Number):Function
		{
			return function():IScrollBar
			{
				// Create the new scrollbar
				var scrollBar:SimpleScrollBar = new SimpleScrollBar();
				
				// Create the scrollbar Background
				mBackgroundBar = new Quad(width, height, Constants.COL_HIGHLIGHT_RED);
				mBackgroundBar.x = -width;
				mBackgroundBar.alpha = 0.2;
				scrollBar.addChild(mBackgroundBar);

				// Create the scrollbar enable zone
				var enableHeight:Number = height > mRealHeight ? height : height * height / mRealHeight;
				mEnableBar = new Quad(width, enableHeight, Constants.COL_HIGHLIGHT_RED);
				mEnableBar.x = -width;
				scrollBar.addChild(mEnableBar);

				// Set scrollbar update event listener
				scrollBar.addEventListener(Event.CHANGE, function onChange(e:Event):void
				{
					//get current scroll bar value
					var value:Number = scrollBar.value / scrollBar.maximum;
					if (value < 0)
					{
						// Reset bar position to the top
						mEnableBar.y = 0;
						return;
					}
					if (value > 1)
					{
						// Reset bar position to the bottom
						mEnableBar.y = mBackgroundBar.height - mEnableBar.height;
						return;
					}
					// Update bar position to current position
					mEnableBar.y = value * (mBackgroundBar.height - mEnableBar.height);
				}
				);
				// Return the scroll bar
				return scrollBar;
			};
		}
	}
}