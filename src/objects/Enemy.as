package objects
{
	import com.yyztom.pathfinding.astar.AStarNodeVO;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	
	// ABSTRACT CLASS (not natively supported by AS3)
	public class Enemy extends starling.display.Sprite
	{
		// Velocity of the enemy when he moves
		protected var velocity:Number = 48;
		// Result of an A* search. It's stored in an instance variable because it's used in a callback.
		protected var resultAStar:Vector.<AStarNodeVO>;
		// Current index in the result of an A* search. It's stored in an instance variable because it's used in a callback.
		protected var resultAStarIndex:int;

		public function Enemy()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createEnemyArt();
		}
		
		private function createEnemyArt():void
		{
			// Draw a white circle in a Flash Sprite
			var box:flash.display.Sprite = new flash.display.Sprite();
			box.graphics.beginFill(this.enemyColor(), 1);
			box.graphics.drawCircle(4,4,4);
			box.graphics.endFill();
			
			// Convert to a Flash BitmapData
			var bitmapData:flash.display.BitmapData = new flash.display.BitmapData(8, 8, true, this.enemyColor());
			bitmapData.draw(box);
			
			// Create a Starling texture and image from the BitmapData
			var texture:Texture = Texture.fromBitmapData(bitmapData, false, false);
			var enemytArt:Image = new Image(texture);
			this.addChild(enemytArt);
		}
		
		protected function enemyColor():uint
		{
			return Color.RED;
		}

		// We use the onComplete callback of the Tween class to generate
		// an animations with consecutive moves. This method is called each
		// time a move is completed.
		protected function animateFromAStar():void
		{
			// The player arrived at destination
			if(resultAStarIndex >= resultAStar.length)
				return;
			
			// Get the next target node 
			var node:AStarNodeVO = resultAStar[resultAStarIndex]
			resultAStarIndex += 1;
			// Translate the node position to the levelArt position
			var nodeX:int = node.position.x * 10;
			var nodeY:int = node.position.y * 10;
			
			// Compute the distance between the current position and the target position
			var distance:Number = Point.distance(new Point(nodeX, nodeY), new Point(this.x, this.y));
			// Compute the movement duration
			var duration:Number = distance / velocity;
			
			// http://wiki.starling-framework.org/manual/animation#tween
			var tween:Tween = new Tween(this, duration, Transitions.LINEAR);
			tween.moveTo(nodeX, nodeY);
			tween.onComplete = animateFromAStar;
			Starling.juggler.add(tween);
		}
}
}