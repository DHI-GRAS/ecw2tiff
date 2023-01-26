# ECW2Tiff
Dockerized GDAL installation with ECW support.

## Convert ECW to GeoTIFF:
1. Build the image (`make build`)
2. Put the file you need to convert under `./data/my_file.ecw`.
3. Run `make raster input=my_file.ecw` to create `data/my_file.tiff`.

It is also configured for Python 3.10, so you can extend the image and use it as a base for your Python projects.