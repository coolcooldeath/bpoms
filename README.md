# bpoms
Лабораторные по безопасности
Компиляция проекта
Используется программное средство Enscription.
emcc EC/Project1/*.cpp EC/BigInteger.cpp EC/EllipticCurve.cpp EC/point.cpp -O3 -s WASM=1 \ - описание того какие файлы будут компилироваться, плюс в какой формат собирается
-s EXPORTED_FUNCTIONS="['_test', '_mult', '_multDec', '_decToHex', '_hexToDec']" \ - экспортируемые функции
-s EXPORTED_RUNTIME_METHODS="['ccall','cwrap']" \ - вызов функции через ccall
-o my_example/EC.html \ - во что собирается
--shell-file assets/shell_minimal.html \ - шаблон сборки
-s ERROR_ON_UNDEFINED_SYMBOLS=0 -s ASSERTIONS=1 - системные настройки 


Стандарт описан здесь - http://apmi.bsu.by/assets/files/std/bign-spec29.pdf - СТБ 34.101.45-2013

В стандарте все числа в шестандцатеричной СС даны в формате LITTLE Endian, а программа работает с числами в формате BIG Endian
Для запуска обязательно нужно использовать сервер. 
Использование формата чисел NAF (Non-adjacent form) для ускорения обработки числовых данных.
Структура проекта :
BigInteger.cpp - библиотечный код для работы с большими числами;
EllipticCurve.cpp - основной класс для работы с элл. кривыми; определены методы сложения, умножения кривой в разных форматах;
NumberTheory.cpp - вспомогательный модуль для нахождения обратного и деление в кольце;
point.cpp - класс точки используемой в программе;
NumeralConverter.cpp - конвертация в различные системы исчисления;
Source.cpp - точка входа программного модуля;
