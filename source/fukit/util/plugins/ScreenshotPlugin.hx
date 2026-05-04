package fukit.util.plugins;

import openfl.utils.Object;
import fukit.states.freeplay.NewFreeplayState;
import fukit.util.DateUtil;
import openfl.desktop.Clipboard;
import openfl.utils.ByteArray;
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
	public static var instance:ScreenshotPlugin;

	public static function init()
	{
		FlxG.plugins.addIfUniqueType(instance = new ScreenshotPlugin());
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

	public function takeScreenshot(save:Bool = true, forced:Bool = false)
	{
		if (!forced)
		{
			currentDate = Date.now();

			var timeDifference:Float = currentDate.getTime() - lastDate.getTime();

			if (timeDifference < SCREENSHOT_DELAY_TIME_SECONDS * 1000)
				return null;

			lastDate = currentDate;
		}

		var data:BitmapData = BitmapData.fromImage(FlxG.stage.window.readPixels());

		if (encoder == null)
			encoder = new PNGEncoderOptions();

		var bytes:ByteArray = data.encode(data.rect, encoder);

		if (save)
		{
			var formatText:String = 'Screenshot ${DateUtil.generateFileTimestamp(currentDate)}';

			var path:String = '$SCREENSHOT_DIRECTORY/$formatText.png';

			if (!FileSystem.exists(SCREENSHOT_DIRECTORY))
				FileSystem.createDirectory(SCREENSHOT_DIRECTORY);

			File.saveBytes(path, bytes);
		}

		return data;
	}

	public var encoder:Object;

	function performScreenshot()
	{
		var data:BitmapData = takeScreenshot();

		var fancyPreviewEnabled:Bool = data != null;

		if (Std.isOfType(FlxG.state, PlayState))
			fancyPreviewEnabled = false;

		// why?
		// if (Std.isOfType(FlxG.state?.subState, NewFreeplayState))
		// 	fancyPreviewEnabled = false;

		if (fancyPreviewEnabled)
			showFancyPreview(data);

		FlxG.sound.play(Paths.sound('screenshot', 'shared'));
	}

	public function showFancyPreview(data:BitmapData)
	{
		var previewSprite:Bitmap = new Bitmap(data);
		FlxG.stage.addChild(previewSprite);

		var flashSprite:Sprite = new Sprite();
		var flashBitmap = new Bitmap(new BitmapData(FlxG.width * 2, FlxG.height * 2, true, FlxG.save.data.flashing ? FlxColor.WHITE : FlxColor.TRANSPARENT));

		flashSprite.mouseEnabled = false;
		flashSprite.addChild(flashBitmap);

		FlxG.stage.addChild(flashSprite);

		var fancyPreviewTween:FlxTween = null;
		var fancyPreviewFlashTween:FlxTween = null;

		fancyPreviewFlashTween = FlxTween.tween(flashSprite, {
			alpha: 0
		}, 1, {
			ease: FlxEase.sineInOut,
			onComplete: t ->
			{
				FlxG.stage.removeChild(flashSprite);
				fancyPreviewFlashTween.destroy();
			}
		});

		fancyPreviewTween = FlxTween.tween(previewSprite, {
			scaleX: 0.2,
			scaleY: 0.2,
			x: 0,
			y: 0
		}, 1, {
			ease: FlxEase.sineInOut
		}).then(FlxTween.tween(previewSprite, {alpha: 0, y: -previewSprite.height}, 1, {
			startDelay: 1,
			onComplete: t ->
			{
				FlxG.stage.removeChild(previewSprite);
				previewSprite.bitmapData.dispose();

				fancyPreviewTween.destroy();
			}
		}));

		function stateTransition()
		{
			fancyPreviewTween.cancel();
			fancyPreviewFlashTween.cancel();

			FlxG.stage.removeChild(previewSprite);
			previewSprite.bitmapData.dispose();

			fancyPreviewTween.destroy();
			fancyPreviewFlashTween.destroy();

			FlxG.signals.postStateSwitch.remove(stateTransition);
		}

		FlxG.signals.postStateSwitch.add(stateTransition);
	}
}
