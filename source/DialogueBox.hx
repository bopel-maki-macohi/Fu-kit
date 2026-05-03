package;

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
	var box:FukitSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portrait:FukitSprite;

	var handSelect:FukitSprite;
	var bgFade:FukitSprite;

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

		handSelect = new FukitSprite(FlxG.width * 0.9, FlxG.height * 0.9);
		add(handSelect);
		handSelect.loadGraphic(Paths.image('UI/dialogue/continueHand'));

		handSelect.scale.set(2, 2);
		handSelect.updateHitbox();
		handSelect.antialiasing = false;

		handSelect.x = box.x + box.width - handSelect.width;
		handSelect.y = box.y + box.height - handSelect.height;

		dropText = new FlxText(242, 502, Std.int(box.width) - 10, "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFF030303;
		// add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(box.width) - 10, "", dropText.size);
		swagDialogue.font = dropText.font;
		swagDialogue.color = 0xFF0A0219;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		swagDialogue.x = box.x + 10;
		swagDialogue.y = box.y + 10;

		dialogueOpened = true;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.x = swagDialogue.x + 2;
		dropText.y = swagDialogue.y + 2;
		dropText.text = swagDialogue.text;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
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
					ease: FlxEase.sineInOut,
					onUpdate: t ->
					{
						dropText.alpha = swagDialogue.alpha;
					}
				});

				FlxTween.tween(portrait, {alpha: 0}, Conductor.crochet / 1000, {
					ease: FlxEase.sineInOut,
				});

				new FlxTimer().start(Conductor.crochet / 1000 + .2, function(tmr:FlxTimer)
				{
					finishThing();
					kill();
				});
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
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

		if (portraitDataFiles.exists(curCharacter))
			portraitData = portraitDataFiles.get(curCharacter);
		else
		{
			portraitData = CoolUtil.coolTextFile(Paths.file('images/dialogue/$curCharacter.txt'));
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
				portrait.loadTexture(Paths.getAnimateAtlas('dialogue/$curCharacter', Paths.currentLevel));
				animated = true;

			case 'sparrow', 'sparrowatlas', 'sparrow atlas':
				portrait.loadTexture(Paths.getSparrowAtlas('dialogue/$curCharacter', Paths.currentLevel));
				animated = true;

			default: portrait.loadGraphic(Paths.image('dialogue/$curCharacter', Paths.currentLevel));
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

		portrait.visible = true;
	}

	public static var portraitDataFiles:Map<String, Array<String>> = [];

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");

		trace(splitName);

		curCharacter = splitName[0];
		dialogueList[0] = splitName[1];
	}
}
