package fukit.play.objects.ui;

import fukit.objects.FukitSprite;

class RatingSprite extends FukitSprite
{
	override public function new()
	{
		super();

		loadTextures([
			FukitSprite.getStaticTexture(Paths.image('UI/popups/shit')),
			FukitSprite.getStaticTexture(Paths.image('UI/popups/bad')),
			FukitSprite.getStaticTexture(Paths.image('UI/popups/good')),
			FukitSprite.getStaticTexture(Paths.image('UI/popups/sick')),
		]);

		anim.add('shit', [0]);
		anim.add('bad', [1]);
		anim.add('good', [2]);
		anim.add('sick', [3]);

        playAnim('sick');
	}
}
