package fukit.play.songs;

import fukit.states.freeplay.FreeplayAlbum;
import haxe.Json;
import lime.utils.Assets;

typedef SongList =
{
	worlds:Array<WorldEntry>,
	songs:Array<SongEntry>,
	albums:Dynamic,
}

typedef WorldEntry =
{
	header:String,
	stage:String,
}

typedef SongEntry =
{
	name:String,
	world:Int,
	album:String,
}

typedef AlbumEntry =
{
	name:String,
}

class SongListManager
{
	public static var songListData(default, null):SongList;

	public static var songList:Array<SongEntry> = [];

	public static var worldList:Array<WorldEntry> = [];
	public static var worldSongLists:Array<Array<String>> = [];

	public static var albumMap:Map<String, AlbumEntry> = [];

	public static function reloadSongList()
	{
		songListData = {worlds: [], songs: [], albums: {}};
		worldSongLists = [];
		songList = [];
		FreeplayAlbum.albums = [];

		var songListPath:String = Paths.json('songs/songList', 'fu-kit');
		trace(songListPath);

		if (!Assets.exists(songListPath))
			return;

		try
		{
			songListData = Json.parse(Assets.getText(songListPath));
		}
		catch (e)
		{
			trace(e);
		}

		for (world in songListData.worlds)
		{
			worldList.push(world);
			worldSongLists.push([]);
		}

		for (song in songListData.songs)
		{
			trace('${song.name} (${songListData.worlds[song?.world]?.header ?? 'None'})');

			songList.push(song);

			if (song?.world != null)
				worldSongLists[song.world].push(song.name);

			FreeplayAlbum.albums.push(song?.album ?? null);
		}

		if (songListData.albums != null)
		{
			var albums:Dynamic = songListData.albums;
			var albumFields:Array<String> = Reflect.fields(albums);

			for (field in albumFields)
				if (Reflect.field(albums, field) != null)
					albumMap.set(field, Reflect.field(albums, field));
		}
	}
}
