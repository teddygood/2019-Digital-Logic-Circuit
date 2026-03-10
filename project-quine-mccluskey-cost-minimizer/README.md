# Quine-McCluskey Cost Minimizer

2019 디지털논리회로 과제용 SOP 최소화 프로그램이다.

## Files

- `QuineMcCluskey.cpp`: 제출용 소스 코드
- `input_minterm.txt`: 기본 입력 예제
- `result.txt`: 실행 결과 예제
- `examples/assignment_sample.txt`: 과제 예제 입력
- `examples/hard_case.txt`: 추가 확인용 입력
- `examples/all_true_5bit.txt`: 경계 사례 입력

## Build

```bash
g++ -std=c++17 -O2 QuineMcCluskey.cpp -o quine
./quine
```

다른 입출력 파일을 사용하려면:

```bash
./quine custom_input.txt custom_result.txt
```

## Input Format

- first line: bit length
- following lines: `m 0101` or `d 1100`
- `m` is a minterm
- `d` is a don't care term

## Output Format

선택된 implicant를 한 줄씩 출력한 뒤 마지막 줄에 비용을 출력한다.

```text
01--
1-01
1010
Cost (# of transistors): 40
```
