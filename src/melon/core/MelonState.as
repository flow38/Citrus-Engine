/**
 * Created by Florent on 04/11/2015.
 */
package melon.core {
import citrus.core.ICitrusObject;
import citrus.core.State;
import citrus.system.IEntity;

public class MelonState extends State implements IMelonState {

    public function MelonState()
    {
        super();
    }

    override public function add(object : ICitrusObject) : ICitrusObject
    {
        super.add(object);
        object.initialize();

        return object;
    }

    override public function addEntity(entity : IEntity) : IEntity
    {
        super.add(entity);
        entity.initialize();

        return entity;
    }

    public function postInitializeAllObjects() : void
    {
        objects.forEach(function (item : IMelonObject, index : int, vector : Vector.<IMelonObject>) : void
        {
            item.postInitialize();
        })
    }
}
}
