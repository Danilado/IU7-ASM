# Как найти пароль в файле?

# ПАРОЛЬ ОТ ФАЙЛА "crackmes.one"

## Решение для x64dbg или IDAfree на Windows [тут](https://reverse-the-planet.blogspot.com/2022/03/mohammadali-very-easy-very-simple-c-code.html)

## Решение для Linux

#### Что установить

1. Поставить wine, потому что файл скомпилен под винду

2. Поставить IDAfree с VPN

3. Поставить Ghidra

#### Что делать

Запускаем ghidra

Создаём новый проект

Добавляем в него файлик crackme.exe

Жмаем пкм > open with > code browser 
![](./img/screenshot1.png)

Когда предлагает проанализировать файл, нажимаем анализировать, видим что-то типа

![](./img/screenshot2.png)

Справа видим код, в нём есть scanf - считывание строки, есть strcmp - сравнение оной с чем-то

Нас интересует то, с чем оно сравнивает - это токен local28, который был проинициализировань чуть ранее

![](./img/screenshot3.png)
![](./img/screenshot4.png)

Видим адрес 0x73736170

Открываем crackme.exe в IDAfree

**ВЫБИРАЕМ АНАЛИЗ И ДЕКОМПИЛЯЦИЮ 8086**

находим +- то же место, клацаем на адрес

![](./img/screenshot5.png)

Заходим в hex view и видим пароль, раздробленный на разные кусочки

![](./img/screenshot6.png)

password123
