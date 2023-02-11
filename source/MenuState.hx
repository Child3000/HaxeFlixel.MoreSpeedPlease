package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	var titleTxt:FlxText;
	var instructionTxt:FlxText;
	var playBtn:FlxButton;

	override public function create()
	{
		super.create();

		titleTxt = new FlxText(0, 0, 0, "More Speed Please!");
		titleTxt.x = FlxG.width / 2 - titleTxt.width / 2;
		titleTxt.y = FlxG.height / 3 - titleTxt.height / 2;
		add(titleTxt);

		instructionTxt = new FlxText(0, 0, 0, "WSAD - Move\n\nSPACE - Trade 10 coins with 1 speed");
		instructionTxt.x = FlxG.width / 2 - instructionTxt.width / 2;
		instructionTxt.y = FlxG.height / 3 * 2 - instructionTxt.height / 2;
		add(instructionTxt);

		playBtn = new FlxButton(0, 0, "Play", onClickPlay);
		playBtn.screenCenter();
		add(playBtn);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function onClickPlay()
	{
		FlxG.switchState(new PlayState());
	}
}
