exports.calledName = "";
exports.names=["tryjson"];

exports.parms=[];

exports.helpText = "json - formats json as a pretty string\r\n"+
	"(Doesn't have to be valid JSON)\r\n"+
	"Syntax: pasty json\r\n";
exports.oneLiner = "formats json as a pretty string";

function buildTabs(tabcount){
	//var settings = require("./node_modules/pasty-clipboard-editor/settings.js").settings;
	//var tabstr = settings.tabString;
    var tabstr = "\t";
	var output = "";
	for(var i=0;i<tabcount;i++){
		output += tabstr;
	}
	return output;
}

exports.edit=function(input, switches){
			var c;
			var escape = false;
			var stringchar = "";
			var tabcount = 0;
			var output = [];
            var started = false;
			//input = input.replace(/[\r\n]/g, '');
			for (c = 0; c < input.length; c++) {
				var char = input[c];
                if (!started) {
                    if (char === "[" || char === "{") {
                        started = true;
                        if (c > 0) {
                            output.push("\r\n");
                        }
                    } else {
                        output.push(char);
                        continue;
                    }
                }
				if (stringchar) {
					output.push(char);
					if (char === stringchar && !escape) {
						stringchar = "";
					} else if (char === '\\' && !escape) {
						escape = true;
					} else {
						escape = false;
					}
				} else {
                    if (char === '\r' || char === '\n') {
                        continue;
                    }
					if (char === '{') {
						output.push("{\r\n");
						tabcount++;
						output.push(buildTabs(tabcount));
					} else if (char === '}') {
						tabcount--;
						output.push("\r\n");
						output.push(buildTabs(tabcount));
						output.push(char);
					} else if (char === '[') {
						output.push("[\r\n");
						tabcount++;
						output.push(buildTabs(tabcount));
					} else if (char === ']') {
						output.push("\r\n");
						tabcount--;
						output.push(buildTabs(tabcount));
						output.push(char);
					} else if (char === ',') {
						output.push(",\r\n");
						output.push(buildTabs(tabcount));
					} else if (char === '<') {
						output.push("&lt;");
					} else if (char === '>') {
						output.push("&gt;");
					} else {
                        if (char === "\"" || char === "'") {
                            stringchar = char;
                        }
						output.push(char);
					}
				}
			}

			return output.join("");
};

