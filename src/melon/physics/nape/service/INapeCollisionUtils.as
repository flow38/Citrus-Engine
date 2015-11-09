/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.physics.nape.service {
import citrus.physics.nape.INapePhysicsObject;

import melon.system.IMelonEntity;

import nape.callbacks.InteractionCallback;
import nape.callbacks.PreCallback;

public interface INapeCollisionUtils {
    /**
     * In Nape we are blind concerning the collision, we are never sure which body is the collider. This function should help.
     * Call this function to obtain the colliding physics object.
     * @param self is a physic component
     * @param callback the InteractionCallback or PreCallBack
     * @return the collider.
     */
    function CollisionGetOther(self : INapePhysicsObject, callback : InteractionCallback) : INapePhysicsObject;

    function CollisionGetOtherIEntity(self : INapePhysicsObject, callback : InteractionCallback) : IMelonEntity;

    /**
     * In Nape we are blind concerning the collision, we are never sure which body is the collider. This function should help.
     * Call this function to obtain the collided physics object.
     * @param self in CE's code, we give this. In your code it will be your hero, a sensor, ...
     * @param callback the InteractionCallback.
     * @return the collided.
     */
    function CollisionGetSelf(self : INapePhysicsObject, callback : InteractionCallback) : INapePhysicsObject;

    /**
     * In Nape we are blind concerning the collision, we are never sure which body is the collider. This function should help.
     * Call this function to obtain the object of the type wanted.
     * @param objectClass the class whose you want to pick up the object.
     * @param callback the InteractionCallback.
     * @return the object of the class desired.
     */
    function CollisionGetObjectByType(objectClass : Class, callback : InteractionCallback) : INapePhysicsObject;

    /**
     * In Nape we are blind concerning the collision, we are never sure which body is the collider. This function should help.
     * Call this function to obtain the colliding physics object.
     * @param self in CE's code, we give this. In your code it will be your hero, a sensor, ...
     * @param callback the InteractionCallback or PreCallBack
     * @return the collider.
     */
    function PreCollisionGetOther(self : INapePhysicsObject, callback : PreCallback) : INapePhysicsObject;

    function PreCollisionGetOtherIEntity(self : INapePhysicsObject, callback : InteractionCallback) : IMelonEntity;

    /**
     * In Nape we are blind concerning the collision, we are never sure which body is the collider. This function should help.
     * Call this function to obtain the collided physics object.
     * @param self in CE's code, we give this. In your code it will be your hero, a sensor, ...
     * @param callback the InteractionCallback.
     * @return the collided.
     */
    function PreCollisionGetSelf(self : INapePhysicsObject, callback : PreCallback) : INapePhysicsObject;

    /**
     * In Nape we are blind concerning the collision, we are never sure which body is the collider. This function should help.
     * Call this function to obtain the object of the type wanted.
     * @param objectClass the class whose you want to pick up the object.
     * @param callback the InteractionCallback.
     * @return the object of the class desired.
     */
    function PreCollisionGetObjectByType(objectClass : Class, callback : PreCallback) : INapePhysicsObject;
}
}
