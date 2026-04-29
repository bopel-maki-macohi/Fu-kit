package fukit.play.components;

class StageComponent extends PlayComponent
{
	override function init()
	{
		super.init();

		if (game != null)
			makeStage();
	}

	public function makeStage() {}
}
