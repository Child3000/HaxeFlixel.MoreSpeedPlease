package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
	public var speed:Float = 100;

	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);

		drag.x = drag.y = 800;

		// makeGraphic(16, 16, FlxColor.BLUE);
		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);

		setSize(8, 8);
		offset.set(4, 8);

		animation.add("down_idle", [0]);
		animation.add("down_walk", [0, 1, 0, 2]);
		animation.add("side_idle", [3]);
		animation.add("side_walk", [3, 4, 3, 5]);
		animation.add("up_idle", [6]);
		animation.add("up_walk", [6, 7, 6, 8]);
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}

	function updateMovement()
	{
		var up = FlxG.keys.anyPressed([UP, W]);
		var down = FlxG.keys.anyPressed([DOWN, S]);
		var left = FlxG.keys.anyPressed([LEFT, A]);
		var right = FlxG.keys.anyPressed([RIGHT, D]);

		var moveAxis = new FlxPoint(0, 0);
		if (up)
			moveAxis.y -= 1;
		if (down)
			moveAxis.y += 1;
		if (left)
			moveAxis.x -= 1;
		if (right)
			moveAxis.x += 1;

		// update velocity
		if (moveAxis.x != 0 || moveAxis.y != 0)
		{
			velocity = moveAxis.normalize() * speed;
		}

		// update facing.
		if (moveAxis.y < 0)
			facing = UP;
		else if (moveAxis.y > 0)
			facing = DOWN;
		else if (moveAxis.x < 0)
			facing = LEFT;
		else if (moveAxis.x > 0)
			facing = RIGHT;

		// update animation.
		var isIdle = velocity.x == 0 && velocity.y == 0 && touching == NONE;
		var action = isIdle ? "idle" : "walk";

		switch (facing)
		{
			case LEFT, RIGHT:
				animation.play("side_" + action);
			case UP:
				animation.play("up_" + action);
			case DOWN:
				animation.play("down_" + action);
			case _:
		}
	}
}
