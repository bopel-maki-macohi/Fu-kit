package fukit.play.songs;

import flixel.math.FlxMath;
import flixel.FlxG;
import openfl.filters.ShaderFilter;
import fukit.shaders.RuntimeRainShader;
import fukit.play.components.SongComponent;

class World1Song extends SongComponent
{
	var rainShader:RuntimeRainShader = new RuntimeRainShader();
	var rainShaderFilter:ShaderFilter;

	// as song goes on, these are used to make the rain more intense throught the song
	// these values are also used for the rain sound effect volume intensity!
	var rainShaderStartIntensity:Float = 0;
	var rainShaderEndIntensity:Float = 0;

	override function init()
	{
		super.init();

		if (game == null)
			return;

		rainShader.scale = FlxG.height / 200; // adjust this value so that the rain looks nice

		switch (game.curSong.toLowerCase())
		{
			case 'new world':
				rainShaderStartIntensity = 0;
				rainShaderEndIntensity = 0.1;
		}

		rainShader.intensity = rainShaderStartIntensity;

		rainShaderFilter = new ShaderFilter(rainShader);
		game.camGame.filters = [rainShaderFilter];
	}

	override function onCreate()
	{
		super.onCreate();

		trace('New World!');
	}

	override function onUpdate(elapsed:Float)
	{
		super.onUpdate(elapsed);

		if (FlxG.sound.music != null)
		{
			var remappedIntensityValue:Float = FlxMath.remapToRange(Conductor.songPosition, 0, FlxG.sound.music.length, rainShaderStartIntensity,
				rainShaderEndIntensity);

			rainShader.intensity = remappedIntensityValue;
		}
		else
		{
			rainShader.intensity = rainShaderStartIntensity;
		}

		rainShader.updateViewInfo(FlxG.width, FlxG.height, FlxG.camera);
		rainShader.update(elapsed);
	}
}
