package fukit.play.songs;

import fukit.objects.RainEmitter;
import flixel.math.FlxMath;
import flixel.FlxG;
import fukit.play.components.SongComponent;

class World1Song extends SongComponent
{
	var rainAlpha:Float = 0;

	override function init()
	{
		super.init();

		if (game == null)
			return;

		var rainEmitter = new RainEmitter(floor.x, floor.y - 200, floor.width);
		rainEmitter.start(false, 0.05);
		
		rainEmitter.scrollFactor.x.set(1, 1.5);
		rainEmitter.scrollFactor.y.set(1, 1.5);

		game.add(rainEmitter);
		
		rainEmitter.alpha.active = false;
		rainEmitter.onEmit.add((particle) -> particle.alpha = rainAlpha);
	}

	override function onCreate()
	{
		super.onCreate();

		trace('New World!');
	}

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);
	}
}
