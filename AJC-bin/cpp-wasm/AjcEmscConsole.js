
/**
 * @constructor
 */
AjcEmscConsole = function() {
	var /** @type {*} */ _script = document.createElement('script');
	_script.onload = this.initWasm.bind(this);
	_script.src = ajcGlobal.emscModuleFileName + ".js";
	_script.defer = false;
	_script.async = false;
	document.head.appendChild(_script);
};

/**
 * @private
 * @type {XMLHttpRequest}
 */
AjcEmscConsole.prototype.loader;


/**
 * @private
 * @type {*}
 */
AjcEmscConsole.prototype.loadedWasmBytes;



/**
 * @private
 */
AjcEmscConsole.prototype.initWasm = function() {
	this.loader = new XMLHttpRequest();
	this.loader.open('GET', ajcGlobal.emscModuleFileName + ".wasm", true);
	this.loader.responseType = 'arraybuffer';
	this.loader.onload = this.loadCompelteEvent.bind(this);
	this.loader.send();
};


/**
 * @private
 * @param {Event=} e
 */
AjcEmscConsole.prototype.loadCompelteEvent = function(e) {
	console.log("wasm loaded");
	this.loadedWasmBytes = this.loader.response;

	var ajcEmscConfig ={}; 
	ajcEmscConfig.noInitialRun = true;
	ajcEmscConfig.onRuntimeInitialized = this.onRuntimeInitialized.bind(this);
	ajcEmscConfig.instantiateWasm = this.wasmInstantiateCallBack.bind(this);
  
    if(ajcGlobal.hasOwnProperty("emscModuleConfig"))
	{
		Object.keys(ajcGlobal.emscModuleConfig).forEach
		(
			function(key)
			{
				ajcEmscConfig[key] = ajcGlobal.emscModuleConfig[key];
			}	
		)
	}
	
	ajcGlobal.stageInitWidth  = ajcGlobal.stageInitWidth || 800;
	ajcGlobal.stageInitHeight = ajcGlobal.stageInitHeight || 600;
	
	var	_rootHtmlElement = document.createElement('div');
	_rootHtmlElement.style.left = "0px";
	_rootHtmlElement.style.top = "0px";
	_rootHtmlElement.style.position = ajcGlobal.useStageMinSize ? "absolute" : "fixed";
	_rootHtmlElement.style.width = ajcGlobal.stageInitWidth.toString() + "px";
	_rootHtmlElement.style.height = ajcGlobal.stageInitHeight.toString() + "px";
	ajcGlobal.rootHtmlElementID = _rootHtmlElement.id = 'rootHtmlElement';
	document.body.appendChild(_rootHtmlElement);
	
	
	if(!ajcEmscConfig.hasOwnProperty('canvas'))
	{
		var canvas = document.createElement('canvas');
		canvas.style.position = "fixed";
		canvas.style.left = "0px";
		canvas.style.top = "0px";
		canvas.id= "canvas";
		_rootHtmlElement.appendChild(canvas);
	
		ajcEmscConfig.canvas = canvas;
	}
	
	window[ajcGlobal.emscOutputModuleName] = new window[ajcGlobal.emscSrcEmscModuleName](ajcEmscConfig);
};

/**
 * @private
 * @param {*} info
 * @param {Function} receiveInstance
 * @return {*}
 */
AjcEmscConsole.prototype.wasmInstantiateCallBack = function(info, receiveInstance) {
	console.log("wasm-Instantiate-CallBack");
	WebAssembly.instantiate(this.loadedWasmBytes, info).then(
	function(output) {
		console.log("receiveInstance");
		receiveInstance(output["instance"]);
	});
	return {};
};


/**
 * @private
 */
AjcEmscConsole.prototype.onRuntimeInitialized = function() 
{
	
	var moduleObject = window[ajcGlobal.emscOutputModuleName];

	Object.keys(moduleObject).forEach
	(
		function(key) 
		{
			if(key.includes("$"))
			{
				console.log("exported packged classes: "+key);
				
				var packageArray = key.split('$');
				var len = packageArray.length -1;
				var parentPackge = moduleObject;
				for(var i = 0; i < len; i++)
				{
					if(!parentPackge.hasOwnProperty(packageArray[i]))
						parentPackge[packageArray[i]] = {};
						
					parentPackge = parentPackge[packageArray[i]];
					
				}
				parentPackge[packageArray[len]] = moduleObject[key];
				delete moduleObject[key];
			}
		}
	) 
	
	moduleObject["_STAGE_INSTANCE_"] = new moduleObject.display.Stage();
	moduleObject["_STAGE_INSTANCE_"].addEventListener("init", this.onStageInit.bind(this));
	
	var arrayArgs = [];
	arrayArgs.push("-windowWidth",ajcGlobal.stageInitWidth.toString());
	arrayArgs.push("-windowHeight",ajcGlobal.stageInitHeight.toString());
	arrayArgs.push("-windowAutoSize",ajcGlobal.stageAutoSize? "1": "0");
	if(ajcGlobal.emscModuleAdditionalMainArgs)
	{
		var additionalArgsArray = ajcGlobal.emscModuleAdditionalMainArgs.split(" ");
		
		Array.prototype.push.apply(arrayArgs,additionalArgsArray);
	}
	window[ajcGlobal.emscOutputModuleName].callMain(arrayArgs);
};

AjcEmscConsole.prototype.onStageInit = function(e)
{
	console.log("onStageInit");
	
	var moduleObject = window[ajcGlobal.emscOutputModuleName];
	
	moduleObject["_STAGE_INSTANCE_"].removeEventListener("init", this.onStageInit.bind(this));
	

	if(ajcGlobal.buildType == 'intermediate')
	{	
		goog.ENABLE_CHROME_APP_SAFE_SCRIPT_LOADING = true;
		goog.require(ajcGlobal.appRootName);
	}
	else
	{
		moduleObject["_STAGE_INSTANCE_"].addChild(new window[ajcGlobal.appRootName]());
	}
	
	var runDependencyWatcher = setInterval(function()
		{
			if(window[ajcGlobal.appRootName] !== undefined)
			{
				clearInterval(runDependencyWatcher);
				moduleObject["_STAGE_INSTANCE_"].addChild(new window[ajcGlobal.appRootName]());
				return;
			}
		}, 100);
	
}