CC:=gcc
CPP:=g++
CROSS_COMPILE:=

CFLAGS:=
LFLAGS:=

SRC:=$(shell find . -name "*.c")
SRC+=$(shell find . -name "*.cpp")
OBJ:=$(subst src/,obj/,$(SRC))
OBJ:=$(subst .cpp,.o,$(OBJ))
OBJ:=$(subst .c,.o,$(OBJ))

OUT:=out/main.elf
DIR:=$(sort $(dir $(OBJ))) $(sort $(dir $(OUT)))
INC:=-Iinc
LIB:=

all:$(DIR) $(OUT)

$(DIR):
	mkdir -p $@

$(OUT):$(OBJ)
	$(CROSS_COMPILE)$(CC) $(LFLAGS) $(OBJ) -o $(OUT) $(LIB)

obj/%.o: src/%.c
	$(CROSS_COMPILE)$(CC) $(CFLAGS) $(INC) -c -o $@ $<

obj/%.o: src/%.cpp
	$(CROSS_COMPILE)$(CPP) $(CFLAGS) $(INC) -c -o $@ $<

clean:
	rm -fr $(DIR)
