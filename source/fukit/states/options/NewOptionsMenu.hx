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
			'Song Position Bar',
			'Downscroll Layout',
			#if desktop
			'Rainbow FPS',
			#end
			'Accuracy Information Display',
			'NPS Display',
		],
		'misc' => [#if desktop 'FPS Counter', #end 'Watermarks'],
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

		optionsMenuList.items.clear();

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

		optionsMenuList.x = -FlxG.width;

		loadMenu('categories');
		optionsMenuList.canSelect = false;

		FlxTween.tween(optionsMenuList, {x: 0}, 4, {
			ease: FlxEase.expoOut,
			onComplete: t ->
			{
				optionsMenuList.canSelect = true;
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		blackBox.scale.set(optionsMenuList.width, optionsMenuList.height);
		blackBox.screenCenter();

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));

			FlxTween.cancelTweensOf(optionsMenuList);
			optionsMenuList.canSelect = false;
			FlxTween.tween(optionsMenuList, {x: -FlxG.width}, 2, {
				ease: FlxEase.expoOut,
			});

			close();
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

	function getItem(s:String):String
	{
		trace('get(${currentMenu}_${s.toLowerCase()})');

		switch (s.toLowerCase()) {}

		return s;
	}

	function onItem(s:String)
	{
		trace('on(${currentMenu}_${s})');

		switch (s) {}
	}
}
