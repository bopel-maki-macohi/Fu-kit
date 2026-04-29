package fukit.play.songs;

import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import fukit.play.stages.GrassWorld;
import fukit.shaders.HSVShader;
import fukit.objects.RainEmitter;
import flixel.math.FlxMath;
import flixel.FlxG;
import fukit.play.components.SongComponent;

class World1Song extends SongComponent
{
	var rainAlpha:Float = 0;
	var rainEmitter:RainEmitter;

	var rainStart:Float = 0.0;
	var rainEnd:Float = 0.0;

	override function init()
	{
		super.init();

		if (game == null)
			return;

		stage = new GrassWorld();
		stage.makeStage();

		rainEmitter = new RainEmitter(0, -64, FlxG.width);
		rainEmitter.start(false, 0.05);

		rainEmitter.scrollFactor.x.set(1, 1.5);
		rainEmitter.scrollFactor.y.set(1, 1.5);

		rainEmitter.alpha.active = false;
		rainEmitter.onEmit.add((particle) -> particle.alpha = rainAlpha);

		bgShader = new HSVShader();
		charShader = new HSVShader();
	}

	var stage:GrassWorld;

	var bgShader:HSVShader;
	var charShader:HSVShader;

	override function onCreate()
	{
		super.onCreate();

		if (game == null)
			return;

		trace(game.curSong);

		switch (game.curSong)
		{
			case 'new world':
				rainStart = -1;
				rainEnd = 0.2;

				// bgShader.set(0, 0, 0);
				// charShader.set(0, 0, 0);

				// stage.sky.shader = bgShader;
				// stage.ground.shader = bgShader;

				// game.dad.shader = charShader;
				// game.boyfriend.shader = charShader;
		}

		// if (rainEnd > 0)
			// game.frontShit.add(rainEmitter);
	}

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);

		rainAlpha = remapToRangeDependentOnSong(rainStart, rainEnd);

		if (game == null)
			return;

		if (game.curSong == 'new world')
		{
			// bgShader.hue = remapToRangeDependentOnSong(1, 1.3);
			// bgShader.saturation = remapToRangeDependentOnSong(1, 0.85);
			// bgShader.value = remapToRangeDependentOnSong(1, 0.95);
		}
	}
}
