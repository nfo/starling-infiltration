package objects.enemies
{
	import com.yyztom.pathfinding.astar.AStar;
	
	import objects.Enemy;
	
	import starling.core.Starling;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	// A runner always knows where the player is, and he won't stop
	// following him.
	public class Runner extends Enemy
	{
		private var passedTime:Number = 0;
		private var hitText:TextField; 

		public function Runner()
		{
			super();
		}

		protected override function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			// Show this text when the runner hits the ennemy
			hitText = new TextField(45, 20, "BURN!", "Arial", 12, Color.RED);
			hitText.hAlign = HAlign.RIGHT;  // horizontal alignment
			hitText.vAlign = VAlign.BOTTOM; // vertical alignment
			hitText.border = true;
			hitText.visible = false;
			(Starling.current.root as Game).addChild(hitText);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(event:EnterFrameEvent):void
		{
			// Compute the path to the player every 0.25s
			passedTime += event.passedTime;
			if(passedTime > 0.25) {
				passedTime = 0;
				var game:Game = (Starling.current.root as Game);
				var astar:AStar = game.level.astar;

				// The level map has blocks of 10 pixels 
				var levelCurrentX:int = Math.abs(this.x/10);
				var levelCurrentY:int = Math.abs(this.y/10);
				var levelTargetX:int = Math.abs(game.player.x/10);
				var levelTargetY:int = Math.abs(game.player.y/10);

				if(levelCurrentX == levelTargetX && levelCurrentY == levelTargetY)
				{
					// The runner got the player
					hitText.x = this.x - 10;
					hitText.y = this.y;
					hitText.visible = true;
				}
				else {
					hitText.visible = false;

					// Compute the shortest path to the player position
					resultAStar = astar.search(game.level.levelMap[levelCurrentX][levelCurrentY], game.level.levelMap[levelTargetX][levelTargetY]);
					resultAStarIndex = 0;
					
					// Animate the enemy
					animateFromAStar();
				}
				
			}
		}
		
		protected override function enemyColor():uint
		{
			return 0xFFFF00;
		}
	}
}