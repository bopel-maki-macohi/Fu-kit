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
		}

		stage.sky.shader = bgShader;
		stage.ground.shader = bgShader;

		game.dad.shader = charShader;
		game.boyfriend.shader = charShader;
	}

	var terminationTween_bgShader:FlxTween;
	var terminationTween_charShader:FlxTween;
	var terminationTween_camShader:FlxTween;

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (game?.curSong == 'termination')
		{
			if (step <= 10 && terminationTween_camShader == null)
			{
				// target: step 64

				var len:Float = (Conductor.stepCrochet / 1000) * (64 - step);

				terminationTween_camShader = FlxTween.tween(FlxG.camera, {zoom: .5}, len, {ease: FlxEase.quadInOut});
			}
			if (step == 160)
			{
				// target: step 255

				var len:Float = (Conductor.stepCrochet / 1000) * (255 - step);

				terminationTween_bgShader = FlxTween.tween(bgShader, {baseBrightness: 0}, len, {ease: FlxEase.sineInOut});

				terminationTween_charShader = FlxTween.tween(charShader, {
					baseHue: 0,
					baseContrast: 0,
					baseSaturation: 0
				}, len, {ease: FlxEase.sineInOut});

				terminationTween_camShader = FlxTween.tween(FlxG.camera, {zoom: 1.05}, len, {ease: FlxEase.sineInOut});
			}
			if (step == 256)
			{
				FlxG.camera.bgColor = FlxColor.BLACK;
			}
		}
	}

	override function onPause()
	{
		super.onPause();

		for (tween in [terminationTween_bgShader, terminationTween_charShader, terminationTween_camShader])
			if (tween != null)
				tween.active = false;
	}

	override function onUnpause()
	{
		super.onUnpause();

		for (tween in [terminationTween_bgShader, terminationTween_charShader, terminationTween_camShader])
			if (tween != null)
				tween.active = true;
	}
}
