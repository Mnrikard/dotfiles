exports.calledName = "";
exports.names=["reconcile"];

exports.parms=[
	{"name":"separator","value":null,"defaultValue":"\n"}
];

exports.helpText = "Presents a list of only items that appear more than once";
exports.oneLiner = "Presents a list of only items that appear more than once";

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
	var sep = exports.parms[0].value;
	var sepRx = new RegExp(escapeRegex(sep),"gi");
	var items = input.split(sepRx);

	console.log(items.length);

	var output = [];

	var i=0,j=0,ignoreCase=(switches.match(/i/));
	for(i=0;i<items.length;i++){
		for(j=i+1;j<items.length;j++){
			if(items[j].trim() === items[i].trim()){
				output.push(items[i]);
				break;
			}

			if(ignoreCase){
				if(items[j].trim().toLowerCase() === items[i].trim().toLowerCase()){
					output.push(items[i]);
					break;
				}
			}
		}
	}
	console.log(output.length);

	return output.join(sep);
};

