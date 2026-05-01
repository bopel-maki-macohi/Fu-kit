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
		display = '$id : ${(FlxG.save.data.accuracyComplex) ? 'Complex' : 'Accurate'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.accuracyComplex = FlxG.save.data.accuracyComplex ? 0 : 1;
	}
}
