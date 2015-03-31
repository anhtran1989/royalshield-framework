package royalshield.graphics
{
    import royalshield.entities.IGameObject;
    import royalshield.utils.IDestroyable;
    
    public interface IGraphic extends IGameObject, IUpdatable, IRenderable, IDestroyable
    {
        function get type():GraphicType;
        function get frames():uint;
        
        function get frame():uint;
        function set frame(value:uint):void;
        
        function get offsetX():uint;
        function get offsetY():uint;
    }
}
