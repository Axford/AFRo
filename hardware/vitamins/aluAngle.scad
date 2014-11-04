module aluAngle(w,h,l,t) {
	// stands vertically at origin (l extends in z+)
	// w in x+, h in y+
	
    vitamin(
        "vitamins/aluAngle.scad", 
        str("Aluminium Angle ",w,"x",h,"x",t,"mm ",l,"mm"), 
        str("aluAngle(",w,",",h,",",l,",",t,")")
    ) {
        view(t=[18, 26, 18], r=[171, 354, 87]);
    }
	
    color(alu_color)
        render()
		linear_extrude(l)
		union() {
			square([t,h]);
			square([w,t]);
		}
}