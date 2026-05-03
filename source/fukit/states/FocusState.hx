package fukit.states;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxState;

class FocusState extends FlxState
{
	public var text:FlxText;

	override function create()
	{
		super.create();

		text = new FlxText(0, 0, 0, 'Click the screen to focus up', 32);
		add(text);

		text.screenCenter();

		FlxG.mouse.visible = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed)
		{
			FlxG.mouse.visible = false;
			InitState.moveStates();
		}
	}
}
