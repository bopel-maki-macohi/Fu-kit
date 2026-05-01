package fukit.states.storymode;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class NewStoryMode extends MusicBeatSubstate
{
	public var blackScreen:FlxSprite;

	override function create()
	{
		super.create();

		blackScreen = new FlxSprite().makeGraphic(Math.round(FlxG.width * 1.5), Math.round(FlxG.height * 1.5), FlxColor.BLACK);
		add(blackScreen);

		blackScreen.alpha = 0;

		FlxTween.tween(blackScreen, {alpha: 1}, 1, {
			ease: FlxEase.expoInOut
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			leave();
	}

	public function leave()
	{
		FlxTween.cancelTweensOf(blackScreen);
		FlxTween.tween(blackScreen, {alpha: 0}, .3, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				close();
			}
		});
	}
}
