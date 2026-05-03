package fukit.play;

import fukit.play.components.StageComponent;
import fukit.play.stages.*;

class StringToStage
{
	public static function convert(str:String):StageComponent
	{
		switch (str)
		{
			case 'grassworld': return new GrassWorld();
			case 'grassworld_arpebody': return new GrassWorldArpeBody();
			
			case 'rdzone': return new RDZone();

			case 'stage': return new MainStage();
		}

		return null;
	}
}
