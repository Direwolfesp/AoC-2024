#include <cstddef>
#include <iostream>
#include <fstream>
#include <string>
#include <utility>
#include <vector>
#include <algorithm>

std::pair<int, int> split_line(const std::string& line)
{
    size_t space_beg = line.find_first_of(' ');
    size_t space_end = line.find_last_of(' ');
    return {std::stoi(line.substr(0, space_beg)), std::stoi(line.substr(space_end + 1))};
}

int part_a(const char* filepath)
{
    std::fstream file(filepath);
    std::string line;

    std::vector<int> list_l;
    std::vector<int> list_r;
    int n_count = 0;

    while (std::getline(file, line))
    {
        auto [left, right] = split_line(line);
        list_l.push_back(left);
        list_r.push_back(right);
        n_count++;
    }

    std::sort(list_l.begin(), list_l.end());
    std::sort(list_r.begin(), list_r.end());
    int total = 0;

    for (int i = 0; i < n_count; i++)
    {
        total += std::abs(list_l[i] - list_r[i]);
    }

    return total;
}

int main(int argc, char* argv[])
{
    if (argc != 2)
    {
        std::cerr << "[!] missing filepath\n";
        return 1;
    }

    std::cout << "> " << part_a(argv[1]) << '\n';

    return 0;
}
