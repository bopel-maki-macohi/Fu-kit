package fukit.play.objects;

import flixel.FlxSprite;

class StaticNote extends FlxSprite
{
	override public function new(i:Int = 0, ?x:Float = 0, ?y:Float = 0)
	{
		super(0, y);

		this.ID = i;

		loadAsset();

		updateHitbox();
		scrollFactor.set();

		animation.play('static');
	}

	public function loadAsset()
	{
		var dir = ['left', 'down', 'up', 'right'];
        
		frames = Paths.getSparrowAtlas('NOTE_assets');
		setGraphicSize(Std.int(width * 0.7));

		animation.addByPrefix('static', 'arrow${dir[ID].toUpperCase()}');
		animation.addByPrefix('pressed', '${dir[ID].toLowerCase()} press', 24, false);
		animation.addByPrefix('confirm', '${dir[ID].toLowerCase()} confirm', 24, false);

		this.x += Note.swagWidth * ID;
	}
}
