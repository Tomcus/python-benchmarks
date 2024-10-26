import random

MATRIX_SIZE = 512 
MULTIPLICATION_COUNT = 1
MIN_VALUE = -100_000
MAX_VALUE = 100_000

def generate_matrix():
    res = [[0 for _ in range(MATRIX_SIZE)] for _ in range(MATRIX_SIZE)]
    for x in range(MATRIX_SIZE):
        for y in range(MATRIX_SIZE):
            res[x][y] = random.randint(MIN_VALUE, MAX_VALUE)
    return res

def mat_mul(a, b):
    res = [[0 for _ in range(MATRIX_SIZE)] for _ in range(MATRIX_SIZE)]
    for x in range(MATRIX_SIZE):
        for y in range(MATRIX_SIZE):
            value = 0
            for z in range(MATRIX_SIZE):
                value += a[z][y] * b[x][z]
            res[x][y] = value
    return res

for _ in range(MULTIPLICATION_COUNT):
    res = mat_mul(generate_matrix(), generate_matrix())
