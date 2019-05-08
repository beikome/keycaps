//$fs = 1;
//$fa = 3;
$fs = 0.1;
$fa = 2;
PI = 3.1415926;

// Stem {{{
module cherry_stem(stem_height) {
    stem_outer_size = 5.5;
    stem_cross_length = 4.0;
    stem_cross_h = 1.25;
    stem_cross_v = 1.10;

    difference() {
        cylinder(d = stem_outer_size, h = stem_height);
        // cross part
        translate([- stem_cross_h / 2, - stem_cross_length / 2, 0]) {
            cube([stem_cross_h, stem_cross_length, stem_height]);
        }
        translate([- stem_cross_length / 2, - stem_cross_v / 2, 0]) {
            cube([stem_cross_length, stem_cross_v, stem_height]);
        }
    }
}
// }}}

// keycap outer shape {{{
module keycap_dish(key_top_size, key_top_size, dish_depth) {
     // spherical top
    translate([0, 0, key_top_height + dish_r(key_top_size * sqrt(2), dish_depth) - dish_depth]) {
        sphere(dish_r(key_top_size * sqrt(2), dish_depth));
    }
}

module keycap_round_base(key_bottom_size, key_top_size, key_top_height, r) {
    n = 20;

    // calculate x, y
    a = key_bottom_size;
    b = key_top_size;
    c = key_top_height;
    y = (c * c + (a - b) * (a - b)) / (2 * (a - b));
    x = asin(c / y);

    hull() {
        for (i = [0 : n]) {
            translate([0, 0, y * sin(x * i / n) ]) {
                d = a - y * (1 - cos(i * x / n));
                rounded_cube([d, d, 0.01], r * i / n);
            }
        }
    }
}

module keycap_outer_shape(key_bottom_size, key_top_size, key_top_height, r, dish_depth) {
    if(dish_depth == 0) {
        keycap_round_base(key_bottom_size, key_top_size, key_top_height, r);
    } else {
        difference() {
            keycap_round_base(key_bottom_size, key_top_size, key_top_height, r);
            keycap_dish(key_top_size, key_top_height, dish_depth);
        }
    }
}

// }}}

// utils {{{
module rounded_cube(size, r) {
    h = 0.0001;
    minkowski() {
        cube([size[0] - r * 2, size[1] - r * 2, size[2] - h], center = true);
        cylinder(r = r, h = h);
    }
}

function dish_r(w, d) = (w * w + 4 * d * d) / (8 * d);

// }}}

// high level modules {{{
module keycap(key_bottom_size, key_top_size, key_top_height, r=3, dish_depth=1) {
    key_inner_height = 5;
    thickness = 1.5;
    // stem
    cherry_stem(key_inner_height);

    // keycap shape
    difference() {
        keycap_outer_shape(key_bottom_size, key_top_size, key_top_height, r, dish_depth);
        keycap_outer_shape(key_bottom_size - 2 * thickness, key_top_size, key_inner_height, r, 0);
    }
}
// }}}

// main {{{
key_bottom_size = 18;
key_top_size = 14;
key_top_height = 14;
stem_height = 5;

keycap(key_bottom_size, key_top_size, key_top_height);

// }}}
