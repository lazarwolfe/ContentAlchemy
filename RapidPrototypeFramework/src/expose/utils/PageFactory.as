package expose.utils
{
	import expose.component.ExposeComponent;
	import expose.component.proxy.CheckboxProxy;
	import expose.component.proxy.InputProxy;
	import expose.screen.page.ExposePage;
	
	import flash.utils.describeType;

	public class PageFactory
	{
		public static function getPageFromObject(obj:*,newPage:ExposePage=null,propertyWhitelist:Array=null,componentCreationFunction:Function=null):ExposePage
		{
			if(newPage==null){
				newPage = new ExposePage();
			}
			var variable:XML;
			var classXML:XML = describeType(obj);
			var reflectionConfigs:Vector.<ReflectionConfig> = new Vector.<ReflectionConfig>();
			var reflectionProxy:ReflectionProxy;
			var reflectionConfig:ReflectionConfig;
			var componentConfigs:Vector.<ComponentConfig> = new Vector.<ComponentConfig>();
			
			// EXCLUDE TAG?...
			//var propertyBlacklist:Array = new Array();
			//for each( var excluded:XML in 
			
			// For each Variable or Accessor, create a Reflection Proxy
			for each( variable in classXML.variable ){
				if( propertyWhitelist==null || propertyWhitelist.indexOf(String(variable.@name))>=0 ){
					reflectionProxy = new ReflectionProxy( obj, variable.@name );
					reflectionConfig = new ReflectionConfig( variable.@type, reflectionProxy );
					reflectionConfigs.push( reflectionConfig );
				}
			}
			for each( variable in classXML.accessor ){
				if( propertyWhitelist==null || propertyWhitelist.indexOf(String(variable.@name))>=0 ){
					
					if( variable.@access != ReflectionProxy.ACCESS_RW ) continue;
					
					reflectionProxy = new ReflectionProxy( obj, variable.@name, variable.@access );
					reflectionConfig = new ReflectionConfig( variable.@type, reflectionProxy );
					reflectionConfigs.push( reflectionConfig );
				}
			}
			
			// For each config, create the Var Proxies for its Type or EditWith tag
			for each( reflectionConfig in reflectionConfigs )
			{
				reflectionProxy = reflectionConfig.reflectionProxy;
				
				// Pass another function to create something based on type
				/*if (componentCreationFunction!=null){
					var newComponent:ExposeComponent = componentCreationFunction(reflectionConfig.type);
					if (newComponent!=null){
						newPage.add( newComponent );
						continue;
					}
				}*/
				
				// Edit With Tag
				
				// Type
				switch( reflectionConfig.type )
				{
					case "Boolean":
						componentConfigs.push( new ComponentConfig( reflectionProxy.propertyName, 
							CheckboxProxy.getNormal( reflectionProxy.propertyName, reflectionProxy.getter, reflectionProxy.setter )
						) );
						break;
					case "int":
						componentConfigs.push( new ComponentConfig( reflectionProxy.propertyName, 
							InputProxy.getInt( reflectionProxy.propertyName, reflectionProxy.getter, reflectionProxy.setter )
						) );
						break;
					case "uint":
						componentConfigs.push( new ComponentConfig( reflectionProxy.propertyName, 
							InputProxy.getHex( reflectionProxy.propertyName, reflectionProxy.getter, reflectionProxy.setter )
						) );
						break;
					case "Number":
						componentConfigs.push( new ComponentConfig( reflectionProxy.propertyName, 
							InputProxy.getNumber( reflectionProxy.propertyName, reflectionProxy.getter, reflectionProxy.setter )
						) );
						break;
					case "String":
						componentConfigs.push( new ComponentConfig( reflectionProxy.propertyName, 
							InputProxy.getString( reflectionProxy.propertyName, reflectionProxy.getter, reflectionProxy.setter )
						) );
						break;
				}
			}
			
			// SORT THEM ALPHABETICALLY
			componentConfigs.sort( function(first:ComponentConfig,second:ComponentConfig):Number{
				if(first.name<second.name){
					return -1;
				}
				if(first.name>second.name){
					return 1;
				}if(first.name<second.name){
					return -1;
				}
				return 0;
			});
			
			// Then add to New Page
			var i:int;
			for( i=0; i<componentConfigs.length; i++ ){
				newPage.add( componentConfigs[i].component );
			}
			
			// Return new page
			return newPage;
		}
		
	}
}


import expose.component.ExposeComponent;
import expose.utils.ReflectionProxy;

class ReflectionConfig
{
	public var reflectionProxy:ReflectionProxy;
	public var type:String;
	public var metadata:XML;
	public function ReflectionConfig( type:String, reflectionProxy:ReflectionProxy, metadata:XML=null ){
		this.type = type;
		this.reflectionProxy = reflectionProxy;
		this.metadata = metadata;
	}
}

class ComponentConfig
{
	public var component:ExposeComponent;
	public var name:String;
	public function ComponentConfig( name:String, component:ExposeComponent ){
		this.name = name;
		this.component = component;
	}
}