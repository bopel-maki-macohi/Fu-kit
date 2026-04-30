package fukit.states.options.components;

import flixel.FlxG;

class AccuracyCalculationOption extends OptionComponent
{
	override public function new()
	{
		super('Accuracy Calculation');
	}

	override function updateDisplay()
	{
		display = '$id : ${(FlxG.save.data.accuracyMod == 1) ? 'Complex' : 'Accurate'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.accuracyMod = FlxG.save.data.accuracyMod == 1 ? 0 : 1;
	}
}
