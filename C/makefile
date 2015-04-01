SOURCE_FOLDER = src
FLAGS = -Wall -pedantic
BUILDS = build/main.o 
BIN = FitBreak

all: $(BIN) $(BUILDS)

clean:
	@rm -rf build/* log tmp $(BIN)

$(BIN): $(BUILDS)
	@echo -n "Compiling FitBreak...\n"
	@gcc $(BUILDS) -o $(BIN) $(FLAGS)
	
build/main.o: $(SOURCE_FOLDER)/main.c
	@echo -n "Compiling main.c..."
	@mkdir -p tmp
	@mkdir -p log
	@gcc -c $(SOURCE_FOLDER)/main.c -o build/main.o $(FLAGS) 2>./log/main.log||touch ./tmp/main.err
	@if test -e ./tmp/main.err;then tput setaf 1; echo "[ERROR]";elif test -s ./log/main.log;then tput setaf 3;echo "[WARNING]";else tput setaf 2; echo "[OK]";fi;
	@tput sgr0;
