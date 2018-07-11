exports.calledName = "";
exports.names=["policeLine"];

exports.parms=[
	{"name":"length","value":null,"defaultValue":"100"}
];

exports.helpText = "policeLine - Creates a DO NOT EDIT BELOW line with your text";
exports.oneLiner = "Creates a DO NOT EDIT BELOW line with your text";

exports.edit=function(input, switches){
	if(input.length%2 == 1){input += "!";}
	input = input.toUpperCase();
	var ll = parseInt(exports.parms[0].value);
	var tl = input.length;
	var sideDashes = (ll-tl)/2;
	var i;

	var template = [];
	for(i=0;i<ll;i++){template[i] = "-";}

	var line = template.join("");
	for (i=sideDashes,j=0;j<input.length;i++,j++){template[i] = input[j];}
	var textLine = template.join("");

	var output = line+"\n"+textLine+"\n"+line;
	return output;
};

