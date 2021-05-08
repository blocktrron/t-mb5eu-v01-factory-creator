
all: work/metadata_image.bin factory.bin

clean:
	rm -rf work/

work:
	mkdir -p work/

work/fwtool: work
	curl -o work/fwtool.tar.xz http://sources.openwrt.org/fwtool-2019-11-12-8f7fe925.tar.xz
	cd work && tar xf fwtool.tar.xz
	mkdir -p work/fwtool-2019-11-12-8f7fe925/build
	cd work/fwtool-2019-11-12-8f7fe925/build && cmake .. && cmake --build .
	mv work/fwtool-2019-11-12-8f7fe925/build/fwtool work/

work/metadata_image.bin: work/fwtool
	cp $(FIRMWARE_IMAGE) work/metadata_image.bin
	work/fwtool -I metadata.json work/metadata_image.bin

factory.bin: work
	bash create.sh work/metadata_image.bin

