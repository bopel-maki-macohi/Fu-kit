package;

import sys.FileSystem;
import animate.FlxAnimateFrames;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

class Paths
{
	inline public static var SOUND_EXT = #if web "mp3" #else "ogg" #end;

	public static var currentLevel:String;

	static public function setCurrentLevel(name:String)
	{
		currentLevel = name.toLowerCase();
	}

	static function getPath(file:String)
	{
		return 'assets/$file';
	}

	public static function exists(path:String)
	{
		return Assets.exists(path) || FileSystem.exists(path);
	}

	inline static public function file(file:String)
	{
		return getPath(file);
	}

	inline static public function lua(key:String)
	{
		return getPath('data/$key.lua');
	}

	inline static public function luaImage(key:String)
	{
		return getPath('data/$key.png');
	}

	inline static public function txt(key:String)
	{
		return getPath('data/$key.txt');
	}

	inline static public function xml(key:String)
	{
		return getPath('data/$key.xml');
	}

	inline static public function json(key:String)
	{
		return getPath('data/$key.json');
	}

	static public function sound(key:String)
	{
		return getPath('sounds/$key.$SOUND_EXT');
	}

	inline static public function soundRandom(key:String, min:Int, max:Int)
	{
		return sound(key + FlxG.random.int(min, max));
	}

	inline static public function music(key:String)
	{
		return getPath('music/$key.$SOUND_EXT');
	}

	inline static public function voices(song:String)
	{
		return getPath('songs/${song.toLowerCase()}/Voices.$SOUND_EXT');
	}

	inline static public function inst(song:String)
	{
		return getPath('songs/${song.toLowerCase()}/Inst.$SOUND_EXT');
	}

	inline static public function image(key:String)
	{
		return getPath('images/$key.png');
	}

	inline static public function font(key:String)
	{
		return getPath('fonts/$key');
	}

	inline static public function frag(key:String)
	{
		return getPath('shaders/$key.frag');
	}

	inline static public function vert(key:String)
	{
		return getPath('shaders/$key.vert');
	}

	inline static public function getSparrowAtlas(key:String)
	{
		return FlxAtlasFrames.fromSparrow(image(key), file('images/$key.xml'));
	}

	inline static public function getPackerAtlas(key:String)
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(image(key), file('images/$key.txt'));
	}

	public static function animateAtlas(path:String):String
	{
		return file('images/$path');
	}

	inline static public function getAnimateAtlas(key:String)
	{
		var graphicKey:String = Paths.animateAtlas(key);

		// Validate asset path.
		if (!exists('${graphicKey}/Animation.json'))
			throw 'No Animation.json file exists at the specified path (${graphicKey})';

		return FlxAnimateFrames.fromAnimate(graphicKey);
	}
}
