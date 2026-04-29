package fukit.objects;

import flixel.util.FlxColor;
import flixel.FlxG;

class RainEmitter extends CustomEmitter
{
	public var autoKill:Bool = true;

	public function new(x:Float = 0, y:Float = 0, width:Float = 0)
	{
		super(x, y);
		
        this.width = width;

		particleClass = RainParticle;
        
		launchAngle.set(60, 100);
		lifespan.set(8); // fuck it

		speed.set(1000, 1600);

		alpha.set(1, null, 0, 1);

		color.set(FlxColor.BLUE, FlxColor.CYAN);
		blend = HARDLIGHT;
	}
}
