/*
 * SKELETON.C --Implementing all things skeleton.
 *
 * Contents:
 * alloc_skeleton()   --Allocate memory for one or more skeletons.
 * free_skeleton()    --Release the memory of a previously allocated skeleton.
 * init_skeleton()    --Initialise a skeleton's memory.
 * new_skeleton()     --Allocate and initialise a single skeleton object.
 * compare_skeleton() --Compare two skeleton objects.
 * skeleton_add()     --Add a child to a parent skeleton.
 * skeleton_move()    --Move a Skeleton to a new position.
 *
 * Remarks:
 * TODO: document the design of skeleton, its history, future directions etc.
 *
 * See Also:
 * TODO: Add any references to similar/related/plagiarised work.
 */

#include <stdlib.h>
#include <string.h>

#include <xtd.h>
#include <skeleton.h>

/*
 * root_skeleton --The magic root of the skeleton tree, I guess.
 */
Skeleton root_skeleton = {
    .id = 0,
    .name = "root",
    .x = 0,
    .y = 0,
    .children = (Skeleton *) NULL
};

static Skeleton UNUSED(temp_skeleton);
static int last_id = 0;

/*
 * alloc_skeleton() --Allocate memory for one or more skeletons.
 *
 * Parameters:
 * count --specifies how many skeletons to allocate
 *
 * Returns: (Skeleton*)
 * Success: the (start of a block of) a skeleton; Failure: NULL.
 */
Skeleton *alloc_skeleton(size_t count)
{
    return (Skeleton *) calloc(count, sizeof(Skeleton));
}

/*
 * free_skeleton() --Release the memory of a previously allocated skeleton.
 */
void free_skeleton(Skeleton * skeleton)
{
    if (skeleton == NULL)
    {
        return;                        /* REVISIT: consider assert() */
    }

    if (skeleton->name != NULL)
    {                                  /* free malloc()d components */
        free((void *) skeleton->name);
    }
    free((void *) skeleton);
}

/*
 * init_skeleton() --Initialise a skeleton's memory.
 */
int init_skeleton(Skeleton * skeleton, const char *name, int x, int y)
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
 */
Skeleton *new_skeleton(const char *name, int x, int y)
{
    Skeleton *skeleton;

    if ((skeleton = alloc_skeleton(1)) != NULL)
    {
        if (!init_skeleton(skeleton, name, x, y))
        {
            free_skeleton(skeleton);
            skeleton = NULL;
        }
    }
    return skeleton;
}

/*
 * compare_skeleton() --Compare two skeleton objects.
 */
int compare_skeleton(const Skeleton * a, Skeleton const *b)
{
    return strcmp(a->name, b->name);
}

/*
 * skeleton_add() --Add a child to a parent skeleton.
 */
Skeleton *skeleton_add(const Skeleton * UNUSED(parent),
                       const Skeleton * UNUSED(child))
{
    //err("%s(): not implemented yet", __func__);
    return NULL;
}

/*
 * skeleton_move() --Move a Skeleton to a new position.
 *
 */
Skeleton *skeleton_move(const Skeleton * UNUSED(skeleton),
                        int UNUSED(x), int UNUSED(y))
{
    //err("%s(): not implemented yet", __func__);
    return NULL;
}
