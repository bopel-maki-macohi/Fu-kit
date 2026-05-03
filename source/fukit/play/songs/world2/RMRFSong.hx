package fukit.play.songs.world2;

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

	public var charShaderTween:FlxTween;

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (game?.curSong != 'rm -rf')
			return;

		switch (step)
		{
			case 96:
				final duration = (Conductor.crochet / 1000) * (144 / step);

				omonusTween = FlxTween.tween(stage.omonus, {alpha: .25}, duration);
				charShaderTween = FlxTween.tween(stage.charShader, {
					baseBrightness: -64
				}, duration);
		}
	}

	override function onPause()
	{
		super.onPause();

		for (tween in [omonusTween, charShaderTween])
			if (tween != null)
				tween.active = false;
	}

	override function onUnpause()
	{
		super.onUnpause();

		for (tween in [omonusTween, charShaderTween])
			if (tween != null)
				tween.active = true;
	}
}
