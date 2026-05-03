package fukit.play.cutscenes;

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
