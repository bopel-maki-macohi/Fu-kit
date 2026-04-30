package fukit.play.songs;

import openfl.filters.ShaderFilter;
import fukit.shaders.RainShader;
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
	// var rainAlpha:Float = 0;
	// var rainEmitter:RainEmitter;
	var rainShader:RainShader;

	var rainStartAlpha:Float = 0.0;
	var rainEndAlpha:Float = 0.0;

	var rainIntensity:Float = 0;

	override function init()
	{
		super.init();

		if (game == null)
			return;

		stage = new GrassWorld();
		stage.makeStage;

		// rainEmitter = new RainEmitter(-320, -160, FlxG.width * 2);
		// rainEmitter.start(false, 0.05);

		// rainEmitter.scrollFactor.destroy();

		// rainEmitter.alpha.active = false;
		// rainEmitter.onEmit.add((particle) -> particle.alpha = rainAlpha);

		bgShader = new DropShadowShader();
		charShader = new DropShadowShader();

		// game.dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/${game.curSong}', 'fu-kit'));
		// trace(game.dialogue);

		// if (game.dialogue.length > 0 && PlayState.isStoryMode)
		// {
		// 	game.startingSong = false;
		// 	startDialogue(game.dialogue);
		// }

		rainShader = new RainShader();
		rainShader.uScreenResolution = [FlxG.width, FlxG.height];
		rainShader.uTime = 0;
		rainShader.uScale = FlxG.height / 200;
		rainShader.uIntensity = rainIntensity;

		game.camGame.filters = [new ShaderFilter(rainShader)];
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
				rainStartAlpha = 0;
				rainEndAlpha = 0.2;

				bgShader.setAdjustColor(0, 0, 0, 0);
				charShader.setAdjustColor(0, 0, 0, 0);

			case 'wetway':
				rainStartAlpha = 0.2;
				rainEndAlpha = 0.5;

			case 'rust':
				rainStartAlpha = 0.5;
				rainEndAlpha = 0.9;
		}

		stage.sky.shader = bgShader;
		stage.ground.shader = bgShader;

		game.dad.shader = charShader;
		game.boyfriend.shader = charShader;

		// if (rainEnd > 0)
		// 	game.frontShit.add(rainEmitter);
	}

	var heartRad:Float = 0;

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);

		// rainAlpha = remapToRangeDependentOnSong(rainStart, rainEnd);

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

			// rainEmitter.frequency = remapToRangeDependentOnSong(0.5, 0.2);
			rainIntensity = remapToRangeDependentOnSong(0, 0.1);
		}
		else if (game?.curSong == 'wetway')
		{
			// rainEmitter.frequency = remapToRangeDependentOnSong(0.2, 0.01);
			rainIntensity = remapToRangeDependentOnSong(0.1, 0.5);
		}
		else if (game?.curSong == 'rust')
		{
			// rainEmitter.frequency = remapToRangeDependentOnSong(0.01, 0.005);
			rainIntensity = remapToRangeDependentOnSong(0.5, 1);
		}

		heartRad += elapsed;
		rainShader.uCameraBounds = [
			game.camGame.scroll.x + game.camGame.viewMarginX,
			game.camGame.scroll.y + game.camGame.viewMarginY,
			game.camGame.scroll.x + game.camGame.viewMarginX + game.camGame.width,
			game.camGame.scroll.y + game.camGame.viewMarginY + game.camGame.height
		];
		rainShader.uTime = heartRad;
		rainShader.uIntensity = rainIntensity;
	}

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (step == 183 && game?.curSong == 'rust')
		{
			game.camMove(false);
			game.defaultCamMove = false;
		}

		if (step == 195 && game?.curSong == 'rust')
		{
			game.defaultCamMove = true;
		}
	}
}
