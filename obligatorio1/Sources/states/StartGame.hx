package states;

import kha.input.KeyCode;
import com.framework.utils.Input;
import com.gEngine.display.Text;
import com.gEngine.display.Sprite;
import com.loading.basicResources.JoinAtlas;
import com.loading.basicResources.ImageLoader;
import com.loading.basicResources.FontLoader;
import com.loading.Resources;
import com.framework.utils.State;

class StartGame extends State{

    public function new(){
        super();

    }

    override function load(resources:Resources) {
        var atlas = new JoinAtlas(512,512);
        atlas.add(new FontLoader("Kenney_Thick",20));
        atlas.add(new ImageLoader("cannonLogo"));
        resources.add(atlas);
    }

    override function init() {
        var text = new Text("Kenney_Thick");
        text.x=520;
        text.y=100;
        text.text="BALL SHOOTER";
        stage.addChild(text); 
        var image = new Sprite("cannonLogo");
        image.smooth=false;
        image.scaleX=0.5;
        image.scaleY=0.5;
        image.x=540;
        image.y=200;
        stage.addChild(image);
        var text = new Text("Kenney_Thick");
        text.x=430;
        text.y=600;
        text.text="Press S to start the game";
        stage.addChild(text);        
    }
    override function update(dt:Float) {
        super.update(dt);
        if(Input.i.isKeyCodePressed(KeyCode.S)){
            this.changeState(new BallShooter());
        }
    }
    
}