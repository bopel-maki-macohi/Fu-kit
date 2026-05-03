package fukit.states.options.components;

import flixel.FlxG;
import openfl.Lib;

class FPSCapOption extends OptionComponent
{
	override public function new()
	{
		super('FPS Cap');
	}

	override function updateDisplay()
	{
		display = 'FPS Cap: ${FlxG.save.data.fpsCap} / 290';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.fpsCap += (FlxG.keys.pressed.SHIFT) ? 20 : 10;
		if (FlxG.save.data.fpsCap > 290)
			FlxG.save.data.fpsCap = 60;

		(cast(Lib.current.getChildAt(0), Main)).setFPSCap(FlxG.save.data.fpsCap);
	}
}
