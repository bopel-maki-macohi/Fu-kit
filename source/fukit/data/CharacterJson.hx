package fukit.data;

typedef CharacterJson =
{
	?textures:Array<String>,

	atlasType:String,

	animations:Array<CharacterJsonAnimation>,

    ?dadStartingCamPosOffsets:Array<Float>,
	?offsetFiles:Array<String>,
}

typedef CharacterJsonAnimation = {
    name:String,
    
    ?framelabel:String,
    ?prefix:String,
    ?indices:Array<Int>,

    ?looping:Bool,
}
