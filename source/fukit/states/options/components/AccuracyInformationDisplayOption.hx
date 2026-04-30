package fukit.states.options.components;

import flixel.FlxG;

class AccuracyInformationDisplayOption extends OptionComponent
{
	override public function new()
	{
		super('Accuracy Information Display');
	}

	override function updateDisplay()
	{
		display = '$id ${(FlxG.save.data.accuracyDisplay) ? 'Enabled' : 'Disabled'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.accuracyDisplay = !FlxG.save.data.accuracyDisplay;
	}
}
