package fukit.play.components;

import flixel.FlxG;

class PlayComponent
{
	public var game(get, never):PlayState;

	function get_game():PlayState
	{
		return cast FlxG.state;
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
	}

	public function onCreate() {}

	public function onUpdate(elapsed:Float) {}

	public function onStepHit(step:Int) {}

	public function onBeatHit(beat:Int) {}

	public function onCountdownStep(step:Int) {}

	public function onCountdownEnd() {}
}
