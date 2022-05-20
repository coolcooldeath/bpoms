#define _CRT_SECURE_NO_WARNINGS

#include <iostream>
#include <sstream>
#include <cstdio>
#include "../EllipticCurve.hpp"
#include "../NAF.hpp"
#include "NumeralConverter.hpp"

#define OUTPUT_SIZE 1000
#define EXTERNC extern "C"

using namespace std;

char outputX[OUTPUT_SIZE] = {};

char outputY[OUTPUT_SIZE] = {};

char* getOutputX() {
    return outputX;
}

char* getOutputY() {
    return outputY;
}

void setOutput(int x, int y) {
    memset(outputX, '\0', OUTPUT_SIZE);
    memset(outputY, '\0', OUTPUT_SIZE);

}

EXTERNC char* test() {
    return (char*)"test";
}

EXTERNC char* hexToDec(char* value) {
    NumeralConverter convM = NumeralConverter(NumeralConverter::NumSystem::HEX, value);
    return (char*)convM.ConvertValue(NumeralConverter::NumSystem::DEC).c_str();
}

EXTERNC char* decToHex(char* value) {
    if (strcmp(value, "0") == 0) {
        return (char*)"0";
    }
    else {
        NumeralConverter convM = NumeralConverter(NumeralConverter::NumSystem::DEC, value);
        return (char*)convM.ConvertValue(NumeralConverter::NumSystem::HEX).c_str();
    }
}

EXTERNC char* mult(
    char* cM, char* ca, char* cb,
    /*char* cpx, char* cpy,*/ char* cqx, char* cqy,
    char* cscalar) {
    NumeralConverter convM = NumeralConverter(NumeralConverter::NumSystem::HEX, cM);
    NumeralConverter conva = NumeralConverter(NumeralConverter::NumSystem::HEX, ca);
    NumeralConverter convb = NumeralConverter(NumeralConverter::NumSystem::HEX, cb);
    //NumeralConverter convpx = NumeralConverter(NumeralConverter::NumSystem::HEX, cpx);
    //NumeralConverter convpy = NumeralConverter(NumeralConverter::NumSystem::HEX, cpy);
    NumeralConverter convqx = NumeralConverter(NumeralConverter::NumSystem::HEX, cqx);
    NumeralConverter convqy = NumeralConverter(NumeralConverter::NumSystem::HEX, cqy);
    NumeralConverter convcscalar = NumeralConverter(NumeralConverter::NumSystem::HEX, cscalar);
    
    BigInteger
        M = BigInteger(convM.ConvertValue(NumeralConverter::NumSystem::DEC)),
        a = BigInteger(conva.ConvertValue(NumeralConverter::NumSystem::DEC)),
        b = BigInteger(convb.ConvertValue(NumeralConverter::NumSystem::DEC)),
        //px = BigInteger(convpx.ConvertValue(NumeralConverter::NumSystem::DEC)),
        //py = BigInteger(convpy.ConvertValue(NumeralConverter::NumSystem::DEC)),
        qx = BigInteger(convqx.ConvertValue(NumeralConverter::NumSystem::DEC)),
        qy = BigInteger(convqy.ConvertValue(NumeralConverter::NumSystem::DEC)),
        scalar = BigInteger(convcscalar.ConvertValue(NumeralConverter::NumSystem::DEC));
    EllipticCurve ec(a, b, M);
    Point Q(qx, qy);

    //cout << "values: " << M << " " << a << " " << b << " " << qx << " " << qy << " " << scalar << endl;

    stringstream x;
    stringstream y;
    char time[100] = {};
    Point R = ec.scalarMultiply(scalar, Q, time);
    x << R.getX();
    y << R.getY();

    char result[10000] = {};
    sprintf(
        result,
        "{\"x\":\"%s\", \"y\":\"%s\", \"time\":\"%s\"}",
        NumeralConverter(NumeralConverter::NumSystem::DEC, x.str().c_str())
            .ConvertValue(NumeralConverter::NumSystem::HEX).c_str(),
        NumeralConverter(NumeralConverter::NumSystem::DEC, y.str().c_str())
            .ConvertValue(NumeralConverter::NumSystem::HEX).c_str(),
        time);
    return result;
}

EXTERNC char* multDec(
    char* cM, char* ca, char* cb,
    /*char* cpx, char* cpy,*/ char* cqx, char* cqy,
    char* cscalar) {
    
    BigInteger
        M = BigInteger(cM),
        a = BigInteger(ca),
        b = BigInteger(cb),
        //px = BigInteger(convpx.ConvertValue(NumeralConverter::NumSystem::DEC)),
        //py = BigInteger(convpy.ConvertValue(NumeralConverter::NumSystem::DEC)),
        qx = BigInteger(cqx),
        qy = BigInteger(cqy),
        scalar = BigInteger(cscalar);
    EllipticCurve ec(a, b, M);
    Point Q(qx, qy);

    //cout << "values: " << M << " " << a << " " << b << " " << qx << " " << qy << " " << scalar << endl;

    stringstream x;
    stringstream y;
    char time[100] = {};
    Point R = ec.scalarMultiply(scalar, Q, time);
    x << R.getX();
    y << R.getY();

    char result[10000] = {};
    sprintf(
        result,
        "{\"x\":\"%s\", \"y\":\"%s\", \"time\":\"%s\"}",
        x.str().c_str(), y.str().c_str(), time);
    return result;
}

char* getR(
    int M, int a, int b,
    int px, int py, int qx, int qy,
    int scalar) {

    EllipticCurve ec(a, b, M);
    Point P(px, py);
    Point Q(qx, qy);

    stringstream buffer;
    Point R = ec.add(P, Q);
    return outputX;
}


int main() {
    //
    //cout <<
    //    mult(
    //        (char*)"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF43",
    //        (char*)"FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF40",
    //        (char*)"77CE6C1515F3A8EDD2C13AABE4D8FBBE4CF55069978B9253B22E7D6BD69C03F1",
    //        (char*)"0",
    //        (char*)"6BF7FC3CFB16D69F5CE4C9A351D6835D78913966C408F6521E29CF1804516A93",
    //        (char*)"69E273C25F23790C9E423207ED1F283418F2749C32F033456739734BB8B5661F") <<
    //    endl;

    return 0;
}