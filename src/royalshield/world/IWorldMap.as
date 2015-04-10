package royalshield.world
{
    import royalshield.entities.creatures.Creature;
    import royalshield.entities.items.Item;
    import royalshield.geom.Direction;
    import royalshield.geom.Position;
    import royalshield.signals.Signal;
    import royalshield.utils.FindPathParams;
    
    public interface IWorldMap
    {
        function get width():uint;
        function get height():uint;
        function get layers():uint;
        function get name():String;
        function get x():uint;
        function get y():uint;
        function get z():uint;
        function get onPositionChanged():Signal;
        function get onMapDirty():Signal;
        
        function inMapRange(x:uint, y:uint, z:uint):Boolean;
        function getTileIndex(x:uint, y:uint, z:uint):int;
        function getTile(x:uint, y:uint, z:uint):Tile;
        function setTile(x:uint, y:uint, z:uint, flags:uint = 0):Tile;
        function getTileByIndex(index:int):Tile;
        function hasTileAt(x:uint, y:uint, z:uint):Boolean;
        function deleteTileAt(x:uint, y:uint, z:uint):Boolean;
        function deleteTile(tile:Tile):Boolean;
        function setPosition(x:uint, y:uint, z:uint):void;
        function moveCreature(creature:Creature, toTile:Tile):Boolean;
        function getPathTo(creature:Creature, position:Position, directions:Vector.<Direction>, distance:int = -1, flags:uint = 0):Boolean;
        function getPathMatching(creature:Creature, directions:Vector.<Direction>, targetPosition:Position, fpp:FindPathParams):Boolean;
        function isSightClear(fromX:uint, fromY:uint, fromZ:uint, toX:uint, toY:uint, toZ:uint, floorCheck:Boolean):Boolean;
        function getSpectators(x:uint, y:uint, z:uint, list:Vector.<Creature>, multifloor:Boolean = false):void;
        function getTopItemAt(x:uint, y:uint, z:uint):Item;
    }
}
