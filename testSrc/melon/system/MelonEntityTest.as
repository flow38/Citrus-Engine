/**
 * Created by Florent on 09/11/2015.
 */
package melon.system {
import flash.events.Event;

import mockolate.partial;
import mockolate.prepare;
import mockolate.received;

import org.flexunit.assertThat;
import org.flexunit.async.Async;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.strictlyEqualTo;

public class MelonEntityTest {

    public function MelonEntityTest()
    {

    }

    private var _melonEntity : MelonEntity;

    private var _melonObject1 : MelonComponent;

    private var _melonObject2 : MelonComponent;

    private var _melonObject3 : MelonComponent;

    private var _melonEntity2 : MelonEntity;

    [Before(async, timeout=5000, order=1)]
    public function setUp() : void
    {
        Async.proceedOnEvent(this,
                prepare(MelonEntity, MelonComponent),
                Event.COMPLETE);

    }

    [Before(order=2)]
    public function setup() : void
    {
        _melonEntity = new MelonEntity('fooEntity');
        _melonObject1 = partial(MelonComponent, null, ['fooComp1']);
        _melonObject2 = partial(MelonComponent, null, ['fooComp2']);

        _melonEntity2 = partial(MelonEntity, null, ['fooEnt3']);
        _melonObject3 = partial(MelonComponent, null, ['fooComp3']);
        _melonEntity2.add(_melonObject3);

        _melonEntity.add(_melonObject1).add(_melonObject2).add(_melonEntity2);
    }

    [Test]
    public function testUpdate() : void
    {
        _melonEntity.update(1000);
        assertThat(_melonObject1, received().once().method('update').arg(1000));
        assertThat(_melonObject2, received().once().method('update').arg(1000));
        assertThat(_melonObject3, received().once().method('update').arg(1000));
        assertThat(_melonEntity2, received().once().method('update').arg(1000));
    }

    [Test]
    public function testRemove() : void
    {
        _melonEntity2.remove(_melonObject3);
        assertThat(_melonObject3.parent, equalTo(null))
    }

    [Test]
    public function testAdd() : void
    {
        assertThat(_melonEntity2.parent, equalTo(_melonEntity));
        assertThat(_melonObject2.parent, equalTo(_melonEntity));
        assertThat(_melonObject3.parent, equalTo(_melonEntity2));
    }

    [Test]
    public function testGetViews() : void
    {

    }

    [Test]
    public function testInitialize() : void
    {
        var obj : Object = new Object();
        _melonEntity.initialize(obj);
        assertThat(_melonObject1, received().once().method('initialize').args(strictlyEqualTo(obj)));
        assertThat(_melonObject2, received().once().method('initialize').args(strictlyEqualTo(obj)));
        assertThat(_melonObject3, received().once().method('initialize').args(strictlyEqualTo(obj)));
        assertThat(_melonEntity2, received().once().method('initialize').args(strictlyEqualTo(obj)));
    }

    [Test]
    public function testDestroy() : void
    {
        _melonEntity.destroy();
        assertThat(_melonObject1, received().once().method('destroy').noArgs());
        assertThat(_melonObject2, received().once().method('destroy').noArgs());
        assertThat(_melonObject3, received().once().method('destroy').noArgs());
        assertThat(_melonEntity2, received().once().method('destroy').noArgs());
    }
}
}
