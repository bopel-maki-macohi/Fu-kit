package fukit.play.components;

class SongComponent extends PlayComponent
{
	public function startDialogue(dialogue:Array<String>)
	{
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		doof.scrollFactor.set();
		doof.finishThing = game.startCountdown;

        game.inCutscene = true;
		game.add(doof);
	}
}
