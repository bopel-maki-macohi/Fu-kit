package fukit.play.objects.ui;

import fukit.objects.FukitSprite;

enum abstract Rating(String) from String to String
{
	var shit = 'shit';
	var bad = 'bad';
	var good = 'good';
	var sick = 'sick';
}

class RatingSprite extends FukitSprite
{
	override public function new()
	{
		super();

		setRating(sick);
	}

	public function setRating(rating:Rating)
	{
		loadGraphic(Paths.image('UI/popups/$rating'));
		updateHitbox();
	}
}
