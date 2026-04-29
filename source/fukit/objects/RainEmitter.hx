package fukit.objects;

import flixel.FlxG;

class RainEmitter extends CustomEmitter
{
	public var autoKill:Bool = true;

	public function new(x:Float = 0, y:Float = 0, width:Float = 0)
	{
		super(x, y);
		
        this.width = width;

		particleClass = RainParticle;
        
		launchAngle.set(0, 160);
		lifespan.set(64); // fuck it

		speed.set(0, 1400);

		alpha.set(1, null, 0, 1);
	}
}
