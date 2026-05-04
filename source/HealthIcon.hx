package;

import fukit.objects.FukitSprite;
import flixel.util.FlxColor;

class HealthIcon extends FukitSprite
{
	public function new(char:String, isPlayer:Bool = false)
	{
		super();

		switch (char)
		{
			case 'arpe', 'arpe-worried', 'arpe-withered', 'folir', 'folir-pissed', 'rd': makeBaseFuKitIcon(char, isPlayer);

			default: makeDefaultIcon(char, isPlayer);
		}

		playAnim(char);

		scrollFactor.set();
	}

	function makeBaseFuKitIcon(char:String, isPlayer:Bool = false)
	{
		loadGraphic(Paths.image('UI/icons/fu-kit_baseIcon'), true, 150, 150);
		anim.add(char, [0, 1], 0, false, isPlayer);

		color = switch (char)
		{
			case 'arpe-withered':
				0x6B597D;

			case 'arpe', 'arpe-worried':
				0x786D8E;

			case 'folir', 'folir-pissed':
				0xCC9999;

			case 'rd':
				0x412E3E;

			default:
				FlxColor.WHITE;
		}
	}

	function makeDefaultIcon(char:String, isPlayer:Bool = false)
	{
		loadGraphic(Paths.image('UI/icons/icon-$char'), true, 150, 150);
		anim.add(char, (char == 'gf' || char == 'dad') ? [0, 0] : [0, 1], 0, false, isPlayer);
	}
}
