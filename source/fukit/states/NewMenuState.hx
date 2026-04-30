package fukit.states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;

class NewMenuState extends MusicBeatState
{
	public var backdrop:FlxBackdrop;

	override function create()
	{
		super.create();

		backdrop = new FlxBackdrop(Paths.image('tile', 'fu-kit'));
		add(backdrop);
		backdrop.scale.set(6, 6);
		backdrop.velocity.set(32, 32);
        
        backdrop.antialiasing = false;

        FlxTween.tween(backdrop.velocity, {x: -32, y: -32}, 1, {
            ease: FlxEase.sineInOut,
            type: PINGPONG
        });
	}
}
