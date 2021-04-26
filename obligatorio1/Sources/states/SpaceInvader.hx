package states;

import kha.Canvas;
import com.collision.platformer.CollisionGroup;
import gameObjects.Bullet;
import com.collision.platformer.ICollider;
import com.collision.platformer.CollisionEngine;
import gameObjects.Invader;
import com.gEngine.display.Layer;
import gameObjects.Player;
import com.framework.utils.State;

class SpaceInvader extends State {
	var simulationLayer:Layer;
	var player:Player;
	var enemyCollision:CollisionGroup=new CollisionGroup();	

	override function init() {
		simulationLayer = new Layer();		
		stage.addChild(simulationLayer);
		
		GlobalGameData.simulationLayer=simulationLayer;

		player = new Player(700, 640, simulationLayer);
		addChild(player);
		//GlobalGameData.player=player;

		var invader = new Invader(300, 300, simulationLayer,enemyCollision);
		addChild(invader);
	}

	override function update(dt:Float) {
		super.update(dt);		
        CollisionEngine.overlap(player.collision,enemyCollision,playerVsInvader);
		CollisionEngine.overlap(player.bulletsCollision,enemyCollision,bulletVsInvader);
	}
    function playerVsInvader(playerC:ICollider,invaderC:ICollider) {
      changeState(new EndGame(false));
    }

	function bulletVsInvader(bulletC:ICollider,invaderC:ICollider) {
		var enemy:Invader = cast invaderC.userData;
		enemy.die();
		var bullet:Bullet = cast bulletC.userData;
		bullet.die();
	  }

	override function destroy() {
		super.destroy();
		GlobalGameData.destroy();
	}

	#if DEBUGDRAW
	override function draw(framebuffer:Canvas) {
		super.draw(framebuffer);
		CollisionEngine.renderDebug(framebuffer,stage.defaultCamera());
	}
	#end

}
