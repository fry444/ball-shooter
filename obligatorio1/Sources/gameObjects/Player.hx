package gameObjects;

import com.collision.platformer.CollisionGroup;
import com.collision.platformer.CollisionBox;
import kha.input.KeyCode;
import com.framework.utils.Input;
import kha.math.FastVector2;
import com.gEngine.display.Layer;
import com.gEngine.helpers.RectangleDisplay;
import com.framework.utils.Entity;

class Player extends Entity {
	var display:RectangleDisplay;

	public var collision:CollisionBox;
	public var bulletsCollision:CollisionGroup;

	var speed:Float = 100;
	var facingDir:FastVector2=new FastVector2(1,0);

	public function new(x:Float, y:Float, layer:Layer) {
		super();
		display = new RectangleDisplay();
		display.setColor(0, 0, 255);
		display.scaleX = 20;
		display.scaleY = 20;
		display.x = x;
		display.y = y;
		layer.addChild(display);

		collision = new CollisionBox();
		collision.width = 20;
		collision.height = 20;
		collision.x = x;
		collision.y = y;
        collision.dragX = 0.9;
        collision.dragY = 0.9;

		bulletsCollision=new CollisionGroup();

	}

	override function update(dt:Float) {		
		
		updatePlayerMovement();

		if(Input.i.isKeyCodePressed(KeyCode.Space)){
			var bullet:Bullet=new Bullet(collision.x+collision.width*0.5,collision.y+collision.height*0.5,facingDir,bulletsCollision);
			addChild(bullet);

		}		

		collision.update(dt);

		super.update(dt);
        
	}

	function updatePlayerMovement(){
		var dir:FastVector2= new FastVector2();

		if (Input.i.isKeyCodeDown(KeyCode.Left)) {
			dir.x += -1;
		}
		if (Input.i.isKeyCodeDown(KeyCode.Right)) {
			dir.x += 1;
		}
		if (Input.i.isKeyCodeDown(KeyCode.Up)) {
			dir.y += -1;
		}
		if (Input.i.isKeyCodeDown(KeyCode.Down)) {
			dir.y += 1;
		}
		if (dir.length != 0) {
			var normalizeDir=dir.normalized();
			var finalVelocity = normalizeDir.mult(speed);
			collision.velocityX = finalVelocity.x;
			collision.velocityY = finalVelocity.y;
			facingDir.x=normalizeDir.x;
			facingDir.y=normalizeDir.y;
		} 
	}

	override function render() {
		super.render();
		display.x = collision.x;
		display.y = collision.y;
	}

    override function destroy() {
        super.destroy();
        display.removeFromParent();
    }
}
