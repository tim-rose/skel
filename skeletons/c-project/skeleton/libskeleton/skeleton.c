/*
 * SKELETON.C --Implementing all things skeleton.
 *
 * Contents:
 * alloc_skeleton()   --Allocate memory for one or more skeletons.
 * free_skeleton()    --Release the memory of a previously allocated skeleton.
 * init_skeleton()    --Initialise a single skeleton's memory.
 * new_skeleton()     --Allocate and initialise a single skeleton object.
 * compare_skeleton() --Compare two skeleton objects.
 * print_skeleton()   --Print a skeleton in human-readable format.
 *
 * Remarks:
 * TODO: document the design of skeleton, its history, future directions etc.
 *
 * See Also:
 * TODO: Add any references to similar/related/plagiarised work.
 */

#include <stdlib.h>
#include <string.h>

#include <log.h>
#include <skeleton.h>

/*
 * root_skeleton --The root of the skeleton tree, I guess.
 */
Skeleton root_skeleton = {
    .id = 0,
    .name = "root",
    .x = 0,
    .y = 0,
    .children = (SkeletonPtr) NULL
};

static Skeleton UNUSED(temp_skeleton);
static int last_id = 0;

/*
 * alloc_skeleton() --Allocate memory for one or more skeletons.
 *
 * Parameters:
 * count --specifies how many skeletons to allocate
 *
 * Returns: (SkeletonPtr)
 * Success: the (start of a block of) a skeleton; Failure: NULL.
 */
SkeletonPtr alloc_skeleton(size_t count)
{
    return (SkeletonPtr) calloc(count, sizeof(Skeleton));
}

/*
 * free_skeleton() --Release the memory of a previously allocated skeleton.
 *
 * Parameters:
 * skeleton --the skeleton to release.
 * count --number of skel items pointed to by skeleton
 *
 * Remarks:
 * The skeleton also contains a strdup() string, this is freed too.
 */
void free_skeleton(SkeletonPtr skeleton, size_t count)
{
    if (skeleton == NULL)
    {
        return;
    }

    for (SkeletonPtr item = skeleton; item < skeleton + count; ++item)
    {
        if (item->name != NULL)
        {                              /* free malloc()d components */
            free((void *) item->name);
        }
    }
    free((void *) skeleton);
}

/*
 * init_skeleton() --Initialise a single skeleton's memory.
 *
 * Parameters:
 * skeleton --the address of a block of skeleton-sized memory
 * name --the initial value for the skeleton's name field
 * x --the skeleton's x offset
 * y --the skeleton's y offset
 *
 * Returns: (int)
 * Success: 1; Failure: 0.
 */
int init_skeleton(SkeletonPtr skeleton, const char *name, int x, int y)
{
    if ((skeleton->name = strdup(name)) == NULL)
    {
        return 0;                      /* failure: no more mmemory!? */
    }
    skeleton->id = ++last_id;
    skeleton->x = x;
    skeleton->y = y;
    return 1;                          /* success */
}

/*
 * new_skeleton() --Allocate and initialise a single skeleton object.
 *
 * Parameters:
 * const char *name, int x, int y)
 *
 * name --the initial value for the skeleton's name field
 * x --the skeleton's x offset
 * y --the skeleton's y offset
 *
 * Returns: (SkeletonPtr)
 * Success: the new skeleton; Failure: NULL.
 */
SkeletonPtr new_skeleton(const char *name, int x, int y)
{
    SkeletonPtr skeleton;

    if ((skeleton = alloc_skeleton(1)) != NULL)
    {
        if (!init_skeleton(skeleton, name, x, y))
        {
            free_skeleton(skeleton, 1);
            skeleton = NULL;
        }
    }
    return skeleton;
}

/*
 * compare_skeleton() --Compare two skeleton objects.
 *
 * Parameters:
 * a, b --the skeletons to be compared.
 *
 * Returns: (int)
 * a comparison result suitable for qsort(3).
 */
int compare_skeleton(const Skeleton *a, Skeleton const *b)
{
    return strcmp(a->name, b->name);
}

/*
 * print_skeleton() --Print a skeleton in human-readable format.
 */
int print_skeleton(const Skeleton* UNUSED(skeleton))
{
    err("%s(): not implemented yet", __func__);
    return 0;
}
