package fukit.objects;

import flixel.FlxSprite;

class RainParticle extends FlxSprite
{
	override public function new()
	{
		super();

		frames = Paths.getSparrowAtlas('stages/rain', 'fu-kit');
		animation.addByPrefix('rain', 'rain', 0);

		reset(0, 0);
	}

	override function reset(X:Float, Y:Float)
	{
		super.reset(X, Y);
		animation.frameIndex = FlxG.random.int(0, 3);
	}
}
