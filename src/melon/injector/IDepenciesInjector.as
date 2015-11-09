/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.injector {
import melon.core.IMelonState;
import melon.service.log.IMelonLog;

public interface IDepenciesInjector {

    function get state() : IMelonState;

    function set state(value : IMelonState) : void;


    function get log() : IMelonLog;

    function set log(value : IMelonLog) : void;

    function service(serviceName : String) : Object;

}
}
