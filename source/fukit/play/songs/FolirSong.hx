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

		FlxG.camera.bgColor = FlxColor.WHITE;

		game.defaultCamMove = false;

		game.camFollow.screenCenter();
		game.camFollow.y += 200;

		game.camHUD.alpha = 0;

		switch (game.curSong)
		{
			case 'termination':
				bgShader.baseBrightness = 500;
				charShader.setAdjustColor(0, -23, 30, -12);

				FlxG.camera.zoom = 10;

			case 'overheat': FlxG.camera.zoom = .9;
		}

		stage.sky.shader = stage.ground.shader = bgShader;

		game.dad.shader = game.boyfriend.shader = charShader;
	}

	var bgShaderTween:FlxTween;
	var charTween:FlxTween;

	var camTween:FlxTween;
	var camZoomTween:FlxTween;
	var hudTween:FlxTween;

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (game?.curSong == 'overheat')
		{
			if (step == 128)
			{
				var len:Float = (Conductor.stepCrochet / 1000) * (174 - step);

				camTween = FlxTween.tween(game.camFollow, {
					x: game.dad.getMidpoint().x + 150,
					y: game.dad.getMidpoint().y - 100,
				}, len, {ease: FlxEase.sineInOut});

				camZoomTween = FlxTween.tween(FlxG.camera, {
					zoom: game.defaultCamZoom,
				}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 128)
			{
				var len:Float = (Conductor.stepCrochet / 1000) * (143 - step);

				hudTween = FlxTween.tween(game.camHUD, {alpha: 1}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 175)
			{
				game.defaultCamMove = true;
			}

			if (step == 288)
			{
				game.defaultCamMove = false;

				var len:Float = (Conductor.stepCrochet / 1000) * (304 - step);

				game.camFollow.screenCenter();
				game.camFollow.y += 200;

				camZoomTween = FlxTween.tween(FlxG.camera, {
					zoom: .8,
				}, len, {ease: FlxEase.sineInOut});
				hudTween = FlxTween.tween(game.camHUD, {alpha: 0}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 448)
			{
				var len:Float = (Conductor.stepCrochet / 1000) * (478 - step);

				camZoomTween = FlxTween.tween(FlxG.camera, {
					zoom: game.defaultCamZoom,
				}, len, {ease: FlxEase.sineInOut});

				hudTween = FlxTween.tween(game.camHUD, {alpha: 1}, len, {ease: FlxEase.sineInOut});
				
				camTween = FlxTween.tween(game.camFollow, {
					x: game.dad.getMidpoint().x + 150,
					y: game.dad.getMidpoint().y - 100,
				}, len, {ease: FlxEase.sineInOut});
			}

			if (step == 480)
			{
				game.defaultCamMove = true;
			}

			if (step == 544)
			{
				game.defaultCamMove = false;

				game.camFollow.screenCenter();
				game.camFollow.y += 200;

				var lenCamZoom:Float = (Conductor.stepCrochet / 1000) * (640 - step);
				var lenShaders:Float = (Conductor.stepCrochet / 1000) * (560 - step);

				camZoomTween = FlxTween.tween(FlxG.camera, {
					zoom: .5,
				}, lenCamZoom, {ease: FlxEase.sineInOut});

				bgShaderTween = FlxTween.tween(bgShader, {baseBrightness: 500}, lenShaders, {ease: FlxEase.sineInOut});

				charTween = FlxTween.tween(charShader, {
					baseBrightness: -500,
				}, lenShaders, {ease: FlxEase.sineInOut});
				hudTween = FlxTween.tween(game.camHUD, {alpha: 0}, lenShaders, {ease: FlxEase.sineInOut});
			}

			if (step == 672)
			{
				game.defaultCamMove = true;

				FlxG.camera.zoom = game.defaultCamZoom;

				bgShader.setAdjustColor(0, 0, 0, 0);
				charShader.setAdjustColor(0, 0, 0, 0);

				game.camHUD.alpha = 1;

				game.camMove(false);
			}

			if (step == 752)
			{
				game.defaultCamMove = false;

				FlxG.camera.zoom = .5;

				bgShader.setAdjustColor(500, 0, 0, 0);
				charShader.setAdjustColor(-500, 0, 0, 0);

				game.camFollow.screenCenter();
				game.camFollow.y += 200;

				game.camHUD.alpha = 0;

				FlxG.camera.focusOn(game.camFollow.getPosition());

				game.dad.dance();
				game.boyfriend.dance();
				game.gf.dance();
			}
		}

		if (game?.curSong == 'termination')
		{
			if (step <= 10 && camTween == null)
			{
				// target: step 64

				var len:Float = (Conductor.stepCrochet / 1000) * (64 - step);

				camZoomTween = FlxTween.tween(FlxG.camera, {zoom: .5}, len, {ease: FlxEase.quadInOut});
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

				camZoomTween = FlxTween.tween(FlxG.camera, {zoom: game.defaultCamZoom}, len, {ease: FlxEase.sineInOut});
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

		for (tween in [bgShaderTween, charTween, camTween, camZoomTween, hudTween])
			if (tween != null)
				tween.active = false;
	}

	override function onUnpause()
	{
		super.onUnpause();

		for (tween in [bgShaderTween, charTween, camTween, camZoomTween, hudTween])
			if (tween != null)
				tween.active = true;
	}
}
