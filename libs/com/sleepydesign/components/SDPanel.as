package com.sleepydesign.components
{
	import com.sleepydesign.core.SDSprite;
	import com.sleepydesign.styles.SDStyle;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	public class SDPanel extends SDComponent
	{
		protected var _mask:SDSprite;
		protected var _back:Shape;
		
		public var content:DisplayObject;
		
		public function SDPanel()
		{
			super();
		}
		
		override public function init(raw:Object=null):void
		{
			super.init(raw);
			setSize(100, 100);
		}
		
		override public function create(config:Object=null):void
		{
			_back = new Shape();
			addChild(_back);
			
			_mask = new SDSprite();
			_mask.mouseEnabled = false;
			addChild(_mask);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			content = child;
			content.mask = _mask;
			return super.addChild(content);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(content);
		}

		override public function draw():void
		{
			_back.graphics.clear();
			_back.graphics.lineStyle(SDStyle.BORDER_THICK, SDStyle.BORDER_COLOR, SDStyle.BORDER_ALPHA, true );
			_back.graphics.beginFill(SDStyle.BACKGROUND);
			
			_back.graphics.drawRect(0, 0, _width, _height);
			_back.graphics.endFill();
			
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff00ff);
			_mask.graphics.drawRect(0, 0, _width, _height);
			_mask.graphics.endFill();
			
			super.draw();
		}
		
		public function get maskRectangle():Rectangle
		{
			return _mask.getRect(_mask.parent);
		}
		
		public function get contentRectangle():Rectangle
		{
			return content.getRect(content.parent);
		}
	}
}