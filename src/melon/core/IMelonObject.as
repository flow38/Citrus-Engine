/**
 * Created by Florent on 04/11/2015.
 */
package melon.core {
import citrus.core.ICitrusObject;

import melon.injector.IDepenciesInjector;

public interface IMelonObject extends ICitrusObject {

    function get injector() : IDepenciesInjector;

    function set injector(value : IDepenciesInjector) : void;

    /**
     * Process after all entity & all components of current level (CE's state)
     * have been initialized
     *
     * PostInitialize goal is to establish communication to others citrus object without worries about their existence and state.
     *
     * IMPORTANT : postInitialize implementation must be proof to duplicate call (use a flag to keep track of post
     * initialisation status). Indeed ICitrusObject will be post initilialized at State's comit and each time a
     * new ICitrusObject is added to state after State's comit.
     *
     *
     * @param    poolObjectParams
     */
    function postInitialize(poolObjectParams : Object = null) : void;

    /**
     * Clean object properties and perform a new initialization via initialize method.
     * @param poolObjectParams
     */
    function reset(poolObjectParams : Object = null) : void;

    /**
     * Preprocessing on  parameter object
     *
     * Implement this method  to handle specific use case relative parameters handling. Common use case is
     * transform a raw data object (ie JSON object from a levelEditor) or some of its properties into more complex stuff.
     *
     * @param    params
     * @return  A preprocessed clone of params
     */
    function preProcessParams(params : Object) : Object;
}
}
