#include <stdio.h>
#include <stdbool.h>
#ifndef DAY07
#define DAY07
#define BUFFER_SIZE 64
#define MAX_N 16
#endif

/*
    Credits: https://github.com/ishanpranav/advent-of-code-2024/blob/master/src/day07a.c
    I added it for testing purposes
*/

static bool main_step(
    long long x, 
    long long y, 
    int s[MAX_N], 
    unsigned int n) {
    if (n == 0)
        return x == y;
    else if (y > x)
        return false;
    else
        return main_step(x, y + s[0], s + 1, n - 1) ||
            main_step(x, y * s[0], s + 1, n - 1);
}

int main(int argc, char* argv[]) {
    long long sum = 0;
    char buffer[BUFFER_SIZE];

    FILE* fd = fopen(argv[1], "r");

    while (fgets(buffer, BUFFER_SIZE, fd)) {
        const char* line = buffer;
        int offset;
        long long x;

        if (sscanf(line, "%lld:%n", &x, &offset) != 1)
            continue;
        
        line += offset;

        int s[MAX_N];
        unsigned int n = 0;

        while (sscanf(line, "%d%n", s + n, &offset) == 1) {
            line += offset;
            n++;
        }

        if (main_step(x, 0, s, n)) sum += x;
    }

    printf("%lld\n", sum);
    return 0;
}
