#include <stdio.h>
#include <stdlib.h>

void split_line(char* line, int* num_l, int* num_r)
{
    char* c = line;
    while(*(c++) != ' ');
    *c = 0;
    while (*(c++) == ' ');
    char* word_r = c;
    while(*(c++));
    *c = 0;

    *num_l = atoi(line);
    *num_r = atoi(word_r);
}

int minus(const void* a, const void* b)
{
    return *(int*)b - *(int*)a;
}

int part_a(const char* filepath)
{
    FILE* file = fopen(filepath, "r");

    if (!file)
    {
        printf("[!] failed to open %s\n", filepath);
        exit(2);
    }

    char line_buf[256];
    int n_lines = 0;
    int list_l[1000];
    int list_r[1000];

    while (fgets(line_buf, sizeof(line_buf), file) && n_lines < 1000)
    {
        split_line(line_buf, &list_l[n_lines], &list_r[n_lines]);
        // printf("> (%d,%d)\n", num_l, num_r);
        n_lines++;
    }

    qsort(list_l, n_lines, sizeof(int), minus);
    qsort(list_r, n_lines, sizeof(int), minus);
    int total = 0;

    for (int i = 0; i < n_lines; i++)
    {
        total += abs(list_r[i] - list_l[i]);
    }

    fclose(file);

    return total;
}

int main(int argc, char* argv[])
{
    if (argc != 2)
    {
        printf("[!] missing filepath\n");
        exit(1);
    }

    printf("> %d\n", part_a(argv[1]));

    return 0;
}
