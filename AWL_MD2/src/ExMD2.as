package
{
	import away3dlite.animators.MovieMesh;
	import away3dlite.core.base.*;
	import away3dlite.events.*;
	import away3dlite.loaders.*;
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.templates.*;
	
	import flash.display.*;

	[SWF(backgroundColor="#FFFFFF", frameRate="30", width="800", height="600")]
	/**
	 * Example : MD2
	 * @author katopz
	 */	
	public class ExMD2 extends BasicTemplate
	{
		override protected function onInit():void
		{
			var md2:MD2 = new MD2();
			md2.scaling = 2;
			md2.material = new BitmapFileMaterial("nemuvine/chair.png");
			
			var loader:Loader3D = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			loader.loadGeometry("nemuvine/table.md2", md2);
			scene.addChild(loader);
		}
		
		private function onSuccess(event:Loader3DEvent):void
		{
			var model:MovieMesh = event.loader.handle as MovieMesh;
			model.rotationY = 180;
			model.bothsides = false;
			model.play();
		}
		
		override protected function onPreRender():void
		{
			scene.rotationY++;
		}
	}
}