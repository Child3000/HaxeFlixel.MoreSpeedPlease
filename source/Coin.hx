package;

import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Coin extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		loadGraphic(AssetPaths.coin__png, false, 8, 8);
	}

	public override function kill()
	{
		alive = false;
		FlxTween.tween(this, {alpha: 0, y: y - 16}, {ease: FlxEase.circOut, onComplete: finishKill});
	}

	function finishKill(_)
	{
		exists = false;

		respawn();
	}

	function respawn()
	{
		FlxTween.tween(this, {alpha: 1, y: y + 16}, 10, {
			ease: FlxEase.circOut,
			onComplete: (_) ->
			{
				exists = true;
				alive = true;
			}
		});
	}
}
