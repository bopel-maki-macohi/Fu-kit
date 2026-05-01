package fukit.states.options.components;

import flixel.FlxG;

class SafeFramesOption extends OptionComponent
{
	override public function new()
	{
		super('Safe Frames');
	}

	override function method()
	{
		super.method();

		Conductor.safeFrames -= (FlxG.keys.pressed.SHIFT) ? 2 : 1;
		if (Conductor.safeFrames < 1)
			Conductor.safeFrames = 20;

		FlxG.save.data.safeFrames = Conductor.safeFrames;

		Conductor.recalculateTimings();
	}

	override function updateDisplay()
	{
		display = '$id : ${Conductor.safeFrames} / 20';
	}
}
