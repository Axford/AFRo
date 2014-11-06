module ThreadedRod(od,l) {
    // stands vertically at origin

    vitamin(
        "vitamins/ThreadedRod.scad",
        str("Threaded Rod M",od," x ",round(l),"mm"),
        str("ThreadedRod(",od,",",l,")")
    ) {
        view(t=[16,14,5], r=[168, 352, 90]);
    }

    color([0.7,0.7,0.7])
        cylinder(r=od/2, h=l);
}
