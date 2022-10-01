/*
 * SKELETON.C --Unit tests for skeleton.
 *
 *
 */
#include <string.h>

#include <xtd/tap.h>
#include <skeleton.h>

int main(void)
{
    SkeletonPtr skeleton_1 = new_skeleton("skeleton-1", 1, 1);
    SkeletonPtr skeleton_2 = new_skeleton("skeleton-2", 2, 2);

    plan_tests(4);

    ok(skeleton_1 != NULL,
       "new_skeleton() allocates object memory");
    ok(strcmp(skeleton_1->name, "skeleton-1") == 0
       && skeleton_1->x == 1
       && skeleton_1->y == 1,
       "new_skeleton() initialises object");

    ok(compare_skeleton(skeleton_1, skeleton_1) == 0,
       "compare_skeleton() tests equal values");
    ok(compare_skeleton(skeleton_1, skeleton_2) == -1,
       "compare_skeleton() tests unequal values");
    return exit_status();
}
