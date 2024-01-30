IMAGE ?= ecw2tif:v0.0.2
INPUT ?= ./input
OUTPUT_DIR ?= ./output


build:
	docker build -t ${IMAGE} .

convert:
	@total_files=$$(find $(INPUT) -type f | wc -l) ; \
	current_file=0 ; \
	find $(INPUT) -type f -name "*.ecw" | while read file; do \
		current_file=$$((current_file + 1)) ; \
		echo "Converting file $$current_file/$$total_files: $$(basename $$file)" ; \
		mkdir -p $(OUTPUT_DIR) ; \
		docker run --rm \
		    -u $$(id -u):$$(id -g) \
			-v "$$(realpath $$(dirname "$$file")):/input" \
			-v "$$(realpath $(OUTPUT_DIR)):/output" \
			${IMAGE} \
			gdal_translate -of "GTiff" "/input/$$(basename $$file)" "/output/$$(basename "$$file" .ecw).tiff"; \
	done

PHONY: build convert