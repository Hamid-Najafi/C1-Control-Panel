let screenWidth = 1920;
let screenHeight = 1080;

function getTopMenuHeight(){
    return 48;
}

function setScreenWidth(width){
    screenWidth = width;
}

function setScreenHeigth(heigth){
    screenHeight = heigth;
}

function getSideMenuWidth(){
    return screenWidth / 3;
}

function getScreenWidth(){
    return screenWidth;
}

function getScreenHeight(){
    return screenHeight;
}

function getMenuHeight(){
    return screenHeight / 6;
}

function colorTransparency(color , transparency){

    let col = Qt.rgba(color.r,color.g,color.b,transparency);
    return col;
}

function getGridItemWidth(width,height,rows,cols,rowSpan,colSpan){
    let singleRow = height / rows;
    let singleCol = width / cols;
    return singleCol  * colSpan;
}
function getGridItemHeight(width,height,rows,cols,rowSpan,colSpan){
    let singleRow = height / rows;
    let singleCol = width / cols;
    return singleRow  * rowSpan;
}

function getGridItemRectSize(width,height,rows,cols,rowSpan,colSpan){
    let singleRow = height / rows;
    let singleCol = width / cols;
    return Math.min(singleRow  * rowSpan , singleRow  * rowSpan);
}

function getGridItemX(width,height,rows,cols,rowSpan,colSpan,row,col){
    let singleRow = height / rows;
    let singleCol = width / cols;
    return singleCol  * (col - 1);
}
function getGridItemY(width,height,rows,cols,rowSpan,colSpan,row,col){
    let singleRow = height / rows;
    let singleCol = width / cols;
    return singleRow * (row - 1);
}

