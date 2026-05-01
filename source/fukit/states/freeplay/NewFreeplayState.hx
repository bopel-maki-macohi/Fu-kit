package fukit.states.freeplay;

class NewFreeplayState extends MusicBeatSubstate
{
	override public function new()
	{
		super();

		closeCallback = drawOnLeave;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
			close();
	}
}
