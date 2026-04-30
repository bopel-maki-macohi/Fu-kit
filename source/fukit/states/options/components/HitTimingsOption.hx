package fukit.states.options.components;

import flixel.FlxG;

class HitTimingsOption extends OptionComponent
{
	override public function new()
	{
		super('Safe Frames');
	}

	override function method()
	{
		super.method();

		if (Conductor.safeFrames == 1)
			Conductor.safeFrames = 20;
		else
			Conductor.safeFrames -= (FlxG.keys.pressed.SHIFT) ? 2 : 1;

		FlxG.save.data.frames = Conductor.safeFrames;

		Conductor.recalculateTimings();
	}

	override function updateDisplay()
	{
		display = '$id : ${Conductor.safeFrames} / 20';
	}
}
