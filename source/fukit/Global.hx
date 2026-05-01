package fukit;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import fukit.states.ui.MenuList;
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
		return 'Fu-kit ${modVer}' + ' (KE ${kadeEngineVer})';
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

	public static function addTextMenuListItem(menuList:MenuList, item:String, ?verticalOffset:Float = 0, ?horizontalOffset:Float = 0)
	{
		var text:FlxText = new FlxText(0, 0, 0, item, 16);

		text.screenCenter();
		text.ID = menuList.members.length;

		if (menuList.type == Vertical)
			text.y = (text.ID * 60) + 60 + verticalOffset;
		else
			text.x = (text.ID * 120) + 60 + horizontalOffset;

		menuList.add(text);
	}

	public static function onTextSelectionChange(menuList:MenuList)
	{
		for (basic in menuList.members)
		{
			var text:FlxText = cast(basic, FlxText);

			if (text != null)
				text.color = (menuList.curSelect == text.ID) ? FlxColor.YELLOW : FlxColor.WHITE;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
