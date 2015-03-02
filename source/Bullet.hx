
package ;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxVelocity;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite {

	private var speed:Float; 
	private var direction:Int;
	private var damage:Float;

	public function new(X:Float, Y:Float, speed:Float, direction:Int, damage:Float) {
		super(X,Y); 
		this.speed = speed;
		this.direction = direction;
		this.damage = damage;
		makeGraphic(2,2,FlxColor.WHITE);
	}

	override public function update():Void {
		super.update(); 
		if (direction == FlxObject.LEFT){
             velocity.x = -speed;     
        }
        if (direction == FlxObject.RIGHT){
            velocity.x = speed;     
        }
        // if (direction == FlxObject.FLOOR){
        //     velocity.y = speed;     
        // }
        // if (direction == FlxObject.CEILING){
        //     velocity.y = -speed;     
        // }
        
    }
 
    override public function destroy():Void
    {
        super.destroy();
    }
	

}