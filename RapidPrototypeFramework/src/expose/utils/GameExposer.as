package expose.utils
{
	import expose.Expose;
	import expose.component.ui.BreakComponent;
	import expose.component.ui.ButtonComponent;
	import expose.component.ui.LabelComponent;
	import expose.screen.page.ExposePage;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	import gamescene.Component;
	import gamescene.GameObject;

	public class GameExposer
	{
		
		public static function showGameDataPage():void
		{
			var newPage:ExposePage = new ExposePage();
			
			// FOR CURR GAME SCENE
			newPage
				.add( ButtonComponent.getCaller('BACK TO SCENE EXPOSE',Core.scenes.getCurrScene().initExpose) )
				.add( ButtonComponent.getCaller('Save Data',Core.dataManager.saveGameData) )
				.add( ButtonComponent.getCaller('Load Data',Core.dataManager.loadGameData) )
			newPage.add( new BreakComponent(false) );
			
			// FOR EACH COMPONENT
			var variable:XML;
			var classXML:XML = describeType(Core.data);
			for each( variable in classXML.variable ){
				newPage.add( LabelComponent.getLabel(variable.@name) );
				PageFactory.getPageFromObject( Core.data[variable.@name], newPage );
				newPage.add( new BreakComponent() );
			}
			newPage.add( new BreakComponent() );
			
			// SHOW
			Expose.show(newPage);
		}
		
		public static function makeGameObjectPage(gameObj:GameObject):ExposePage
		{
			var newPage:ExposePage = new ExposePage();
			
			// FOR CURR GAME SCENE
			newPage.add( ButtonComponent.getCaller('BACK TO SCENE EXPOSE',Core.scenes.getCurrScene().initExpose) );
			newPage.add( new BreakComponent(false) );
			
			// FOR GAME OBJECT
			newPage.add( LabelComponent.getLabel( getClassName(gameObj) ) );
			PageFactory.getPageFromObject(gameObj,newPage);
			newPage.add( new BreakComponent() );
			
			// FOR EACH COMPONENT
			for each( var component:Component in gameObj.components ){
				newPage.add( LabelComponent.getLabel( getClassName(component) ) );
				PageFactory.getPageFromObject(component,newPage);
				newPage.add( new BreakComponent() );
			}
			
			// RETURN
			return newPage;
		}
		
		private static function getClassName(obj:*):String {
			var fullName:String = getQualifiedClassName(obj);
			return fullName.substr( fullName.indexOf("::") );
		}
		
		public static function showClickedGameObject(event:MouseEvent):void
		{
			if( event.target is MovieClip ){
				var mc:MovieClip = MovieClip(event.target);
				if(mc!=null){
					var gameObj:GameObject = Core.scenes.getCurrScene().getGameObjectById(mc.name);
					if(gameObj!=null){
						Expose.show( makeGameObjectPage(gameObj) );
					}
				}
			}
		}
	}
}