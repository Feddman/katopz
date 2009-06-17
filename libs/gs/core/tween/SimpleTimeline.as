/**
 * VERSION: 0.61
 * DATE: 5/7/2009
 * ACTIONSCRIPT VERSION: 3.0 (AS2 version is also available)
 * UPDATES & MORE DETAILED DOCUMENTATION AT: http://www.TweenLite.com
 **/
package gs.core.tween {
/**
 * SimpleTimeline is the base class for the TimelineLite and TimelineMax classes. It provides the
 * most basic timeline functionality and is used for the root timelines in TweenLite. It is meant
 * to be very fast and lightweight. <br /><br />
 * 
 * <b>Copyright 2009, GreenSock. All rights reserved.</b> This work is subject to the terms in <a href="http://www.greensock.com/terms_of_use.html">http://www.greensock.com/terms_of_use.html</a> or for corporate Club GreenSock members, the software agreement that was issued with the corporate membership.
 * 
 * @author Jack Doyle, jack@greensock.com
 */	
	public class SimpleTimeline extends Tweenable {
		/** @private **/
		protected var _firstChild:Tweenable;
		/** @private **/
		protected var _lastChild:Tweenable;
		/**If a timeline's autoRemoveChildren is true, its children will be removed and made eligible for garbage collection as soon as they complete. This is the default behavior for the main/root timeline. **/
		public var autoRemoveChildren:Boolean; 
		
		public function SimpleTimeline($vars:Object=null) {
			super(0, $vars);
		}
		
		/** @private **/
		public function addChild($node:Tweenable):void {
			if ($node.timeline != null && !$node.gc) {
				$node.timeline.remove($node, true); //removes from existing timeline so that it can be properly added to this one.
			}
			$node.timeline = this;
			if ($node.gc) {
				$node.setEnabled(true, true);
			}
			if (_firstChild != null) {
				_firstChild.prevNode = $node;
				$node.nextNode = _firstChild;
			} else {
				$node.nextNode = null;
			}
			_firstChild = $node;
			$node.prevNode = null;
		}
		
		/** @private **/
		public function remove($node:Tweenable, $skipDisable:Boolean=false):void {
			if (!$node.gc && !$skipDisable) {
				$node.setEnabled(false, true);
			}
			if ($node.nextNode != null) {
				$node.nextNode.prevNode = $node.prevNode;
			} else if (_lastChild == $node) {
				_lastChild = $node.prevNode;
			}
			if ($node.prevNode != null) {
				$node.prevNode.nextNode = $node.nextNode;
			} else if (_firstChild == $node) {
				_firstChild = $node.nextNode;
			}
		}
		
		/** @private **/
		override public function renderTime($time:Number, $force:Boolean=false):void {
			this.cachedTotalTime = this.cachedTime = $time;
			var tween:Tweenable = _firstChild, dur:Number;
			while (tween != null) {
				if (tween.active || ($time >= tween.startTime && !tween.cachedPaused)) {
					if (!tween.cachedReversed) {
						tween.renderTime(($time - tween.startTime) * tween.cachedTimeScale);
					} else {
						dur = (tween.cacheIsDirty) ? tween.totalDuration : tween.cachedTotalDuration;
						tween.renderTime(dur - (($time - tween.startTime) * tween.cachedTimeScale));
					}
				}
				tween = tween.nextNode;
			}
		}
		
	}
}