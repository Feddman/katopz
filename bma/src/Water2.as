﻿/**
* ...
* @author katopz@sleepydesign.com
* @version 0.1
*/

package {

	import flash.geom.*
	import flash.display.*

	public class Water2 extends Sprite{
		
		public function Water2(iRect:Rectangle=null,alpha:Number=0.1,iRotation:Number=180,color:Number=0x6CA8DE){
			
			if (iRect)
			{
				/*
				var fillType:String = GradientType.LINEAR;
				var colors:Array = [0x6CA8DE, 0x6CA8DE];
				var alphas:Array = [0, alpha];
				var ratios:Array = [0xEE, 0xFF];
				var matr:Matrix = new Matrix();
				matr.rotate(iRotation)
				var spreadMethod:String = SpreadMethod.PAD;

				graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
				*/
				graphics.beginFill(color, alpha)
				graphics.drawRect(iRect.x,iRect.y,iRect.width,iRect.height);
				graphics.lineStyle(0.5,0x0000FF,0.5)
				graphics.lineTo(iRect.x,iRect.y)
				graphics.lineTo(iRect.x+iRect.width,iRect.y)
			}
		}
		
	}

}