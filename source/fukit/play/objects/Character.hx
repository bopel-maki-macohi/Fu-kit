package fukit.play.objects;

import haxe.Json;
import fukit.data.CharacterJson;
import fukit.play.objects.ui.Note;
import fukit.objects.FukitSprite;
import lime.utils.Assets;
import flixel.math.FlxPoint;
import animate.FlxAnimateFrames;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FukitSprite
{
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
	public var generalOffsets:FlxPoint;

	public function setCharacter(character:String = 'bf', isPlayer:Bool = false)
	{
		curCharacter = character;
		this.isPlayer = isPlayer;

		animOffsets = [];

		camFocusPosOffsets = FlxPoint.weak(0, 0);
		dadStartingCamPosOffsets = FlxPoint.weak(0, 0);
		generalOffsets = FlxPoint.weak(0, 0);

		switch (curCharacter)
		{
			default: parseCharacterJson(curCharacter);
		}

		parseOffsets(curCharacter);

		for (animName in getAnimList())
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

	var dadVar:Float = 4;

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (anim?.name?.startsWith('sing'))
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
				if (anim?.name?.startsWith('hair'))
					return;

				danced = !danced;

				if (danced)
					playAnim('danceRight');
				else
					playAnim('danceLeft');

			default: playAnim('idle');
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		anim.play(AnimName, Force, Reversed, Frame);

		offset.set(generalOffsets.x, generalOffsets.y);
		if (animOffsets.exists(AnimName))
		{
			var daOffset = animOffsets.get(AnimName);
			
			offset.x += daOffset[0];
			offset.y += daOffset[1];
		}

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

	override public function parseOffsets(path:String)
	{
		super.parseOffsets('characters/$path');
	}

	public function parseCharacterJson(character:String)
	{
		var path:String = Paths.json('characters/$character');

		if (!Paths.exists(path))
		{
			trace('$character has no json at $path');
			return;
		}

		var data:CharacterJson = null;

		try
		{
			data = Json.parse(Assets.getText(path));
		}
		catch (e)
		{
			FlxG.stage.window.alert('$e', 'Character JSON Parsing Error');
			return;
		}

		if (data.textures == null)
			return;
		if (data.animations == null)
			return;
		if (data.atlasType == null)
			return;

		if (data.offsetFiles == null || data.offsetFiles == [])
			data.offsetFiles = [character];

		var textures:Array<FlxAtlasFrames> = [];

		var atlasType = data.atlasType;
		for (texturePath in data.textures)
		{
			var FAF:FlxAtlasFrames = null;

			switch (atlasType)
			{
				case animate: FAF = Paths.getAnimateAtlas(texturePath);
				case sparrow: FAF = Paths.getSparrowAtlas(texturePath);
			}

			if (FAF != null)
				textures.push(FAF);
		}

		loadTextures(textures);

		for (animData in data.animations)
		{
			if (animData.name == null)
				continue;

			final animateAnim:Bool = atlasType == animate && animData.framelabel != null;
			final sparrowAnim:Bool = atlasType == sparrow && animData.prefix != null;

			if (animData.indices != null)
			{
				if (animateAnim)
					anim.addByFrameLabelIndices(animData.name, animData.framelabel, animData.indices, 24, animData?.looping ?? false);
				else if (sparrowAnim)
					anim.addByIndices(animData.name, animData.prefix, animData.indices, '', 24, animData?.looping ?? false);
			}
			else
			{
				if (animateAnim)
					addByFrameLabel(animData.name, animData.framelabel, 24, animData?.looping ?? false);
				else if (sparrowAnim)
					addByPrefix(animData.name, animData.prefix, 24, animData?.looping ?? false);
			}
		}

		this.flipX = data?.flipX ?? false;
		this.dadVar = data?.dadVar ?? 4;

		for (offsetFile in data.offsetFiles)
			parseOffsets(offsetFile);

		if (data.dadStartingCamPosOffsets != null)
		{
			if (data.dadStartingCamPosOffsets.length >= 1)
				dadStartingCamPosOffsets.x += data.dadStartingCamPosOffsets[0];

			if (data.dadStartingCamPosOffsets.length > 1)
				dadStartingCamPosOffsets.y += data.dadStartingCamPosOffsets[1];
		}

		if (data.camFocusPosOffsets != null)
		{
			if (data.camFocusPosOffsets.length >= 1)
				camFocusPosOffsets.x += data.camFocusPosOffsets[0];

			if (data.camFocusPosOffsets.length > 1)
				camFocusPosOffsets.y += data.camFocusPosOffsets[1];
		}

		if (data.generalOffsets != null)
		{
			if (data.generalOffsets.length >= 1)
				generalOffsets.x += data.generalOffsets[0];

			if (data.generalOffsets.length > 1)
				generalOffsets.y += data.generalOffsets[1];
		}
	}
}
