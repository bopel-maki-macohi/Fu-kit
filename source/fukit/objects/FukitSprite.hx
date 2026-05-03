package fukit.objects;

import animate.internal.Timeline;
import lime.utils.Assets;
import animate.FlxAnimateFrames;
import flixel.graphics.frames.FlxAtlasFrames;
import animate.FlxAnimate;

class FukitSprite extends FlxAnimate
{
	public function addByPrefix(name:String, prefix:String, frameRate = 24.0, looped = false):Void
		anim.addByPrefix(name, prefix, frameRate, looped);

	public function addByFrameLabel(name:String, label:String, ?frameRate:Float = 24.0, ?looped:Bool = false, ?timeline:Timeline):Void
		anim.addByFrameLabel(name, label, frameRate, looped, false, false, timeline);

	public function loadTexture(texture:FlxAtlasFrames)
		loadTextures([texture]);

	public function loadTextures(textures:Array<FlxAtlasFrames>)
		frames = FlxAnimateFrames.combineAtlas(textures);

	public var animOffsets:Map<String, Array<Dynamic>> = [];

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		anim.play(AnimName, Force, Reversed, Frame);

		if (animOffsets.exists(AnimName))
		{
			var daOffset = animOffsets.get(AnimName);
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function parseOffsets(path:String)
	{
		final path:String = Paths.txt('$path');

		if (!Assets.exists(path))
			return;

		var parsed:Array<String> = CoolUtil.coolTextFile(path);

		for (line in parsed)
		{
			var spaceSplit:Array<String> = line.split(' ');

			var anim:String = spaceSplit[0];

			var x:Float = Std.parseFloat(spaceSplit[1] ?? '0');
			var y:Float = Std.parseFloat(spaceSplit[2] ?? '0');

			addOffset(anim, x, y);
		}
	}

	public function createOffsetsFile():String
	{
		var file:String = '';

		// trace(anim.getNameList());

		for (animName in anim.getNameList())
		{
			var line:String = '$animName';

			if (animOffsets.exists(animName))
				line += ' ${animOffsets[animName][0]} ${animOffsets[animName][1]}';
			else
				line += ' 0 0';

			file += '$line\n';
		}

		return file;
	}
}
