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

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
	}

	function onEnd()
	{
		FlxG.switchState(() -> new MainMenuState());
	}

	var mylastbeat:Int = 0;

	override function beatHit()
	{
		super.beatHit();

		if (mylastbeat < curBeat)
		{
			trace(mylastbeat);

			function addTextsForLengthAtBeats(len:Int, beats:Array<Int>)
			{
				if (wackyList.length == len)
					for (i => beat in beats)
					{
						if (mylastbeat == beat)
							addText(wackyList[i]);
					}
			}

			addTextsForLengthAtBeats(1, [3]);
			addTextsForLengthAtBeats(2, [0, 3]);
			addTextsForLengthAtBeats(3, [0, 2, 4]);
			addTextsForLengthAtBeats(4, [0, 1, 3, 4]);
			addTextsForLengthAtBeats(5, [0, 1, 2, 3, 5]);
			addTextsForLengthAtBeats(6, [0, 1, 2, 3, 4, 5]);

			mylastbeat++;
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
}
