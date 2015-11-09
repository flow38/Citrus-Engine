package melon.command {
import melon.core.MelonObject;

public class AbstractMelonCommand extends MelonObject implements ICommand {

    public function AbstractMelonCommand(name : String, params : Object = null)
    {
        super(name, params);
        _childrenCmd = new Vector.<ICommand>();
        //Abstract class implementation
        if (Object(this).constructor === AbstractMelonCommand) {
            throw new Error("AbstractMelonCommand class is abstract, you must instanciate a concrete implementation, ie MelonCommand ...");
        }
    }

    protected var _onComplete : Function;

    //Execution and cancellation callback functions
    protected var _onCancel : Function;
    /**
     * Store sub commands to create a MacroCommand
     */
    private var _childrenCmd : Vector.<ICommand>;
    /**
     * _childrenCmd index of current executed or cancelled child command.
     */
    private var _childExecutionCursor : int = -1

    /**
     * Does Command can be cancelled via cancel() method
     */
    private var _isCancelable : Boolean = false;

    public function get isCancelable() : Boolean
    {
        return _isCancelable;
    }

    public function set isCancelable(value : Boolean) : void
    {
        _isCancelable = value;
    }

    override protected function clean() : void
    {
        _onCancel = null;
        _onComplete = null;
        _onCancel = null;
        _childrenCmd = new Vector.<ICommand>();

        super.clean();
    }


    /**
     * Should never be override
     */
    override public function destroy() : void
    {
        _childrenCmd.every(function (childCmd : ICommand, index : int, childrenCmd : Vector.<ICommand>) : Boolean
        {
            childCmd.destroy()

            return true;
        });

        super.destroy();
    }

    public function execute() : void
    {
        done();
    }

    public function cancel() : void
    {
        cancelDone();
    }

    /**
     * Add a command to execute after completing this one
     *
     * @param    next
     * @return
     */
    public function chain(next : ICommand) : ICommand
    {
        if (next is ICommand) {
            _childrenCmd.push(next);
        } else {
            throw(new Error('chain argument is not ICommand !'));
        }

        return this;
    }

    /**
     * Define a callback function to be execute when command execute method ending
     * @param    value    End command execution callback
     */
    public function onComplete(value : Function) : ICommand
    {
        _onComplete = value;

        return this;
    }

    /**
     * Define a callback function to be execute when command cancel method ending
     * @param    value    End cancel command execution callback
     */
    public function onCancel(value : Function) : ICommand
    {
        if (!_isCancelable) {
            throw(new Error('You try to set a cancel complete callback on a no cancellable !!'));
        }
        _onCancel = value;

        return this;
    }

    /**
     * Define a callback function to be execute when command ending or cancelling
     *
     * Basically a shortcut when you wanna same callback function to be call
     * when command is complete or is canceled
     *
     * @param    value    End command execution callback
     */
    public function onCompleteOrCancel(callback : Function) : ICommand
    {
        onCancel(callback);
        onComplete(callback);

        return this;
    }

    /**
     * End command execution
     *
     * Default behavior : call onComplete callback if exist one
     *
     * Macro command (_childrenCmd.length != 0) : unshift first child command and execute it.  Whhen all child
     * command have been executed, call onComplete callback if exist one.
     *
     */
    final protected function done() : void
    {
        _childExecutionCursor++;
        if (hasChildCommandToExecute()) {
            var cmd : ICommand = _childrenCmd[_childExecutionCursor];
            cmd.onComplete(this.done);
            cmd.execute();
        } else if (_onComplete != null) {
            _onComplete.apply();
        }
    }

    /**
     * End command cancellation
     *
     * Default behavior : call onCancel callback if exist one
     *
     * Macro command (_childrenCmd.length != 0) : unshift first child command and cancel it.  When all child
     * command have been cancelled, call onCancel callback if exist one.
     *
     */
    final protected function cancelDone() : void
    {
        _childExecutionCursor--;
        if (hasChildCommandToCancel()) {
            var cmd : ICommand = _childrenCmd[_childExecutionCursor];
            cmd.onCancel(this.cancelDone);
            cmd.cancel();
        } else if (_onCancel != null) {
            _onCancel.apply();
        }
    }

    private function hasChildCommandToExecute() : Boolean
    {
        return _childrenCmd.length != 0 && _childExecutionCursor < _childrenCmd.length;
    }

    private function hasChildCommandToCancel() : Boolean
    {
        return _childrenCmd.length != 0 && _childExecutionCursor >= 0;
    }
}
}