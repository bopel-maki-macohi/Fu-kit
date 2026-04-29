package fukit.shaders;

import lime.utils.Assets;
import flixel.addons.display.FlxRuntimeShader;

class RainShader extends FlxRuntimeShader
{
	override public function new()
	{
		super(Assets.getText(Paths.frag('rain')));
	}

	public var uTime(get, set):Float;

	function get_uTime():Float
	{
		return getFloat('uTime');
	}

	function set_uTime(uTime:Float):Float
	{
        setFloat('uTime', uTime);

		return uTime;
	}

	/**
	 * 0 - 1
     * 
     * 0 - none
     * 1 - max
	 */
	public var uIntensity(get, set):Float;

	function get_uIntensity():Float
	{
		return getFloat('uIntensity');
	}

	function set_uIntensity(uIntensity:Float):Float
	{
        setFloat('uIntensity', uIntensity);

		return uIntensity;
	}
}
