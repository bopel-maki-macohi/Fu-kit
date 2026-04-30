package fukit.states.options.components;

import flixel.FlxG;

class NPSDisplayOption extends OptionComponent
{
	override public function new()
	{
		super('NPS Display');
	}

	override function updateDisplay()
	{
		display = '$id : ${(FlxG.save.data.npsDisplay) ? 'Enabled' : 'Disabled'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.npsDisplay = !FlxG.save.data.npsDisplay;
	}
}
