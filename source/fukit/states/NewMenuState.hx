package fukit.states;

import fukit.objects.FukitSprite;
import fukit.states.storymode.NewStoryMode;
import fukit.states.freeplay.NewFreeplayState;
import flixel.util.FlxTimer;
import flixel.FlxSubState;
import fukit.states.options.NewOptionsMenu;
import fukit.objects.Logo;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import fukit.states.ui.MenuList;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;

class NewMenuState extends MusicBeatState
{
	public var backdrop:FlxBackdrop;

	public var blackBox:FukitSprite;
	public var menuList:MenuList;

	public var logo:Logo;

	public var inSubState:Bool = false;
	public var transitionedOut:Bool = false;

	var startingEntry:String;

	final backdropXSpeed:Float = 512;
	final backdropYSpeed:Float = 256;

	override public function new(?startingEntry:String)
	{
		super();

		this.startingEntry = startingEntry;
	}

	override function create()
	{
		super.create();

		backdrop = new FlxBackdrop(Paths.image('tile'));
		add(backdrop);
		backdrop.scale.set(6, 6);
		backdrop.velocity.set(backdropXSpeed, backdropYSpeed);

		FlxTween.tween(backdrop.velocity, {y: -backdropYSpeed}, 6, {ease: FlxEase.bounceInOut, type: PINGPONG});
		FlxTween.tween(backdrop.velocity, {x: -backdropXSpeed}, 3, {ease: FlxEase.bounceInOut, type: PINGPONG});

		backdrop.antialiasing = false;

		blackBox = new FukitSprite();
		blackBox.makeGraphic(240, 320, FlxColor.BLACK);
		blackBox.screenCenter();
		add(blackBox);
		blackBox.alpha = .3;

		blackBox.y += 160;

		menuList = new MenuList(Vertical);
		add(menuList);

		menuList.addEntry('Story Mode', storymodeOption);
		menuList.addEntry('Freeplay', freeplayOption);
		menuList.addEntry('Options', optionsOption);
		menuList.addEntry('Exit', exitOption);

		menuList.addItem = item -> Global.addTextMenuListItem(menuList, item, blackBox.y, blackBox.x);
		menuList.onSelectionChange.add(() -> Global.onTextSelectionChange(menuList));

		menuList.regenItems();

		logo = new Logo();
		add(logo);

		logo.screenCenter();
		logo.y = -32;

		persistentUpdate = true;

		if (startingEntry != null)
		{
			FlxTimer.wait(transIn?.duration ?? 1, () ->
			{
				menuList.accept(startingEntry);
				startingEntry = null;
			});
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logo.anim.play('logoBumpin');
	}

	function storymodeOption()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		transitionTweens(false);
		openSubState(new NewStoryMode());
	}

	function freeplayOption()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		transitionTweens(false);
		openSubState(new NewFreeplayState());
	}

	function optionsOption()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		transitionTweens(false);
		openSubState(new NewOptionsMenu());
	}

	override function openSubState(SubState:FlxSubState)
	{
		inSubState = true;

		super.openSubState(SubState);
	}

	function transitionTweens(comingBack:Bool)
	{
		try
		{
			FlxTween.cancelTweensOf(logo);
			FlxTween.cancelTweensOf(blackBox);
			FlxTween.cancelTweensOf(menuList);
		}
		catch (e)
		{
			trace(e);
		}

		var translationOffsets:Float = FlxG.width;

		if (comingBack)
			translationOffsets = -translationOffsets;

		FlxTween.tween(logo, {x: logo.x + translationOffsets}, 1, {
			ease: FlxEase.expoInOut
		});
		FlxTween.tween(blackBox, {x: blackBox.x + translationOffsets, alpha: (comingBack) ? .3 : .0}, 1, {
			ease: FlxEase.expoInOut
		});
		FlxTween.tween(menuList, {x: menuList.x + translationOffsets}, 1, {
			ease: FlxEase.expoInOut
		});

		FlxTween.color(backdrop, 1, backdrop.color, (comingBack) ? FlxColor.WHITE : FlxColor.PINK, {
			ease: FlxEase.expoOut
		});

		transitionedOut = !comingBack;
	}

	override function closeSubState()
	{
		super.closeSubState();

		inSubState = false;

		if (transitionedOut)
			transitionTweens(true);
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

		menuList.canSelect = !inSubState;
	}
}
