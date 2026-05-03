package fukit.play.songs.world2;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import fukit.play.stages.RDZone;

class RMRFSong extends RDSong
{
	public var stage:RDZone;

	override function init()
	{
		super.init();

		if (game == null)
		{
			stage = new RDZone();
			return;
		}

		stage = cast(game.stage, RDZone);
	}

	public var omonusTween:FlxTween;
	public var hudTween:FlxTween;
	public var charShaderTween:FlxTween;
	public var camTween:FlxTween;
	public var camZoomTween:FlxTween;

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (game?.curSong != 'rm -rf')
			return;

		switch (step)
		{
			case 96:
				final duration = (Conductor.crochet / 1000) * (144 / step);

				camZoomTween = FlxTween.tween(FlxG.camera, {zoom: .6}, duration);
				omonusTween = FlxTween.tween(stage.omonus, {alpha: .25}, duration);
				charShaderTween = FlxTween.tween(stage.charShader, {
					baseBrightness: -64
				}, duration);
			case 160:
				final duration = (Conductor.crochet / 1000) * (176 / step);

				camZoomTween = FlxTween.tween(FlxG.camera, {zoom: .7}, duration);
				omonusTween = FlxTween.tween(stage.omonus, {alpha: 0}, duration);
				charShaderTween = FlxTween.tween(stage.charShader, {
					baseBrightness: -100
				}, duration);
				camTween = FlxTween.tween(game.camFollow, {x: game.boyfriend.getMidpoint().x}, duration, {ease: FlxEase.quadOut});

			case 336:
				final duration = (Conductor.crochet / 1000) * (352 / step);

				hudTween = FlxTween.tween(game.camHUD, {alpha: 0}, duration);
				camZoomTween = FlxTween.tween(FlxG.camera, {zoom: 1.05}, duration);
				charShaderTween = FlxTween.tween(stage.charShader, {
					baseBrightness: -500
				}, duration);

			case 448:
				final duration = (Conductor.crochet / 1000) * (464 / step);

				hudTween = FlxTween.tween(game.camHUD, {alpha: 1}, duration);
				camZoomTween = FlxTween.tween(FlxG.camera, {zoom: game.defaultCamZoom}, duration * 2, {ease: FlxEase.expoOut});
				charShaderTween = FlxTween.tween(stage.charShader, {
					baseBrightness: -100
				}, duration * 2);

				
			case 608:
				final duration = (Conductor.crochet / 1000) * (640 / step);
				hudTween = FlxTween.tween(game.camHUD, {alpha: 1}, duration);

				stage.charShader.baseBrightness = -10000;

				FlxG.camera.flash(FlxColor.RED, duration);
		}
	}

	override function onPause()
	{
		super.onPause();

		for (tween in [omonusTween, charShaderTween, hudTween, camTween, camZoomTween])
			if (tween != null)
				tween.active = false;
	}

	override function onUnpause()
	{
		super.onUnpause();

		for (tween in [omonusTween, charShaderTween, hudTween, camTween, camZoomTween])
			if (tween != null)
				tween.active = true;
	}
}
