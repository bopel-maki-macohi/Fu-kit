package fukit.play.songs;

import flixel.FlxG;
import fukit.play.objects.ui.Note;
import fukit.play.components.SongComponent;

using StringTools;

class RDSong extends SongComponent
{
	override function onCreate()
	{
		super.onCreate();

		if (game == null)
			return;

		game.applyMiddleScroll();
	}

	override function onNoteMiss(direction:Int, note:Note)
	{
		super.onNoteMiss(direction, note);

		if (game == null)
			return;

		game.health = -10;
	}

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);

		if (game == null)
			return;

		game.scoreTxt.text = game.scoreTxt.text.replace(' | Misses: ${game.misses}', ' | No Missing' + (FlxG.save.data.ghostTapping ? ', Cheater' : ''));
	}
}
