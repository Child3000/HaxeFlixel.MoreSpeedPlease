package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	var player:Player;
	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;
	var coins:FlxTypedGroup<Coin>;
	var pickupCoinNumber:Int;
	var coinTxt:FlxText;
	var playerSpeedTxt:FlxText;
	var timePressingSpace:Float;

	override public function create()
	{
		super.create();

		map = new FlxOgmo3Loader(AssetPaths.Level__ogmo, AssetPaths.room_001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		walls.follow();
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		coins = new FlxTypedGroup<Coin>();
		add(coins);

		coinTxt = new FlxText(10, 10);
		add(coinTxt);

		playerSpeedTxt = new FlxText(10, 10);
		add(playerSpeedTxt);

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);
	}

	function placeEntities(entity:EntityData)
	{
		if (entity.name == "player")
		{
			player.setPosition(entity.x, entity.y);
		}
		else if (entity.name == "coin")
		{
			coins.add(new Coin(entity.x + 4, entity.y + 4));
		}
		else if (entity.name == "coin_text")
		{
			coinTxt.setPosition(entity.x + 4, entity.y + 4);
			playerSpeedTxt.setPosition(entity.x + 4, entity.y + 4 + 16);
		}
	}

	function checkTradeAction(dt:Float)
	{
		var trade = FlxG.keys.anyJustReleased([SPACE]) || (FlxG.keys.anyPressed([SPACE]) && timePressingSpace >= 1);

		timePressingSpace = FlxG.keys.anyPressed([SPACE]) ? timePressingSpace + dt : 0;

		if (trade)
		{
			var canTrade = pickupCoinNumber >= 10;
			if (canTrade)
			{
				pickupCoinNumber -= 10;
				player.speed += 1;

				FlxG.sound.play(AssetPaths.trade__wav, 1, false);
			}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.overlap(player, coins, playerOverlapCoin);

		checkTradeAction(elapsed);
		updateTexts();
	}

	function updateTexts()
	{
		coinTxt.text = "COIN: " + Std.string(pickupCoinNumber);
		playerSpeedTxt.text = "SPEED: " + Std.string(player.speed);
	}

	function playerOverlapCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();

			pickupCoinNumber += 1;

			FlxG.sound.play(AssetPaths.coin__wav, 0.5, false);
		}
	}
}
