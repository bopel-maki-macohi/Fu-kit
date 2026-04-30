package fukit.states;

import fukit.states.options.NewOptionsMenu;
import fukit.objects.Logo;
import flixel.FlxG;
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

	public var logo:Logo;

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

		menuList.addEntry('Story Mode', storymodeOption);
		menuList.addEntry('Freeplay', freeplayOption);
		menuList.addEntry('Options', optionsOption);
		menuList.addEntry('Exit', exitOption);

		menuList.addItem = addItem;
		menuList.onSelectionChange.add(onSelectionChange);

		menuList.regenItems();

		logo = new Logo();
		add(logo);

		logo.screenCenter();
		logo.y = -32;

		persistentUpdate = true;
	}

	override function beatHit()
	{
		super.beatHit();

		logo.anim.play('logoBumpin');
	}

	function storymodeOption() {}

	function freeplayOption() {}

	function optionsOption()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		menuList.canSelect = false;

		FlxTween.tween(logo, {x: logo.x + FlxG.width}, 4, {
			ease: FlxEase.sineInOut
		});
		FlxTween.tween(blackBox, {x: blackBox.x + FlxG.width}, 2, {
			ease: FlxEase.sineInOut
		});
		FlxTween.tween(menuList, {x: menuList.x + FlxG.width}, 2, {
			ease: FlxEase.sineInOut
		});

		FlxTween.tween(backdrop.velocity, {x: -32}, 3, {
			ease: FlxEase.backInOut
		});

		openSubState(new NewOptionsMenu());
	}

	function exitOption()
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));
		Sys.sleep(1);
		Sys.exit(0);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		Global.playMainTheme();

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	function addItem(item:String)
	{
		var text:FlxText = new FlxText(0, 0, 0, item, 16);

		text.screenCenter();
		text.ID = menuList.members.length;

		if (menuList.type == Vertical)
			text.y = (text.ID * 60) + 60 + blackBox.y;
		else
			text.x = (text.ID * 120) + 60 + blackBox.x;

		menuList.add(text);
	}

	function onSelectionChange()
	{
		for (basic in menuList.members)
		{
			var text:FlxText = cast(basic, FlxText);

			if (text != null)
				text.color = (menuList.curSelect == text.ID) ? FlxColor.YELLOW : FlxColor.WHITE;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
