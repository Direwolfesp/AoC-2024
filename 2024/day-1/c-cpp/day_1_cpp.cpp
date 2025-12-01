#include <fstream>
#include <iostream>
#include <array>
#include <algorithm>

const int N_LINES = 1000;

int day_1(std::string_view path) {
    std::ifstream file(path.data());
    if (!file) {
        std::cerr << "Could not open file '" << path << "'\n";
        std::exit(1);
    }

    std::array<int, N_LINES> list_l;
    std::array<int, N_LINES> list_r;

    int l{}, r{}, i{};
    while (file >> l >> r) {
        list_l[i] = l;
        list_r[i] = r;
        i += 1;
    }

    std::sort(list_l.begin(), list_l.end());
    std::sort(list_r.begin(), list_r.end());

    int total = 0;
    for (int i = 0; i < N_LINES; i += 1) 
        total += std::abs(list_l[i] - list_r[i]);
    return total;
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        std::cerr << "Usage: ./day_1 <input>\n";
        return 1;
    }
    std::string path = argv[1];
    std::cout << day_1(path) << "\n";
}
