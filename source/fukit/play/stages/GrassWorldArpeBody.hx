package fukit.play.stages;

import fukit.objects.FukitSprite;

class GrassWorldArpeBody extends GrassWorld
{
	public var arpeCorpse:FukitSprite;

	override function makeStage()
	{
		super.makeStage();

		PlayState.curStage = 'grassworld_arpebody';

		arpeCorpse = new FukitSprite(0, 0, Paths.image('stages/grassworld/arpe corpse'));
		add(arpeCorpse, back);

        arpeCorpse.screenCenter();
        arpeCorpse.y += arpeCorpse.height * 1.65;
	}
}
