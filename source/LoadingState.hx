package;

import flixel.FlxG;
import flixel.FlxState;

class LoadingState extends MusicBeatState
{
	var target:FlxState;
	var stopMusic = false;

	function new(target:FlxState, stopMusic:Bool)
	{
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false)
	{
		FlxG.switchState(() -> getNextState(target, stopMusic));
	}

	static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();

		return target;
	}
}
