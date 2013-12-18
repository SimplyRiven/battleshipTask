package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author SimplyRiven
	 */	
	public class Main extends Sprite 
	{
		
		private var tileMap:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>();
		private var mapBoxes:Tile = new Tile;
		
		private var background:Sprite = new Sprite;
		private var backgroundGameArea:Sprite = new Sprite;
		
		private var hitValue:int;
		private var missValue:int;
		private var shipX:int;
		private var shipY:int;
		
		private var hitScore:TextField = new TextField;
		private var missScore:TextField = new TextField;
		private var alreadyClickDisplay:TextField = new TextField;
		
		private var shipVerticalOrHorizontal:Number;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			startUpInitiation();
			
		}
		
		/*
		 * I created a function of the entry point purely because of my personal preference that it looks better this way.
		 * Also, namegiving is essential, i want the person who reads my code to understand what is meant to happen in the entry point.
		 */
		
		private function startUpInitiation():void
		{
			background.graphics.beginFill(0x000000);
			background.graphics.drawRect(0, 0, 1000, 1000);
			background.graphics.endFill();
			
			backgroundGameArea.graphics.beginFill(0xffffff);
			backgroundGameArea.graphics.drawRect(90, 90, 332, 332)
			backgroundGameArea.graphics.endFill();
			
			hitScore.text = "Hits: " + hitValue;
			missScore.text = "Misses: " + missValue;
			hitScore.border = true;
			hitScore.background = 0x00ff00;
			
			hitScore.x = GENERALSCOREBOARDPOSITIONX;
			hitScore.y = GENERALSCOREBOARDPOSITIONY;
			missScore.x = GENERALSCOREBOARDPOSITIONX;
			missScore.y = GENERALSCOREBOARDPOSITIONY + SCOREPOSITIONY;
			
			alreadyClickDisplay.textColor = 0xffffff;
			alreadyClickDisplay.x = CLICKDISPLAYPOSITIONX;
			alreadyClickDisplay.y = CLICKDISPLAYPOSITIONY;
			alreadyClickDisplay.width = CLICKDISPLAYWIDTH;
			
			addChild(background);			
			addChild(backgroundGameArea);
			addChild(hitScore);
			addChild(missScore);
			addChild(alreadyClickDisplay);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardEvents);
			
			createTileMap();
		}
		
		/*
		 * The first part of this function works because of how a vector works, it creates a single tile on the X-axis, and then proceedes to create 9 more tiles in the Y-axis,
		 * it keeps doing that until you have 10 tiles on the X- respectivly Y-axis.
		 * I decided to go with this solution because it seemed simple to basically use the same method you used, I don't really understand the other methods.
		 */
		
		private function createTileMap():void
		{
			for (var horLineValue:int = 0; horLineValue < AMOUNTOFBOXESX; horLineValue++) 
			{
				
				var horLine:Vector.<Tile> = new Vector.<Tile>();
					
				for (var verLineValue:int = 0; verLineValue < AMOUNTOFBOXESY; verLineValue++) 
				{	
					
					var mapWaterTile:Tile = new Tile();
					
					mapWaterTile.buttonMode = true;
					
					mapWaterTile.x = MAPSTART + verLineValue * (BOXSIDE-MARGINBOX);
					mapWaterTile.y = MAPSTART + horLineValue * (BOXSIDE-MARGINBOX);
					
					addChild(mapWaterTile);
					
					horLine.push(mapWaterTile);
					
					mapWaterTile.addEventListener(MouseEvent.CLICK, clickOnTile);
					
				}
					
				tileMap.push(horLine);
				
			}
			
			/*
			 * This is the easiest method of creating a single three-tiled ship at a random position on the board, the random values from shipX and shipY is inserted in the vector and it changes the
			 * already existing tile into a ship with the help of the boolean called isShip, which is false for every single tile up until this point.
			 * At first, this part of the function didn't work, because sometimes the value was > 10, because of the vector only having 10 tiles at every direction I had to solve this problem,
			 * I did this by creating an if-batch wheras if the value exceeded 7 it would generate the ship in a downward fashion instead.
			 */
			
			shipX = Math.round(Math.random() * GENERATERANDOMPOSITION);
			shipY = Math.round(Math.random() * GENERATERANDOMPOSITION);
			shipVerticalOrHorizontal = Math.random();
			
			tileMap[shipX][shipY].isShip = true;
			
			if (shipVerticalOrHorizontal < 0.5)
			{
				if (shipX > 7)
				{
					tileMap[shipX - GENERATESHIPTILETWO][shipY].isShip = true;
					tileMap[shipX - GENERATESHIPTILETHREE][shipY].isShip = true;
				}
				else
				{
					tileMap[shipX + GENERATESHIPTILETWO][shipY].isShip = true;
					tileMap[shipX + GENERATESHIPTILETHREE][shipY].isShip = true;
				}
				
			}
			else if (shipVerticalOrHorizontal > 0.5)
			{
				if (shipY > 7)
				{
					tileMap[shipX][shipY - GENERATESHIPTILETWO].isShip = true;
					tileMap[shipX][shipY - GENERATESHIPTILETHREE].isShip = true;
				}
				else
				{
					tileMap[shipX][shipY + GENERATESHIPTILETWO].isShip = true;
					tileMap[shipX][shipY + GENERATESHIPTILETHREE].isShip = true;
				}
				
			}
			//This part was seemingly necessary, otherwise when you use the debugg function the stage will become untargeted.
			stage.focus = stage;
		}
		
		/*
		 * This function is not really necessary, but yet again, I like to give the reader a better perspectiv of what is actually going on.
		 */
		
		private function resetTileMap():void
		{
			for ( var y:int = 0; y < tileMap.length; y++)
			{
				for ( var x:int = 0; x < tileMap.length; x++)
				{
					removeChild(tileMap[y][x]);
				}
			}
			tileMap.length = 0;
			createTileMap();
		}
		
		/*
		 * I decided to create a single function for all (2) of the keyboardEvents, because it didn't seem necessary to create multiple functions for similar actions.
		 */
		
		private function keyboardEvents(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.SPACE)
			{
				resetTileMap();
				hitValue = 0;
				hitScore.text = "Hits: " + hitValue;
				missValue = 0;
				missScore.text = "Misses: " + missValue;
			}
			
			/*
			 * The following part of this function is created purely for research purposes (and cheating purposes :)
			 * It is an exact copy of the second part of the createMap function but with an added twist, instead of making the tiles a ship it shows those tiles who were previously decided.
			 * This works because it uses the same variables and therefore displays which 3 tiles on the map are in fact ships.
			 */
			
			//If you want to cheat
			if (e.keyCode == Keyboard.D)
			{
				var waterBoxHit1:Bitmap = new Tile.HitImage();
				var waterBoxHit2:Bitmap = new Tile.HitImage();
				var waterBoxHit3:Bitmap = new Tile.HitImage();
				
				if (shipVerticalOrHorizontal < 0.5)
				{
				if (shipX > 7)
				{	
					tileMap[shipX][shipY].addChild(waterBoxHit1);
					tileMap[shipX - GENERATESHIPTILETWO][shipY].addChild(waterBoxHit2);
					tileMap[shipX - GENERATESHIPTILETHREE][shipY].addChild(waterBoxHit3);
				}
				else
				{
					tileMap[shipX][shipY].addChild(waterBoxHit1);
					tileMap[shipX + GENERATESHIPTILETWO][shipY].addChild(waterBoxHit2);
					tileMap[shipX + GENERATESHIPTILETHREE][shipY].addChild(waterBoxHit3);
				}
				
				}
				else if (shipVerticalOrHorizontal > 0.5)
				{
					if (shipY > 7)
					{
						tileMap[shipX][shipY].addChild(waterBoxHit1);
						tileMap[shipX][shipY - GENERATESHIPTILETWO].addChild(waterBoxHit2);
						tileMap[shipX][shipY - GENERATESHIPTILETHREE].addChild(waterBoxHit3);
					}
					else
					{
						tileMap[shipX][shipY].addChild(waterBoxHit1);
						tileMap[shipX][shipY + GENERATESHIPTILETWO].addChild(waterBoxHit2);
						tileMap[shipX][shipY + GENERATESHIPTILETHREE].addChild(waterBoxHit3);
					}
					
				}
			}
		}
		
		/*
		 * This function works because every single tile knnows its own properties, in this case, the target knows if it has already been clicked as well as if it is a ship or not.
		 * This is the reason classes rock :)
		 */
		
		private function clickOnTile(e:MouseEvent):void
		{
			if (Tile (e.target).isClicked)
			{
				alreadyClickDisplay.text = "This tile has already been clicked."
			}
			else if (Tile(e.target).isShip)
			{
				var waterBoxHit:Bitmap = new Tile.HitImage();
				e.target.addChild(waterBoxHit);
				hitValue++;
				hitScore.text = "Hits: " + hitValue;
				e.target.isClicked = true;
				e.target.buttonMode = false;
				alreadyClickDisplay.text = " ";
			}
			else
			{
				var waterBoxMiss:Bitmap = new Tile.MissImage();
				e.target.addChild(waterBoxMiss);
				missValue++;
				missScore.text = "Misses: " + missValue;
				e.target.isClicked = true;
				e.target.buttonMode = false;
				alreadyClickDisplay.text = " ";
			}
			
		}
		
		private const AMOUNTOFBOXESX:int = 10;
		private const AMOUNTOFBOXESY:int = 10;
		private const BOXSIDE:int = 32;
		private const MARGINBOX:int = 1;
		private const MAPSTART:int = 100;
		private const SCOREPOSITIONX:int = 600;
		private const SCOREPOSITIONY:int = 12;
		private const GENERALSCOREBOARDPOSITIONX:int = 430;
		private const GENERALSCOREBOARDPOSITIONY:int = 89;
		private const CLICKDISPLAYPOSITIONX:int = 172;
		private const CLICKDISPLAYPOSITIONY:int = 420;
		private const CLICKDISPLAYWIDTH:int = 500;
		private const GENERATERANDOMPOSITION:int = 9;
		private const GENERATESHIPTILETWO:int = 1;
		private const GENERATESHIPTILETHREE:int = 2;
		
	}
	
	// THINGS I'VE COULD HAVE DONE BETTER:
	
	/*
	 * I could have defenately done more challenges, although i could only find simple solutions to them, one of the things that come in to mind is multiple ships,
	 * where my solution to it was basically add another ship X tiles away from the already created one, which isn't a very good way of solving the problem.
	 * 
	 * I could probably have come up with a different and smarter way of creating the actual tileMap, but i guess i like to take simple approaces to problems.
	 * 
	 * Instead of actually deleting the entire vector values and then recreating them, i could have changed respective booleans to false and added the waterBox bitmap to all the tiles instead.
	 * This would have resulted in better looking code and a faster running program.
	 * 
	 * Instead of constantly inserting the textfields in order to update the text values in every single change, i could have added a gameLoop to the stage so it updates automatically.
	 * It would result in better looking code, yet again, as well as less lines!
	 * 
	 * Considering I am new to programming overall, I haven't really grasped the concept of classes, although i know how to use them i tend to just do things in the main class,
	 * as it seems easier when you do it, but in the end you realize that you probably should have done quite a few things in other classes instead, which is something i will look into in the future.
	 */
	
}