package fukit.states;

import flixel.group.FlxGroup;
import flixel.FlxG;

class SplashTextState extends MusicBeatState
{
	public var wackyList:Array<String> = [];

	public var alphabets:FlxGroup;

	override function create()
	{
		super.create();

		var wackyStr = FlxG.random.getObject(CoolUtil.coolTextFile(Paths.txt('introText')));
		wackyList = wackyStr.split('--');
		trace('wackyList: $wackyList');

		alphabets = new FlxGroup();
		add(alphabets);

		Conductor.changeBPM(75);

		FlxG.sound.playMusic(Paths.music('StartupJingle', 'fu-kit'), 1.0, false);
		FlxG.sound.music.onComplete = onEnd;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		FlxG.mouse.visible = false;

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (controls.ACCEPT)
		{
			FlxG.sound.music.stop();
			FlxG.sound.music.destroy();

			onEnd();
		}
	}

	function onEnd()
	{
		FlxG.switchState(() -> new NewMenuState());
	}

	var mylaststep:Int = 0;

	override function stepHit()
	{
		super.stepHit();

		if (mylaststep < curStep)
		{
			trace(mylaststep);

			switch (mylaststep)
			{
				case 0, 12: clearTexts();

				case 1: addText('fu');

				case 2: addText('kit');

				case 3: addText('mod');

				case 14: addText(wackyList[0]);

				case 18: addText(wackyList[1]);

				case 22: addText(wackyList[2]);
			}

			mylaststep++;
		}
	}

	var curTexts:Array<String> = [];

	function addText(text:String)
	{
		if (curTexts.contains(text))
		{
			trace('no repeats!');
			return;
		}

		curTexts.push(text);
		trace('$text');

		var alphabet:Alphabet = new Alphabet(0, 0, text, true);
		alphabet.screenCenter();
		alphabet.y = (alphabets.length * 60) + 200;
		alphabets.add(alphabet);
	}

	function clearTexts()
	{
		alphabets.clear();
	}
}
