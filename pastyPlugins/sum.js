exports.calledName = "";
exports.names=["sum"];

exports.parms=[
	{"name":"separator","value":null,"defaultValue":"\n"}
];

exports.helpText = "sum - Sums all the numbers in your clipboard";
exports.oneLiner = "Creates a DO NOT EDIT BELOW line with your text";

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

	var output = 0;
	items.forEach(function(n){
		try {
			var nn = parseInt(n);
		} catch (e){
			return;
		}

		if (!nn || nn == NaN){
			return;
		}

		output += nn;
	});

	return output+"";
};

