package fukit.play.cutscenes;

import flixel.util.FlxTimer;
import openfl.Lib;
import fukit.objects.FukitSprite;
import openfl.display.BitmapData;
import openfl.display.JPEGEncoderOptions;
import fukit.util.plugins.ScreenshotPlugin;
import flixel.FlxG;

class OverheatDialogueCutscene extends SongMusicDialogueCutscene
{
	override public function new(endCallback:Void->Void)
	{
		super('overheat', endCallback);
	}

	var sprite:FukitSprite;

	override function onLine(line:Int)
	{
		super.onLine(line);

		if (line == 7)
		{
			dialogueBox.swagDialogue.skip();

			FlxG.sound.music.stop();

			FlxTimer.wait(.1, () ->
			{
				Main.fpsCounter.visible = false;

				ScreenshotPlugin.instance.encoder = new JPEGEncoderOptions(0);
				var screenshot:BitmapData = ScreenshotPlugin.instance.takeScreenshot(false, true);

				sprite = new FukitSprite(0, 0, screenshot);
				dialogueBox.add(sprite);

				Main.fpsCounter.visible = true;
			});
		}
	}
}
