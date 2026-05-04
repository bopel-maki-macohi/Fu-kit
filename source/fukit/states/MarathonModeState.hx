package fukit.states;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import fukit.states.ui.MenuList;

class MarathonModeState extends MusicBeatSubstate
{
	public var difficultyMenuList:MenuList;

	override function create()
	{
		super.create();

		difficultyMenuList = new MenuList(Horizontal);
		add(difficultyMenuList);

		difficultyMenuList.addItem = item -> Global.addTextMenuListItem(difficultyMenuList, item, 0, 0);
		difficultyMenuList.onSelectionChange.add(() -> Global.onTextSelectionChange(difficultyMenuList));

		for (diffculty in CoolUtil.difficultyArray)
			difficultyMenuList.addEntry(diffculty, null);
		difficultyMenuList.y = -FlxG.height;

		difficultyMenuList.regenItems();
		difficultyMenuList.curSelect = difficultyMenuList.itemKeys.indexOf('HARD');
		difficultyMenuList.onSelectionChange.dispatch();

		difficultyMenuList.canSelect = false;
		FlxTween.tween(difficultyMenuList, {y: -(FlxG.height / 4)}, 1, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				difficultyMenuList.canSelect = true;
			}
		});
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK && difficultyMenuList.canSelect)
			leave();

		super.update(elapsed);
	}

	public function leave()
	{
		FlxTween.cancelTweensOf(difficultyMenuList);

		difficultyMenuList.canSelect = false;

		FlxTween.tween(difficultyMenuList, {y: -FlxG.height}, .5, {
			ease: FlxEase.expoInOut,
			onComplete: t ->
			{
				close();
			}
		});
	}
}
