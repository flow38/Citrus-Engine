/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.physics.nape.service {
import flash.utils.Dictionary;

import melon.core.MelonObject;

import nape.phys.Material;

public class MaterialManager extends MelonObject implements IMaterialManager {

    public static const NAME : String = 'MaterialManager';

    public function MaterialManager(name : String = null, params : Object = null)
    {
        super(name == null ? NAME : name, params);
        _materials = new Dictionary();
    }

    private var _materials : Dictionary;

    public function getMaterial(materialID : String) : Material
    {
        if (_materials[materialID] == null) {
            throw(new Error("MaterialList::get() unknown material " + materialID));
        }
        var m : Material = _materials[materialID] as Material;
        return m.copy();
    }
}
}
