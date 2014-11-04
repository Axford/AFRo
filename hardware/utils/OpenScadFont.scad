//OpenScadFont

//Author: Steve Miller (avrgeek on Thingiverse)
//http://www.thingiverse.com/thing:6820

/*

Usage: fnt_str(chars,char_count, block_size, height)
Example fnt_str(["H","e","l","l","o"],5,1,3);

This provides an alternate method of embedding lettering into an OpenSCAD project.  An 
open source font is exported into dxf files, and those files are linear_extruded to provide nicely 
rendered fonts.  The code is based on the bitmap font module 
(http://www.thingiverse.com/thing:2054).  The function provided by the fnt_str will map to the 
8bit_str moudule.  The block-size parameter will have no effect on the generated size of the letters.  
Make sure the "fnt-LeagueGothic" directory is contained within the directory for your project.

The font use was League Gothic from the League of Moveable Type 
(http://www.theleagueofmoveabletype.com/fonts/7-league-gothic)  This font does have variable width,
so some of the letters may look out of place.  Some manual adjustments have been made, but
OpenSCAD's immutable variables makes calculating the proper spacing difficult.  Perhaps a 
smarter person has a way of pulling this off.

Other fonts can be adapted to this module.  The Customize.txt file will contain basic instructions for
porting new fonts.



*/

font_spacing = 0.0;
aa = 3.5 + font_spacing;
bb = 3.35 + font_spacing;
cc = 3.3 + font_spacing;
dd = 3.35 + font_spacing;
ee = 3.3 + font_spacing;
ff = 2.65 + font_spacing;
gg = 4.35 + font_spacing;
hh = 3.35 + font_spacing;
ii = 1.3 + font_spacing;
jj = 2.1 + font_spacing;
kk = 3.45 + font_spacing;
ll = 1.3 + font_spacing;
mm = 4.75 + font_spacing;
nn = 3.35 + font_spacing;
oo = 3.35 + font_spacing;
pp = 3.35 + font_spacing;
qq = 3.35 + font_spacing;
rr = 2.6 + font_spacing;
ss = 3.5 + font_spacing;
tt = 2.9 + font_spacing;
uu = 3.35 + font_spacing;
vv = 3.6 + font_spacing;
ww = 4.6 + font_spacing;
xx = 3.7 + font_spacing;
yy = 3.4 + font_spacing;
zz = 3.2 + font_spacing;
AA = 4.55 + font_spacing;
BB = 3.85 + font_spacing;
CC = 3.7 + font_spacing;
DD = 3.85 + font_spacing;
EE = 3.18 + font_spacing;
FF = 3.3 + font_spacing;
GG = 3.7 + font_spacing;
HH = 3.85 + font_spacing;
II = 1.4 + font_spacing;
JJ = 2.15 + font_spacing;
KK = 4.2 + font_spacing;
LL = 3.25 + font_spacing;
MM = 4.55 + font_spacing;
NN = 3.55 + font_spacing;
OO = 3.7 + font_spacing;
PP = 3.8 + font_spacing;
QQ = 4.0 + font_spacing;
RR = 3.85 + font_spacing;
SS = 3.95 + font_spacing;
TT = 4.0 + font_spacing;
UU = 3.7 + font_spacing;
VV = 4.3 + font_spacing;
WW = 4.65 + font_spacing;
XX = 3.9 + font_spacing;
YY = 4.25 + font_spacing;
ZZ = 3.7 + font_spacing;
one1 = 2.35 + font_spacing;
two2 = 3.8 + font_spacing;
three3 = 3.7 + font_spacing;
four4 = 4.1 + font_spacing;
five5 = 3.65 + font_spacing;
six6 = 3.65 + font_spacing;
seven7 = 3.55 + font_spacing;
eight8 = 3.7 + font_spacing;
nine9 = 3.65 + font_spacing;
zero0 = 3.7 + font_spacing;
ampersand_ = 4.85 + font_spacing;
asterisk_ = 3.3 + font_spacing;
backslash_ = 4.85 + font_spacing;
bar_ = 2.95 + font_spacing;
dollar_ = 3.45 + font_spacing;
dot_ = 1.4 + font_spacing;
doublequote_ = 3.7 + font_spacing;
equals_ = 4.35 + font_spacing;
underscore_ = 5.0 + font_spacing;
comma_ = 1.4 + font_spacing;
colon_ = 3.7 + font_spacing;
exclamation_ = 1.5 + font_spacing;
openpar_ = 2.9 + font_spacing;
closepar_ = 2.85 + font_spacing;
opensquare_ = 2.5 + font_spacing;
closesquare_ = 2.5 + font_spacing;
at_ = 4.7 + font_spacing;
hash_ = 4.45 + font_spacing;
plus_ = 5.7 + font_spacing;
minus_ = 3.5 + font_spacing;
fowardslash_ = 4.2 + font_spacing;
greaterthan_ = 4.25 + font_spacing;
lessthan_ = 4.25 + font_spacing;
percent_ = 4.35 + font_spacing;
question_ = 3.6 + font_spacing;
singlequote_ = 1.35 + font_spacing;


//fnt_str2( ["'","P"], [0,singlequote_], 2, 1, 1 );

/*
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License. To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/; or, (b) send a letter to Creative Commons, 171 2nd Street, Suite 300, San Francisco, California, 94105, USA.
*/

//Variables
fnt_directory="utils/fnt-LeagueGothic/";


//Test module for 
module fnt_str(chars,char_count, block_size, height) {
   //Block-size will be effectly ignored for now...may try to do something with it in the future
   char_width=5;
   echo(str("Total Width: ", char_width*char_count, "mm"));

   //Trans
   union() {
     for (count = [0:char_count-1]) {
      translate(v = [5,-2.5+count * char_width, 0])
        rotate([0,0,90]) fnt_char(chars[count], block_size, height);
     }
 }
}

//Test module for 
module fnt_str_p(chars,positions, char_count, block_size, height) 
{
	//Trans
	union() 
	{
     		for (count = [0:char_count-1]) 
		{
		      translate(v = [5,positions[count], 0])
			rotate([0,0,90]) fnt_char(chars[count], block_size, height);
		}
 	}
}

module fnt_char(char, block_size, height=dw, include_base) {
  //TODO: Adjust scaling factors, determine correct "block" size.
   scale_x=8;
   scale_y=8;

    if (char == "0") {
    scale([scale_x,scale_y,0]) linear_extrude(file=str(fnt_directory,"0.dxf"),height=height, convexity=10);
  } else if (char == "1") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"1.dxf"),height=height, convexity=10);
  } else if (char == "2") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"2.dxf"),height=height, convexity=10);
  } else if (char == "3") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"3.dxf"),height=height, convexity=10);
  } else if (char == "4") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"4.dxf"),height=height, convexity=10);
  } else if (char == "5") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"5.dxf"),height=height, convexity=10);
  } else if (char == "6") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"6.dxf"),height=height, convexity=10);
  } else if (char == "7") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"7.dxf"),height=height, convexity=10);
  } else if (char == "8") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"8.dxf"),height=height, convexity=10);
  } else if (char == "9") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"9.dxf"),height=height, convexity=10);
  } else if (char == "a") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"a-lower.dxf"),height=height, convexity=10);
  } else if (char == "A") {
    scale([scale_x,scale_y,1]) linear_extrude(height) import(str(fnt_directory,"A.dxf"));
  } else if (char == "&") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"amperstand.dxf"),height=height, convexity=10);
  } else if (char == "*") {
    translate([0,2,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"asterisk.dxf"),height=height, convexity=10);
  } else if (char == "\\") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"backslash.dxf"),height=height, convexity=10);
  } else if (char == "|") {
    translate([1.7,0,1])scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"bar.dxf"),height=height, convexity=10);
  } else if (char == "b") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"b-lower.dxf"),height=height, convexity=10);
  } else if (char == "B") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"B.dxf"),height=height, convexity=10);
  } else if (char == "c") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"c-lower.dxf"),height=height, convexity=10);
  } else if (char == "C") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"C.dxf"),height=height, convexity=10);
  } else if (char == "-") {
    translate([1.7,4,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"dash.dxf"),height=height, convexity=10);
  } else if (char == "d") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"d-lower.dxf"),height=height, convexity=10);
  } else if (char == "D") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"D.dxf"),height=height, convexity=10);
  } else if (char == "$") {
    translate([0,-1.5,1]) scale([scale_x-1,scale_y,1]) linear_extrude(file=str(fnt_directory,"dollarsign.dxf"),height=height, convexity=10);
  } else if (char == ".") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"dot.dxf"),height=height, convexity=10);
  } else if (char == "\"") {
    translate([0,6,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"doublequote.dxf"),height=height, convexity=10);
  } else if (char == "=") {
    translate([0,2.5,1]) scale([scale_x-2,scale_y,1]) linear_extrude(file=str(fnt_directory,"=.dxf"),height=height, convexity=10);
  } else if (char == "_") {
    scale([scale_x-2,scale_y,1]) linear_extrude(file=str(fnt_directory,"__1.dxf"),height=height, convexity=10);
  } else if (char == ",") {
    translate([0,-1.75,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,",.dxf"),height=height, convexity=10);
  } else if (char == ":") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,":.dxf"),height=height, convexity=10);
  } else if (char == "!") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"!.dxf"),height=height, convexity=10);
  } else if (char == "(") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"openpar.dxf"),height=height, convexity=10);
  } else if (char == ")") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"closepar.dxf"),height=height, convexity=10);
  } else if (char == "[") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"[.dxf"),height=height, convexity=10);
  } else if (char == "]") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"].dxf"),height=height, convexity=10);
  } else if (char == "@") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"@.dxf"),height=height, convexity=10);
  } else if (char == "#") {
    scale([scale_x-3,scale_y,1]) linear_extrude(file=str(fnt_directory,"#.dxf"),height=height, convexity=10);
  } else if (char == "+") {
    translate([0,2,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"+.dxf"),height=height, convexity=10);
  } else if (char == "e") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"e-lower.dxf"),height=height, convexity=10);
  } else if (char == "E") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"E.dxf"),height=height, convexity=10);
  } else if (char == "f") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"f-lower.dxf"),height=height, convexity=10);
  } else if (char == "F") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"F.dxf"),height=height, convexity=10);
  } else if (char == "/") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"forwardslash.dxf"),height=height, convexity=10);
  } else if (char == "g") {
    translate([0,-3,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"g-lower.dxf"),height=height, convexity=10);
  } else if (char == "G") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"G.dxf"),height=height, convexity=10);
  } else if (char == ">") {
    scale([scale_x-2,scale_y,1]) linear_extrude(file=str(fnt_directory,"greaterthen.dxf"),height=height, convexity=10);
  } else if (char == "h") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"h-lower.dxf"),height=height, convexity=10);
  } else if (char == "H") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"H.dxf"),height=height, convexity=10);
  } else if (char == "i") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"i-lower.dxf"),height=height, convexity=10);
  } else if (char == "I") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"I.dxf"),height=height, convexity=10);
  } else if (char == "j") {
     translate([0,-2.5,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"j-lower.dxf"),height=height, convexity=10);
  } else if (char == "J") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"J.dxf"),height=height, convexity=10);
  } else if (char == "k") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"k-lower.dxf"),height=height, convexity=10);
  } else if (char == "K") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"K.dxf"),height=height, convexity=10);
  } else if (char == "l") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"l-lower.dxf"),height=height, convexity=10);
  } else if (char == "L") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"L.dxf"),height=height, convexity=10);
  } else if (char == "<") {
    scale([scale_x-2,scale_y,1]) linear_extrude(file=str(fnt_directory,"lessthen.dxf"),height=height, convexity=10);
  } else if (char == "m") {
    scale([scale_x-1,scale_y,1]) linear_extrude(file=str(fnt_directory,"m-lower.dxf"),height=height, convexity=10);
  } else if (char == "M") {
    scale([scale_x-1,scale_y,1]) linear_extrude(file=str(fnt_directory,"M.dxf"),height=height, convexity=10);
  } else if (char == "n") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"n-lower.dxf"),height=height, convexity=10);
  } else if (char == "N") {
    scale([scale_x-1,scale_y,1]) linear_extrude(file=str(fnt_directory,"N.dxf"),height=height, convexity=10);
  } else if (char == "o") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"o-lower.dxf"),height=height, convexity=10);
  } else if (char == "O") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"O.dxf"),height=height, convexity=10);
  } else if (char == "p") {
     translate([0,-2.5,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"p-lower.dxf"),height=height, convexity=10);
  } else if (char == "P") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"P.dxf"),height=height, convexity=10);
  } else if (char == "%") {
   scale([scale_x-1.75,scale_y,1]) linear_extrude(file=str(fnt_directory,"percent.dxf"),height=height, convexity=10);
  } else if (char == "q") {
     translate([0,-2.5,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"q-lower.dxf"),height=height, convexity=10);
  } else if (char == "Q") {
     translate([0,-0.5,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"Q.dxf"),height=height, convexity=10);
  } else if (char == "?") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"question.dxf"),height=height, convexity=10);
  } else if (char == "r") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"r-lower.dxf"),height=height, convexity=10);
  } else if (char == "R") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"R.dxf"),height=height, convexity=10);
  } else if (char == "s") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"s-lower.dxf"),height=height, convexity=10);
  } else if (char == "S") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"S.dxf"),height=height, convexity=10);
  } else if (char == "'") {
    translate([0,6,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"singlequote.dxf"),height=height, convexity=10);
  } else if (char == "t") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"t-lower.dxf"),height=height, convexity=10);
  } else if (char == "T") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"T.dxf"),height=height, convexity=10);
  } else if (char == "u") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"u-lower.dxf"),height=height, convexity=10);
  } else if (char == "U") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"U.dxf"),height=height, convexity=10);
  } else if (char == "v") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"v-lower.dxf"),height=height, convexity=10);
  } else if (char == "V") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"V.dxf"),height=height, convexity=10);
  } else if (char == "w") {
    scale([scale_x-1,scale_y,1]) linear_extrude(file=str(fnt_directory,"w-lower.dxf"),height=height, convexity=10);
  } else if (char == "W") {
    scale([scale_x-2,scale_y,1]) linear_extrude(file=str(fnt_directory,"W.dxf"),height=height, convexity=10);
  } else if (char == "x") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"x-lower.dxf"),height=height, convexity=10);
  } else if (char == "X") {
    scale([scale_x-1,scale_y,1]) linear_extrude(file=str(fnt_directory,"X.dxf"),height=height, convexity=10);
  } else if (char == "y") {
     translate([0,-2.5,1]) scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"y-lower.dxf"),height=height, convexity=10);
  } else if (char == "Y") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"Y.dxf"),height=height, convexity=10);
  } else if (char == "z") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"z-lower.dxf"),height=height, convexity=10);
  } else if (char == "Z") {
    scale([scale_x,scale_y,1]) linear_extrude(file=str(fnt_directory,"Z.dxf"),height=height, convexity=10);
  } else {
    echo ("Unknown charachter: ",char);
  }

}

module fnt_test() {
    fnt_str(["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y","Z"],26,1,2);

   translate([15,0,0]) fnt_str(["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"],26,1,2);

   translate([30,0,0]) fnt_str(["0","1","2","3","4","5","6","7","8","9","+","-",":",".",",","?","=","*","!","''","#","$","%","&","@","'"],26,1,2);
translate([45,0,0]) fnt_str(["(",")","<",">","[","]","/","\\","_","|"],10,1,2);
}
