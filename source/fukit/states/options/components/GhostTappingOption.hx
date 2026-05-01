package fukit.states.options.components;

import flixel.FlxG;
import openfl.Lib;

class GhostTappingOption extends OptionComponent
{
	override public function new()
	{
		super('Ghost Tapping');
	}

	override function updateDisplay()
	{
		display = '$id : ${(FlxG.save.data.ghostTapping) ? 'Enabled' : 'Disabled'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.ghostTapping = !FlxG.save.data.ghostTapping;
	}
}
