/*
 * SKELETON.C -- Do that "skeleton" thang.
 *
 * COPYRIGHT
 *
 * Options:
 *
 * Contents:
 * main()         --Process command options into config and start skeletoning.
 * opt_range()    --Process/validate that an option value is in range.
 * print_config() --Output the values of the specified config.
 *
 * Remarks:
 * TODO: Write overview description of skeleton, w/ technical details.
 *
 * See Also:
 * TODO: Reference similar or related work.
 */
#include <xtd.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <xtd/option.h>
#include <xtd/strparse.h>
#include <xtd/vector.h>
#include <xtd/estring.h>
#include <xtd/log.h>

#include <skeleton.h>

#ifndef VERSION
#define VERSION "unknown"
#endif /* VERSION */

#define SKELETON_MAX	10             /* TODO: comment */
#define RETRY_MAX	10

static const char name[] = "skeleton";
static const char version[] = VERSION;

/*
 * skeleton configuration adjustable by command-line options.
 */
typedef struct SkeletonConfig_t
{
    int retry_max;
    int seed;
    int version;
    double dwell;
    double velocity;
    double temperature;
} SkeletonConfig, *SkeletonConfigPtr;

static void print_config(SkeletonConfig *config);
static int opt_range(const char *name, const char *text, void *data);

static SkeletonConfig skeleton_config = { 0 };

static char help_prologue[] = "skeleton [options] files...";
static Option opts[] = {               /* command-line options... */
    {
     .opt = 'd',.name = "dwell",.value_name = "duration",
     .value = "300ms",
     .doc = "set the skeleton dwell timeout",
     .proc = opt_duration,.data = (void *) &skeleton_config.dwell},
    {
     .opt = 'r',.name = "retry",.value_name = "count",
     .value = "3",
     .doc = "specify the number of retries skeleton will attempt",
     .proc = opt_range,.data = (void *) &skeleton_config.retry_max},
    {
     .opt = 's',.name = "seed",.value_name = "random-seed",
     .value = "0",
     .doc = "specify the seed value for random numbers",
     .proc = opt_int,.data = (void *) &skeleton_config.seed},
    {
     .opt = 'x',.name = "velocity",.value_name = "target",
     .value = "1km/h",
     .doc = "set the skeleton target velocity",
     .proc = opt_velocity,.data = (void *) &skeleton_config.velocity},
    {
     .opt = 't',.name = "temperature",.value_name = "threshold",
     .value = "25C",
     .doc = "set the skeleton threshold temperature",
     .proc = opt_temperature,.data = (void *) &skeleton_config.temperature},
    {
     .opt = 'V',.name = "version",.value_name = "version",
     .doc = "print skeleton's version and exit",
     .proc = opt_bool,.data = (void *) &skeleton_config.version},
    /*
     * mix in logging options: -v, -q, -_, --log-level
     */
    OPTION_LOG,
    {0}                                /* sentinel */
};

/*
 * main() --Process command options into config and start skeletoning.
 */
int main(int argc, char *argv[])
{
    Skeleton *skeleton = new_skeleton("skeleton", 1, 2);

    log_init(name);
    if (!opt_getopts_long(argc, argv, opts) || !opt_defaults(opts))
    {
        opt_usage(help_prologue, opts, NULL);
        exit(2);                       /* failure: bad options */
    }
    if (skeleton_config.version)
    {
        printf("skeleton version %s\n", version);
        exit(0);
    }
    print_config(&skeleton_config);

    (void) compare_skeleton(skeleton, skeleton);
    free_skeleton(skeleton);

    if (optind < argc)
    {
        for (; optind < argc; ++optind)
        {
            printf("argument: %s\n", argv[optind]);
        }
    }
    else
    {
        log_quit(2, "no arguments");
    }
    exit(0);                           /* success */
}

/*
 * opt_range() --Process/validate that an option value is in range.
 */
static int opt_range(const char *opt_name, const char *text, void *data)
{
    if (!str_int_in_range(text, data, 1, RETRY_MAX))
    {
        err("%s is outside allowed range: (%d-%d)", opt_name, 1, RETRY_MAX);
        return 0;                      /* failed: out of range */
    }
    return 1;                          /* success */
}

/*
 * print_config() --Output the values of the specified config.
 */
static void print_config(SkeletonConfig *config)
{
    if (config == NULL)
    {
        warning("no config");
        return;
    }
    printf("retries: %d\n", config->retry_max);
    printf("random seed: %d\n", config->seed);
    printf("dwell duration: %.3fs\n", config->dwell);
    printf("velocity: %.3fm/s\n", config->velocity);
    printf("temperature: %.3fC\n", config->temperature);
}
