package fukit.play.stages;

import fukit.objects.FukitSprite;
import flixel.util.FlxColor;
import flixel.system.frontEnds.BitmapFrontEnd;
import flixel.FlxG;
import fukit.play.components.StageComponent;

using StringTools;

class GrassWorld extends StageComponent
{
	public var sky:FukitSprite;
	public var ground:FukitSprite;

	override function makeStage()
	{
		super.makeStage();

		PlayState.curStage = 'grassworld';

		sky = new FukitSprite(0, 0);
		sky.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromString('0x33CCFF'));
		ground = new FukitSprite(0, 0, Paths.image('stages/grassworld/ground'));

		sky.scale.set(2, 2);
		sky.updateHitbox();

		sky.scrollFactor.set();
		sky.screenCenter();
		sky.active = false;

		ground.scale.set(1.2, 1.2);
		ground.updateHitbox();

		ground.scrollFactor.set(.75, .75);
		ground.screenCenter();
		ground.active = false;

		ground.y += ground.height * 0.75;

		add(sky, back);
		add(ground, back);

		if (game == null)
			return;

		game.remove(game.gf);

		if (game.dad.curCharacter.startsWith('folir'))
			game.dad.y += 120 + 100;
		if (game.dad.curCharacter.startsWith('arpe'))
			game.dad.y += 120;
	}
}
