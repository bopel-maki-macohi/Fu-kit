package;

import lime.utils.Assets;
import flixel.math.FlxPoint;
import animate.FlxAnimate;
import animate.FlxAnimateFrames;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxAnimate
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		setCharacter(character, isPlayer);
	}

	public function playSingAnim(note:Note, suffix:String = '')
	{
		switch (note.noteData)
		{
			case 2: playAnim('singUP' + suffix, true);
			case 3: playAnim('singRIGHT' + suffix, true);
			case 1: playAnim('singDOWN' + suffix, true);
			case 0: playAnim('singLEFT' + suffix, true);
		}

		if (!isPlayer)
			holdTimer = 0;
	}

	public var dadStartingCamPosOffsets:FlxPoint;
	public var camFocusPosOffsets:FlxPoint;

	public function setCharacter(character:String = 'bf', isPlayer:Bool = false)
	{
		curCharacter = character;
		this.isPlayer = isPlayer;

		animOffsets = new Map<String, Array<Dynamic>>();

		camFocusPosOffsets = FlxPoint.weak(0, 0);
		dadStartingCamPosOffsets = FlxPoint.weak(0, 0);

		switch (curCharacter)
		{
			case 'folir':
				loadTexture(Paths.getSparrowAtlas('characters/$curCharacter', 'fu-kit'));

				addByPrefix('idle', 'folir anim idle', 24);
				addByPrefix('singLEFT', 'folir anim left', 24);
				addByPrefix('singDOWN', 'folir anim down', 24);
				addByPrefix('singUP', 'folir anim up', 24);
				addByPrefix('singRIGHT', 'folir anim right', 24);

				dadStartingCamPosOffsets.set(202, 60);

				playAnim('idle');

			case 'arpe', 'arpe-worried':
				loadTexture(Paths.getSparrowAtlas('characters/$curCharacter', 'fu-kit'));

				addByPrefix('idle', 'arpe anim idle', 24);

				addByPrefix('singLEFT', 'arpe anim left', 24);
				addByPrefix('singDOWN', 'arpe anim down', 24);
				addByPrefix('singUP', 'arpe anim up', 24);
				addByPrefix('singRIGHT', 'arpe anim right', 24);

				parseOffsets('arpe');

				dadStartingCamPosOffsets.set(202, 60);

				playAnim('idle');

			case 'arpe-withered':
				loadTextures([
					Paths.getSparrowAtlas('characters/arpe-withered', 'fu-kit'),
					Paths.getSparrowAtlas('characters/arpe-withered-alt', 'fu-kit')
				]);

				addByPrefix('idle', 'arpe anim idle', 24);

				addByPrefix('singLEFT', 'arpe anim left', 24);
				addByPrefix('singDOWN', 'arpe anim down', 24);
				addByPrefix('singUP', 'arpe anim up', 24);
				addByPrefix('singRIGHT', 'arpe anim right', 24);

				addByPrefix('singLEFT-alt', 'arpe anim alt left', 24);
				addByPrefix('singDOWN-alt', 'arpe anim alt down', 24);
				addByPrefix('singUP-alt', 'arpe anim alt up', 24);
				addByPrefix('singRIGHT-alt', 'arpe anim alt right', 24);

				dadStartingCamPosOffsets.set(202, 60);

				playAnim('idle');

			case 'gf':
				// GIRLFRIEND CODE
				loadTexture(Paths.getSparrowAtlas('characters/GF_assets', 'shared'));

				addByPrefix('cheer', 'GF Cheer');
				addByPrefix('singLEFT', 'GF left note');
				addByPrefix('singRIGHT', 'GF Right Note');
				addByPrefix('singUP', 'GF Up Note');
				addByPrefix('singDOWN', 'GF Down Note');
				anim.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "");
				anim.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "");
				anim.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "");
				anim.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				anim.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "");
				addByPrefix('scared', 'GF FEAR', 24);

				playAnim('danceRight');

				if (PlayState.isStoryMode)
					dadStartingCamPosOffsets.x += 600;

			case 'dad':
				loadTexture(Paths.getSparrowAtlas('characters/DADDY_DEAREST', 'shared'));

				addByPrefix('idle', 'Dad idle dance');
				addByPrefix('singUP', 'Dad Sing Note UP');
				addByPrefix('singRIGHT', 'Dad Sing Note RIGHT');
				addByPrefix('singDOWN', 'Dad Sing Note DOWN');
				addByPrefix('singLEFT', 'Dad Sing Note LEFT');

				playAnim('idle');

				dadStartingCamPosOffsets.x += 400;

				dadVar = 6.1;

			case 'bf':
				loadTexture(Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared'));

				addByPrefix('idle', 'BF idle dance');
				addByPrefix('singUP', 'BF NOTE UP0');
				addByPrefix('singLEFT', 'BF NOTE LEFT0');
				addByPrefix('singRIGHT', 'BF NOTE RIGHT0');
				addByPrefix('singDOWN', 'BF NOTE DOWN0');
				addByPrefix('singUPmiss', 'BF NOTE UP MISS');
				addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS');
				addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS');
				addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS');
				addByPrefix('hey', 'BF HEY!!');

				addByPrefix('firstDeath', "BF dies");
				addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				addByPrefix('deathConfirm', "BF Dead confirm");

				addByPrefix('scared', 'BF idle shaking', 24);

				playAnim('idle');

				flipX = true;
		}

		parseOffsets(character);

		for (animName in anim.getNameList())
			if (animOffsets[animName] == null)
				addOffset(animName);

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = anim.getByName('singRIGHT').frames;
				anim.getByName('singRIGHT').frames = anim.getByName('singLEFT').frames;
				anim.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (anim.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = anim.getByName('singRIGHTmiss').frames;
					anim.getByName('singRIGHTmiss').frames = anim.getByName('singLEFTmiss').frames;
					anim.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function addByPrefix(name:String, prefix:String, frameRate = 24.0, looped = false):Void
		anim.addByPrefix(name, prefix, frameRate, looped);

	function loadTexture(texture:FlxAtlasFrames)
		loadTextures([texture]);

	function loadTextures(textures:Array<FlxAtlasFrames>)
		frames = FlxAnimateFrames.combineAtlas(textures);

	var dadVar:Float = 4;

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (anim?.name.startsWith('sing'))
				holdTimer += elapsed;

			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf': if (anim?.name == 'hairFall' && anim?.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance()
	{
		if (debugMode)
			return;

		switch (curCharacter)
		{
			case 'gf':
				if (anim?.name.startsWith('hair'))
					return;

				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');

			default: playAnim('idle');
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		anim.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;
			else if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	public function parseOffsets(offsetFile:String)
	{
		final path:String = Paths.txt('characters/$offsetFile');

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
