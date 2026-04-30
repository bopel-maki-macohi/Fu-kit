package fukit.states;

import flixel.addons.display.FlxBackdrop;

class NewMenuState extends MusicBeatState
{
    public var backdrop:FlxBackdrop;

	override function create()
	{
		super.create();

        backdrop = new FlxBackdrop(Paths.image('tile', 'fu-kit'));
        add(backdrop);
        backdrop.velocity.set(32, 32);
	}
}
