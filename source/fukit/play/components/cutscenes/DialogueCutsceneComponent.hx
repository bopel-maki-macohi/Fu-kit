package fukit.play.components.cutscenes;

import fukit.play.components.CutsceneComponent;

class DialogueCutsceneComponent extends CutsceneComponent
{
	public var dialogueBox:DialogueBox;

	public var targetFile:String;

	override public function new(targetFile:String, endCallback:Void->Void)
	{
		super(endCallback);

		this.targetFile = targetFile;
	}

	override function create()
	{
		super.create();

		if (targetFile != null)
			loadDialogue(targetFile);
	}

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
