/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.service.log {
public interface IMelonLog {

    function info(scope : Object, object : Object) : void;

    function warning(scope : Object, object : Object) : void;

    function error(scope : Object, object : Object) : void;

    function debug(scope : Object, object : Object) : void;

    function debugMore(scope : Object, object : Object) : void;

    function customTrace(scope : *, object : *, perso : String, label : String, color : uint) : void;

}
}
