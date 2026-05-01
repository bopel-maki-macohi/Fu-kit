package fukit.states.storymode;

import fukit.play.songs.SongList.SongListManager;
import fukit.states.ui.MenuList;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class NewStoryMode extends MusicBeatSubstate
{
	public var blackScreen:FlxSprite;

	public var worldsMenuList:MenuList;
	public var difficultyMenuList:MenuList;

	override public function new()
	{
		super();

		closeCallback = drawOnLeave;
	}

	override function create()
	{
		super.create();

		blackScreen = new FlxSprite().makeGraphic(Math.round(FlxG.width * 1.5), Math.round(FlxG.height * 1.5), FlxColor.BLACK);
		add(blackScreen);

		blackScreen.alpha = 0;

		FlxTween.tween(blackScreen, {alpha: 1}, 1, {
			ease: FlxEase.expoInOut
		});

		difficultyMenuList = new MenuList(Vertical);
		add(difficultyMenuList);

		difficultyMenuList.addItem = item -> Global.addTextMenuListItem(difficultyMenuList, item, 0, 0);
		difficultyMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(difficultyMenuList));

		for (diffculty in CoolUtil.difficultyArray)
			difficultyMenuList.addEntry(diffculty, null);

		difficultyMenuList.regenItems();
		difficultyMenuList.x = -FlxG.width;

		worldsMenuList = new MenuList(Horizontal);
		add(worldsMenuList);

		worldsMenuList.addItem = item -> Global.addTextMenuListItem(worldsMenuList, item, 0, 0);
		worldsMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(worldsMenuList));

		for (index => world in SongListManager.worldList)
		{
			worldsMenuList.addEntry(world.header, function()
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				
				worldsMenuList.canSelect = false;
				Global.goIntoWeek(SongListManager.worldSongLists[index], difficultyMenuList.curSelect, index);
			});
		}

		worldsMenuList.y = -FlxG.height;

		worldsMenuList.canSelect = false;
		worldsMenuList.regenItems();

		FlxTween.tween(difficultyMenuList, {x: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(worldsMenuList, {y: 0}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				worldsMenuList.canSelect = true;
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		difficultyMenuList.screenCenter(Y);
		worldsMenuList.screenCenter(X);

		difficultyMenuList.canSelect = worldsMenuList.canSelect;

		if (controls.BACK)
			leave();
	}

	public function leave()
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));

		FlxTween.cancelTweensOf(blackScreen);
		FlxTween.tween(blackScreen, {alpha: 0}, .3, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				close();
			}
		});

		FlxTween.cancelTweensOf(difficultyMenuList);
		FlxTween.cancelTweensOf(worldsMenuList);

		worldsMenuList.canSelect = false;
		FlxTween.tween(difficultyMenuList, {x: 0}, .3, {ease: FlxEase.expoInOut});
		FlxTween.tween(worldsMenuList, {y: 0}, .3, {ease: FlxEase.expoInOut});
	}
}
