/*
 * SKELETON.C --Unit tests for skeleton.
 *
 *
 */
#include <string.h>

#include <tap.h>
#include <skeleton.h>

int vector[] = { 0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 };

static int intcmp(int *i1, int *i2)
{
    return *i1 - *i2;
}

int main(void)
{
    size_t i, n, key = 0, slot;
    bool status;

    plan_tests(17);

    slot = binsearch(&key, vector, 0, sizeof(vector[0]),
                     (CompareProc) intcmp, &status);
    ok(!status && slot == 0, "zero-size table");
    for (n = 0; n <= 10; n += 5)
    {
        for (i = 0; i < n; i += 2)
        {
            key = i;
            slot = binsearch(&key, vector, n, sizeof(vector[0]),
                             (CompareProc) intcmp, &status);
            ok(status &&
               slot == key / 2, "find key %d in vector[%d]", key, n);

            key = i + 1;
            slot = binsearch(&key, vector, n, sizeof(vector[0]),
                             (CompareProc) intcmp, &status);
            ok(!status && slot == key / 2 + 1,
               "find slot for key %d in vector[%d]", key, n);
        }
    }
    return exit_status();
}
