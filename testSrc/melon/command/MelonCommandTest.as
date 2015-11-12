/**
 * Created by Florent on 07/11/2015.
 */
package melon.command {
import flash.events.Event;

import mockolate.partial;
import mockolate.prepare;
import mockolate.received;

import org.flexunit.assertThat;
import org.flexunit.async.Async;
import org.hamcrest.core.allOf;
import org.hamcrest.core.throws;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.hasProperty;
import org.hamcrest.object.instanceOf;
import org.hamcrest.text.containsString;

public class MelonCommandTest {

    public function MelonCommandTest()
    {
    }

    public var mainCmd : MelonCommand;

    [Before(async, timeout=5000, order=1)]
    public function setUp() : void
    {
        Async.proceedOnEvent(this,
                prepare(MelonCommand),
                Event.COMPLETE);

    }

    [Before(order=2)]
    public function setup() : void
    {
        mainCmd = new MelonCommand('fooCommand');
        mainCmd.isCancelable = true;
    }

    [After]
    public function tearDown() : void
    {

    }

    [Test]
    public function testOnCompleteOrCancel() : void
    {
        var foo : uint = 0;
        var callback : Function = function () : void
        {
            foo++;
        }

        mainCmd.onCompleteOrCancel(callback);
        mainCmd.execute();
        assertThat(foo, equalTo(1));

        mainCmd.cancel();
        assertThat(foo, equalTo(2));
    }

    [Test]
    /**
     * Assert that children commands "execute" method are call when macro is executed.
     * Asset that macro's onComplete callback is call while all micro commands have been executed
     * Assert that children commands "cancel" method are call when macro is cancelled.
     * Asset that macro's onCancel callback is call while all micro commands have been executed
     */
    public function testChain() : void
    {
        var foo : uint = 0;
        var callback : Function = function () : void
        {
            foo++;
        }


        var macroCmd : MelonCommand = partial(MelonCommand);
        macroCmd.isCancelable = true;
        macroCmd.onCompleteOrCancel(callback);
        var child1 : MelonCommand = partial(MelonCommand);
        var child2 : MelonCommand = partial(MelonCommand);
        var child3 : MelonCommand = partial(MelonCommand);
        child1.isCancelable = child2.isCancelable = child3.isCancelable = true;

        macroCmd.chain(child1).chain(child2).chain(child3);

        macroCmd.execute();
        assertThat(child1, received().once().method('execute'));
        assertThat(child2, received().once().method('execute'));
        assertThat(child2, received().once().method('execute'));
        assertThat(foo, equalTo(1));

        macroCmd.cancel();
        assertThat(child1, received().once().method('cancel'));
        assertThat(child2, received().once().method('cancel'));
        assertThat(child2, received().once().method('cancel'));
        assertThat(foo, equalTo(2));

    }

    [Test]
    public function testOnCancel() : void
    {
        var foo : uint = 0;
        var callback : Function = function () : void
        {
            foo++;
        }

        mainCmd.onCancel(callback);
        mainCmd.execute();
        assertThat(foo, equalTo(0));
        mainCmd.cancel();
        assertThat(foo, equalTo(1));

        mainCmd.isCancelable = false;

        assertThat(function () : void
                {
                    mainCmd.onCancel(callback);
                },
                throws(
                        allOf(
                                instanceOf(Error),
                                hasProperty("message", containsString(" try to set a cancel complete callback on a no cancellable ")))));


    }

    [Test]
    public function testOnComplete() : void
    {
        var foo : uint = 0;
        var callback : Function = function () : void
        {
            foo++;
        }

        mainCmd.onComplete(callback);
        mainCmd.cancel();
        assertThat(foo, equalTo(0));
        mainCmd.execute();
        assertThat(foo, equalTo(1));
    }

    [Test]
    public function testDestroy() : void
    {
        var macroCmd : MelonCommand = partial(MelonCommand);
        var child1 : MelonCommand = partial(MelonCommand);
        var child2 : MelonCommand = partial(MelonCommand);
        var child3 : MelonCommand = partial(MelonCommand);

        macroCmd.chain(child1).chain(child2).chain(child3).destroy();
        assertThat(child1, received().once().method('destroy'));
        assertThat(child2, received().once().method('destroy'));
        assertThat(child3, received().once().method('destroy'));
    }
}
}
