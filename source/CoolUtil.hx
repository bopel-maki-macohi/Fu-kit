package;

import flixel.math.FlxMath;
import lime.utils.Assets;

using StringTools;

class CoolUtil
{
	public static function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		if (!Assets.exists(path))
		{
			trace('$path doesnt exist');
			return [];
		}

		return coolStringFile(Assets.getText(path));
	}

	public static function coolStringFile(path:String):Array<String>
	{
		try
		{
			var daList:Array<String> = path.trim().split('\n');

			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}

			return daList;
		}
		catch (e)
		{
			return [];
		}
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}

	// ty nightmare vision

	function makeShader(fragFile:String = null, vertFile:String = null)
	{ // returns a FlxRuntimeShader but with file names lol
		var runtime:flixel.addons.display.FlxRuntimeShader = null;

		try
		{
			runtime = new flixel.addons.display.FlxRuntimeShader(fragFile == null ? null : Assets.getText(Paths.frag(fragFile)),
				vertFile == null ? null : Assets.getText(Paths.vert(vertFile)));
		}
		catch (e:Dynamic)
		{
			trace("Shader compilation error:" + e.message);
		}

		return runtime ?? new flixel.addons.display.FlxRuntimeShader();
	}
}
