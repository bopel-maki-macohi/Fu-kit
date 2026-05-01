package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
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
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				FlxG.sound.playMusic(Paths.music('MainTheme', 'fu-kit'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		FlxTween.tween(bgFade, {alpha: 0.7}, Conductor.crochet / 1000, {
			ease: FlxEase.expoOut
		});

		this.dialogueList = dialogueList;

		box = new FlxSprite(0, 0);
		box.makeGraphic(Math.round(FlxG.width * 0.9), Math.round(FlxG.height * 0.5));
		add(box);

		box.screenCenter();
		box.y = (FlxG.height * 0.9) - box.height;

		portraitLeft = new FlxSprite(-20, 40);
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		add(portraitRight);
		portraitRight.visible = false;

		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).makeGraphic(16, 16, FlxColor.BLACK);
		add(handSelect);

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFC0E7F9;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF545B7D;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogueOpened = true;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		dropText.text = swagDialogue.text;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (isEnding)
					return;

				isEnding = true;

				if (FlxG.sound.music?.playing)
					FlxG.sound.music.fadeOut(2.2, 0);

				portraitLeft.visible = false;
				portraitRight.visible = false;

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

		portraitLeft.visible = false;
		portraitRight.visible = false;

		if (leftPortraits.contains(curCharacter))
		{
			portraitLeft.loadGraphic(Paths.image('dialogue/$curCharacter'));
			portraitLeft.visible = true;
		}
		else
		{
			portraitRight.loadGraphic(Paths.image('dialogue/$curCharacter'));
			portraitRight.visible = true;
		}
	}

	public static var leftPortraits:Array<String> = ['arpe-idle',];

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
