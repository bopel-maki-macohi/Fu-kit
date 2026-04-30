package fukit.states;

import flixel.text.FlxText;
import fukit.states.ui.MenuList;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;

class NewMenuState extends MusicBeatState
{
	public var backdrop:FlxBackdrop;

	public var menuList:MenuList;

	override function create()
	{
		super.create();

		backdrop = new FlxBackdrop(Paths.image('tile', 'fu-kit'));
		add(backdrop);
		backdrop.scale.set(6, 6);
		backdrop.velocity.set(32, 32);

		backdrop.antialiasing = false;

		menuList = new MenuList(Vertical);
		add(menuList);

		menuList.items.set('Story Mode', null);
		menuList.items.set('Freeplay', null);
		menuList.items.set('Options', null);
		menuList.items.set('Exit', () -> Sys.exit(0));

		menuList.addItem = function(item:String)
		{
			var text:FlxText = new FlxText(0, 0, 0, item, 16);

			if (menuList.type == Vertical)
				text.y = (menuList.members.length * 60) + 200;
			else
				text.x = (menuList.members.length * 120) + 200;

			menuList.add(text);
		}

		menuList.regenItems();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMainTheme();
	}
}
