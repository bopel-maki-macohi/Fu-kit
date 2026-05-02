package fukit.play.stages;

import flixel.FlxSprite;
import fukit.play.components.StageComponent;

using StringTools;

class GrassWorld extends StageComponent
{
	public var sky:FlxSprite;
	public var ground:FlxSprite;

	override function makeStage()
	{
		super.makeStage();

		PlayState.curStage = 'grassworld';

		sky = new FlxSprite(0, 0, Paths.image('stages/grassworld/sky', 'fu-kit'));
		ground = new FlxSprite(0, 0, Paths.image('stages/grassworld/ground', 'fu-kit'));

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
