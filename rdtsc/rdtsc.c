#include <stdint.h>
#include <cpuid.h>
#include <inttypes.h>

#include <utils/Log.h>
#include <utils/Timers.h>

/*
 * Get the TSC count.
 */
static inline uint64_t rdtsc(void) {
    uint32_t lo, hi;

    asm volatile("rdtsc" : "=a" (lo), "=d" (hi));
    return ((uint64_t)hi << 32U) | lo;
}

/*
 * Get the TSC frequency (in KHz).
 */
uint32_t get_tsc_freq(void) {
    uint32_t eax, ebx, ecx, edx;
    uint64_t tsc_freq = 0;

    if (__get_cpuid(0x15, &eax, &ebx, &ecx, &edx)) {
        if ((ebx != 0) && (ecx != 0)) {
            tsc_freq = (ecx * (ebx / eax))/1000; /* Refer to CPUID.15H */
        }
    }

    if ((tsc_freq == 0) && (__get_cpuid_max(0, NULL) >= 0x16)) {
        /* Get the CPU base frequency (in MHz) */
        if (__get_cpuid(0x16, &eax, &ebx, &ecx, &edx)) {
            tsc_freq = eax * 1000;
            ALOGE("%s(), TSC frequency is enumerated via CPUID.16H, it is NOT accurate!", __func__);
        }
    }

    if (tsc_freq == 0) {
        ALOGE("%s(), TSC frequency detection failed, Dummy value is used!", __func__);
        tsc_freq = 2800000; /* 2800 MHz*/
    }

    return (uint32_t)tsc_freq;
}

int main() {
    uint32_t tsc_freq;
    uint64_t tsc_count;
    uint64_t tsc_time;
    nsecs_t now = 0;
    ALOGI("rdtsc running");

    tsc_freq = get_tsc_freq();
    tsc_count = rdtsc();
    tsc_time = tsc_count / tsc_freq;

    now = systemTime(SYSTEM_TIME_MONOTONIC);
    now = now / (1000 * 1000);

    ALOGI("TSC Freq: %" PRIu32 "(KHz), Time Seq TSC: %" PRIu64 ", TSC Time: %" PRIu64 "(MS), Now: %" PRId64 "(MS)",
          tsc_freq, tsc_count, tsc_time, now);
    return 0;
}
