package fukit.states.options.components;

import flixel.FlxG;

class WatermarksOption extends OptionComponent
{
	override public function new()
	{
		super('Watermarks');
	}

	override function updateDisplay()
	{
		display = '$id : ${(Main.watermarks) ? 'Enabled' : 'Disabled'}';
	}

	override function method()
	{
		super.method();

		Main.watermarks = !Main.watermarks;
		FlxG.save.data.watermark = Main.watermarks;
	}
}
