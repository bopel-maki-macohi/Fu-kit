package fukit.plugins;

import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.display.Sprite;
import openfl.display.PNGEncoderOptions;
import sys.io.File;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import sys.FileSystem;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxBasic;

class ScreenshotPlugin extends FlxBasic
{
	public static function init()
	{
		FlxG.plugins.addIfUniqueType(new ScreenshotPlugin());
	}

	override public function new()
	{
		super();

		lastDate = Date.now();
	}

	public static var SCREENSHOT_KEY:FlxKey = F3;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.anyJustPressed([SCREENSHOT_KEY]))
			performScreenshot();
	}

	public static var SCREENSHOT_DIRECTORY:String =
	#if debug
	'../../../../dump/screenshots';
	#else
	'screenshots';
	#end

	public static var SCREENSHOT_DELAY_TIME_SECONDS:Float = 5;

	var lastDate:Date;
	var currentDate:Date;

	function performScreenshot()
	{
		// Wanted format:
		// Screenshot 2026-04-28 162426

		currentDate = Date.now();

		var timeDifference:Float = currentDate.getTime() - lastDate.getTime();

		if (timeDifference < SCREENSHOT_DELAY_TIME_SECONDS * 1000)
		{
			// trace('timeDifference: $timeDifference');
			return;
		}

		lastDate = currentDate;

		var formatText:String = 'Screenshot ${currentDate.getFullYear()}-${currentDate.getMonth()}-${currentDate.getDate()} ${Math.round(currentDate.getTime() / 1000)}';

		var path:String = '$SCREENSHOT_DIRECTORY/$formatText.png';

		if (!FileSystem.exists(SCREENSHOT_DIRECTORY))
			FileSystem.createDirectory(SCREENSHOT_DIRECTORY);

		var data:BitmapData = BitmapData.fromImage(FlxG.stage.window.readPixels());
		File.saveBytes(path, data.encode(data.rect, new PNGEncoderOptions()));

		showFancyPreview(data);

		FlxG.sound.play(Paths.sound('screenshot', 'shared'));
	}

	function showFancyPreview(data:BitmapData)
	{
		var previewSprite:Bitmap = new Bitmap(data);
		FlxG.stage.addChild(previewSprite);

		var flashSprite:Sprite = new Sprite();
		var flashBitmap = new Bitmap(new BitmapData(FlxG.width * 2, FlxG.height * 2, true, FlxG.save.data.flashing ? FlxColor.WHITE : FlxColor.TRANSPARENT));

		flashSprite.mouseEnabled = false;
		flashSprite.addChild(flashBitmap);

		FlxG.stage.addChild(flashSprite);

		FlxTween.tween(flashSprite, {
			alpha: 0
		}, 1, {
			ease: FlxEase.sineInOut
		});

		FlxTween.tween(previewSprite, {
			scaleX: 0.2,
			scaleY: 0.2,
			x: 0,
			y: 0
		}, 1, {
			ease: FlxEase.sineInOut
		});

		FlxTween.tween(previewSprite, {alpha: 0, y: -previewSprite.height}, 1, {
			startDelay: 1,
			onComplete: t ->
			{
				FlxG.stage.removeChild(previewSprite);
				previewSprite.bitmapData.dispose();
			}
		});
	}
}
