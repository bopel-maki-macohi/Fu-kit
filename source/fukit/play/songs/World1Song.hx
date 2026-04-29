package fukit.play.songs;

import fukit.shaders.DropShadowShader;
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

		bgShader = new DropShadowShader();
		charShader = new DropShadowShader();
	}

	var stage:GrassWorld;

	var bgShader:DropShadowShader;
	var charShader:DropShadowShader;

	override function onCreate()
	{
		super.onCreate();

		if (game == null)
			return;

		trace(game.curSong);

		bgShader.setAdjustColor(-100, 53, -70, -17);
		charShader.setAdjustColor(-55, -35, -38, -26);

		switch (game.curSong)
		{
			case 'new world':
				rainStart = -1;
				rainEnd = 0.2;

				bgShader.setAdjustColor(0, 0, 0, 0);
				charShader.setAdjustColor(0, 0, 0, 0);

			case 'wetway':
				rainStart = 0.2;
				rainEnd = 0.5;

			case 'rust':
				rainStart = 0.5;
				rainEnd = 0.9;
		}

		stage.sky.shader = bgShader;
		stage.ground.shader = bgShader;

		game.dad.shader = charShader;
		game.boyfriend.shader = charShader;

		if (rainEnd > 0)
			game.frontShit.add(rainEmitter);
	}

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);

		rainAlpha = remapToRangeDependentOnSong(rainStart, rainEnd);

		if (game?.curSong == 'new world')
		{
			var bgVals = [
				remapToRangeDependentOnSong(0, -100), // brightness
				remapToRangeDependentOnSong(0, 53), // hue
				remapToRangeDependentOnSong(0, -70), // contrast
				remapToRangeDependentOnSong(0, -17), // saturation
			];

			var charVals = [
				remapToRangeDependentOnSong(0, -55),
				remapToRangeDependentOnSong(0, -35),
				remapToRangeDependentOnSong(0, -38),
				remapToRangeDependentOnSong(0, -26),
			];

			bgShader.setAdjustColor(bgVals[0], bgVals[1], bgVals[2], bgVals[3]);
			charShader.setAdjustColor(charVals[0], charVals[1], charVals[2], charVals[3]);

			rainEmitter.frequency = remapToRangeDependentOnSong(1, 0.75);
		}
		else if (game?.curSong == 'wetway')
		{
			rainEmitter.frequency = remapToRangeDependentOnSong(0.75, 0.25 / 8);
		}
		else if (game?.curSong == 'rust')
		{
			rainEmitter.frequency = remapToRangeDependentOnSong(0.25 / 8, 0.175 / 16);
		}
	}

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (step == 183 && game?.curSong == 'rust')
		{
			game.camMove(false);
		}
	}
}
