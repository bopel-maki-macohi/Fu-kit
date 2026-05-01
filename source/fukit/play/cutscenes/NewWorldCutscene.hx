package fukit.play.cutscenes;

import fukit.play.components.cutscenes.DialogueCutsceneComponent;

class NewWorldCutscene extends DialogueCutsceneComponent
{
	override function create()
	{
		super.create();

		loadDialogue('new world');
	}
}
