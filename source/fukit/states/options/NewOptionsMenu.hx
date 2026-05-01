package fukit.states.options;

import fukit.states.options.components.*;
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

	public var optionsMenus:Map<String, Array<OptionComponent>> = [];

	public var currentMenu:String = '';

	public var blackBox:FlxSprite;

	override public function new()
	{
		super();

		closeCallback = drawOnLeave;

		optionsMenus = [
			'categories' => [
				new OptionComponent('Gameplay', () -> loadMenu('Gameplay')),
				new OptionComponent('Appearence', () -> loadMenu('Appearence')),
				new OptionComponent('Misc', () -> loadMenu('Misc')),
			],
			'gameplay' => [
				new OptionComponent('Back', () -> loadMenu('Categories')),
				new DFJKOption(),
				new HitTimingsOption(),
				#if desktop
				new FPSCapOption(),
				#end
				new CustomScrollSpeedOption(),
				new AccuracyCalculationOption(),
				new OffsetChangingOption(),
			],
			'appearence' => [
				new OptionComponent('Back', () -> loadMenu('Categories')),
				new SongPositionOption(),
				new DownscrollOption(),
				#if desktop
				new RainbowFPSOption(),
				#end
				new AccuracyInformationDisplayOption(),
				new NPSDisplayOption(),
			],
			'misc' => [
				new OptionComponent('Back', () -> loadMenu('Categories')),
				#if desktop
				new FPSCounterOption(),
				#end
			],
		];
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

		for (item in optionsMenus.get(menu))
		{
			item.updateDisplay();

			optionsMenuList.addEntry(item.display, () ->
			{
				final lastMenu = currentMenu;

				item.method();

				if (FlxG.save.data.dfjk)
					controls.setKeyboardScheme(KeyboardScheme.Solo, true);
				else
					controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

				if (currentMenu == lastMenu)
				{
					savedCurSelect = optionsMenuList.curSelect;
					loadMenu(currentMenu);

					optionsMenuList.curSelect = savedCurSelect;
					optionsMenuList.onSelectionChange.dispatch();
				}
			});
		}

		// trace(optionsMenuList.itemKeys);

		currentMenu = menu;
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
			leave();
	}

	function addItem(item:String)
	{
		var text:FlxText = new FlxText(0, 0, 0, item, 16);

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
