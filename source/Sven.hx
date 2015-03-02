
package ;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

class Sven extends FlxSprite {

	public var jaw : FlxSprite;
	public var middleY : Float; 
	public var count : Int = 0; 
	public var gnashOn : Bool = true; 
	public var closed : Bool = true; 
	public var firing : Bool = false; 
	public var openCount : Int = 0; 
	public var closeCount : Int = 0; 
	public var fireCount : Int = 0; 
	public var waitToFireCount : Int = 0; 
	public var shot : Bool = false; 

	public var jawOffset : Float = 120-2;

	public var emitter : FlxEmitter;
	private var fire : FlxParticle;

	private var sfxHit:FlxSound;


	public function new(x:Float = 0, y:Float=0)
	{ 
		super(x,y); 
		middleY = y; 
		loadGraphic("assets/images/svenHeadTop.png", false, 132, 120); 
		jaw = new FlxSprite(x+45,y+jawOffset); 
		jaw.loadGraphic("assets/images/svenHeadBot.png", false, 53,22); 

		emitter = new FlxEmitter(x+65, y+128, 40); 
		emitter.setXSpeed(-100, -50);
		emitter.setYSpeed(-50,50); 
		emitter.setScale(0.1);
		for (i in 0...(Std.int(emitter.maxSize/2))) {
			fire = new FlxParticle();
			fire.loadGraphic("assets/images/svenHead2.png",false,23,32); 
			emitter.add(fire);
			fire = new FlxParticle();
			fire.loadGraphic("assets/images/svenHead.png",false,25,32); 
			emitter.add(fire);
		}
		emitter.start(false, 3.5, 0.1);
		emitter.on = false;
		
		sfxHit = FlxG.sound.load("assets/sounds/hit.wav"); 
	}

	override public function update():Void 
	{
		super.update();

		

		if (waitToFireCount < 90 && gnashOn == false) {
			waitToFireCount++;
		} else {
			gnashOn = true;
			waitToFireCount = 0;  
		}

		emitter.x = x+65;
		emitter.y = y+jawOffset+jawOffset/4;

		if (this.x > 175) { 
			x-= 0.5; 
		} else { 
			count++; 
			x = 175; 
			y = middleY+(Math.sin(count * 0.02) * FlxG.height/8); 
		}

		jaw.x = this.x + 45;

		if (gnashOn == true) { 
			closed = false; 
			openCount++; 
			if (jaw.y < y+jawOffset+jawOffset/3) { 
				jaw.y++; 
			} 
			if (jaw.y > y + jawOffset+jawOffset/3) {
				jaw.y--; 
			}  
			if (openCount > 60) {
				emitter.on = true;
				fireCount++;
				if (fireCount > 60) { 
					gnashOn = false;
					openCount = 0;
					fireCount = 0; 
				}
			}
		} 

		if (gnashOn == false && closed == false) { 
			closeCount++;
			emitter.on = false; 
			if (jaw.y < y+jawOffset) { 
				jaw.y+=1; 
				} 
			if (jaw.y > y + jawOffset) {
				jaw.y-=1; 
			}  
			if (closeCount > 60) {
				closed = true;
				closeCount = 0; 
			}
		}

		if (closed == true && gnashOn == false) { 
			jaw.y = y + jawOffset;
		}

		this.color = this.shot ? FlxColor.RED : FlxColor.WHITE;
		this.jaw.color = this.shot ? FlxColor.RED : FlxColor.WHITE;
		if (this.shot == true) {
			sfxHit.stop(); 
			sfxHit.play();
			// this.scale.set(this.scale.x+0.01,this.scale.y+0.01);
			// this.updateHitbox();
			// this.offset.set(0,0); 
			// this.jaw.scale.set(this.scale.x,this.scale.y);
			// this.jaw.updateHitbox();
			// this.jaw.offset.set(0,0);
			// this.jawOffset = ( height - (height/60) ) - jaw.height/10;//118 * (this.scale.y - (this.scale.y/10));//  (this.height) - (this.height*this.scale.y)/(60/this.scale.y);
			
		}

		this.shot = false; 
	}

	override public function destroy():Void
	{ 
		super.destroy(); 
	}

}