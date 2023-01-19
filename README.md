# ECW2Tiff
Dockerized gdal+ecw installation for converting ecw files to tiff.


## Usage
1. Build the image (`make build`)
2. Put the file you need to convert under `./data`.
3. Run `make raster input=some_file.ecw` to create `data/some_file.tiff`.

The image also has Python installed and configured for GDAL.

### TODO
GDAL installation fails on newer verions of Ubuntu