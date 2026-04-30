package fukit.states.options.components;

import flixel.FlxG;

class DownscrollOption extends OptionComponent
{
	override public function new()
	{
		super('Downscroll Layout');
	}

	override function updateDisplay()
	{
		display = '${(FlxG.save.data.downscroll) ? 'Downscroll' : 'Upscroll'} Layout';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
	}
}
