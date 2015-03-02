package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxRandom;
import flixel.FlxObject;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

//	private var starfield : FlxTypedGroup<Bullet>;
	private var _player : Player;
	private var sven : Sven;

	private var emitter : FlxEmitter;
	private var whitePixel : FlxParticle;
	private var mines = new FlxTypedGroup<Mine>(20);
	private var asplodes = new FlxTypedGroup<FlxSprite>();

	private var sfxHit:FlxSound;
	private var sfxHit2:FlxSound;


	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
	
		// starfield = new FlxTypedGroup<Bullet>();
		// add(starfield); 
		FlxG.mouse.visible = false; 

		emitter = new FlxEmitter(FlxG.width, 0, 400); 
		emitter.height = FlxG.height; 
		emitter.setXSpeed(-100, -30);
		emitter.setYSpeed(0,0);
		add(emitter); 
		for (i in 0...(Std.int(emitter.maxSize/2))) {
			whitePixel = new FlxParticle();
			whitePixel.makeGraphic(2,2,FlxColor.GRAY);
			emitter.add(whitePixel);
			whitePixel = new FlxParticle();
			whitePixel.makeGraphic(1,1,FlxColor.GRAY);
			emitter.add(whitePixel);
		}
		emitter.start(false, 10, 0.1);

		for (i in 0...mines.maxSize) { 
			mines.add(new Mine(FlxG.width + FlxRandom.float()*(FlxG.width*3), FlxRandom.float()*FlxG.height)); 
		}
		add(mines); 

		_player = new Player(20,20); 
		add(_player); 
		add(_player.engine);
		add(_player.bulletArray);

		sven = new Sven(350, 50); 
		add(sven);
		add(sven.jaw);
		add(sven.emitter);

		add(asplodes);

		sfxHit = FlxG.sound.load("assets/sounds/hit.wav"); 
		sfxHit2 = FlxG.sound.load("assets/sounds/hit2.wav"); 

		//FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN, 1); 

		super.create();
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		for (b in _player.bulletArray) { 
			if (FlxG.pixelPerfectOverlap(b, sven) || FlxG.pixelPerfectOverlap(b, sven.jaw)) {
				sven.shot = true; 
				sfxHit.stop(); 
				sfxHit.play();
				var splode = new FlxSprite(b.x-15, b.y-15);
				splode.loadGraphic("assets/images/asplode.png", true, 32, 32);  
				splode.animation.add("boom", [0,1,2,3,4,5,6,7,8,9], 24, false); 
				splode.animation.play("boom");
				asplodes.add(splode);

				_player.bulletArray.remove(b);

				b.destroy;
				
				
			}
			if (b.x > FlxG.width) {
				_player.bulletArray.remove(b);
				b.destroy;
			}
		}

		for (splode in asplodes) {
			if (splode.animation.frameIndex == 9) {
				asplodes.remove(splode);
			}
		}

		FlxG.overlap(_player, mines, playerTouchMine);
		FlxG.overlap(_player.bulletArray, mines, mineShot); 
		FlxG.overlap(_player.bulletArray, sven.emitter, particlesShot); 
		
	
		// if (FlxRandom.float() > 0.9) { 
		// 	var newStar = new Bullet(WIDTH, FlxRandom.float()*HEIGHT, 200, FlxObject.LEFT, 0); 
		// 	starfield.add(newStar);
		// }


		if ( _player.x > FlxG.width-24) {
			_player.x = FlxG.width-24;
		}
		if (_player.x < 0) { 
			_player.x = 0;
		}
		if (_player.y > FlxG.height-24) {
			_player.y = FlxG.height-24;
		}
		if (_player.y < 0) {
			_player.y = 0; 
		}

		super.update();
	}

	// private function svenShot(b:Bullet, s:Sven):Void 
	// {
	// 	if (s.alive && s.exists && b.alive && b.exists) {
	// 		m.kill(); 
	// 	}
	// }

	private function particlesShot(b:Bullet, p:FlxParticle):Void
	{
		if (p.alive && p.exists && b.alive && b.exists) {
			var splode = new FlxSprite(b.x-15, b.y-15);
			splode.loadGraphic("assets/images/asplode.png", true, 32, 32);  
			splode.animation.add("boom", [0,1,2,3,4,5,6,7,8,9], 24, false); 
			splode.animation.play("boom");
			asplodes.add(splode);
			sfxHit2.stop(); 
			sfxHit2.play();
			p.kill(); 
			b.kill(); 

		}
	}

	private function playerTouchMine(p:Player, m:Mine):Void
	{
		if (p.alive && p.exists && m.alive && m.exists) {
			m.kill(); 
		}
	}	

	private function mineShot(b:Bullet, m:Mine):Void 
	{
		if (b.alive && b.exists && m.alive && m.exists) { 
			var splode = new FlxSprite(b.x-15, b.y-15);
			splode.loadGraphic("assets/images/asplode.png", true, 32, 32);  
			splode.animation.add("boom", [0,1,2,3,4,5,6,7,8,9], 24, false); 
			splode.animation.play("boom");
			asplodes.add(splode);
			sfxHit2.stop(); 
			sfxHit2.play();
			m.kill();
			b.kill(); 
		}
	}
}