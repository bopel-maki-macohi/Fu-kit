package fukit.states.options.components;

import flixel.FlxG;

class DFJKOption extends OptionComponent
{
	override public function new()
	{
		super('DFJK');
	}

	override function updateDisplay()
	{
		display = '${(FlxG.save.data.dfjk) ? 'DFJK' : 'WASD'} Keybinds';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.dfjk = !FlxG.save.data.dfjk;
	}
}
