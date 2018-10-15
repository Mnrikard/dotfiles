exports.calledName = "";
exports.names=["mdtable"];

exports.parms=[
	{"name":"separator","value":null,"defaultValue":"\t"}
];

exports.helpText = "Converts a delimited text to a markdown table";
exports.oneLiner = "Converts a delimited text to a markdown table";

escapeRegex = function(actualText){
	return actualText.replace(/\(/g,"\\(")
		.replace(/\)/g,"\\)")
		.replace(/\+/g,"\\+")
		.replace(/\*/g,"\\*")
		.replace(/\-/g,"\\-")
		.replace(/\./g,"\\.")
		.replace(/\|/g,"\\|");
};

splitColumns = function(row){
	var sep = exports.parms[0].value;
	var sepRx = new RegExp(escapeRegex(sep),"gi");

	return row.split(sepRx);
}

getColumnLengths = function(rows){
	var output = [];
	rows.forEach(function(row){
		if(row.trim().length === 0){
			return;
		}
		cols = splitColumns(row);
		var i;
		for(i = 0; i<cols.length;i++){
			if(output[i]){
				output[i] = Math.max(output[i],cols[i].trim().length);
			} else {
				output.push(cols[i].length);
			}
		}
	});

	return output;
}

writeRow = function(cols, lengths){
	var i;
	for(i=0;i<cols.length;i++){
		cols[i] = cols[i].trim().padEnd(lengths[i]);
	}
	return "| " + cols.join(" | ") + " |";
}

writeSeparator = function(lengths){
	var i;
	var cols = [];
	for(i=0;i<lengths.length;i++){
		cols.push("".padEnd(lengths[i],"-"));
	}
	return "|-" + cols.join("-|-") + "-|";
}

writeTable = function(rows, lengths){
	var output = [];
	var header = rows.shift();
	header = splitColumns(header);
	output.push(writeRow(header, lengths));
	output.push(writeSeparator(lengths));
	rows.forEach(function(row){
		if(row.trim().length === 0){return;}
		cols = splitColumns(row);
		output.push(writeRow(cols, lengths));
	});
	return output.join("\n");
}

exports.edit=function(input, switches){
	var rows = input.trim().split(/\n/);
	while(rows.length > 0 && rows[0].match(/^\s*$/)){
		rows.shift();
	}

	var lengths = getColumnLengths(rows);

	return writeTable(rows,lengths);
};

