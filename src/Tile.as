package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author SimplyRiven
	 */
	public class Tile extends Sprite
	{
		
		[Embed(source = '../lib/water.png')]
		public static var WaterImage:Class;
		
		[Embed(source = '../lib/miss.png')]
		public static var MissImage:Class;
		
		[Embed(source = '../lib/hit.png')]
		public static var HitImage:Class;
		
		//These booleans are properties that every single tile possesses, you can change these values from false to true individually, which is a huge plus.
		public var isShip:Boolean = false;
		public var isClicked:Boolean = false;
		
		public function Tile() 
		{
			//This is what happens for every single created tile on the stage, they are all, at the beginning, water.
			var waterBox:Bitmap = new WaterImage();
			this.addChild(waterBox);	
		}
		
	}
}