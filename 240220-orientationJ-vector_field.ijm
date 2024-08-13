// requires OrientationJ plugin

#@ File (label="Select file", style = "file") file
#@ File (label="Select output directory", style = "directory") output

BFopen(file);
img_name = File.nameWithoutExtension;

// the orientationJ kernel operates on a square grid; if the image in not square,
// and not devidable by the kernal size, one row at the edge will have weird results
// because an incomplete window was analyzed
makeRectangle(65, 7, 1274, 1274);
run("Crop");
if (img_name.matches(".*90deg.*")) {
    run("Rotate 90 Degrees Right");
}

// the orientation map is more or less continuous; the grid size determines what
// values are exported. the image dimensions have to be devidable by the grid size
// to not get corrupt values
// for 1274x1274: 1    2    7   13   14   26   49   91   98  182  637 1274
run("OrientationJ Vector Field", "tensor=10 gradient=0 radian=on " +
    "vectorgrid=49 vectorscale=80.0 vectortype=0 vectoroverlay=on vectortable=on ");

saveAs("Results", output + File.separator + img_name + ".csv");

// save image with vector field overlay
if (img_name.matches(".*90deg.*")) {
    run("Rotate 90 Degrees Left");
}
run("Size...", "width=700 height=642 depth=1 constrain average interpolation=Bilinear");
run("Enhance Contrast", "saturated=0.35");
run("RGB Color");
saveAs("PNG", output + File.separator + img_name +".png");

close(img_name + ".csv");
close("*");


function BFopen(file) { 
  // Open input using the bioformats importer
  run("Bio-Formats Importer", 
  "open=[" + file + 
  "] autoscale color_mode=Default rois_import=[ROI manager] specify_range" +
  " view=Hyperstack stack_order=XYCZT t_begin=1 t_end=1 c_begin=2 c_end=2 c_step=1");
}

//makeRectangle(65, 7, 600, 600);