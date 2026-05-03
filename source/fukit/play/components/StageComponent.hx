package fukit.play.components;

import flixel.FlxSprite;

enum StageObjectLayer
{
	back;
	front;
}

class StageComponent extends PlayComponent
{
	public var members:Array<FlxSprite> = [];

	override function init()
	{
		super.init();

		if (game != null)
			makeStage();
	}

	public function makeStage() {}

	public function add(object:FlxSprite, layer:StageObjectLayer = back)
	{
		members.push(object);

		if (game == null)
			return;

		switch (layer)
		{
			case front: game.frontShit.add(object);
			case back: game.backShit.add(object);
		}
	}

	public function remove(object:FlxSprite)
	{
		members.remove(object);

		if (game == null)
			return;

		if (game.frontShit.members.contains(object))
			game.frontShit.remove(object);

		if (game.backShit.members.contains(object))
			game.backShit.remove(object);
	}
}
