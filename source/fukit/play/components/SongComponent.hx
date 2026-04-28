package fukit.play.components;

class SongComponent
{
	public function new()
	{
		init();
	}

	public function init()
	{
		PlayState.onCreate.add(onCreate);
		PlayState.onUpdate.add(onUpdate);
		PlayState.onStepHit.add(onStepHit);
		PlayState.onBeatHit.add(onBeatHit);
	}

	public function onCreate() {}

	public function onUpdate(elapsed:Float) {}

	public function onStepHit(step:Int) {}

	public function onBeatHit(beat:Int) {}
}
