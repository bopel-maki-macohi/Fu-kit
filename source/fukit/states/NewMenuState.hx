package fukit.states;

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

		menuList.regenItems();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMainTheme();
	}
}
