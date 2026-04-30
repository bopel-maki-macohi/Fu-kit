package fukit.states.options.components;

import flixel.FlxG;

using StringTools;

class CustomScrollSpeedOption extends OptionComponent
{
	override public function new()
	{
		super('Custom Scroll Speed');
	}

	override function updateDisplay()
	{
		var scrollSpeed = CoolUtil.truncateFloat(FlxG.save.data.scrollSpeed, 1);

		if (scrollSpeed == 1)
			display = 'Default Song Scroll Speed';
		else
			display = 'Custom Song Scroll Speed: ${scrollSpeed}${(!'$scrollSpeed'.contains('.')) ? '.0' : ''} / 10.0';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.scrollSpeed += (FlxG.keys.pressed.SHIFT) ? 0.5 : 0.1;

		if (FlxG.save.data.scrollSpeed > 10)
			FlxG.save.data.scrollSpeed = 1;
	}
}
