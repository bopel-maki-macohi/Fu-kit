package fukit.play.components.cutscenes;

import fukit.play.components.CutsceneComponent;

class DialogueCutsceneComponent extends CutsceneComponent
{
	public var dialogueBox:DialogueBox;

	public function loadDialogue(file:String)
	{
		var dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/$file'));

		if (dialogue.length < 1)
		{
			leave();
			return;
		}

		dialogueBox = new DialogueBox(true, dialogue);
		add(dialogueBox);

		dialogueBox.finishThing = leave;
	}
}
