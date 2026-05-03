package fukit.states.freeplay;

import fukit.objects.FukitSprite;

class FreeplayAlbum extends FukitSprite
{
	public static var albums:Array<String> = [];

	public var album:String = '_';

	override public function new()
	{
		super();

		setAlbum(null);
	}

	public function setAlbum(album:String)
	{
		if (this.album == album)
			return;

		this.album = album;

        this.visible = false;
		if (this.album == null)
			return;

        this.visible = true;
		this.loadGraphic(Paths.image('UI/freeplay/albums/$album'));

        setGraphicSize(320, 180);
	}
}
