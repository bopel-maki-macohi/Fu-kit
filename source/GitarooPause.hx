package;

import fukit.objects.FukitSprite;
import fukit.play.PlayStateSwitcher;
import fukit.states.NewMenuState;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class GitarooPause extends MusicBeatState
{
	var replayButton:FukitSprite;
	var cancelButton:FukitSprite;

	var replaySelect:Bool = false;

	public function new():Void
	{
		super();
	}

	override function create()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		var bg:FukitSprite = new FukitSprite();
		bg.loadGraphic(Paths.image('pauseAlt/pauseBG'));
		add(bg);

		var bf:FukitSprite = new FukitSprite(0, 30);
		bf.loadTexture(Paths.getSparrowAtlas('pauseAlt/bfLol'));
		bf.addByPrefix('lol', "funnyThing", 13);
		bf.playAnim('lol');
		add(bf);
		bf.screenCenter(X);

		replayButton = new FukitSprite(FlxG.width * 0.28, FlxG.height * 0.7);
		replayButton.loadTexture(Paths.getSparrowAtlas('pauseAlt/pauseUI'));
		replayButton.addByPrefix('selected', 'bluereplay', 0, false);
		replayButton.animation.appendByPrefix('selected', 'yellowreplay');
		replayButton.playAnim('selected');
		add(replayButton);

		cancelButton = new FukitSprite(FlxG.width * 0.58, replayButton.y);
		cancelButton.loadTexture(Paths.getSparrowAtlas('pauseAlt/pauseUI'));
		cancelButton.addByPrefix('selected', 'bluecancel', 0, false);
		cancelButton.animation.appendByPrefix('selected', 'cancelyellow');
		cancelButton.playAnim('selected');
		add(cancelButton);

		changeThing();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.LEFT_P || controls.RIGHT_P)
			changeThing();

		if (controls.ACCEPT)
		{
			if (replaySelect)
			{
				LoadingState.loadAndSwitchState(PlayStateSwitcher.getPlayStateSwitch());
			}
			else
			{
				FlxG.switchState(() -> new NewMenuState());
			}
		}

		super.update(elapsed);
	}

	function changeThing():Void
	{
		replaySelect = !replaySelect;

		if (replaySelect)
		{
			cancelButton.animation.curAnim.curFrame = 0;
			replayButton.animation.curAnim.curFrame = 1;
		}
		else
		{
			cancelButton.animation.curAnim.curFrame = 1;
			replayButton.animation.curAnim.curFrame = 0;
		}
	}
}
