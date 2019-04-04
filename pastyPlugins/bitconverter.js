exports.calledName = "";
exports.names=["encodebits","decodebits"];

exports.parms=[
	{"name":"separator","value":null,"defaultValue":"-"}
];

exports.helpText = "encodebits - encodes bits as hex values separated by dashes\r\n"+
	"Syntax: pasty encodebits\r\n"+
	"Example: echo abcd | pasty reverse\r\n"+
	">> dcba";
exports.oneLiner = "reverses a string";

escapeRegex = function(actualText){
	return actualText.replace(/\(/g,"\\(")
		.replace(/\)/g,"\\)")
		.replace(/\+/g,"\\+")
		.replace(/\*/g,"\\*")
		.replace(/\-/g,"\\-")
		.replace(/\./g,"\\.")
		.replace(/\|/g,"\\|");
};

exports.edit=function(input, switches){
	var i;
	var output = [];
	var sep = exports.parms[0].value;
	if(exports.calledName.match(/decodebits/i)){
		var sepRx = new RegExp(escapeRegex(sep),"gi");
		var bits = input.split(sepRx);

		for(i=0;i<bits.length;i++){
			var num = parseInt(bits[i],16);
			output.push(String.fromCharCode(num));
		}

		return output.join("");
	}

	if(exports.calledName.match(/encodebits/i)){
		for(i=0;i<input.length;i++){
			output.push(input.charCodeAt(i).toString(16).toUpperCase());
		}
		return output.join(sep);
	}
};

