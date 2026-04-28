package fukit.plugins;

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

    public static var SCREENSHOT_KEY:FlxKey = F3;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

        if (FlxG.keys.anyPressed([SCREENSHOT_KEY]))
            performScreenshot();
	}

    public static var SCREENSHOT_DIRECTORY:String = 'screenshots';

    function performScreenshot()
    {
        var path:String = '$SCREENSHOT_DIRECTORY/${Date.now().getTime()}';

        if (!FileSystem.exists(SCREENSHOT_DIRECTORY))
            FileSystem.createDirectory(SCREENSHOT_DIRECTORY);

        var data:BitmapData = BitmapData.fromImage(FlxG.stage.window.readPixels());
        File.saveBytes(path, data.encode(data.rect, new PNGEncoderOptions()));

        FlxG.camera.flash();

        showFancyPreview(data);
    }

    function showFancyPreview(data:BitmapData)
    {
        var sprite:Bitmap = new Bitmap(data);

        FlxG.stage.addChild(sprite);

        FlxTween.tween(sprite, {alpha: 0}, 1, {
            startDelay: 1, 
            onComplete: t -> {
                FlxG.stage.removeChild(sprite);
                sprite.bitmapData.dispose();
            }
        });
    }
}
