package royalshield.entities
{
    import royalshield.collections.IGameObjectContainer;
    
    /**
     * The IDynamicGameObject interface represents objects that can be moved on map.
     */
    public interface IDynamicGameObject
    {
        function get parent():IGameObjectContainer;
        function get topParent():IGameObjectContainer;
    }
}
