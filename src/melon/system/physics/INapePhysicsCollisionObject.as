package melon.system.physics {
import nape.callbacks.InteractionCallback;
import nape.callbacks.PreCallback;
import nape.callbacks.PreFlag;

/**
 * You should extend this class to take advantage of Nape. This class provides template methods for defining
 * and creating Nape bodies, fixtures, shapes, and joints. If you are not familiar with Nape, you should first
 * learn about it via the <a href="http://napephys.com/help/manual.html">Nape Manual</a>.
 */
public interface INapePhysicsCollisionObject {

    /**
     * All your init physics code must be added in this method, no physics code into the constructor.
     * <p>You'll notice that the NapePhysicsObject's initialize method calls a bunch of functions that start with "define" and "create".
     * This is how the Nape objects are created. You should override these methods in your own NapePhysicsObject implementation
     * if you need additional Nape functionality. Please see provided examples of classes that have overridden
     * the NapePhysicsObject.</p>
     */
    function initialize(poolObjectParams : Object = null) : void;

    function destroy() : void ;


    function handlePreContact(callback : PreCallback) : PreFlag;

    /**
     * Override this method to handle the begin contact collision.
     */
    function handleBeginContact(callback : InteractionCallback) : void;

    /**
     * Override this method to handle the end contact collision.
     */
    function handleEndContact(callback : InteractionCallback) : void;

}
}