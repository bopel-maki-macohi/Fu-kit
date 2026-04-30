package fukit.states;

import flixel.FlxG;

class SplashTextState extends MusicBeatState
{
	public var wackyList:Array<String> = [];

	override function create()
	{
		super.create();

		var wackyStr = FlxG.random.getObject(CoolUtil.coolTextFile(Paths.txt('introText')));
		wackyList = wackyStr.split('--');
		trace('wackyList: $wackyList');

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
}
