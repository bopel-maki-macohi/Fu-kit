package fukit.play.songs.world2;

import fukit.play.stages.RDZone;

class RMRFSong extends RDSong
{
	public var stage:RDZone;

	override function init()
	{
		super.init();

		if (game == null)
		{
            stage = new RDZone();
			return;
		}

		stage = cast(game.stage, RDZone);
	}
}
