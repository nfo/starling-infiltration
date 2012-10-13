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
	
	public class Player extends starling.display.Sprite
	{
		// Velocity of the player when he moves
		private var velocity:Number = 96;
		// Result of an A* search. It's stored in an instance variable because it's used in a callback.
		private var resultAStar:Vector.<AStarNodeVO>;
		// Current index in the result of an A* search. It's stored in an instance variable because it's used in a callback.
		private var resultAStarIndex:int;
		
		public function Player()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createPlayerArt();
		}
		
		// The player sprite is drawn manually thanks to the Sprite Flash API.
		// @see http://forum.starling-framework.org/topic/drawinggraphics-api-work-with-starling 
		private function createPlayerArt():void
		{
			// Draw a white circle in a Flash Sprite
			var box:flash.display.Sprite = new flash.display.Sprite();
			box.graphics.beginFill(0xffffff, 1);
			box.graphics.drawCircle(4,4,4);
			box.graphics.endFill();
			
			// Convert to a Flash BitmapData
			var bitmapData:flash.display.BitmapData = new flash.display.BitmapData(8, 8, true, 0x00000000);
			bitmapData.draw(box);
			
			// Create a Starling texture and image from the BitmapData
			var texture:Texture = Texture.fromBitmapData(bitmapData, false, false);
			var playerArt:Image = new Image(texture);
			// playerArt.x = Math.ceil(-playerArt.width/2);
			// playerArt.y = Math.ceil(-playerArt.height/2);
			this.addChild(playerArt);
		}
		
		public function moveToPoint(level:Level, x:Number, y:Number):void
		{
			// The level map has blocks of 10 pixels 
			var levelCurrentX:int = Math.abs(this.x/10);
			var levelCurrentY:int = Math.abs(this.y/10);
			var levelTargetX:int = Math.abs(x/10);
			var levelTargetY:int = Math.abs(y/10);

			// Do nothing if the target is a wall
			if(level.levelMap[levelTargetX][levelTargetY].isWall)
				return;
			
			// Search the path with A*
			resultAStar = level.astar.search(level.levelMap[levelCurrentX][levelCurrentY], level.levelMap[levelTargetX][levelTargetY]);
			resultAStarIndex = 0;

			// Animate the player
			animateFromAStar();
		}
		
		// We use the onComplete callback of the Tween class to generate
		// an animations with consecutive moves. This method is called each
		// time a move is completed.
		private function animateFromAStar():void
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