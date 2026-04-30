package fukit.states.options.components;

import flixel.FlxG;

class OffsetChangingOption extends OptionComponent
{
	override public function new()
	{
		super('Offset Changing');
	}

	override function method()
	{
		super.method();

		Global.goIntoSong('Tutorial', 2, 0, false, true);
	}
}
