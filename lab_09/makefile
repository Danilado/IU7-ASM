CC := g++

INCPATH := ./inc/
SRCPATH := ./src/
OUTPATH := ./out/

$(shell mkdir -p $(OUTPATH))

SRCS := $(wildcard $(SRCPATH)*.c)
SRCS := $(SRCS:.c=.d)
SRCS := $(subst $(SRCPATH), $(OUTPATH), $(SRCS))

BUILDFLAGS := -lm -m64
CPPFLAGS := -std=c++20 -O0 -Wall -Wextra -Werror -I$(INCPATH) -masm=intel -m64 -fPIE -fno-inline #-DNO_TEST
DEBUGFLAGS := -O0 -g3

OBJECTS := $(OUTPATH)matrices.o

# release build part

.PHONY: debug
debug: debug.lastbuildstate | app.exe

# files
app.exe: $(OUTPATH)main.o $(OBJECTS)
	$(CC) $< $(OBJECTS) -o $@ $(BUILDFLAGS)

%.s: $(SRCPATH)%.cpp $(OBJECTS)
	$(CC) $(CPPFLAGS) -m80387 -DX87 -S -fverbose-asm $< $(OBJECTS) -o $@

%.dump: %.exe
	objdump -S --disassemble $< > $@

$(OUTPATH)%.o : */%.cpp
	$(CC) $(CPPFLAGS) -c $< -o $@

$(OUTPATH)lib%.a : $(OUTPATH)%.o
	ar cr $@ $<
	ranlib $@ 

$(OUTPATH)lib%.so : $(OUTPATH)%.o
	gcc -o $@ -shared $<

$(OUTPATH)%.d : */%.c
	$(CC) $(CPPFLAGS) -MM $< > $@

%.lastbuildstate: 
	make clean
	touch $@

.PHONY: clean
clean:
	rm -f ./*.exe ./out/* ./*.o ./*.gcov ./*.gcno ./*.gcda out.txt ./*.d ./*.lastbuildstate ./*.dump ./*.s

include $(SRCS)
