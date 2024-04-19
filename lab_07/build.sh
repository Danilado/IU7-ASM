#!/bin/bash

g++ -c -masm=intel -fPIE main.cpp -o main.o
yasm -f elf64 main.nasm -o strcpyasm.o # yasm == nasm
g++ -fPIE main.o strcpyasm.o -o app.exe
