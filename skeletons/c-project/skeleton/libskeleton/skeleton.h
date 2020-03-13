/*
 * SKELETON.H --Definitions for the skeleton module.
 *
 * COPYRIGHT
 *
 * Remarks:
 * TODO: Describe the (single!) purpose/motivation for skeleton
 * TODO: Summarise how the skeleton module should be used.
 *
 * See Also:
 * TODO: Add any references to similar/related/plagiarised work.
 */
#ifndef SKELETON_H
#define SKELETON_H

#ifdef __cplusplus
extern "C"
{
#endif                                 /* C++ */

    typedef struct Skeleton_t
    {
        int id;                        /* unique */
        const char *name;              /* order */
        int x, y;
        struct Skeleton_t *children;   /* list of children */
    } Skeleton, *SkeletonPtr;

    typedef int (*SkeletonCompareProc)(const Skeleton *a,
                                       const Skeleton *b);

    extern Skeleton root_skeleton;

    SkeletonPtr alloc_skeleton(size_t count);
    void free_skeleton(SkeletonPtr skeleton, size_t count);
    int init_skeleton(SkeletonPtr skeleton, const char *name, int x, int y);
    SkeletonPtr new_skeleton(const char *name, int x, int y);
    int compare_skeleton(const Skeleton *a, const Skeleton *b);
    int print_skeleton(const Skeleton *skeleton);

#ifdef __cplusplus
}
#endif                                 /* C++ */
#endif                                 /* SKELETON_H */
