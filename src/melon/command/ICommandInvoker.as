/**
 * Created by FALCYFLO on 06/11/2015.
 */
package melon.command {
public interface ICommandInvoker {
    function execute(cmd : ICommandInvoker) : void;
}
}
