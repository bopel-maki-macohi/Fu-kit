package fukit.play.components;

class CutsceneComponent extends MusicBeatState
{
	public var endCallback:Void->Void;

	public function new(endCallback:Void->Void)
	{
		super();

		this.endCallback = endCallback;
	}

	public function leave()
	{
		if (endCallback != null)
			endCallback();
	}
}
