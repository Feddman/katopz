package com.sleepydesign.utils{	import flash.display.*;	import flash.events.*;	import flash.text.TextField;	import flash.text.TextFormat;	public class DebugUtil 	{		private static var _enable:Boolean = true;		public static var label:TextField;				public static function get enable() : Boolean		{			return _enable;		}				public static function set enable(value:Boolean) : void		{			_enable = value;			label.visible = value;		}				public static function clear() : void		{			label.text = "";		}		public static function trace(value:*) : void		{			if(_enable)				doTrace(value);		}				public static function addText(value:String) : void		{			if(_enable)				label.appendText(value+"\n");		}		 		public static function init(container:DisplayObjectContainer, x:Number, y:Number) : void 		{			if(!label)			{				label = new TextField();				label.autoSize = "left"				label.cacheAsBitmap = true;				label.multiline = true;				label.defaultTextFormat = new TextFormat("Tahoma", 12, 0xFFFFFF);				label.background = true;				label.backgroundColor = 0x111111;				label.selectable = true;				label.mouseWheelEnabled = true;				label.mouseEnabled = true;				//label.blendMode = BlendMode.MULTIPLY;								label.x = x;				label.y = y;								container.addChild(label);			}		}	}}function doTrace(value:*):void{    trace(value);}