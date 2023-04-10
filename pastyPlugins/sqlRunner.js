exports.calledName = "";
exports.names=["sqlRunner"];

exports.parms=[
    {"name":"number of columns","value":null,"defaultValue":null}
];

exports.helpText = "sqlrunner - formats copied text from sql runner to paste into a spreadsheet";
exports.oneLiner = "formats copied text from sql runner to paste into a spreadsheet";

exports.edit=function(input, switches){
    let colNum = parseInt(exports.parms[0].value);
    lines = input.split(/\n/);
    let output = [lines.shift()];
    let line = [];
    for(let i=0;i<lines.length;i++) {
        if (i%colNum == 0 && i > 0) {
            output.push(line.join("\t"));
            line = [];
        }
        line.push(lines[i]);
    }
    output.push(line.join("\t"));

    return output.join("\n");
};

