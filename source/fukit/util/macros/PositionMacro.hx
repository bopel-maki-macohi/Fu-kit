package fukit.util.macros;

class PositionMacro
{
	public macro static function currentPosition()
	{
		return macro $v{Std.string(haxe.macro.Context.currentPos())};
	}
}
