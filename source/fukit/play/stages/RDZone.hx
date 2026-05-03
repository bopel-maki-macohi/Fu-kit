package fukit.play.stages;

import fukit.shaders.DropShadowShader;
import fukit.objects.FukitSprite;
import fukit.play.components.StageComponent;

class RDZone extends StageComponent
{
	public var omonus:FukitSprite;

	public var charShader:DropShadowShader;

	override function makeStage()
	{
		super.makeStage();

		PlayState.curStage = 'rdzone';

		omonus = new FukitSprite(0, 0, Paths.image('stages/rdzone/omonus'));
		add(omonus);

		omonus.scale.set(2, 2);
		omonus.updateHitbox();

		omonus.screenCenter();
		omonus.y += 480;

		charShader = new DropShadowShader();
		charShader.setAdjustColor(-48, -20, -12, -32);

		if (game == null)
			return;

		game.defaultCamZoom = .5;

		game.remove(game.gf);

		game.boyfriend.shader = charShader;
		game.dad.shader = charShader;

		game.defaultCamMove = false;

		game.camFollow.screenCenter(X);

		game.dad.y += 120;
		game.dad.x -= 360;

		game.boyfriend.x += 360;
	}

	override function onCreate()
	{
		super.onCreate();

		game.applyMiddleScroll();
	}
}
