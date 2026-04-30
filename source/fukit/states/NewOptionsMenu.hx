package fukit.states;

import flixel.math.FlxMath;
import openfl.Lib;
import Controls.KeyboardScheme;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import fukit.states.ui.MenuList;
import flixel.FlxG;

class NewOptionsMenu extends MusicBeatSubstate
{
	public var optionsMenuList:MenuList;

	public var optionsMenus:Map<String, Array<String>> = [
		'categories' => ['Gameplay', 'Appearence', 'Misc',],
		'gameplay' => [
			'Back',
			'DFJK Keybinds',
			'Hit Timings / Safe Frames',
			#if desktop
			'FPS Cap',
			#end
			'Custom Scroll Speed',
			'Accuracy Calculation',
			'Offset Changing',
		],
		'appearence' => [
			'Back',
			'Song Position Bar',
			'Downscroll Layout',
			#if desktop
			'Rainbow FPS',
			#end
			'Accuracy Information Display',
			'NPS Display',
		],
		'misc' => ['Back', #if desktop 'FPS Counter', #end 'Watermarks'],
	];

	public var currentMenu:String = '';

	public var blackBox:FlxSprite;

	override public function new()
	{
		super();

		closeCallback = drawOnLeave;
	}

	function loadMenu(menu:String)
	{
		if (optionsMenuList == null)
			return;

		menu = menu.toLowerCase();

		if (!optionsMenus.exists(menu))
			return;

		// trace(optionsMenus.get(menu));

		if (optionsMenus.get(menu).length < 1)
			return;

		optionsMenuList.clearList();

		currentMenu = menu;
		for (item in optionsMenus.get(menu))
			optionsMenuList.addEntry(item, () -> onItem(item.toLowerCase()));

		// trace(optionsMenuList.itemKeys);

		optionsMenuList.regenItems();
	}

	override function create()
	{
		super.create();

		blackBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		add(blackBox);
		blackBox.alpha = 0;

		optionsMenuList = new MenuList(Vertical);
		add(optionsMenuList);
		optionsMenuList.addItem = addItem;
		optionsMenuList.onSelectionChange.add(onSelectionChange);

		optionsMenuList.x = -FlxG.width;

		loadMenu('categories');
		optionsMenuList.canSelect = false;

		FlxTween.tween(optionsMenuList, {x: 0}, 2.2, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				optionsMenuList.canSelect = true;
			}
		});

		FlxTween.tween(blackBox, {alpha: .3}, 2.2, {
			ease: FlxEase.expoInOut,
		});
	}

	public var savedCurSelect:Int = 0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		optionsMenuList.screenCenter(Y);

		blackBox.scale.x = FlxMath.lerp(blackBox.scale.x, optionsMenuList.width * 1.5, .1);
		blackBox.scale.y = FlxMath.lerp(blackBox.scale.y, FlxG.height, .1);
		blackBox.updateHitbox();

		blackBox.x = optionsMenuList.members[0].getGraphicMidpoint().x - (blackBox.width / 2);

		if (controls.BACK && optionsMenuList.canSelect)
		{
			leave();
		}
	}

	function addItem(item:String)
	{
		var text:FlxText = new FlxText(0, 0, 0, getItem(item), 16);

		text.screenCenter();
		text.ID = optionsMenuList.members.length;

		if (optionsMenuList.type == Vertical)
			text.y = (text.ID * 60) + 60;
		else
			text.x = (text.ID * 120) + 60;

		optionsMenuList.add(text);
	}

	function onSelectionChange()
	{
		for (basic in optionsMenuList.members)
		{
			var text:FlxText = cast(basic, FlxText);

			if (text != null)
				text.color = (optionsMenuList.curSelect == text.ID) ? FlxColor.YELLOW : FlxColor.WHITE;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function getItem(s:String):String
	{
		// trace('get(${currentMenu} : ${s})');

		switch (s.toLowerCase())
		{
			case 'dfjk keybinds':
				return '${(FlxG.save.data.dfjk) ? 'DFJK' : 'WASD'} Keybinds';

			case 'hit timings / safe frames':
				return '$s : ${Conductor.safeFrames} / 20';

			case 'fps cap':
				return 'FPS Cap: ${FlxG.save.data.fpsCap} / 290';

			case 'custom scroll speed':
				if (FlxG.save.data.scrollSpeed == 1)
					return 'Default Song Scroll Speed';

				return 'Custom Song Scroll Speed: ${FlxG.save.data.scrollSpeed} / 10.0';

			case 'accuracy calculation':
				return '$s : ${(FlxG.save.data.accuracyMod == 1) ? 'Complex' : 'Accurate'}';

			case 'song position bar':
				return '$s : ${(FlxG.save.data.songPosition) ? 'Enabled' : 'Disabled'}';

			case 'downscroll layout':
				return '${(FlxG.save.data.downscroll) ? 'Downscroll' : 'Upscroll'} Layout';

			case 'rainbow fps':
				return '$s : ${(FlxG.save.data.fpsRain) ? 'Enabled' : 'Disabled'}';

			case 'accuracy information display':
				return '$s : ${(FlxG.save.data.fpsRain) ? 'Enabled' : 'Disabled'}';

			case 'nps display':
				return '$s : ${(FlxG.save.data.npsDisplay) ? 'Enabled' : 'Disabled'}';

			case 'fps counter':
				return '$s : ${(FlxG.save.data.fps) ? 'Enabled' : 'Disabled'}';

			case 'watermarks':
				return '$s : ${(Main.watermarks) ? 'Enabled' : 'Disabled'}';
		}

		return s;
	}

	function onItem(s:String)
	{
		// trace('on(${currentMenu} : ${s})');

		var refresh:Bool = true;

		switch (s)
		{
			case 'gameplay', 'appearence', 'misc':
				refresh = false;

				if (currentMenu == 'categories')
					loadMenu(s);

			case 'back':
				refresh = false;

				if (currentMenu != 'categories')
					loadMenu('categories');
				else
					leave();

			case 'dfjk keybinds':
				FlxG.save.data.dfjk = !FlxG.save.data.dfjk;

				if (FlxG.save.data.dfjk)
					controls.setKeyboardScheme(KeyboardScheme.Solo, true);
				else
					controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

			case 'hit timings / safe frames':
				if (Conductor.safeFrames == 1)
					Conductor.safeFrames = 20;
				else
					Conductor.safeFrames -= 1;

				FlxG.save.data.frames = Conductor.safeFrames;

				Conductor.recalculateTimings();

			case 'fps cap':
				if (FlxG.save.data.fpsCap > 290)
					FlxG.save.data.fpsCap = 60;
				else
					FlxG.save.data.fpsCap = FlxG.save.data.fpsCap + 10;
				(cast(Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);

			case 'custom scroll speed':
				FlxG.save.data.scrollSpeed += 0.1;

				if (FlxG.save.data.scrollSpeed < 1)
					FlxG.save.data.scrollSpeed = 1;

				if (FlxG.save.data.scrollSpeed > 10)
					FlxG.save.data.scrollSpeed = 10;

			case 'accuracy calculation':
				FlxG.save.data.accuracyMod = FlxG.save.data.accuracyMod == 1 ? 0 : 1;

			case 'offset changing':
				Global.goIntoSong('Tutorial', 2, 0, false, true);

			case 'song position bar':
				FlxG.save.data.songPosition = !FlxG.save.data.songPosition;

			case 'downscroll layout':
				FlxG.save.data.downscroll = !FlxG.save.data.downscroll;

			case 'rainbow fps':
				FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
				(cast(Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);

			case 'accuracy information display':
				FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;

			case 'nps display':
				FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;

			case 'fps counter':
				FlxG.save.data.fps = !FlxG.save.data.fps;
				(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);

			case 'watermarks':
				Main.watermarks = !Main.watermarks;
				FlxG.save.data.watermark = Main.watermarks;
		}

		if (refresh)
		{
			savedCurSelect = optionsMenuList.curSelect;
			optionsMenuList.regenItems();

			optionsMenuList.curSelect = savedCurSelect;
			optionsMenuList.onSelectionChange.dispatch();
		}
	}

	function leave()
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));

		FlxTween.cancelTweensOf(optionsMenuList);
		FlxTween.cancelTweensOf(blackBox);

		optionsMenuList.canSelect = false;

		FlxTween.tween(optionsMenuList, {x: -FlxG.width}, 2.2, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				close();
			}
		});

		FlxTween.tween(blackBox, {alpha: 0}, 2.2, {
			ease: FlxEase.expoInOut,
		});
	}
}
