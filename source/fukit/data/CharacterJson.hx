package fukit.data;

enum abstract CharacterAtlasType(String) from String to String
{
	var animate = 'animate';
	var sparrow = 'sparrow';
}

typedef CharacterJson =
{
	?textures:Array<String>,

	atlasType:CharacterAtlasType,

	animations:Array<CharacterJsonAnimation>,

	?dadStartingCamPosOffsets:Array<Float>,
	?offsetFiles:Array<String>,

	?flipX:Bool,
	?dadVar:Float,
}

typedef CharacterJsonAnimation =
{
	name:String,

	?framelabel:String,
	?prefix:String,
	?indices:Array<Int>,

	?looping:Bool,
}
