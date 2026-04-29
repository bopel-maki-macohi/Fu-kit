package fukit.play.songs;

import flixel.math.FlxMath;
import flixel.FlxG;
import fukit.play.components.SongComponent;

class World1Song extends SongComponent
{
	override function init()
	{
		super.init();

		if (game == null)
			return;
	}

	override function onCreate()
	{
		super.onCreate();

		trace('New World!');
	}

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);
	}
}
