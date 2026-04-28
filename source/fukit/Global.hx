package fukit;

import flixel.util.FlxTimer;

class Global
{
	public static var watermarkText(get, never):String;

	static function get_watermarkText():String
	{
		if (Main.watermarks)
			return 'Fu-kit ${MainMenuState.modVer}' + ' (KE ${MainMenuState.kadeEngineVer})';

		return MainMenuState.modVer;
	}

	public static function goIntoSong(song:String = 'tutorial', difficulty:Int = 2, week:Int = 0, storymode:Bool = false)
	{
		var poop:String = Highscore.formatSong(song.toLowerCase(), difficulty);

		PlayState.SONG = Song.loadFromJson(poop, song.toLowerCase());
		PlayState.isStoryMode = storymode;
		PlayState.storyDifficulty = difficulty;
		PlayState.storyWeek = week;

		LoadingState.loadAndSwitchState(new PlayState());
	}

	public static function goIntoWeek(songs:Array<String>, difficulty:Int = 2, week:Int = 0, storymode:Bool = true)
	{
		PlayState.storyPlaylist = songs;
		PlayState.campaignScore = 0;

		goIntoSong(PlayState.storyPlaylist[0], difficulty, week, storymode);
	}
}
