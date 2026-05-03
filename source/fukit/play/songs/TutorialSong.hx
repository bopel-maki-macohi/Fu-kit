package fukit.play.songs;

import fukit.play.objects.Note;
import fukit.play.stages.MainStage;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import fukit.play.components.SongComponent;

class TutorialSong extends SongComponent
{
	override function onBeatHit(beat:Int)
	{
		super.onBeatHit(beat);

		if (game != null)
			if (beat % 16 == 15 && beat > 16 && beat < 48)
			{
				game.boyfriend.playAnim('hey', true);
				game.dad.playAnim('cheer', true);
			}
	}

	override function onCamMove(playerCam:Bool)
	{
		super.onCamMove(playerCam);

		if (game != null)
			if (playerCam)
				FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
			else
				FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function init()
	{
		super.init();

		if (game == null)
			return;

		new MainStage();

		if (PlayState.isStoryMode)
			FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function onOpponentNote(note:Note)
	{
		super.onOpponentNote(note);

		game.camZooming = true;
	}
}
