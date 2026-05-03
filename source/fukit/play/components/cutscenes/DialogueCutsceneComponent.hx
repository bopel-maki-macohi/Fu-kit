package fukit.play.components.cutscenes;

import flixel.FlxG;
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
		{
			makeMusic();
			loadDialogue(targetFile);
		}
	}

	public function makeMusic()
	{
		FlxG.sound.playMusic(Paths.music('MainTheme', 'fu-kit'), 0);
		FlxG.sound.music.fadeIn(1, 0, 0.8);
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

		dialogueBox.onLine.add(onLine);
		dialogueBox.onEnd.add(onEnd);
	}

	public function onLine(line:Int) {}

	public function onEnd() {}
}
