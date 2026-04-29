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

		var rainEmitter = new RainEmitter(0, -64, FlxG.width);
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

		if (game != null)
		{
			trace(game.curSong);

			switch(game.curSong.toLowerCase())
			{
				case 'new world':
					rainEnd = 0.2;
			}
		}
	}

	var rainStart:Float = 0.0;
	var rainEnd:Float = 0.0;

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);

		if (FlxG.sound.music != null)
		{
			var remappedIntensityValue:Float = FlxMath.remapToRange(Conductor.songPosition, 0, FlxG.sound.music.length, rainStart, rainEnd);

			rainAlpha = remappedIntensityValue;
		}
	}
}
