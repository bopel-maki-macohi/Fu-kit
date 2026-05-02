package fukit.play.songs;

import fukit.play.stages.GrassWorld;
import fukit.play.components.SongComponent;

class FolirSong extends SongComponent
{
	public var stage:GrassWorld;

	override function init()
	{
		super.init();

		stage = new GrassWorld();
	}
}
