package fukit.data;

import haxe.io.Path;
import sys.FileSystem;

class CharacterRegistry
{
	public static final characterDataPath:String = Paths.file('data/characters');

	public static var list:Array<String> = [];

	public static function reloadCharacterRegistry()
	{
		list = [];

		for (file in FileSystem.readDirectory(characterDataPath))
		{
			var ext:String = Path.extension(file);

			if (ext != 'json')
				continue;

			list.push(Path.withoutExtension(file));
		}

		trace('${list.length} char(s) via $characterDataPath');
	}
}
