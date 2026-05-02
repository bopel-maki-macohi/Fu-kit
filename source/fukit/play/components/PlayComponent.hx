package fukit.play.components;

import flixel.math.FlxMath;
import flixel.FlxG;

class PlayComponent
{
	public var game(get, never):PlayState;

	function get_game():PlayState
	{
		if (Std.isOfType(FlxG.state, PlayState))
			return cast FlxG.state;

		return null;
	}

	function remapToRangeDependentOnSong(start:Float, end:Float)
	{
		if (FlxG.sound.music == null)
			return start;

		return FlxMath.remapToRange(Conductor.songPosition, 0, FlxG.sound.music.length, start, end);
	}

	public function new()
	{
		init();
	}

	public function init()
	{
		if (game == null)
			return;

		PlayState.onCreate.add(onCreate);
		PlayState.onUpdate.add(onUpdate);

		PlayState.onStepHit.add(onStepHit);
		PlayState.onBeatHit.add(onBeatHit);

		PlayState.onCountdownStep.add(onCountdownStep);
		PlayState.onCountdownEnd.add(onCountdownEnd);

		PlayState.onOpponentNote.add(onOpponentNote);
		PlayState.onPlayerNote.add(onPlayerNote);
	}

	public function onCreate() {}

	public function onUpdate(elapsed:Float) {}

	public function onStepHit(step:Int) {}

	public function onBeatHit(beat:Int) {}

	public function onCountdownStep(step:Int) {}

	public function onCountdownEnd() {}

	public function onCamMove(playerCam:Bool) {}

	public function onOpponentNote(note:Note) {}

	public function onPlayerNote(note:Note) {}
}
