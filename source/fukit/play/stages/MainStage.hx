package fukit.play.stages;

import fukit.objects.FukitSprite;
import fukit.play.components.StageComponent;

class MainStage extends StageComponent
{
	override function makeStage()
	{
		super.makeStage();

		if (game != null)
			game.defaultCamZoom = 0.9;

		PlayState.curStage = 'stage';

		var bg:FukitSprite = new FukitSprite(-600, -200, loadGraphic(Paths.image('stageback')));
		bg.scrollFactor.set(0.9, 0.9);
		bg.active = false;
		add(bg, back);

		var stageFront:FukitSprite = new FukitSprite(-650, 600, loadGraphic(Paths.image('stagefront')));
		stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
		stageFront.updateHitbox();
		stageFront.scrollFactor.set(0.9, 0.9);
		stageFront.active = false;
		add(stageFront, back);

		var stageCurtains:FukitSprite = new FukitSprite(-500, -300, loadGraphic(Paths.image('stagecurtains')));
		stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
		stageCurtains.updateHitbox();
		stageCurtains.scrollFactor.set(1.3, 1.3);
		stageCurtains.active = false;

		add(stageCurtains, back);
	}
}
