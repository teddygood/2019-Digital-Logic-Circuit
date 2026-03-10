#include <algorithm>
#include <cctype>
#include <fstream>
#include <iostream>
#include <map>
#include <set>
#include <sstream>
#include <stdexcept>
#include <string>
#include <utility>
#include <vector>

struct InputRecord {
    char kind;
    std::string bits;
};

struct Implicant {
    std::string pattern;
    std::vector<int> coveredMinterms;
};

namespace {

std::string trim(const std::string& text) {
    std::size_t start = 0;
    while (start < text.size() && std::isspace(static_cast<unsigned char>(text[start]))) {
        ++start;
    }

    std::size_t end = text.size();
    while (end > start && std::isspace(static_cast<unsigned char>(text[end - 1]))) {
        --end;
    }

    return text.substr(start, end - start);
}

std::string stripComment(const std::string& line) {
    const std::size_t commentPos = line.find("//");
    return commentPos == std::string::npos ? line : line.substr(0, commentPos);
}

int countOnes(const std::string& pattern) {
    return static_cast<int>(std::count(pattern.begin(), pattern.end(), '1'));
}

int literalCount(const std::string& pattern) {
    return static_cast<int>(std::count_if(pattern.begin(), pattern.end(), [](char ch) {
        return ch == '0' || ch == '1';
    }));
}

bool isSubset(const std::vector<int>& left, const std::vector<int>& right) {
    return std::includes(right.begin(), right.end(), left.begin(), left.end());
}

void mergeInto(std::vector<int>& target, const std::vector<int>& source) {
    if (source.empty()) {
        return;
    }
    if (target.empty()) {
        target = source;
        return;
    }

    std::vector<int> merged;
    merged.reserve(target.size() + source.size());
    std::set_union(
        target.begin(), target.end(),
        source.begin(), source.end(),
        std::back_inserter(merged)
    );
    target.swap(merged);
}

bool covers(const std::string& pattern, const std::string& minterm) {
    for (std::size_t i = 0; i < pattern.size(); ++i) {
        if (pattern[i] == '-') {
            continue;
        }
        if (pattern[i] != minterm[i]) {
            return false;
        }
    }
    return true;
}

bool canCombine(const std::string& left, const std::string& right, std::string& combined) {
    int diffCount = 0;
    std::size_t diffIndex = 0;

    for (std::size_t i = 0; i < left.size(); ++i) {
        if (left[i] == right[i]) {
            continue;
        }
        if (left[i] == '-' || right[i] == '-') {
            return false;
        }
        ++diffCount;
        diffIndex = i;
        if (diffCount > 1) {
            return false;
        }
    }

    if (diffCount != 1) {
        return false;
    }

    combined = left;
    combined[diffIndex] = '-';
    return true;
}

std::vector<Implicant> buildImplicants(const std::map<std::string, std::vector<int>>& mergedPatterns) {
    std::vector<Implicant> implicants;
    implicants.reserve(mergedPatterns.size());
    for (const auto& [pattern, covered] : mergedPatterns) {
        implicants.push_back({pattern, covered});
    }

    std::sort(implicants.begin(), implicants.end(), [](const Implicant& a, const Implicant& b) {
        const int aOnes = countOnes(a.pattern);
        const int bOnes = countOnes(b.pattern);
        if (aOnes != bOnes) {
            return aOnes < bOnes;
        }
        return a.pattern < b.pattern;
    });
    return implicants;
}

std::vector<Implicant> generatePrimeImplicants(const std::vector<Implicant>& initialTerms) {
    std::vector<Implicant> current = initialTerms;
    std::map<std::string, std::vector<int>> primeMap;

    while (!current.empty()) {
        std::vector<bool> used(current.size(), false);
        std::map<std::string, std::vector<int>> nextMap;

        // Combine terms that differ in exactly one bit and carry forward the union of covered minterms.
        for (std::size_t i = 0; i < current.size(); ++i) {
            for (std::size_t j = i + 1; j < current.size(); ++j) {
                std::string combined;
                if (!canCombine(current[i].pattern, current[j].pattern, combined)) {
                    continue;
                }

                used[i] = true;
                used[j] = true;

                std::vector<int> mergedCoverage = current[i].coveredMinterms;
                mergeInto(mergedCoverage, current[j].coveredMinterms);
                mergeInto(nextMap[combined], mergedCoverage);
            }
        }

        for (std::size_t i = 0; i < current.size(); ++i) {
            if (!used[i] && !current[i].coveredMinterms.empty()) {
                mergeInto(primeMap[current[i].pattern], current[i].coveredMinterms);
            }
        }

        if (nextMap.empty()) {
            break;
        }

        current = buildImplicants(nextMap);
    }

    return buildImplicants(primeMap);
}

std::vector<std::vector<int>> pruneProducts(std::vector<std::vector<int>> candidates) {
    for (auto& candidate : candidates) {
        std::sort(candidate.begin(), candidate.end());
        candidate.erase(std::unique(candidate.begin(), candidate.end()), candidate.end());
    }

    std::sort(candidates.begin(), candidates.end(), [](const std::vector<int>& a, const std::vector<int>& b) {
        if (a.size() != b.size()) {
            return a.size() < b.size();
        }
        return a < b;
    });

    candidates.erase(std::unique(candidates.begin(), candidates.end()), candidates.end());

    std::vector<std::vector<int>> pruned;
    for (const auto& candidate : candidates) {
        bool absorbed = false;
        for (const auto& kept : pruned) {
            if (isSubset(kept, candidate)) {
                absorbed = true;
                break;
            }
        }
        if (!absorbed) {
            pruned.push_back(candidate);
        }
    }
    return pruned;
}

int computeCost(const std::vector<std::string>& terms) {
    if (terms.empty()) {
        return 0;
    }

    // The assignment measures transistor count as inverter cost + AND plane cost + OR plane cost.
    std::vector<bool> negated(terms.front().size(), false);
    int andCost = 0;

    for (const auto& term : terms) {
        for (std::size_t i = 0; i < term.size(); ++i) {
            if (term[i] == '0') {
                negated[i] = true;
            }
        }

        const int literals = literalCount(term);
        if (literals >= 2) {
            andCost += (2 * literals) + 2;
        }
    }

    const int inverterCost = 2 * static_cast<int>(std::count(negated.begin(), negated.end(), true));
    const int orCost = terms.size() >= 2 ? (2 * static_cast<int>(terms.size())) + 2 : 0;
    return inverterCost + andCost + orCost;
}

std::vector<std::string> materializeTerms(
    const std::vector<Implicant>& primes,
    const std::vector<int>& selectedIndices
) {
    std::vector<std::string> terms;
    terms.reserve(selectedIndices.size());
    for (int index : selectedIndices) {
        terms.push_back(primes[index].pattern);
    }
    std::sort(terms.begin(), terms.end());
    terms.erase(std::unique(terms.begin(), terms.end()), terms.end());
    return terms;
}

std::vector<int> chooseBestCover(
    const std::vector<Implicant>& primes,
    int mintermCount
) {
    const int primeCount = static_cast<int>(primes.size());
    std::vector<std::vector<int>> coveringPrimes(mintermCount);

    for (int i = 0; i < primeCount; ++i) {
        for (int mintermIndex : primes[i].coveredMinterms) {
            coveringPrimes[mintermIndex].push_back(i);
        }
    }

    std::vector<bool> selected(primeCount, false);
    std::vector<bool> covered(mintermCount, false);
    bool changed = true;

    // First pick essential prime implicants before expanding the remaining choices with Petrick's method.
    while (changed) {
        changed = false;
        for (int minterm = 0; minterm < mintermCount; ++minterm) {
            if (covered[minterm]) {
                continue;
            }

            std::vector<int> candidates;
            for (int primeIndex : coveringPrimes[minterm]) {
                if (!selected[primeIndex]) {
                    candidates.push_back(primeIndex);
                }
            }

            if (candidates.empty()) {
                throw std::runtime_error("A minterm is not covered by any prime implicant.");
            }

            if (candidates.size() == 1) {
                const int onlyPrime = candidates.front();
                if (!selected[onlyPrime]) {
                    selected[onlyPrime] = true;
                    changed = true;
                    for (int coveredIndex : primes[onlyPrime].coveredMinterms) {
                        covered[coveredIndex] = true;
                    }
                }
            }
        }
    }

    std::vector<int> essentialIndices;
    for (int i = 0; i < primeCount; ++i) {
        if (selected[i]) {
            essentialIndices.push_back(i);
        }
    }

    std::vector<int> remainingMinterms;
    for (int minterm = 0; minterm < mintermCount; ++minterm) {
        if (!covered[minterm]) {
            remainingMinterms.push_back(minterm);
        }
    }

    std::vector<std::vector<int>> product(1);
    for (int minterm : remainingMinterms) {
        std::vector<std::vector<int>> nextProduct;
        for (const auto& term : product) {
            for (int primeIndex : coveringPrimes[minterm]) {
                if (selected[primeIndex]) {
                    continue;
                }
                auto expanded = term;
                expanded.push_back(primeIndex);
                nextProduct.push_back(std::move(expanded));
            }
        }

        if (nextProduct.empty()) {
            throw std::runtime_error("Petrick expansion failed because a remaining minterm has no candidate.");
        }

        product = pruneProducts(std::move(nextProduct));
    }

    if (remainingMinterms.empty()) {
        product = {{}};
    }

    int bestCost = -1;
    std::vector<std::string> bestTerms;
    std::vector<int> bestSelection;

    for (const auto& extra : product) {
        std::vector<int> mergedSelection = essentialIndices;
        mergedSelection.insert(mergedSelection.end(), extra.begin(), extra.end());
        std::sort(mergedSelection.begin(), mergedSelection.end());
        mergedSelection.erase(std::unique(mergedSelection.begin(), mergedSelection.end()), mergedSelection.end());

        const std::vector<std::string> terms = materializeTerms(primes, mergedSelection);
        const int cost = computeCost(terms);

        if (bestCost == -1 || cost < bestCost ||
            (cost == bestCost && terms.size() < bestTerms.size()) ||
            (cost == bestCost && terms.size() == bestTerms.size() && terms < bestTerms)) {
            bestCost = cost;
            bestTerms = terms;
            bestSelection = mergedSelection;
        }
    }

    return bestSelection;
}

std::vector<InputRecord> parseInput(const std::string& inputPath, int& bitLength) {
    std::ifstream input(inputPath);
    if (!input) {
        throw std::runtime_error("Failed to open input file: " + inputPath);
    }

    std::string line;
    bool readBitLength = false;
    std::map<std::string, char> deduplicated;

    while (std::getline(input, line)) {
        line = trim(stripComment(line));
        if (line.empty()) {
            continue;
        }

        if (!readBitLength) {
            // The first payload line declares the width used by every minterm and don't-care pattern.
            std::stringstream parser(line);
            if (!(parser >> bitLength) || bitLength <= 0) {
                throw std::runtime_error("The first non-empty line must be a positive bit length.");
            }
            readBitLength = true;
            continue;
        }

        std::stringstream parser(line);
        std::string kindToken;
        std::string bits;
        if (!(parser >> kindToken >> bits)) {
            throw std::runtime_error("Each term line must have the form '<m|d> <binary>'.");
        }

        if (kindToken.size() != 1) {
            throw std::runtime_error("The term kind must be exactly one character: 'm' or 'd'.");
        }

        const char kind = static_cast<char>(std::tolower(static_cast<unsigned char>(kindToken[0])));
        if (kind != 'm' && kind != 'd') {
            throw std::runtime_error("The term kind must be 'm' or 'd'.");
        }

        if (static_cast<int>(bits.size()) != bitLength) {
            throw std::runtime_error("All binary strings must match the declared bit length.");
        }

        for (char ch : bits) {
            if (ch != '0' && ch != '1') {
                throw std::runtime_error("Binary strings may contain only '0' and '1'.");
            }
        }

        auto found = deduplicated.find(bits);
        if (found == deduplicated.end()) {
            deduplicated.emplace(bits, kind);
        } else if (found->second == 'd' && kind == 'm') {
            found->second = 'm';
        }
    }

    if (!readBitLength) {
        throw std::runtime_error("The input file is empty.");
    }

    std::vector<InputRecord> records;
    records.reserve(deduplicated.size());
    for (const auto& [bits, kind] : deduplicated) {
        records.push_back({kind, bits});
    }
    std::sort(records.begin(), records.end(), [](const InputRecord& a, const InputRecord& b) {
        if (a.kind != b.kind) {
            return a.kind < b.kind;
        }
        return a.bits < b.bits;
    });
    return records;
}

}  // namespace

int main(int argc, char* argv[]) {
    const std::string inputPath = argc >= 2 ? argv[1] : "input_minterm.txt";
    const std::string outputPath = argc >= 3 ? argv[2] : "result.txt";

    if (argc > 3) {
        std::cerr << "Usage: " << argv[0] << " [input_minterm.txt] [result.txt]\n";
        return 1;
    }

    try {
        int bitLength = 0;
        const std::vector<InputRecord> records = parseInput(inputPath, bitLength);

        std::vector<std::string> minterms;
        std::map<std::string, int> mintermIndex;
        for (const auto& record : records) {
            if (record.kind == 'm') {
                mintermIndex[record.bits] = static_cast<int>(minterms.size());
                minterms.push_back(record.bits);
            }
        }

        std::vector<Implicant> initialTerms;
        initialTerms.reserve(records.size());
        for (const auto& record : records) {
            std::vector<int> covered;
            if (record.kind == 'm') {
                covered.push_back(mintermIndex.at(record.bits));
            }
            initialTerms.push_back({record.bits, covered});
        }

        const std::vector<Implicant> primes = generatePrimeImplicants(initialTerms);
        const std::vector<int> selectedIndices = chooseBestCover(primes, static_cast<int>(minterms.size()));
        const std::vector<std::string> selectedTerms = materializeTerms(primes, selectedIndices);
        const int totalCost = computeCost(selectedTerms);

        std::ofstream output(outputPath);
        if (!output) {
            throw std::runtime_error("Failed to open output file: " + outputPath);
        }

        for (const auto& term : selectedTerms) {
            output << term << '\n';
        }
        if (!selectedTerms.empty()) {
            output << '\n';
        }
        output << "Cost (# of transistors): " << totalCost << '\n';

        std::cout << "Wrote minimized SOP to " << outputPath << '\n';
        std::cout << "Prime implicants: " << primes.size() << ", selected terms: " << selectedTerms.size() << '\n';
        std::cout << "Bit length: " << bitLength << '\n';
        return 0;
    } catch (const std::exception& error) {
        std::cerr << "ERROR: " << error.what() << '\n';
        return 1;
    }
}
