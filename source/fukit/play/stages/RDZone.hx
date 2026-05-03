import fukit.play.components.StageComponent;

class RDZone extends StageComponent
{
	override function makeStage()
	{
		super.makeStage();

		PlayState.curStage = 'rdzone';

        if (game == null) return;

        game.defaultCamZoom = .75;
	}
}
