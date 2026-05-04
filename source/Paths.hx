package;

import animate.FlxAnimateFrames;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	public static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String, library:Null<String>)
	{
		if (library != null)
			return getLibraryPath(file, library);

		if (currentLevel != null)
		{
			var levelPath = getLibraryPathForce(file, currentLevel);
			if (OpenFlAssets.exists(levelPath))
				return levelPath;
		}

		var fukitPath = getLibraryPathForce(file, 'fu=kit');
		var sharedPath = getLibraryPathForce(file, 'shared');

		if (OpenFlAssets.exists(fukitPath))
			return fukitPath;

		if (OpenFlAssets.exists(sharedPath))
			return sharedPath;

		return getPreloadPath(file);
	}

	static public function getLibraryPath(file:String, library = "preload")
	{
		return if (library == "preload" || library == "default") getPreloadPath(file); else getLibraryPathForce(file, library);
	}

	inline static function getLibraryPathForce(file:String, library:String)
	{
		return '$library:assets/$library/$file';
	}

	inline static function getPreloadPath(file:String)
	{
		return 'assets/$file';
	}

	inline static public function file(file:String, ?library:String)
	{
		return getPath(file, library);
	}

	inline static public function lua(key:String, ?library:String)
	{
		return getPath('data/$key.lua', library);
	}

	inline static public function luaImage(key:String, ?library:String)
	{
		return getPath('data/$key.png', library);
	}

	inline static public function txt(key:String, ?library:String)
	{
		return getPath('data/$key.txt', library);
	}

	inline static public function xml(key:String, ?library:String)
	{
		return getPath('data/$key.xml', library);
	}

	inline static public function json(key:String, ?library:String)
	{
		return getPath('data/$key.json', library);
	}

	static public function sound(key:String, ?library:String)
	{
		return getPath('sounds/$key.$SOUND_EXT', library);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String)
	{
		return sound(key + FlxG.random.int(min, max), library);
	}

	inline static public function music(key:String, ?library:String)
	{
		return getPath('music/$key.$SOUND_EXT', library);
	}

	inline static public function voices(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Voices.$SOUND_EXT';
	}

	inline static public function inst(song:String)
	{
		return 'songs:assets/songs/${song.toLowerCase()}/Inst.$SOUND_EXT';
	}

	inline static public function image(key:String, ?library:String)
	{
		return getPath('images/$key.png', library);
	}

	inline static public function font(key:String)
	{
		return 'assets/fonts/$key';
	}

	inline static public function frag(key:String)
	{
		return getPreloadPath('shaders/$key.frag');
	}

	inline static public function vert(key:String)
	{
		return getPreloadPath('shaders/$key.vert');
	}

	inline static public function getSparrowAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key, library), file('images/$key.xml', library));
	}

	inline static public function getPackerAtlas(key:String, ?library:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key, library), file('images/$key.txt', library));
	}

	public static function animateAtlas(path:String, ?library:String):String
	{
		return file('images/$path', library);
	}

	inline static public function getAnimateAtlas(key:String, ?library:String)
	{
		var graphicKey:String = Paths.animateAtlas(key, library);

		// Validate asset path.
		if (!Assets.exists('${graphicKey}/Animation.json'))
			throw 'No Animation.json file exists at the specified path (${graphicKey})';

		return FlxAnimateFrames.fromAnimate(graphicKey);
	}
}
