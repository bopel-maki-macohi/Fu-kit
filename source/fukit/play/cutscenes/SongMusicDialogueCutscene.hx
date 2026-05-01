package fukit.play.cutscenes;

import flixel.FlxG;
import fukit.play.components.cutscenes.DialogueCutsceneComponent;

class SongMusicDialogueCutscene extends DialogueCutsceneComponent
{
	override function makeMusic()
	{
		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song.toLowerCase()), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.8);
	}
}
