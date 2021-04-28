package gameObjects;

import states.GlobalGameData;
import com.framework.utils.Input;
import kha.input.KeyCode;
import com.collision.platformer.CollisionGroup;
import com.gEngine.helpers.Screen;
import kha.math.FastVector2;
import com.collision.platformer.CollisionBox;
import com.gEngine.helpers.RectangleDisplay;
import com.framework.utils.Entity;

class Cannon extends Entity{
	
    var display:RectangleDisplay;

    public var collision: CollisionBox;
    public var bulletsCollision: CollisionGroup;
	var facingDir:FastVector2=new FastVector2(0,-1);
    var speed:Float = 350;
	var screenWidth = Screen.getWidth();


    public function new(x:Float, y:Float) {        
		super();
        display = new RectangleDisplay();
		display.setColor(0, 188, 212);
		display.scaleX = 20;
		display.scaleY = 20;
		display.x = x;
		display.y = y;
		GlobalGameData.simulationLayer.addChild(display);
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
			shoot();
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
		if (dir.length != 0) {
			var normalizeDir=dir.normalized();
			var finalVelocity = normalizeDir.mult(speed);
			collision.velocityX = finalVelocity.x;
			collision.velocityY = finalVelocity.y;
		} 
		if(collision.x<0){
			collision.x=0;
		} 
		if(collision.x+20>screenWidth){
			collision.x=screenWidth-20;
		}
	}

	function shoot(){
		var bullet:Bullet=new Bullet(collision.x+collision.width*0.5,collision.y+collision.height*0.5,facingDir,bulletsCollision);
		addChild(bullet);
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