package melon.physics.nape.service {

import citrus.physics.nape.INapePhysicsObject;

import melon.core.MelonObject;
import melon.system.IMelonComponent;
import melon.system.IMelonEntity;

import nape.callbacks.InteractionCallback;
import nape.callbacks.PreCallback;

/**
 * A service to simplify Nape collision handling
 */
public class NapeCollisionUtils extends MelonObject implements INapeCollisionUtils {

    public static const NAME : String = 'NapeCollisionUtils';

    public function NapeCollisionUtils(name : String = null, params : Object = null)
    {
        super(name == null ? NAME : name, params);
    }

    public function CollisionGetOther(self : INapePhysicsObject, callback : InteractionCallback) : INapePhysicsObject
    {
        return self == callback.int1.userData.myData ? callback.int2.userData.myData : callback.int1.userData.myData;
    }

    public function CollisionGetOtherIEntity(self : INapePhysicsObject, callback : InteractionCallback) : IMelonEntity
    {
        var otherComp : IMelonComponent = IMelonComponent(self == callback.int1.userData.myData ? callback.int2.userData.myData : callback.int1.userData.myData);

        return (otherComp.parent) as IMelonEntity;
    }

    public function CollisionGetSelf(self : INapePhysicsObject, callback : InteractionCallback) : INapePhysicsObject
    {
        return self == callback.int1.userData.myData ? callback.int1.userData.myData : callback.int2.userData.myData;
    }

    public function CollisionGetObjectByType(objectClass : Class, callback : InteractionCallback) : INapePhysicsObject
    {
        return callback.int1.userData.myData is objectClass ? callback.int1.userData.myData : callback.int2.userData.myData
    }

    public function PreCollisionGetOther(self : INapePhysicsObject, callback : PreCallback) : INapePhysicsObject
    {
        return self == callback.int1.userData.myData ? callback.int2.userData.myData : callback.int1.userData.myData;
    }

    public function PreCollisionGetOtherIEntity(self : INapePhysicsObject, callback : InteractionCallback) : IMelonEntity
    {
        var otherComp : IMelonComponent = IMelonComponent(self == callback.int1.userData.myData ? callback.int2.userData.myData : callback.int1.userData.myData);

        return otherComp.parent as IMelonEntity;
    }

    public function PreCollisionGetSelf(self : INapePhysicsObject, callback : PreCallback) : INapePhysicsObject
    {
        return self == callback.int1.userData.myData ? callback.int1.userData.myData : callback.int2.userData.myData;
    }

    public function PreCollisionGetObjectByType(objectClass : Class, callback : PreCallback) : INapePhysicsObject
    {
        return callback.int1.userData.myData is objectClass ? callback.int1.userData.myData : callback.int2.userData.myData
    }
}
}
