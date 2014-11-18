package models.ui.controls
{
	// Flash Includes
	import flash.text.TextFormat;
	
	// Feathers Includes
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.FeathersControl;
	import feathers.core.ITextRenderer;
	import feathers.data.ListCollection;
	
	// Starling Includes
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/** 
	 * Combo Box Class<br/>
	 * The class will construct and manage the Combo Box
	 * 
	 * @author Code Alchemy
	 **/
	public class ComboBox extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[ComboBox] ';
		
		// Picker List Instance
		private var mList:PickerList;
		
		/**
		 * Public Picker List instance
		 **/
		public function get pList():PickerList
		{ return mList; }
		
		/**
		 * Combo list Enable State
		 **/
		public function set enable(state:Boolean):void
		{
			mList.isEnabled = state;
			if (mList.isEnabled) mList.alpha = 1;
			else mList.alpha = 0.5;
		}
		
		/**
		 * Combo list Data
		 **/
		public function set data(items:Array):void
		{ mList.dataProvider = new ListCollection(items); }
		
		/**
		 * Combo list Prompt
		 **/
		public function set prompt(value:String):void
		{ mList.prompt = value; }
		
		/** 
		 * Combo Box constructor
		 * TODO: Fix the osition of the pop-up list to be more "comboBox style"
		 *   
		 * @param label Combo Box label
		 * @param items Array of Items to be included in the list
		 **/
		public function ComboBox(label:String,items:Array)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Set button Label
			var sliderLabel:TextField = createLabel(label);
			addChild(sliderLabel);
			
			// Update Feather default text render
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{ return new TextFieldTextRenderer() }

			// Create the Pickerlist
			mList = new PickerList();
			mList.prompt = Root.getMsg(Constants.MSG_COMBO_DEFAULT);
			mList.dataProvider = new ListCollection(items);
			mList.selectedIndex = -1;
			mList.labelField = "label";
			mList.x = 97;
			addChild(mList);
			
			// Create the Text Format to be used
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font	= Constants.FONT_NAME;
			txtFormat.size	= Constants.FONT_SIZE_SMALL;
			txtFormat.color	= Constants.COL_WHITE;
			
			// Create the custom button.
			mList.buttonFactory = function():Button
			{
				var button:Button = new Button();
				button.defaultSkin = new Image ( Root.assets.getTexture(Constants.IMG_COMBOBOX) );
				button.defaultLabelProperties.textFormat = txtFormat;
				button.horizontalAlign = HAlign.LEFT;
				return button;
			};
			
			// Create the custom List.
			mList.listFactory = function():List
			{
				// Cell fixed dimensions
				const cellWidth:uint = 173;
				const cellHeight:uint = 15;
				
				var list:List = new List();
				// Set list dimensions
				list.width	= cellWidth;
				list.height	= cellHeight*5; // 5 rows at maximum
				
				// Create the custom List objects.
				list.itemRendererFactory = function():IListItemRenderer
				{
					var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
					renderer.defaultSkin = new Image( Root.assets.getTexture(Constants.IMG_COMBOFIELD) );
					renderer.defaultLabelProperties.textFormat = txtFormat;
					renderer.horizontalAlign = HAlign.LEFT;
					// Set list dimensions
					renderer.width		= cellWidth;
					renderer.height		= cellHeight;
					renderer.labelField	= "label";
					return renderer;
				};
				return list;
			};
		}
		
		/** 
		 * Create the Label Textfield Object
		 *   
		 * @param text Text to be used for the label
		 * 
		 * @return Textfield Object for the Label
		 **/
		private function createLabel(text:String):TextField
		{
			// Create The Label
			var label:TextField	= new TextField(1, 24, text);
			label.autoSize		= TextFieldAutoSize.HORIZONTAL;
			label.fontName		= Constants.FONT_NAME;
			label.fontSize		= Constants.FONT_SIZE_SMALL;
			label.color			= Constants.COL_FONT_LIGHT;
			label.hAlign		= HAlign.LEFT;
			label.vAlign		= VAlign.TOP;
			label.touchable		= false;
			return label;
		}
	}
}