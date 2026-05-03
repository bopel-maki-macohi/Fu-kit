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

	override function onLine(line:Int)
	{
		super.onLine(line);

		if (line == 7)
			FlxG.sound.music.stop();
	}
}
