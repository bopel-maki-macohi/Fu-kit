package fukit;

class Global
{
	public static var watermarkText(get, never):String;

	static function get_watermarkText():String
	{
		if (Main.watermarks)
			return 'Fu-kit ${MainMenuState.modVer}' + ' (KE ${MainMenuState.kadeEngineVer})';

		return MainMenuState.modVer;
	}
}
