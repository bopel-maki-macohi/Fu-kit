package fukit.states.storymode;

import fukit.play.StringToStage;
import fukit.play.songs.SongList.SongEntry;
import fukit.play.components.StageComponent;
import flixel.FlxBasic;
import flixel.math.FlxMath;
import fukit.states.ui.ScoreBox;
import flixel.text.FlxText;
import fukit.play.songs.SongList.SongListManager;
import fukit.states.ui.MenuList;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class NewStoryMode extends MusicBeatSubstate
{
	public var blackBar:FlxSprite;

	public var worldsMenuList:MenuList;
	public var worldStages:Array<String> = [];

	public var difficultyMenuList:MenuList;

	public var scoreBox:ScoreBox;

	public var stageComponents:Map<String, StageComponent> = [];
	public var stageObjects:Map<String, Array<FlxSprite>> = [];

	override public function new()
	{
		super();

		closeCallback = drawOnLeave;
	}

	override function create()
	{
		super.create();

		blackBar = new FlxSprite().makeGraphic(Math.round(FlxG.width * 1.5), Math.round(FlxG.height * 0.5), FlxColor.BLACK);
		blackBar.alpha = 0;

		FlxTween.tween(blackBar, {alpha: 1}, 1, {
			ease: FlxEase.expoInOut
		});

		difficultyMenuList = new MenuList(Vertical);

		difficultyMenuList.addItem = item -> Global.addTextMenuListItem(difficultyMenuList, item, 0, 0);
		difficultyMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(difficultyMenuList));

		for (diffculty in CoolUtil.difficultyArray)
			difficultyMenuList.addEntry(diffculty, null);

		difficultyMenuList.regenItems();
		difficultyMenuList.x = -FlxG.width;

		worldsMenuList = new MenuList(Horizontal);

		worldsMenuList.addItem = item -> Global.addTextMenuListItem(worldsMenuList, item, 0, 0);
		worldsMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(worldsMenuList));

		for (index => world in SongListManager.worldList)
		{
			final songs:Array<String> = SongListManager.worldSongLists[index];

			if (world.stage != null)
			{
				var stageComp:StageComponent = StringToStage.convert(world.stage);

				if (stageComp != null)
				{
					if (!stageObjects.exists(world.stage))
					{
						stageComp.makeStage();

						stageComponents.set(world.stage, stageComp);
						stageObjects.set(world.stage, stageComp.members);

						for (sprite in stageComp.members)
						{
							sprite.alpha = 0;
							add(sprite);
						}
					}

					// trace('Nonnull stageComp: ${world.stage}');
					worldStages.push(world.stage);
				}
				else
				{
					// trace('Null stageComp: ${world.stage}');
					worldStages.push(null);
				}
			}

			worldsMenuList.addEntry(world.header, function()
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				worldsMenuList.canSelect = false;
				Global.goIntoWeek(songs, difficultyMenuList.curSelect, index);
			});
		}

		worldsMenuList.y = -FlxG.height;

		worldsMenuList.canSelect = false;
		worldsMenuList.regenItems();

		FlxTween.tween(difficultyMenuList, {x: 0}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(worldsMenuList, {y: -128}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				worldsMenuList.canSelect = true;
			}
		});

		scoreBox = new ScoreBox();

		scoreBox.x = FlxG.width + scoreBox.width;
		scoreBox.y = FlxG.height - scoreBox.height;

		FlxTween.tween(scoreBox, {x: FlxG.width - scoreBox.width, alpha: .6}, 1, {
			ease: FlxEase.expoInOut,
		});

		blackBar.screenCenter();
		blackBar.y = 0;

		add(blackBar);
		add(difficultyMenuList);
		add(worldsMenuList);
		add(scoreBox);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		difficultyMenuList.canSelect = worldsMenuList.canSelect;

		updateScoreText();

		updateCurrentStageStuff();

		if (controls.BACK)
			leave();
	}

	var curStage:String;

	function updateCurrentStageStuff()
	{
		curStage = worldStages[worldsMenuList.curSelect] ?? null;

		for (stage => objects in stageObjects)
		{
			for (sprite in objects)
				sprite.alpha = FlxMath.lerp(sprite.alpha, (curStage == stage) ? 1 : 0, .1);
		}
	}

	var curSongScore:Float = 0;

	function updateScoreText()
	{
		var songScore:Float = Highscore.getWeekScore(worldsMenuList.curSelect, difficultyMenuList.curSelect);

		curSongScore = FlxMath.lerp(curSongScore, songScore, .2);

		scoreBox.text = 'HIGHSCORE:\n${Math.round(curSongScore)}';
	}

	public function leave()
	{
		FlxG.sound.play(Paths.sound('cancelMenu'));

		worldStages = [];

		FlxTween.cancelTweensOf(blackBar);
		FlxTween.tween(blackBar, {alpha: 0}, .3, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				close();
			}
		});

		FlxTween.cancelTweensOf(difficultyMenuList);
		FlxTween.cancelTweensOf(worldsMenuList);

		worldsMenuList.canSelect = false;
		FlxTween.tween(worldsMenuList, {y: -FlxG.height}, .3, {ease: FlxEase.expoInOut});
		FlxTween.tween(difficultyMenuList, {x: -FlxG.width}, .3, {ease: FlxEase.expoInOut});

		FlxTween.cancelTweensOf(scoreBox);

		FlxTween.tween(scoreBox, {x: FlxG.width + scoreBox.width, alpha: .6}, 1, {
			ease: FlxEase.expoInOut,
		});
	}
}
