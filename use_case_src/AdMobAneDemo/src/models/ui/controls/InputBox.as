package models.ui.controls
{
	// Feathers Includes
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	
	// Starling Includes
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/** 
	 * Input Box Class<br/>
	 * The class will construct and manage the Input Box<br>
	 * ALLERT: This class work only if the value <code>android:hardwareAccelerated</code> is set to "false".<br>
	 * If it is set to true, andrid will crash when the input box lose focus.<br>
	 * This is pretty bad, iknow. However this is a bug of Feathers wich needs to be address.<br>
	 * In iOS no problems.<br>
	 * TODO: Fix the issue
	 * 
	 * @author Code Alchemy
	 **/
	public class InputBox extends Sprite
	{
		// Tag Constant for log
		private const LOG_TAG:String ='[InputBox] ';
		
		// Button Instance
		private var mInputField:TextInput
		
		/**
		 * Input text value
		 **/
		public function get value():String
		{ return mInputField.text; }
		public function set value(val:String):void
		{ mInputField.text = val; }
		
		/**
		 * Input enable state
		 **/
		public function set enable(val:Boolean):void
		{ mInputField.isEnabled = val; }
		
		/** 
		 * InputBox constructor
		 *   
		 * @param label InputBox Label
		 **/
		public function InputBox(label:String)
		{
			// Debug Logger
			Root.log(LOG_TAG,"Constructor");
			
			// Create the Input Label
			//var inputLabel:TextField = createLabel(Root.getMsg(label));
			var inputLabel:TextField = createLabel(label);
			inputLabel.touchable = false;
			
			// Create the Input Field
			mInputField = createField();
			mInputField.x = inputLabel.width;
			
			// Add the element
			addChild(inputLabel);
			addChild(mInputField);
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
	
		/** 
		 * Create the Imput field Object
		 *   
		 * @return TextInput Object for the field
		 **/
		private function createField():TextInput
		{
			// Create the new TextImput instance
			var inputField:TextInput = new TextInput();
			
			/* THIS IS USED ONLY IF WE NEED THE PROMPT */
			/*
			// Update Feather default text render
			FeathersControl.defaultTextRendererFactory = function():ITextRenderer
			{ return new TextFieldTextRenderer() }
			
			// Create the Text Format to be used for the prompt
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font	= Constants.FONT_NAME;
			txtFormat.size	= Constants.FONT_SIZE_SMALL;
			txtFormat.color	= Constants.COL_WHITE;
			
			// Create the style for the prompt
			inputField.promptFactory = function():ITextRenderer
			{
				var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
				
				// customize properties and styleshere
				textRenderer.textFormat = txtFormat;
				
				return textRenderer;
			}			
			// Set the Prompt proprierty
			inputField.prompt = "Enter value";
			*/
			
			// Set skin elements
			inputField.backgroundFocusedSkin = new Image ( Root.assets.getTexture(Constants.IMG_INPUT_FOC) );
			inputField.backgroundSkin = new Image ( Root.assets.getTexture(Constants.IMG_INPUT_BKG) );
			
			// Set field proprierties
			inputField.displayAsPassword = false;
			inputField.maxChars = 6; // sovalue such as 1000.5 can fit
			inputField.isEditable = true;
			inputField.width = 115/2;
			inputField.height = 35/2;

			// Create the style for text editor
			inputField.textEditorFactory = function():ITextEditor
			{
				var editor:StageTextTextEditor = new StageTextTextEditor();
				editor.fontFamily = Constants.FONT_NAME;
				editor.fontSize = Constants.FONT_SIZE_SMALL;
				editor.color = Constants.COL_FONT_LIGHT;
				return editor;
			}			
			
			// Return the field
			return inputField;
		}
	}
}