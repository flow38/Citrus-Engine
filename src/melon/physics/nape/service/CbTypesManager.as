package melon.physics.nape.service {

import flash.utils.Dictionary;

import melon.core.MelonObject;
import melon.system.component.physics.nape.enum.CbTypesEnum;

import nape.callbacks.CbType;

/**
 * A Service to rule Nape's cbTypes
 * @author ffalcy
 */
public class CbTypesManager extends MelonObject implements ICbTypesManager {

    public static const NAME : String = 'CbTypesManager';

    public function CbTypesManager(name : String = null, params : Object = null)
    {
        super(name == null ? NAME : name, params);
    }

    protected var _registeredCbTypes : Array = [
        CbTypesEnum.PHYSICS_OBJECT,
        CbTypesEnum.SENSOR_OBJECT
    ];
    private var _cbTypesDico : Dictionary = new Dictionary(true);

    public function cbTypesByName(name : String) : CbType
    {
        if (_cbTypesDico[name] == null) {
            if (_registeredCbTypes.indexOf(name) == -1) {
                throw(new Error("CbType name " + name + " is not record as a valid name!!"));
            } else {
                _cbTypesDico[name] = new CbType();
                injector.log.info("CbTypesEnum", "CbTypesEnum create a new CbType named " + name + "  ID : " + _cbTypesDico[name].id);
            }
        }

        return _cbTypesDico[name] as CbType;
    }

}

}