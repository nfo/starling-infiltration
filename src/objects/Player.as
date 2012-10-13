package objects
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Player extends starling.display.Sprite
	{
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
	}
}