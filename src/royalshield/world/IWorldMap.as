package royalshield.world
{
    import royalshield.entities.creatures.Creature;
    import royalshield.geom.Position;
    import royalshield.signals.Signal;
    import royalshield.utils.IDestroyable;
    
    public interface IWorldMap extends IDestroyable
    {
        function get width():uint;
        function get height():uint;
        function get layers():uint;
        function get tileSize():uint;
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
        function deleteTileAt(x:uint, y:uint, z:uint):void;
        function deleteTile(tile:Tile):void;
        function setPosition(x:uint, y:uint, z:uint):void;
        function moveCreature(creature:Creature, toTile:Tile):Boolean;
        function getPathTo(creature:Creature, position:Position, directions:Vector.<String>, distance:int = -1, flags:uint = 0):Boolean;
        function isSightClear(fromX:uint, fromY:uint, fromZ:uint, toX:uint, toY:uint, toZ:uint, floorCheck:Boolean):Boolean;
        function getSpectators(x:uint, y:uint, z:uint, list:Vector.<Creature>, multifloor:Boolean = false):void;
    }
}
