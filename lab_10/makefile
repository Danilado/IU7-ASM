CFLAGS := -I/usr/include/gtk-3.0 -I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -I/usr/include/pango-1.0/ -I/usr/include/harfbuzz/
CFLAGS += -I/usr/include/cairo -I/usr/include/gdk-pixbuf-2.0/ -I/usr/include/atk-1.0

MYLDFLAGS = -m elf_x86_64 -lc --dynamic-linker /lib/ld-linux-x86-64.so.2
PKGCONF = `pkg-config --libs gtk+-3.0`

app.exe: main.o
	ld -o $@ $(MYLDFLAGS) $< $(PKGCONF)
# gcc $^ -L/usr/lib/ $$(pkg-config --libs gtk+-3.0) -o $@ -no-pie

%.o: %.nasm
	nasm -f elf64 -o $@ $<

.PHONY: clean
clean:
	rm -f ./*.o ./*.exe