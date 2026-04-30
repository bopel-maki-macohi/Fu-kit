package fukit.states.ui;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxSignal;
import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;

enum MenuListType
{
	Vertical;
	Horizontal;
}

class MenuList extends FlxTypedSpriteGroup<FlxSprite>
{
	public var items:Map<String, Void->Void>;
	public var itemKeys:Array<String>;

	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public var type:MenuListType;

	public var canSelect:Bool = true;

	override public function new(type:MenuListType)
	{
		super();

		this.items = [];
		this.itemKeys = [];

		this.type = type;
	}

	public function addEntry(item:String, method:Void->Void)
	{
		items.set(item, method);
		itemKeys.push(item);
	}

	public var curSelect:Int = 0;

	public var onRegenItems:FlxSignal = new FlxSignal();
	public var onSelectionChange:FlxSignal = new FlxSignal();

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		var prevSelect:Int = curSelect;

		if (canSelect)
			if (type == Vertical)
			{
				if (controls.UP_P)
					curSelect--;
				if (controls.DOWN_P)
					curSelect++;
			}

		if (canSelect)
			if (type == Horizontal)
			{
				if (controls.LEFT_P)
					curSelect--;
				if (controls.RIGHT_P)
					curSelect++;
			}

		if (curSelect < 0)
			curSelect = itemKeys.length - 1;
		if (curSelect > itemKeys.length - 1)
			curSelect = 0;

		if (curSelect != prevSelect)
			onSelectionChange.dispatch();

		if (canSelect)
			if (controls.ACCEPT)
			{
				var item = itemKeys[curSelect];

				trace(item);

				if (items.get(item) != null)
					items.get(item)();
			}
	}

	public function regenItems()
	{
		for (item in members)
		{
			members.remove(item);
			item.destroy();
		}

		clear();

		for (item in itemKeys)
			addItem(item);

		onRegenItems.dispatch();

		curSelect = 0;
		onSelectionChange.dispatch();
	}

	/**
	 * Add your sprites
	 */
	public dynamic function addItem(item:String)
	{
		var sprite:FlxSprite = new FlxSprite().makeGraphic(64, 64);

		sprite.screenCenter();

		if (type == Vertical)
			sprite.y = (members.length * 60);
		else
			sprite.x = (members.length * 120);

		sprite.ID = members.length;

		add(sprite);
	}

	public function clearList()
	{
		items.clear();
		itemKeys = [];
	}
}
