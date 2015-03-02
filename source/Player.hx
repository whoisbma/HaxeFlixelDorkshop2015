
package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.util.FlxDestroyUtil;
import flixel.util.FlxPoint;
import flixel.FlxObject;
import flixel.group.FlxTypedGroup;

class Player extends FlxSprite {

	private static var SPEED : Float = 120; 
	public var engine : FlxSprite;
	public var bulletArray:FlxTypedGroup<Bullet>;
	private var sfxBullet:FlxSound;

	public function new(X : Float = 0, Y : Float = 0) {
		super(X,Y);
		//makeGraphic(24,24,FlxColor.BLUE); 
//		loadGraphic("assets/images/player.png");
		loadGraphic("assets/images/player.png", true, 24, 24);  
		animation.add("up", [2], 0, false); 
		animation.add("down", [1], 0, false); 
		drag.x = drag.y = 1000; 

		//attach another sprite?
		engine = new FlxSprite(-8,4); 
		//engine.makeGraphic(16,16,FlxColor.WHITE); 
		engine.loadGraphic("assets/images/engine.png", true, 8, 8);
		engine.animation.add("flicker", [0,1], 13, true);  
		engine.animation.add("thrust", [0,1,0,0,0],13,true); 
		engine.animation.add("off", [0,1,1,1,1,1],13,true); 

		bulletArray = new FlxTypedGroup<Bullet>();

		sfxBullet = FlxG.sound.load("assets/sounds/shoot.wav"); 
		FlxG.sound.playMusic("assets/sounds/engine.wav", 1, true);
	}

	override public function update():Void { 
//		engine.velocity = this.velocity;
		

		movement();

		super.update();


		engine.x = this.x-7;
		engine.y = this.y+8;
		engine.update(); 
		
	}


	private function attack():Void {
		var newBullet = new Bullet(x + 18, y+12, 500, FlxObject.RIGHT,10); 
		sfxBullet.stop(); 
		sfxBullet.play();
		bulletArray.add(newBullet);
	}

	private function movement() : Void {
		var _up : Bool = false; 
		var _down : Bool = false; 
		var _left : Bool = false; 
		var _right : Bool = false; 
		var _space : Bool = false;

		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]); 
		_left = FlxG.keys.anyPressed(["LEFT", "A"]); 
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]); 
		_space = FlxG.keys.justPressed.SPACE;

		if (_space) {
			attack();
		}

		if (_up && _down) { 
			_up = _down = false; 
		}
		if (_left && _right) {
			_left = _right = false; 
		}

		if (_up || _down || _left || _right) {
			//velocity.x = speed; 
			//velocity.y = speed;
			var mA:Float = 0;
			if (_up) {
				animation.play("up");
			    mA = -90;
    			if (_left)
        			mA -= 45;
    			else if (_right)
        			mA += 45;
			}
			else if (_down) {
				animation.play("down");
			    mA = 90;
    			if (_left)
        			mA += 45;
    			else if (_right)
        			mA -= 45;
			}
			else if (_left) {
			    mA = 180;
			    animation.frameIndex = 0; 
			    engine.animation.play("off"); 
			}
			else if (_right) {
			    mA = 0;
			    animation.frameIndex = 0; 
			    engine.animation.play("thrust");
			}
			FlxAngle.rotatePoint(SPEED,0,0,0,mA,velocity);
		} else { 
			animation.frameIndex = 0; 
			engine.animation.play("flicker"); 
			
		}
	}

	override public function destroy():Void
	{ 
		super.destroy(); 
		sfxBullet = FlxDestroyUtil.destroy(sfxBullet); 
		engine = FlxDestroyUtil.destroy(engine); 
		bulletArray = FlxDestroyUtil.destroy(bulletArray);
	}

}