IMAGE = ecw2tif
TAG = v0.0.1
output ?= $(input:.ecw=.tiff)


build:
	docker build -t ${IMAGE}:${TAG} .

raster:
	docker run --rm -v ${PWD}/data:/data ${IMAGE}:${TAG} gdal_translate -of "GTiff" /data/${input} /data/${output}

.PHONY: build raster
