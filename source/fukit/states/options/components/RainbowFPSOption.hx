package fukit.states.options.components;

import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.Lib;

class RainbowFPSOption extends OptionComponent
{
	override public function new()
	{
		super('Rainbow FPS');
	}

	override function updateDisplay()
	{
		display = '$id : ${(FlxG.save.data.fpsRain) ? 'Enabled' : 'Disabled'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.fpsRain = !FlxG.save.data.fpsRain;
		(cast(Lib.current.getChildAt(0), Main)).changeFPSColor(FlxColor.WHITE);
	}
}
