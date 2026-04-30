package fukit.states.options;

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

	var currentMenu:String = '';

	function loadMenu(menu:String)
	{
		if (!optionsMenus.exists(menu.toLowerCase()))
			return;
		if (optionsMenus.get(menu.toLowerCase()).length > 0)
			return;
		if (optionsMenuList != null)
			return;

		optionsMenuList.items.clear();

		currentMenu = menu;
		for (item in optionsMenus.get(menu.toLowerCase()))
			optionsMenuList.addEntry(item, () -> onItem(item.toLowerCase()));

		optionsMenuList.regenItems();
	}

	override function create()
	{
		super.create();

		optionsMenuList = new MenuList(Vertical);
		add(optionsMenuList);

		loadMenu('categories');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
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
