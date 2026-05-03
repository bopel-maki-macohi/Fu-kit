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

	public var omonusColorTween:FlxTween;

	override function onStepHit(step:Int)
	{
		super.onStepHit(step);

		if (game?.curSong != 'rm -rf')
			return;

		switch (step)
		{
			case 96: omonusColorTween = FlxTween.color(stage.omonus, (Conductor.crochet / 1000) * (144 / step), 0xFFFFFF, 0x444444);
		}
	}

	override function onPause()
	{
		super.onPause();

		if (omonusColorTween != null)
			omonusColorTween.active = false;
	}

	override function onUnpause()
	{
		super.onUnpause();

		if (omonusColorTween != null)
			omonusColorTween.active = true;
	}
}
