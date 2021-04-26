package states;

import gameObjects.Cannon;
import gameObjects.Player;
import com.gEngine.display.Layer;

class GlobalGameData {
    static public var simulationLayer:Layer;
    static public var cannon:Cannon;

    static public function destroy(){
        simulationLayer=null;
        cannon=null;
    }
}