package fukit;

import lime.app.Application;
import flixel.FlxG;
import flixel.util.FlxTimer;

class Global
{
	public static var modVer(get, never):String;

	static function get_modVer():String
	{
		return Application.current.meta.get('version');
	}

	public static final kadeEngineVer:String = '1.4.2';

	public static var watermarkText(get, never):String;

	static function get_watermarkText():String
	{
		if (Main.watermarks)
			return 'Fu-kit ${modVer}' + ' (KE ${kadeEngineVer})';

		return modVer;
	}

	public static function goIntoSong(song:String = 'tutorial', difficulty:Int = 2, week:Int = 0, storymode:Bool = false, offsetTesting:Bool = false)
	{
		var poop:String = Highscore.formatSong(song.toLowerCase(), difficulty);

		PlayState.SONG = Song.loadFromJson(poop, song.toLowerCase());
		PlayState.isStoryMode = storymode;
		PlayState.storyDifficulty = difficulty;
		PlayState.storyWeek = week;
		PlayState.offsetTesting = offsetTesting;

		LoadingState.loadAndSwitchState(new PlayState());
	}

	public static function goIntoWeek(songs:Array<String>, difficulty:Int = 2, week:Int = 0, storymode:Bool = true)
	{
		PlayState.storyPlaylist = songs;
		PlayState.campaignScore = 0;

		goIntoSong(PlayState.storyPlaylist[0], difficulty, week, storymode);
	}

	public static function playMainTheme()
	{
		if (FlxG.sound.music != null && FlxG.sound.music?.playing)
			return;

		Conductor.changeBPM(120);
		FlxG.sound.playMusic(Paths.music('MainTheme', 'fu-kit'));
	}
}
