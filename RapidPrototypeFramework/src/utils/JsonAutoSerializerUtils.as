package utils {
	import avmplus.getQualifiedClassName;
	
	import Core;
	import debug.logger.LogCategories;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;

	/**
	 * This is the actionscript3 version of GSon.
	 * It converts JSON objects to typed objects and the other way around.
	 * */
	public class JsonAutoSerializerUtils {	
		//# STATIC CONST
		//# PUBLIC
		//# PRIVATE/PROTECTED/INTERNAL
		//# PROPERTIES
		//# CONSTRUCTOR/INIT/DESTROY
		//# PUBLIC
		public static function fromJsonString(jsonString : String, type : Class) : Object {
			return fromJson(JSON.parse(jsonString),type);
		}
		public static function toJsonString(object:Object) : String {
			return JSON.stringify(toJson(object));
		}
		
		/**
		 * Recursively goes through a typed object and copies all the references to json (dynamic) object.
		 * Supported data types are all of the basic types, any user defined types and Vectors of any type.
		 * Arrays and Dictionaries on the typed object are not supported (as they are not typed and cant be deserialized).
		 * Vectors on the typed object will map to a Arrays on the json object.
		 * @param 	typedObject The object that will be serialized to json
		 * @param	debugString Leave empty. This is used in the recurson to provide debug information.
		 * @returns An dynamic (json) object with all the properties of the passed typedObject.
		 * */
		public static function toJson(typedObject : Object, debugString:String = "") : Object {
			var json : Object = { };
			var typeName:String = getQualifiedClassName(typedObject);
			var simpleTypeName:String;
			var i:int;
			var p:String;
			var partialDebugString:String = "";
			
			//Super easy way out?
			if(typedObject == null) {
				return null;
			}
			
			//Easy way out?
			simpleTypeName = typeof(typedObject);
			if(simpleTypeName == "boolean" || simpleTypeName == "function" || simpleTypeName == "number" || simpleTypeName == "xml" || typedObject is String) {
				return typedObject;
			}
			
			try {
				//Is this a Vector?
				if(typeName.indexOf("__AS3__.vec::Vector") != -1) {
					var array:Array = [];
					for(i = 0 ; i < typedObject.length ; i++) {
						array.push( toJson( typedObject[i], debugString + "[" + i + "]"));
					}
					return array;
				}
				else {	//Complex Object Types
					
					// Determine if o is a class instance or a plain object
					var classInfo:XML = describeType( typedObject );
					if (classInfo.@name.toString() == "Object" ) {
						for (p in typedObject){
							partialDebugString = "." + p;
							json[p] = toJson(typedObject[p], debugString + partialDebugString);
							partialDebugString = "";
						}
					}
					else { //Class instance
						for each ( var v:XML in classInfo.variable) {
							p = v.@name;
							partialDebugString = "." + p;
							json[p] = toJson(typedObject[p], debugString + partialDebugString);
							partialDebugString = "";
						}
					}
				}
			}
			catch(error:Error) {
				Core.logs.error("Failed to auto serialize JSON object on property: " + debugString + partialDebugString, toJson, LogCategories.SERIALIZATION, error); 
			}
			
			return json;
		}
		
		/**
		 * Recursively goes through an json object and copies all the references to a typed (non dynamic) object of type "type".
		 * The properties' names must match.
		 * Supported data types are all of the basic types, any user defined types and Vectors of any type.
		 * Arrays and Dictionaries on the typed object are not supported (as they are not typed).
		 * Arrays on the json object will map to a Vector on the typed object.
		 * @param 	json The json (dynamic) object
		 * @param	type The Class object of the target data type. An object of this type will be returned
		 * @param	debugString Leave empty. This is used in the recurson to provide debug information.
		 * @returns An object of type "type" with all the properties of the passed json object.
		 * */
		public static function fromJson(json : Object, type : Class, debugString:String = "root") : Object {
			var typedObject : Object = new type();
			var typeName:String = getQualifiedClassName(typedObject);
			var simpleTypeName:String;
			var i:int;
			var p:String;
			var partialDebugString:String = "";
			
			//Super easy way out?
			if(json == null) {
				return null;
			}
			
			//Easy way out?
			simpleTypeName = typeof(typedObject);
			if(simpleTypeName == "boolean" || simpleTypeName == "function" || simpleTypeName == "number" || simpleTypeName == "xml" || json is String) {
				return json;
			}
			
			try {
				//Is this a Vector?
				if(typeName.indexOf("__AS3__.vec::Vector") != -1) {
					//Get the type of its members using magical string manipulation
					var a:int = typeName.indexOf("<");
					var b:int = typeName.lastIndexOf(">");
					var vectorTypeName:String = typeName.substr(a + 1, b - a - 1);
					var vectorType:Class = getDefinitionByName(vectorTypeName) as Class;
					for(i = 0 ; i < json.length ; i++) {
						typedObject.push( fromJson( json[i], vectorType, debugString + "[" + i + "]"));
					}
					
				}
				else {	//Complex Object Types
					for (p in json) {
						try {
							partialDebugString = "." + p;
							var propertyTypeName:String = getQualifiedClassName(typedObject[p]);
							var propertyType:Class = getDefinitionByName(propertyTypeName) as Class;
							typedObject[p] = fromJson(json[p], propertyType, debugString + partialDebugString);
							partialDebugString = "";
						}
						catch(error : Error) {
							trace("VAR : " + p + " - " + error.errorID + "|" + error.message + "\n" + error.getStackTrace());
							throw error;
						}
					}
				}
			}
			catch(error:Error) {
				Core.logs.error("Failed to auto deserialize JSON object on property: " + debugString + partialDebugString, fromJson, LogCategories.SERIALIZATION, error); 
			}
			
			return typedObject;
		}
		
		//# PRIVATE/PROTECTED/INTERNAL
	} // class
} // package