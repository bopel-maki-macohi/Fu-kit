package;

import fukit.states.SplashTextState;
import haxe.Http;
import fukit.objects.FukitSprite;
import fukit.states.NewMenuState;
import fukit.Global;
import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class OutdatedSubState extends MusicBeatState
{
	public static var leftState:Bool = false;

	public static var needVer:String = "IDFK LOL";

	override function create()
	{
		super.create();
		var bg:FukitSprite = new FukitSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Fu-Kit is Outdated!\n"
			+ Global.modVer
			+ " is your current version\nwhile the most recent version is "
			+ needVer
			+ "!\nPress Space to go to the github or ESCAPE to ignore this!!",
			32);
		txt.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		txt.screenCenter();
		add(txt);
	}

	override function update(elapsed:Float)
	{
		if (controls.ACCEPT || controls.BACK)
		{
			if (controls.ACCEPT)
				FlxG.openURL("https://github.com/bopel-maki-macohi/Fu-kit/releases/latest");

			leftState = true;
			FlxG.switchState(() -> new SplashTextState());
		}
		super.update(elapsed);
	}

	public static function getOutdated():Bool
	{
		var http:Http = new Http('https://raw.githubusercontent.com/bopel-maki-macohi/Fu-kit/refs/heads/main/version.downloadMe');

		var outdated:Bool = false;

		#if hl
		return false;
		#end

		http.onData = (str) ->
		{
			outdated = str.trim() != Global.modVer;
		}

		http.onError = (err) ->
		{
			trace('http error: $err');
			outdated = false;
		}

		http.request();

		return outdated;
	}
}
