package fukit.play.objects.ui;

import fukit.objects.FukitSprite;

class StaticNote extends FukitSprite
{
	override public function new(i:Int = 0, ?x:Float = 0, ?y:Float = 0)
	{
		super(x, y);

		this.ID = i;

		loadAsset();

		updateHitbox();
		scrollFactor.set();

		animation.play('static');
	}

	public function loadAsset()
	{
		var dir = ['left', 'down', 'up', 'right'];

		loadTexture(Paths.getSparrowAtlas('NOTE_assets'));
		setGraphicSize(Std.int(width * 0.7));

		addByPrefix('static', 'arrow${dir[ID].toUpperCase()}');
		addByPrefix('pressed', '${dir[ID].toLowerCase()} press');
		addByPrefix('confirm', '${dir[ID].toLowerCase()} confirm');

		this.x += Note.swagWidth * ID;
	}
}
