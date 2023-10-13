#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>
#include "signal_library.h"

// Function to compare two float vectors with a tolerance
bool compareFloatArrays(float array1[], float array2[], int size, float tolerance) {
    for (int i = 0; i < size; i++) {
        if (fabs(array1[i] - array2[i]) > tolerance) {
            return false;
        }
    }
    return true;
}

int main() {
    float arrayToCompare[] = {1.0, 2.0, 3.0, 4.0, 5.0};
    float arrays[][5] = {
        {1.1, 2.1, 2.9, 4.0, 5.0},
        {5.0, 3.9, 3.0, 2.1, 1.1},
        {1.2, 2.2, 3.2, 4.2, 5.2},
        {0.0, 0.0, 0.0, 0.0, 0.0}
    };

    int numArrays = sizeof(arrays) / sizeof(arrays[0]);
    float tolerance = 0.2; // Adjust the tolerance as needed

    for (int i = 0; i < numArrays; i++) {
        if (compareFloatArrays(arrayToCompare, arrays[i], 5, tolerance)) {
            printf("Array %d matches the array to compare.\n", i);
        } else {
            printf("Array %d does not match the array to compare.\n", i);
        }
    }

    return(EXIT_SUCCESS);
}
