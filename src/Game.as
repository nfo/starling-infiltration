package
{
	import objects.Player;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		public function Game()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			drawGame();
		}
		
		private function drawGame():void
		{
			var player:Player = new Player();
			// Draw the player at the middle of the screen
			player.x = stage.stageWidth/2;
			player.y = stage.stageHeight/2;
			this.addChild(player);
		}
	}
}