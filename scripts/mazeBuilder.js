var ctx = canvas.getContext("2d");


function decideDirection(){
	var motions = [[-1,0],[1,0],[0,-1],[0,1]];
	var motion = motions[parseInt(Math.random()*4)];
	return motion;
}


function automateDrone(){
	var motion = decideDirection();
	move(motion[0],motion[1]);
	if(drones[drones.length-1].oncell.end){
		alert("found the end");
	} else {
		setTimeout(automateDrone,500);
	}
}


function cell(row,col){
	return {"left":true,"right":true,"top":true,"bottom":true,"row":row,"col":col,"begin":false,"end":false};
}

var grid;

var cellsize=20;
var rad = parseInt(cellsize/2);

function drone(cell){
	return {"visited":[],"oncell":cell};
}

var drones = [];

function animateDrone(cell1,cell2){
	var thisdrone = drones[drones.length-1];
	thisdrone.visited.push(cell2);
	thisdrone.oncell = cell2;

	var x = cell2.col*cellsize;
	var y = cell2.row*cellsize;
	drawCell(cell1);
	drawCell(cell2);

	ctx.fillStyle = "#0000ff";
	ctx.beginPath();
	ctx.arc(x+rad,y+rad,rad,0,2*Math.PI);
	ctx.fill();
}

function move(x,y){
	var thisdrone = drones[drones.length-1];
	var row = thisdrone.oncell.row + y;
	var col = thisdrone.oncell.col + x;

	if(row < 0 || row >= grid.rows.length || col < 0 || col >= grid.rows[0].cols.length){
		return;
	}

	if(x == 1){
		breakWall(thisdrone.oncell,"right");
	} else if (x == -1) {
		breakWall(thisdrone.oncell,"left");
	} else if (y == -1) {
		breakWall(thisdrone.oncell,"top");
	} else if (y == 1) {
		breakWall(thisdrone.oncell,"bottom");
	}

	animateDrone(thisdrone.oncell, grid.rows[row].cols[col]);

}

function drawCell(box){
	ctx.fillStyle = "#000000";
	var x = box.col*cellsize;
	var y = box.row*cellsize;
	ctx.clearRect(x,y,cellsize,cellsize);

	ctx.beginPath();
	ctx.moveTo(x,y);
	if(box.left){
		ctx.lineTo(x,y+cellsize);
		ctx.stroke();
	}else{
		ctx.moveTo(x,y+cellsize);
	}

	if(box.bottom){
		ctx.lineTo(x+cellsize,y+cellsize);
		ctx.stroke();
	}else{
		ctx.moveTo(x+cellsize,y+cellsize);
	}

	if(box.right){
		ctx.lineTo(x+cellsize,y);
		ctx.stroke();
	}else{
		ctx.moveTo(x+cellsize,y);
	}

	if(box.top){
		ctx.lineTo(x,y);
		ctx.stroke();
	}else{
		ctx.moveTo(x,y);
	}


	if(box.begin){
		ctx.fillStyle = "#00FF00";
		ctx.beginPath();
		ctx.arc(x+rad,y+rad,rad,0,2*Math.PI);
		ctx.fill();
	}

	if(box.end){
		ctx.fillStyle = "#FF0000";
		ctx.beginPath();
		ctx.arc(x+rad,y+rad,rad,0,2*Math.PI);
		ctx.fill();
	}

}


function getEnds(){
	var top = grid.rows[0].cols.slice(0);
	var bottom = grid.rows[grid.rows.length-1].cols.slice(0);

	possibles = top.concat(bottom);
	var i;
	for(i=1;i<grid.rows.length-1;i++){
		possibles.push(grid.rows[i].cols[0]);
		possibles.push(grid.rows[i].cols[grid.rows[i].cols.length-1]);
	}

	var start = parseInt(Math.random()*possibles.length);
	possibles[start].begin=true;
	drawCell(possibles[start]);
	drones.push(new drone(possibles[start]));


	possibles.splice(start,1);
	var end = parseInt(Math.random()*possibles.length);
	possibles[end].end=true;
	drawCell(possibles[end]);
}

function initBoard(rowcount,colcount){
	grid = {"rows":[]};
	canvas.width = colcount*cellsize;
	canvas.height = rowcount*cellsize;
	ctx.clearRect(0, 0, canvas.width, canvas.height);
	var r,c;

	for(r=0;r<rowcount;r++){
		var row = {"cols":[]};
		for(c=0;c<colcount;c++){
			var box = new cell(r,c);
			row.cols.push(box);
			drawCell(box);
		}
		grid.rows.push(row);
	}
	getEnds();
}

function breakWall(cell,wall){
	var othercell,otherwall;
	switch(wall){
		case "top":
			othercell = grid.rows[cell.row-1].cols[cell.col];
			otherwall = "bottom";
			break;
		case "bottom":
			othercell = grid.rows[cell.row+1].cols[cell.col];
			otherwall = "top";
			break;
		case "left":
			othercell = grid.rows[cell.row].cols[cell.col-1];
			otherwall = "right";
			break;
		case "right":
			othercell = grid.rows[cell.row].cols[cell.col+1];
			otherwall = "left";
			break;
	}
	cell[wall] = false;
	othercell[otherwall] = false;
	drawCell(cell);
	drawCell(othercell);
}

initBoard(10,20);
automateDrone();

document.onkeydown = checkKey;
function checkKey(e) {
	e = e || window.event;

	if (e.keyCode == '38') { //up arrow
		move(0,-1);
	} else if (e.keyCode == '40') { //down arrow
		move(0,1);
	} else if (e.keyCode == '37') { //left
		move(-1,0);
	} else if (e.keyCode == '39') { //right
		move(1,0);
	}
}
