package;

import flixel.util.FlxSignal;
import fukit.objects.FukitSprite;
import animate.FlxAnimate;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	public var box:FukitSprite;

	public var curCharacter:String = '';

	public var dialogueList:Array<String> = [];
	public var swagDialogue:FlxTypeText;
	public var swagYoudontfuckingknowAnything:FlxText;

	public var finishThing:Void->Void;

	public var portrait:FukitSprite;

	public var bgFade:FukitSprite;

	public var onLine:FlxTypedSignal<Int->Void> = new FlxTypedSignal<Int->Void>();
	public var onEnd:FlxSignal = new FlxSignal();

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		bgFade = new FukitSprite(-200, -200);
		bgFade.makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		FlxTween.tween(bgFade, {alpha: 0.7}, Conductor.crochet / 1000, {
			ease: FlxEase.expoOut
		});

		this.dialogueList = dialogueList;

		box = new FukitSprite(0, 0);
		box.makeGraphic(Math.round(FlxG.width * 0.9), Math.round(FlxG.height * 0.4));

		box.screenCenter();
		box.y = (FlxG.height * 0.9) - box.height;

		portrait = new FukitSprite(-20, 40);
		add(portrait);
		portrait.visible = false;

		add(box);


		swagDialogue = new FlxTypeText(240, 500, Std.int(box.width) - 10, "", 32);
		swagDialogue.font = Paths.font('pixel.otf');
		swagDialogue.color = FlxColor.BLACK;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		
		swagYoudontfuckingknowAnything = new FlxText(0, 0, 0, 'ENTER to continue', 16);
		swagYoudontfuckingknowAnything.font = swagDialogue.font;
		swagYoudontfuckingknowAnything.color = FlxColor.WHITE;

		swagYoudontfuckingknowAnything.x = 10;
		swagYoudontfuckingknowAnything.y = FlxG.height - swagYoudontfuckingknowAnything.height - 10;

		add(swagYoudontfuckingknowAnything);
		add(swagDialogue);

		swagDialogue.x = box.x + 10;
		swagDialogue.y = box.y + 10;

		dialogueOpened = true;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ENTER && dialogueStarted == true)
		{
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (isEnding)
					return;

				isEnding = true;

				if (FlxG.sound.music?.playing)
					FlxG.sound.music.fadeOut(2.2, 0);

				FlxTween.tween(box, {alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.sineInOut,
				});

				FlxTween.tween(bgFade, {alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.sineInOut,
				});

				FlxTween.tween(swagDialogue, {alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.sineInOut
				});

				FlxTween.tween(portrait, {alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.sineInOut,
				});

				onEnd.dispatch();

				new FlxTimer().start(Conductor.crochet / 1000 + .2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				line++;
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		portrait.visible = false;

		var portraitData:Array<String> = [];

		var path:String = 'UI/dialogue/portraits/$curCharacter';

		if (portraitDataFiles.exists(curCharacter))
			portraitData = portraitDataFiles.get(curCharacter);
		else
		{
			portraitData = CoolUtil.coolTextFile(Paths.file('images/$path.txt'));
			portraitDataFiles.set(curCharacter, portraitData);
		}

		var leftSide:Bool = portraitData[0] == '1';

		var portraitType:String = portraitData[1]?.toLowerCase() ?? 'static';

		var animated:Bool = false;
		var animationType:String = portraitData[2]?.toLowerCase() ?? null;
		var animationName:String = portraitData[3]?.toLowerCase() ?? null;

		// portrait type

		switch (portraitType)
		{
			case 'animateatlas', 'textureatlas', 'animate atlas', 'texture atlas':
				portrait.loadTexture(Paths.getAnimateAtlas(path));
				animated = true;

			case 'sparrow', 'sparrowatlas', 'sparrow atlas':
				portrait.loadTexture(Paths.getSparrowAtlas(path));
				animated = true;

			default: portrait.loadGraphic(Paths.image(path));
		}

		if (animated)
		{
			switch (animationType)
			{
				case 'prefix': portrait.addByPrefix('anim', animationName, 24, false);
				case 'framelabel': portrait.addByFrameLabel('anim', animationName, 24, false);
			}
			portrait.anim.play('anim');
		}

		if (leftSide)
			portrait.x = (portrait.width * 0.2);
		else
			portrait.x = FlxG.width - (portrait.width * 1.1);
		portrait.y = box.y - (portrait.height * 0.95);

		if (portrait.graphic != null)
			portrait.visible = true;

		onLine.dispatch(line);
	}

	public var line:Int = 0;

	public static var portraitDataFiles:Map<String, Array<String>> = [];

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");

		trace(splitName);

		curCharacter = splitName[0];
		dialogueList[0] = splitName[1];
	}
}
