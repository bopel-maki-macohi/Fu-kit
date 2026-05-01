package fukit.play.cutscenes;

import fukit.play.components.CutsceneComponent;

class NewWorldCutscene extends CutsceneComponent
{
    public var dialogueBox:DialogueBox;

	override function create()
	{
		super.create();

		var dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/new world', 'fu-kit'));

		if (dialogue.length < 1 || !PlayState.isStoryMode)
        {
            leave();
            return;
        }

        dialogueBox = new DialogueBox(true, dialogue);
        add(dialogueBox);

        dialogueBox.finishThing = leave;
	}
}
