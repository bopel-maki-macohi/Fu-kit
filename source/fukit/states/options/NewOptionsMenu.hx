package fukit.states.options;

import flixel.FlxG;

class NewOptionsMenu extends MusicBeatSubstate
{
	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
            FlxG.sound.play(Paths.sound('cancelMenu'));
			close();
		}
	}
}
