
package ;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;

class Mine extends FlxSprite 
{

	public function new(x:Float = 0, y:Float=0)
	{ 
		super(x,y); 
		//makeGraphic(8,8,FlxColor.RED);
		if (FlxRandom.float() > 0.5) {
			loadGraphic("assets/images/svenHead2.png",false,23,32); 
		} else {
			loadGraphic("assets/images/svenHead.png",false,25,32); 
		}
	}	

	override public function update():Void
	{
		movement(); 
		super.update(); 
	}

	private function movement():Void { 
		y = y + (Math.sin(x*0.05) * 2);
		x--; 
	}

	// override public function kill():Void
	// { 
	// 	alive = false; 
	// }

}