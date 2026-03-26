# Quine-McCluskey Cost Minimizer

An SOP minimization program created for the 2019 Digital Logic Circuit assignment.

## Files

- `QuineMcCluskey.cpp`: source code for submission
- `input_minterm.txt`: default input example
- `result.txt`: example output
- `examples/assignment_sample.txt`: assignment sample input
- `examples/hard_case.txt`: additional verification input
- `examples/all_true_5bit.txt`: edge case input

## Build

```bash
g++ -std=c++17 -O2 QuineMcCluskey.cpp -o quine
./quine
```

To use different input and output files:

```bash
./quine custom_input.txt custom_result.txt
```

## Input Format

- first line: bit length
- following lines: `m 0101` or `d 1100`
- `m` is a minterm
- `d` is a don't care term

## Output Format

The program prints each selected implicant on its own line and prints the final cost on the last line.

```text
01--
1-01
1010
Cost (# of transistors): 40
```
