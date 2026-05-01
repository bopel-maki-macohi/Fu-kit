package fukit.states.freeplay;

import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.text.FlxText;
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
	public var songMenuList:MenuList;
	public var difficultyMenuList:MenuList;

	public var songBlackBox:FlxSprite;
	public var difficultyBlackBox:FlxSprite;
	public var scoreBlackBox:FlxSprite;

	public var scoreText:FlxText;

	override public function new()
	{
		super();

		closeCallback = drawOnLeave;
	}

	override function create()
	{
		super.create();

		songBlackBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		add(songBlackBox);
		songBlackBox.alpha = 0;

		songMenuList = new MenuList(Vertical);
		add(songMenuList);

		difficultyBlackBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		add(difficultyBlackBox);
		difficultyBlackBox.alpha = 0;

		difficultyMenuList = new MenuList(Horizontal);
		add(difficultyMenuList);

		songMenuList.addItem = item -> Global.addTextMenuListItem(songMenuList, item, 0, 0);
		songMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(songMenuList));

		difficultyMenuList.addItem = item -> Global.addTextMenuListItem(difficultyMenuList, item, 0, 0);
		difficultyMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(difficultyMenuList));

		for (song in SongListManager.songList)
		{
			songMenuList.addEntry(song.name, () ->
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				songMenuList.canSelect = false;
				Global.goIntoSong(song.name, difficultyMenuList.curSelect, song.world);
			});
		}
		songMenuList.regenItems();
		songMenuList.x = -FlxG.width;

		for (diffculty in CoolUtil.difficultyArray)
			difficultyMenuList.addEntry(diffculty, null);

		difficultyMenuList.regenItems();
		difficultyMenuList.y = -FlxG.height;

		songMenuList.canSelect = false;

		scoreBlackBox = new FlxSprite();
		scoreBlackBox.makeGraphic(320, 160, FlxColor.BLACK);
		add(scoreBlackBox);
		scoreBlackBox.alpha = 0;

		scoreBlackBox.x = FlxG.width + scoreBlackBox.width;
		scoreBlackBox.y = FlxG.height - scoreBlackBox.height;

		scoreText = new FlxText(0, 0, scoreBlackBox.width, 'Bob', 32);
		add(scoreText);

		scoreText.alignment = CENTER;

		FlxTween.tween(songMenuList, {x: -(FlxG.width / 4)}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				songMenuList.canSelect = true;
			}
		});

		FlxTween.tween(songBlackBox, {alpha: .3}, 1, {
			ease: FlxEase.expoInOut,
		});

		FlxTween.tween(difficultyMenuList, {y: -(FlxG.height / 4)}, 1, {
			ease: FlxEase.expoInOut,
		});

		FlxTween.tween(difficultyBlackBox, {alpha: .3}, 1, {
			ease: FlxEase.expoInOut,
		});

		FlxTween.tween(scoreBlackBox, {x: FlxG.width - scoreBlackBox.width, alpha: .6}, 1, {
			ease: FlxEase.expoInOut,
		});

		songMenuListCam = new FlxCamera(0, 0);
		FlxG.cameras.add(songMenuListCam, false);
		songMenuListCam.bgColor.alpha = 0;

		songBlackBox.camera = songMenuListCam;
		songMenuList.camera = songMenuListCam;

		songMenuListCamFollowOBJ = new FlxObject(640, 0);
		add(songMenuListCamFollowOBJ);

		songMenuListCam.follow(songMenuListCamFollowOBJ, LOCKON, 0.5);

		songBlackBox.scrollFactor.set(0, 0);
	}

	public var songMenuListCam:FlxCamera;
	public var songMenuListCamFollowOBJ:FlxObject;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		difficultyMenuList.canSelect = songMenuList.canSelect;

		songMenuList.screenCenter(Y);
		difficultyMenuList.screenCenter(X);

		songBlackBox.scale.x = FlxMath.lerp(songBlackBox.scale.x, songMenuList.width * 1.5, .1);
		songBlackBox.scale.y = FlxMath.lerp(songBlackBox.scale.y, FlxG.height, .1);
		songBlackBox.updateHitbox();

		songBlackBox.x = songMenuList.members[0].getGraphicMidpoint().x - (songBlackBox.width / 2);

		difficultyBlackBox.scale.x = FlxMath.lerp(difficultyBlackBox.scale.x, FlxG.width, .1);
		difficultyBlackBox.scale.y = FlxMath.lerp(difficultyBlackBox.scale.y, difficultyMenuList.height * 1.5, .1);
		difficultyBlackBox.updateHitbox();

		difficultyBlackBox.y = difficultyMenuList.members[0].getGraphicMidpoint().y - (difficultyBlackBox.height / 2);

		scoreText.x = scoreBlackBox.x;
		scoreText.y = scoreBlackBox.y + scoreText.height / 2;

		updateScoreText();

		songMenuListCamFollowOBJ.y = 0 + songMenuList.members[songMenuList.curSelect].y;

		if (controls.BACK && songMenuList.canSelect)
			leave();
	}

	var curSongScore:Float = 0;

	function updateScoreText()
	{
		var songScore:Float = Highscore.getScore(songMenuList.itemKeys[songMenuList.curSelect], difficultyMenuList.curSelect);

		curSongScore = FlxMath.lerp(curSongScore, songScore, .2);

		scoreText.text = 'HIGHSCORE:\n${Math.round(curSongScore)}';
	}

	function leave()
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));

		FlxTween.cancelTweensOf(songMenuList);
		FlxTween.cancelTweensOf(songBlackBox);

		FlxTween.cancelTweensOf(difficultyMenuList);
		FlxTween.cancelTweensOf(difficultyBlackBox);

		FlxTween.cancelTweensOf(scoreText);
		FlxTween.cancelTweensOf(scoreBlackBox);

		songMenuList.canSelect = false;

		FlxTween.tween(songMenuList, {x: -FlxG.width}, .5, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				close();
			}
		});

		FlxTween.tween(songBlackBox, {alpha: 0}, .5, {
			ease: FlxEase.expoInOut,
		});

		FlxTween.tween(difficultyMenuList, {y: -FlxG.height}, .5, {
			ease: FlxEase.expoInOut,
		});

		FlxTween.tween(difficultyBlackBox, {alpha: 0}, .5, {
			ease: FlxEase.expoInOut,
		});

		FlxTween.tween(scoreBlackBox, {x: FlxG.width + scoreBlackBox.width, alpha: 0}, .5, {
			ease: FlxEase.expoInOut,
		});
	}
}
