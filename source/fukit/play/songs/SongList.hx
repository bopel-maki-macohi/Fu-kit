package fukit.play.songs;

import haxe.Json;
import lime.utils.Assets;

typedef SongList =
{
	worlds:Array<WorldEntry>,
	songs:Array<SongEntry>,
}

typedef WorldEntry =
{
	header:String,
	unlocked:Bool,
}

typedef SongEntry =
{
	name:String,
	world:Int,
	stage:String,
}

class SongListManager
{
	public static var songList(default, null):SongList;

	public static function reloadSongList()
	{
		songList = {worlds: [], songs: []};

		var songListPath:String = Paths.json('ui/songList', 'fu-kit');

		if (!Assets.exists(songListPath))
			return;

		try
		{
			songList = Json.parse(Assets.getText(songListPath));
		}
		catch (e)
		{
			songList = {worlds: [], songs: []};
			trace(e);
		}
	}
}
