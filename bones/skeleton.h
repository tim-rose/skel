/**
 * @file
 * @brief The skeleton module, for frabulating tinkerolas.
 *
 * @copyright COPYRIGHT
 *
 * TODO: Describe the (single!) purpose/motivation for skeleton.
 * TODO: Summarise how the skeleton module should be used.
 *
 * @see
 * TODO: Add any references to similar/related/plagiarised work.
 */
#ifndef SKELETON_H
#define SKELETON_H

#ifdef __cplusplus
extern "C"
{
#endif                                 /* C++ */
    /**
     * @brief TODO: Describe core Skeleton data structure(s).
     */
    typedef struct Skeleton_t
    {
        int id;                        /**< Unique identifier. */
        const char *name;              /**< A name for searching, ordering. */
        int x, y;
        struct Skeleton_t *children;   /**< A NULL-terminated list of children */
    } Skeleton, *SkeletonPtr;

    /**
     * @brief A function that can compare two Skeleton objects.
     *
     * This conforms to and may be used with binsearch(3), qsort(3), etc.
     */
    typedef int (*SkeletonCompareProc)(const Skeleton * a,
                                       const Skeleton * b);

    extern Skeleton root_skeleton;
                                        /**<  TODO: Some global Skeleton object */

    /**
     * @brief Allocate memory for one or more Skeletons.
     * @param count Specifies how many skeletons to allocate.
     * @return Success: the (start of a block of) a skeleton; Failure: NULL.
     *
     * This allocates memory but does not initialise the Skeleton
     * structure itself.
     */
    Skeleton *alloc_skeleton(size_t count);

    /**
     * @brief Release the memory from some previously allocated Skeleton.
     *
     * The skeleton may also contain a strdup()'d string, this is freed too.
     */
    void free_skeleton(Skeleton * skeleton);

    /**
     * @brief Initialise a skeleton's memory/state.
     * @param skeleton The address of a block of skeleton-sized memory.
     * @param name The initial value for the skeleton's name field.
     * @param x The skeleton's x offset.
     * @param y The skeleton's y offset.
     * @return Success: 1; Failure: 0.
     *
     * The name field is assumed to be dynamically allocated,
     * (e.g. strdup(3), and will be freed if not NULL.
     */
    int init_skeleton(Skeleton * skeleton, const char *name, int x, int y);

    /**
     * @brief Allocate and initialise a skeleton object.
     * @param name The name of the Skeleton.
     * @param x The skeleton's x position.
     * @param y The skeleton's y position.
     * @eturn Success: the new skeleton; Failure: NULL.
     *
     * This function will fail if alloc_skeleton() fails.
     * The name field is duplicated to dynamic memory using strdup(3).
     */
    Skeleton *new_skeleton(const char *name, int x, int y);

    /**
     * @brief Compare two skeletons.
     * @param a  --One of the skeletons to be compared.
     * @param b  --The other skeleton to be compared.
     * @return
     * * +ve: `a` > `b`
     * * 0: `a` == `b`
     * * -ve: `a` < `b`.
     */
    int compare_skeleton(const Skeleton * a, const Skeleton * b);

    /**
     * @brief Add a child to a parent Skeleton.
     * @paaram parent The parent Skeleton.
     * @param child The child Skeleton.
     * @return Success: parent; Failure: NULL.
     */
    Skeleton *skeleton_add(const Skeleton * parent, const Skeleton * child);

    /**
     * @brief Move a Skeleton to a new position.
     * @paaram skeleton The Skeleton to be moved.
     * @param x The new "x" position.
     * @param y The new "y" position.
     * @return Success: skeleton; Failure: NULL.
     */
    Skeleton *skeleton_move(const Skeleton * skeleton, int x, int y);

#ifdef __cplusplus
}
#endif                                 /* C++ */
#endif                                 /* SKELETON_H */
