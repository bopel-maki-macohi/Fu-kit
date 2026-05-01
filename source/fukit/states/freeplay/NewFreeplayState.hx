package fukit.states.freeplay;

import fukit.play.songs.SongList.SongListManager;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import fukit.states.ui.MenuList;

class NewFreeplayState extends MusicBeatSubstate
{
	public var freeplayMenuList:MenuList;

	public var blackBox:FlxSprite;

	override public function new()
	{
		super();

		closeCallback = drawOnLeave;
	}

	public var curDifficulty:Int = 2;

	override function create()
	{
		super.create();

		blackBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		add(blackBox);
		blackBox.alpha = 0;

		freeplayMenuList = new MenuList(Vertical);
		add(freeplayMenuList);

		freeplayMenuList.addItem = item -> Global.addTextMenuListItem(freeplayMenuList, item, 0, 0);
		freeplayMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(freeplayMenuList));

		for (song in SongListManager.songList.songs)
		{
			freeplayMenuList.addEntry(song.name, () ->
			{
				freeplayMenuList.canSelect = false;
				Global.goIntoSong(song.name, curDifficulty, song.world);
			});
		}
		freeplayMenuList.regenItems();

		FlxTween.tween(freeplayMenuList, {x: 0}, 2.2, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				freeplayMenuList.canSelect = true;
			}
		});

		FlxTween.tween(blackBox, {alpha: .3}, 2.2, {
			ease: FlxEase.expoInOut,
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		freeplayMenuList.screenCenter(Y);

		blackBox.scale.x = FlxMath.lerp(blackBox.scale.x, freeplayMenuList.width * 1.5, .1);
		blackBox.scale.y = FlxMath.lerp(blackBox.scale.y, FlxG.height, .1);
		blackBox.updateHitbox();

		blackBox.x = freeplayMenuList.members[0].getGraphicMidpoint().x - (blackBox.width / 2);

		if (controls.BACK && freeplayMenuList.canSelect)
			leave();
	}

	function leave()
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));

		FlxTween.cancelTweensOf(freeplayMenuList);
		FlxTween.cancelTweensOf(blackBox);

		freeplayMenuList.canSelect = false;

		FlxTween.tween(freeplayMenuList, {x: -FlxG.width}, 2.2, {
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
