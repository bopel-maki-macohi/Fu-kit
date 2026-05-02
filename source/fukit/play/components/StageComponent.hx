package fukit.play.components;

import flixel.FlxBasic;

enum StageObjectLayer
{
	back;
	front;
}

class StageComponent extends PlayComponent
{
	public var members:Array<FlxBasic> = [];

	override function init()
	{
		super.init();

		if (game != null)
			makeStage();
	}

	public function makeStage() {}

	public function add(object:FlxBasic, layer:StageObjectLayer = back)
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

	public function remove(object:FlxBasic)
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
