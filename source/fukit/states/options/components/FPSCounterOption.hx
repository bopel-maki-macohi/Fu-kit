package fukit.states.options.components;

import flixel.FlxG;
import openfl.Lib;

class FPSCounterOption extends OptionComponent
{
	override public function new()
	{
		super('FPS Counter');
	}

	override function updateDisplay()
	{
		display = '$id : ${(FlxG.save.data.fps) ? 'Enabled' : 'Disabled'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.fps = !FlxG.save.data.fps;
		(cast(Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fps);
	}
}
