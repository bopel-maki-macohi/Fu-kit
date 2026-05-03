package fukit.util.macros;

class VariableMacro
{
	public macro static function nameof(e:haxe.macro.Expr):haxe.macro.Expr
	{
		return switch e.expr
		{
			case EConst(CIdent(ident)): macro $v{ident};
			case _: throw "identifier expected";
		}
	}
}
