package fukit.play;

import fukit.play.components.cutscenes.DialogueCutsceneComponent;
import flixel.FlxState;
import flixel.FlxG;

class PlayStateSwitcher
{
	static var dialogueComponentSongs:Array<String> = ['new world', 'rust', 'wetway'];

	public static function getPlayStateSwitch(allowCutscenes:Bool = false):FlxState
	{
		var target:PlayState = new PlayState();

		var curSong:String = PlayState.SONG.song.toLowerCase();

		if (allowCutscenes)
		{
			if (dialogueComponentSongs.contains(curSong))
				return new DialogueCutsceneComponent(curSong, () -> FlxG.switchState(() -> target));
		}

		return target;
	}
}
