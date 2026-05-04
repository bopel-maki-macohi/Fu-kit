package fukit.util.macros;

import haxe.macro.Expr;
class BuildDate
{
    public static macro function generate():Expr
    {
        var BD:String = '';
        var currentDate:Date = Date.now();

        BD = currentDate.toString();

        haxe.macro.Context.info('Build Date: ${BD}', haxe.macro.Context.currentPos());

        return macro $v{BD};
    }
}