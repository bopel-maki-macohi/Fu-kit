package fukit.play;

import openfl.Assets;
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

		var player1:Boyfriend = new Boyfriend(0, 0, PlayState.SONG.player1);
		var player2:Character = new Character(0, 0, PlayState.SONG.player2);

		Assets.cache.setBitmapData(player1.graphic.assetsKey, player1.graphic.bitmap);
		Assets.cache.setBitmapData(player2.graphic.assetsKey, player2.graphic.bitmap);

		FlxG.sound.cache(Paths.inst(curSong));
		FlxG.sound.cache(Paths.voices(curSong));

		if (allowCutscenes)
		{
			if (dialogueComponentSongs.contains(curSong))
				return new DialogueCutsceneComponent(curSong, () -> FlxG.switchState(() -> target));
		}

		return target;
	}
}
