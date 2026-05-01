package fukit.play;

import flixel.FlxState;
import flixel.FlxG;
import fukit.play.cutscenes.*;

class PlayStateSwitcher
{
	public static function getPlayStateSwitch(allowCutscenes:Bool = false):FlxState
	{
		var target:PlayState = new PlayState();

		if (allowCutscenes)
			switch (PlayState.SONG.song.toLowerCase())
			{
				case 'new world': return new NewWorldCutscene(() -> FlxG.switchState(() -> target));
			}

		return target;
	}
}
