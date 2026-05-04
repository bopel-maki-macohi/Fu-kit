package fukit.play;

import fukit.play.cutscenes.*;
import openfl.Assets;
import flixel.FlxState;
import flixel.FlxG;

class PlayStateSwitcher
{
	static var dialogueComponentSongs:Array<String> = ['new world', 'rust', 'wetway', 'overheat'];
	static var freeplayCutsceneSongs:Array<String> = [];

	public static function getPlayStateSwitch(allowCutscenes:Bool = false):FlxState
	{
		var target:PlayState = new PlayState();

		var curSong:String = PlayState.SONG.song.toLowerCase();

		FlxG.sound.cache(Paths.inst(curSong));

		if (PlayState.SONG.needsVoices)
			FlxG.sound.cache(Paths.voices(curSong));

		if (!allowCutscenes)
			return target;

		if (dialogueComponentSongs.contains(curSong)
			&& (PlayState.isStoryMode || #if FREEPLAY_CUTSCENES true #else freeplayCutsceneSongs.contains(curSong) #end))
		{
			switch (curSong)
			{
				case 'rust', 'rm -rf': return new NoMusicDialogueCutscene(curSong, () -> FlxG.switchState(() -> target));
				case 'overheat': return new OverheatDialogueCutscene(() -> FlxG.switchState(() -> target));
			}

			return new SongMusicDialogueCutscene(curSong, () -> FlxG.switchState(() -> target));
		}

		return target;
	}
}
