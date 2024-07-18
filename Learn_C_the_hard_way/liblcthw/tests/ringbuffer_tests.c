#include "minunit.h"
#include <lcthw/ringbuffer.h>
#include <assert.h>

static RingBuffer *ringbuffer = NULL;
char *tests[] = {"test1 data", "test2 data", "test3 data"};

#define NUM_TESTS 3

char *test_create() {
    ringbuffer = RingBuffer_create(strlen(tests[0]) + strlen(tests[1]));
    mu_assert(ringbuffer != NULL, "Failed to create ringbuffer.");

    return NULL;
}

char *test_read_write() {
    char *readout = calloc(strlen(tests[0]) + 1, 1);
    // test1: CHECK empty before write
    mu_assert(RingBuffer_empty(ringbuffer), "Ringbuffer is not empty before any write.");
    // test2: write and check the ends_at
    RingBuffer_write(ringbuffer, tests[0], strlen(tests[0]));
    mu_assert(RingBuffer_ends_at(ringbuffer) == ringbuffer->buffer + strlen(tests[0]),
                "Ringbuffer end does't match the real length.");
    // test3: read out and check if empty and the start and end is reset
    RingBuffer_read(ringbuffer, readout, strlen(tests[0]));
    mu_assert(RingBuffer_empty(ringbuffer), "Ringbuffer is not empty after a whole read out.");
    mu_assert(ringbuffer->start == 0 && ringbuffer->end == 0,
                "The start and end index are not reset after a whole read out.");
    // test4: check full is no problem
    RingBuffer_write(ringbuffer, tests[0], strlen(tests[0]));
    RingBuffer_write(ringbuffer, tests[1], strlen(tests[1]));
    mu_assert(RingBuffer_full(ringbuffer), "Ringbuffer Full func is not in work.");
    // test5: test read out content
    RingBuffer_read(ringbuffer, readout, strlen(tests[0]));
    mu_assert(strcmp(tests[0], readout) == 0, "Read out data not correct.");
    mu_assert(RingBuffer_starts_at(ringbuffer) == ringbuffer->buffer + strlen(tests[0]),
                "Ringbuffer start index not correct.");

    free(readout);
    
    return NULL;
}

char *test_destroy() {
    mu_assert(ringbuffer != NULL, "Failed to find ringbuffer.");
    RingBuffer_destroy(ringbuffer);

    return NULL;
}

char *all_tests() {
    mu_suite_start();

    mu_run_test(test_create);
    mu_run_test(test_read_write);
    mu_run_test(test_destroy);

    return NULL;
}

RUN_TESTS(all_tests);