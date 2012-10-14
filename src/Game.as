package
{
	import objects.Level;
	import objects.Player;
	import objects.enemies.Runner;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Game extends Sprite
	{
		public var level:Level;
		public var player:Player;
		public var runner1:Runner;
		public var runner2:Runner;
		public var runner3:Runner;
		
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			drawGame();

			stage.addEventListener(TouchEvent.TOUCH, onTouchEvent);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			trace("Game initialized");
		}
		
		private function drawGame():void
		{
			level = new Level();
			this.addChild(level);
			
			// Draw the player at the middle of the screen
			player = new Player();
			player.x = stage.stageWidth/2;
			player.y = stage.stageHeight/2;
			this.addChild(player);
			
			// Draw 3 runner enemies at the edge of the screen
			runner1 = new Runner();
			runner1.x = stage.stageWidth - 10;
			this.addChild(runner1);
			runner2 = new Runner();
			runner2.y = stage.stageHeight - 10;
			this.addChild(runner2);
			runner3 = new Runner();
			runner3.x = stage.stageWidth - 10;
			runner3.y = stage.stageHeight - 10;
			this.addChild(runner3);
		}

		private function onTouchEvent(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
				player.moveToPoint(level, touch.globalX, touch.globalY);
			}
		}

		private function onEnterFrame(event:EnterFrameEvent):void
		{
			// http://wiki.starling-framework.org/manual/animation#the_juggler
			Starling.juggler.advanceTime(event.passedTime);
		}
		
	}
}