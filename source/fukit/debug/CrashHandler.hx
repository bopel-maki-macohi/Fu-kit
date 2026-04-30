package fukit.debug;

import sys.io.File;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import sys.FileSystem;
import fukit.util.DateUtil;
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

		#if debug
		if (FileSystem.exists(SCREENSHOT_DIRECTORY))
			FileSystem.deleteDirectory(SCREENSHOT_DIRECTORY);
		#end

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);

		FlxG.signals.postUpdate.add(errorKeybind);
	}

	public static var CRASH_KEY:FlxKey = F1;

	static function errorKeybind()
	{
		if (FlxG.keys.anyJustPressed([CRASH_KEY]))
			throw 'Crash via ${CRASH_KEY.toString()}';
	}

	public static var CRASH_DIRECTORY:String =
		#if debug
		'../../../../dump/crash';
		#else
		'crash';
		#end

	static function onUncaughtError(event:UncaughtErrorEvent)
	{
		var path:String = '$CRASH_DIRECTORY/${DateUtil.generateCurrentFileTimestamp()}.log';

		if (!FileSystem.exists(CRASH_DIRECTORY))
			FileSystem.createDirectory(CRASH_DIRECTORY);

		var errorMessage:String = 'Uncaught Error: ${event.toString()}\n\n';

		var callStack:Array<StackItem> = CallStack.exceptionStack(true);

		errorMessage += 'Callstack: ';
		for (item in callStack)
		{
			switch (item)
			{
				default:
					errorMessage += '- ${item.getName()}[${item}]\n';
			}
		}

		errorMessage += 'Please report to the github: https://github.com/bopel-maki-macohi/Fu-kit/issues';

		File.saveContent(path, errorMessage);
	}
}
