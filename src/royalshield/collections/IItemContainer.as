package royalshield.collections
{
    import royalshield.entities.items.Item;
    
    public interface IItemContainer extends IGameObjectContainer
    {
        function get itemCount():uint;
        
        function addItem(item:Item):Boolean;
        function removeItem(item:Item):Boolean;
        function getItemAt(index:int):Item;
    }
}
