package fukit.debug;

import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import openfl.events.UncaughtErrorEvent;
import openfl.Lib;

class CrashHandler
{
	public static function init()
	{
		if (FlxG.signals.postUpdate.has(errorKeybind))
			return;

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
		
		FlxG.signals.postUpdate.add(errorKeybind);
	}

	public static var CRASH_KEY:FlxKey = F1;

	static function errorKeybind()
	{
		if (FlxG.keys.anyJustPressed([CRASH_KEY]))
			throw 'Crash via ${CRASH_KEY.toString()}';
	}

	static function onUncaughtError(event:UncaughtErrorEvent) {}
}
