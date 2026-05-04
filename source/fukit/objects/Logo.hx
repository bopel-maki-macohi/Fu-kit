package fukit.objects;

import animate.FlxAnimate;

class Logo extends FukitSprite
{
	override public function new()
	{
		super();

		loadTexture(Paths.getAnimateAtlas('UI/logo'));
		addByFrameLabel('logoBumpin', 'logoBumpin');
	}
}
