package fukit.states.ui;

import flixel.FlxSprite;
import fukit.objects.FukitSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;

class ScoreBox extends FlxTypedGroup<FlxSprite>
{
	public var box:FukitSprite;
	public var textField:FlxText;

	public var x(get, set):Float;

	function get_x():Float
		return box.x;

	function set_x(x:Float):Float
		return box.x = x;

	public var y(get, set):Float;

	function get_y():Float
		return box.y;

	function set_y(y:Float):Float
		return box.y = y;

	public var width(get, set):Float;

	function get_width():Float
		return box.width;

	function set_width(width:Float):Float
		return box.width = width;

	public var height(get, set):Float;

	function get_height():Float
		return box.height;

	function set_height(height:Float):Float
		return box.height = height;

	public var alpha(get, set):Float;

	function get_alpha():Float
		return box.alpha;

	function set_alpha(alpha:Float):Float
		return box.alpha = alpha;

	public var text(get, set):String;

	function get_text():String
		return textField.text;

	function set_text(text:String):String
		return textField.text = text;

	override public function new()
	{
		super();

		box = new FukitSprite();
		box.makeGraphic(320, 160, FlxColor.BLACK);
		add(box);
		box.alpha = 0;

		textField = new FlxText(0, 0, box.width, 'Bob', 32);
		add(textField);

		textField.alignment = CENTER;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		textField.x = x;
		textField.y = y + textField.height / 2;
	}
}
