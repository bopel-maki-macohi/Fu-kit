package fukit.states;

import fukit.play.songs.SongList;
import flixel.math.FlxRect;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.addons.transition.FlxTransitionSprite;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import fukit.debug.CrashHandler;
import fukit.plugins.ScreenshotPlugin;
import flixel.FlxSprite;
import flixel.FlxG;
import lime.app.Application;
import Discord.DiscordClient;
import flixel.FlxState;

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

		#if FREEPLAY
		FlxG.switchState(() -> new NewMenuState('Freeplay'));
		#elseif CHARTING
		FlxG.switchState(() -> new ChartingState());
		#elseif ANIMDEBUG
		FlxG.switchState(() -> new AnimationDebug('folir'));
		#elseif SONG
		fukit.Global.goIntoSong('Termination', #if DIFF_EASY 0 #elseif DIFF_NORMAL 1 #else 2 #end, 0);
		#elseif STORYMENU
		FlxG.switchState(() -> new NewMenuState('Story Mode'));
		#elseif OPTIONS
		FlxG.switchState(() -> new NewMenuState('Options'));
		#elseif MAINMENU
		FlxG.switchState(() -> new NewMenuState());
		#else
		FlxG.switchState(() -> new SplashTextState());
		#end
	}
}
