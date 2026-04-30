package fukit.states;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import fukit.states.ui.MenuList;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;

class NewMenuState extends MusicBeatState
{
	public var backdrop:FlxBackdrop;

	public var blackBox:FlxSprite;

	public var menuList:MenuList;

	override function create()
	{
		super.create();

		backdrop = new FlxBackdrop(Paths.image('tile', 'fu-kit'));
		add(backdrop);
		backdrop.scale.set(6, 6);
		backdrop.velocity.set(32, 32);

		backdrop.antialiasing = false;

		blackBox = new FlxSprite().makeGraphic(240, 320, FlxColor.BLACK);
		blackBox.screenCenter();
		add(blackBox);

		blackBox.y += 160;

		menuList = new MenuList(Vertical);
		add(menuList);

		menuList.addEntry('Story Mode', null);
		menuList.addEntry('Freeplay', null);
		menuList.addEntry('Options', null);
		menuList.addEntry('Exit', () -> Sys.exit(0));

		menuList.addItem = function(item:String)
		{
			var text:FlxText = new FlxText(0, 0, 0, item, 16);

			text.screenCenter();
			if (menuList.type == Vertical)
				text.y = (menuList.members.length * 60) + 60 + blackBox.y;
			else
				text.x = (menuList.members.length * 120) + 60 + blackBox.x;
			text.ID = menuList.members.length;

			menuList.add(text);
		}

		menuList.onSelectionChange.add(function()
		{
			for (basic in menuList.members)
			{
				var text:FlxText = cast(basic, FlxText);

				if (text != null)
					text.color = (menuList.curSelect == text.ID) ? FlxColor.YELLOW : FlxColor.WHITE;
			}
		});

		menuList.regenItems();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMainTheme();
	}
}
