package fukit.play.songs;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import fukit.shaders.DropShadowShader;
import fukit.play.stages.GrassWorld;
import fukit.play.components.SongComponent;

class FolirSong extends SongComponent
{
	public var stage:GrassWorld;

	override function init()
	{
		super.init();

		stage = new GrassWorld();

		bgShader = new DropShadowShader();
		charShader = new DropShadowShader();
	}

	var bgShader:DropShadowShader;
	var charShader:DropShadowShader;

	override function onCreate()
	{
		super.onCreate();

		if (game == null)
			return;

		switch (game.curSong)
		{
			case 'termination':
				bgShader.baseBrightness = 500;
				charShader.setAdjustColor(0, -23, 30, -12);

				FlxG.camera.bgColor = FlxColor.WHITE;

				game.defaultCamMove = false;
				FlxG.camera.zoom = 10;

				game.camFollow.screenCenter();
				game.camFollow.y += 160;

				game.camHUD.alpha = 0;

			case 'overheat':
				game.defaultCamMove = false;
				FlxG.camera.zoom = .9;

				game.camFollow.screenCenter();
				game.camFollow.y += 160;

				game.camHUD.alpha = 0;
		}

		stage.sky.shader = bgShader;
		stage.ground.shader = bgShader;

		game.dad.shader = charShader;
		game.boyfriend.shader = charShader;
	}

	var bgShaderTween:FlxTween;
	var charTween:FlxTween;

	var camTween:FlxTween;
	var hudTween:FlxTween;

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (game?.curSong == 'overheat')
		{
			if (step == 128)
			{
				var len:Float = (Conductor.stepCrochet / 1000) * (144 - step);

				camTween = FlxTween.tween(game.camFollow, {
					x: game.dad.getGraphicMidpoint().x - 150,
					y: game.dad.getGraphicMidpoint().y - 140,
					zoom: game.defaultCamZoom,
				}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 128)
			{
				var len:Float = (Conductor.stepCrochet / 1000) * (143 - step);

				hudTween = FlxTween.tween(game.camHUD, {alpha: 1}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 144)
			{
				game.defaultCamMove = true;
			}
		}

		if (game?.curSong == 'termination')
		{
			if (step <= 10 && camTween == null)
			{
				// target: step 64

				var len:Float = (Conductor.stepCrochet / 1000) * (64 - step);

				camTween = FlxTween.tween(FlxG.camera, {zoom: .5}, len, {ease: FlxEase.quadInOut});
			}

			if (step == 120)
			{
				// target: step 255

				var len:Float = (Conductor.stepCrochet / 1000) * (255 - step);

				hudTween = FlxTween.tween(game.camHUD, {alpha: 1}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 160)
			{
				// target: step 255

				var len:Float = (Conductor.stepCrochet / 1000) * (255 - step);

				bgShaderTween = FlxTween.tween(bgShader, {baseBrightness: 0}, len, {ease: FlxEase.sineInOut});

				charTween = FlxTween.tween(charShader, {
					baseHue: 0,
					baseContrast: 0,
					baseSaturation: 0
				}, len, {ease: FlxEase.sineInOut});

				camTween = FlxTween.tween(FlxG.camera, {zoom: game.defaultCamZoom}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 256)
			{
				FlxG.camera.bgColor = FlxColor.BLACK;
				game.defaultCamMove = true;
			}
		}
	}

	override function onPause()
	{
		super.onPause();

		for (tween in [bgShaderTween, charTween, camTween, hudTween])
			if (tween != null)
				tween.active = false;
	}

	override function onUnpause()
	{
		super.onUnpause();

		for (tween in [bgShaderTween, charTween, camTween, hudTween])
			if (tween != null)
				tween.active = true;
	}
}
