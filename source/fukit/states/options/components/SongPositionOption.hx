package fukit.states.options.components;

import flixel.FlxG;

class SongPositionOption extends OptionComponent
{
	override public function new()
	{
		super('Song Position');
	}

	override function updateDisplay()
	{
		display = '$id : ${(FlxG.save.data.songPosition) ? 'Enabled' : 'Disabled'}';
	}

	override function method()
	{
		super.method();

		FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
	}
}
