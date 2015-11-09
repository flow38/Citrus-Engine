package melon.system.physics.nape {

import nape.shape.Shape;

/**
 * Sensors simply listen for when an object begins and ends contact with them. They disaptch a signal
 * when contact is made or ended, and this signal can be used to perform custom game logic such as
 * triggering a scripted event, ending a level, popping up a dialog box, and virtually anything else.
 *
 * Remember that signals dispatch events when ANY Nape object collides with them, so you will want
 * your collision handler to ignore collisions with objects that it is not interested in, or extend
 * the sensor and use maskBits to ignore collisions altogether.
 *
 * Events
 * onBeginContact - Dispatches on first contact with the sensor.
 * onEndContact - Dispatches when the object leaves the sensor.
 */
public class NapeSensorComponent extends PhysicComponent {

    [Embed(source="assets/data/component/NapeSensorComponent.json", mimeType="application/octet-stream")]
    private static const DEFAULT_PARAMS : Class;

    public static function defaultParams() : Object
    {
        return JSON.parse(new DEFAULT_PARAMS());
    }

    public function NapeSensorComponent(name : String, params : Object = null)
    {
        if (params.cbTypes == null) {
            params.cbTypes = CbTypesEnum.SENSOR_OBJECT;
        } else {
            params.cbTypes += '|' + CbTypesEnum.SENSOR_OBJECT;
        }

        params = mergeVO(
                params,
                {
                    'collisionGroup' : [],
                    'sensorGroup' : [AcrossPhysicsCollisionCategories.SENSOR],
                    'sensorMask' : [AcrossPhysicsCollisionCategories.BALL]
                }
        );

        super(name, params);
    }

    override protected function createShape() : void
    {
        super.createShape();
        this._body.shapes.foreach(function (shape : Shape) : void
        {
            shape.sensorEnabled = true;
        });
    }


}
}
