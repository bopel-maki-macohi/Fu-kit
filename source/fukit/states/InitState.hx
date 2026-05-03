package fukit.states;

import fukit.play.songs.SongList;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import fukit.util.debug.CrashHandler;
import fukit.util.plugins.ScreenshotPlugin;
import flixel.FlxSprite;
import flixel.FlxG;
import lime.app.Application;
import Discord.DiscordClient;
import flixel.FlxState;
import fukit.util.macros.DefineMacro;

class InitState extends FlxState
{
	override function create()
	{
		super.create();

		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end

		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			for (id => library in lime.utils.Assets.libraries)
			{
				var libraryAssets = [];

				for (asset in library.list('BINARY'))
					if (StringTools.startsWith(asset, 'assets/'))
						libraryAssets.push(asset);

				trace('${id.toUpperCase()} : ${libraryAssets.length} asset(s)');
				// trace(' - ' + libraryAssets);
			}
		}

		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end

		FlxG.save.bind('fu-kit', 'Maki');

		function saveOnExit(i)
		{
			FlxG.save.flush();
		}

		if (!Application.current.onExit.has(saveOnExit))
			Application.current.onExit.add(saveOnExit);

		KadeEngineData.initSave();

		Highscore.load();

		FlxSprite.defaultAntialiasing = true;

		ScreenshotPlugin.init();
		CrashHandler.init();

		var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
		diamond.persist = true;
		diamond.destroyOnNoUse = false;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1), {asset: diamond, width: 32, height: 32},
			new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

		Paths.setCurrentLevel('fu-kit');

		SongListManager.reloadSongList();

		FlxG.mouse.visible = false;

		FlxG.switchState(() -> new FocusState());
	}

	public static function moveStates()
	{
		var MAINMENU:String = DefineMacro.definedValue('MAINMENU')?.toLowerCase();
		var CHARTING:String = DefineMacro.definedValue('CHARTING');
		var ANIMDEBUG:String = DefineMacro.definedValue('ANIMDEBUG');
		var SONG:String = DefineMacro.definedValue('SONG');
		var SONG_DIFFICULTY:String = DefineMacro.definedValue('SONG_DIFFICULTY')?.toUpperCase();

		var diff:Int = CoolUtil.difficultyArray.indexOf(SONG_DIFFICULTY ?? 'NORMAL');

		if (diff == -1)
			diff = 1;

		if (MAINMENU != null)
		{
			switch (MAINMENU)
			{
				case 'story', 'storymode', 'storymenu', 'story mode', 'story menu': FlxG.switchState(() -> new NewMenuState('Story Mode'));
				case 'freeplay', 'free play': FlxG.switchState(() -> new NewMenuState('Freeplay'));
				case 'settings', 'options', 'config', 'configurations': FlxG.switchState(() -> new NewMenuState('Options'));

				default: FlxG.switchState(() -> new NewMenuState());
			}
		}
		else if (CHARTING != null)
		{
			PlayState.SONG = Song.testSong;

			if (CHARTING != '1')
				PlayState.SONG = Song.loadFromJson(Highscore.formatSong(CHARTING, diff), CHARTING) ?? null;

			if (SONG != null && SONG != '1')
				PlayState.SONG = Song.loadFromJson(Highscore.formatSong(SONG, diff), SONG) ?? null;

			if (PlayState.SONG == null)
			{
				PlayState.SONG = Song.testSong;

				if (CHARTING != '1')
					PlayState.SONG.song = CHARTING;

				if (SONG != null && SONG != '1')
					PlayState.SONG.song = SONG;
			}

			FlxG.switchState(() -> new ChartingState());
		}
		else if (ANIMDEBUG != null)
			FlxG.switchState(() -> new AnimationDebug(ANIMDEBUG ?? 'bf'));
		else if (SONG != null && SONG != '1')
			fukit.Global.goIntoSong(SONG, diff, 0);
		else
			FlxG.switchState(() -> new SplashTextState());
	}
}
