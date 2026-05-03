package fukit.util.macros;

import haxe.macro.Expr;

class DefineMacro
{
	public static macro function defined(key:String):Expr
	{
		return macro $v{haxe.macro.Context.defined(key)};
	}

	public static macro function definedValue(key:String, ?defaultValue:String = null):Expr
	{
		var value:Null<String> = haxe.macro.Context.definedValue(key);

		if (value == null)
			value = defaultValue;

		return macro $v{value};
	}
}
