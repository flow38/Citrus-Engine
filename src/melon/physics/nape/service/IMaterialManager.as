/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.physics.nape.service {
import nape.phys.Material;

public interface IMaterialManager {
    function getMaterial(materialID : String) : Material;
}
}
