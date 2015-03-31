package royalshield.graphics
{
    import royalshield.display.GameCanvas;
    
    public interface IRenderable
    {
        function render(canvas:GameCanvas, pointX:int, pointY:int, patternX:int = 0, patternY:int = 0, patternZ:int = 0):void;
    }
}
