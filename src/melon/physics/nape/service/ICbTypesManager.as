/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.physics.nape.service {
import nape.callbacks.CbType;

public interface ICbTypesManager {
    /**
     * Search and create if not exist a cbTypes
     *
     * @param    name    cbType's name we want access to
     * @return    a cbType
     */
    function cbTypesByName(name : String) : CbType;
}
}
