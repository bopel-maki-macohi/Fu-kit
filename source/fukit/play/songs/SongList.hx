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
}

typedef SongEntry =
{
	name:String,
	world:Int,
}

class SongListManager
{
	public static var songListData(default, null):SongList;

	public static var songList:Array<SongEntry> = [];

	public static var worldList:Array<WorldEntry> = [];
	public static var worldSongLists:Array<Array<String>> = [];

	public static function reloadSongList()
	{
		songListData = {worlds: [], songs: []};
		worldSongLists = [];
		songList = [];

		var songListPath:String = Paths.json('ui/songList', 'fu-kit');

		if (!Assets.exists(songListPath))
			return;

		try
		{
			songListData = Json.parse(Assets.getText(songListPath));
		}
		catch (e)
		{
			songListData = {worlds: [], songs: []};
			trace(e);
		}

		for (world in songListData.worlds)
		{
			worldList.push(world);
			worldSongLists.push([]);
		}

		for (song in songListData.songs)
		{
			trace('${song.name} (${songListData.worlds[song.world]?.header ?? 'Unknown'})');

			songList.push(song);
			worldSongLists[song.world].push(song.name);
		}
	}
}
