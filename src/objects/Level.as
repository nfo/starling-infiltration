package objects
{
	import com.yyztom.pathfinding.astar.AStar;
	import com.yyztom.pathfinding.astar.AStarNodeVO;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Level extends starling.display.Sprite
	{
		// Level map used by the A* algorithm
		public var levelMap:Vector.<Vector.<AStarNodeVO>>;
		// Used to search the best path, initialized with the level map
		public var astar:AStar;

		public function Level()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage():void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			createLevelMap();
			createLevelArt();
		}
		
		// The level sprite is drawn manually thanks to the Sprite Flash API.
		// @see http://forum.starling-framework.org/topic/drawinggraphics-api-work-with-starling 
		private function createLevelArt():void
		{
			// Draw the level based on the level map (see createLevelMap())
			var box:flash.display.Sprite = new flash.display.Sprite();
			var x : uint = 0;
			var y : uint = 0;
			while ( x < levelMap.length ) {
				while ( y < levelMap[x].length ){
					var block:AStarNodeVO = levelMap[x][y];
					if(block.isWall)
						box.graphics.beginFill(0x333333, 1);
					else
						box.graphics.beginFill(0xAAAAAA, 1);
					box.graphics.drawRect(x*10,y*10,10,10);
					y += 1;
				}
				y = 0;
				x+= 1;
			}
			box.graphics.endFill();
			
			// Convert to a Flash BitmapData
			var bitmapData:flash.display.BitmapData = new flash.display.BitmapData(800, 600, false);
			bitmapData.draw(box);
			
			// Create a Starling texture and image from the BitmapData
			var texture:Texture = Texture.fromBitmapData(bitmapData, false, false);
			var levelArt:Image = new Image(texture);
			this.addChild(levelArt);
		}

		// Build the map with squares of 10 pixels, will 30% walls.
		// @see https://github.com/tomnewton/AS3AStar/blob/master/src/com/yyztom/test/ui/Demo.as
		private function createLevelMap():void
		{
			// Build the level map for the AStar algorithm
			levelMap = new Vector.<Vector.<AStarNodeVO>>();
			var _previousNode : AStarNodeVO;
			
			var x : uint = 0;
			var y : uint = 0;
			
			while ( x < 80 ) {
				levelMap[x] = new Vector.<AStarNodeVO>();
				
				while ( y < 60 ){
					var node :AStarNodeVO  = new AStarNodeVO();
					node.next = _previousNode;
					node.h = 0;
					node.f = 0;
					node.g = 0;
					node.visited = false;
					node.parent = null;
					node.closed = false;
					node.isWall = isOccupied();
					node.position = new Point(x, y);
					levelMap[x][y]  = node;
					_previousNode = node;
					
					y+=1;
				}
				y=0;
				x+=1;
			}
			
			astar = new AStar(levelMap);
		}
		
		private function isOccupied():Boolean {
			var ran : Number = Math.random();
			return ran < 0.3; // 30% of probability to return true
		}

	}
}