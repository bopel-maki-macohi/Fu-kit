package fukit.states.options;

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

	function loadMenu(menu:String)
	{
		if (optionsMenuList == null)
			return;

		menu = menu.toLowerCase();

		if (!optionsMenus.exists(menu))
			return;

		trace(optionsMenus.get(menu));

		if (optionsMenus.get(menu).length < 1)
			return;

		for (key => item in optionsMenuList.items)
		{
			optionsMenuList.items.remove(key);
		};

		currentMenu = menu;
		for (item in optionsMenus.get(menu))
			optionsMenuList.addEntry(item, () -> onItem(item.toLowerCase()));

		optionsMenuList.regenItems();
	}

	override function create()
	{
		super.create();

		blackBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		add(blackBox);

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
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		optionsMenuList.screenCenter(Y);

		blackBox.scale.set(optionsMenuList.width * 1.1, optionsMenuList.height * 1.1);
		blackBox.updateHitbox();

		blackBox.screenCenter(Y);

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
		trace('get(${currentMenu} : ${s})');

		switch (s.toLowerCase()) {}

		return s;
	}

	function onItem(s:String)
	{
		trace('on(${currentMenu} : ${s})');

		switch (s)
		{
			case 'gameplay', 'appearence', 'misc':
				if (currentMenu == 'categories')
					loadMenu(s);
			case 'back':
				if (currentMenu != 'categories')
					loadMenu('categories');
				else
					leave();
		}
	}

	function leave()
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));

		FlxTween.cancelTweensOf(optionsMenuList);

		optionsMenuList.canSelect = false;

		FlxTween.tween(optionsMenuList, {x: -FlxG.width}, 2.2, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				close();
			}
		});
	}
}
