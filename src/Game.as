package
{
	import objects.Player;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Game extends Sprite
	{
		private var player:Player;
		
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
			player = new Player();
			// Draw the player at the middle of the screen
			player.x = stage.stageWidth/2;
			player.y = stage.stageHeight/2;
			this.addChild(player);
		}

		private function onTouchEvent(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(stage);
			if(touch != null && touch.phase == TouchPhase.ENDED)
			{
				player.moveToPoint(touch.globalX, touch.globalY);
			}
		}

		private function onEnterFrame(event:EnterFrameEvent):void
		{
			// http://wiki.starling-framework.org/manual/animation#the_juggler
			Starling.juggler.advanceTime(event.passedTime);
		}
		
	}
}