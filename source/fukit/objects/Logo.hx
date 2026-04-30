package fukit.objects;

import animate.FlxAnimate;

class Logo extends FlxAnimate
{
	override public function new()
	{
		super();

		frames = Paths.getAnimateAtlas('UI/logo', 'fu-kit');
		anim.addByFrameLabel('logoBumpin', 'logoBumpin', 24, false);
	}
}
