/*
 * Copyright (C) 2017 The Android Open Source Project
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use, copy,
 * modify, merge, publish, distribute, sublicense, and/or sell copies
 * of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdio.h>
#include <sysexits.h>
#include <android-base/logging.h>
#include <cutils/properties.h>
#include <utils/Errors.h>
#include <libgen.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CAPSULE_SYSFS_ENTRY "/sys/kernel/capsule/capsule_name"
#define LOG_FILE "/data/logs/aplog"

static void check_and_fclose(FILE *fp, const char *name) {
	fflush(fp);
	if (fsync(fileno(fp)) == -1) {
		PLOG(ERROR) << "Failed to fsync " << name;
	}
	if (ferror(fp)) {
		PLOG(ERROR) << "Error in " << name;
	}
	fclose(fp);
}

static void redirect_stdio(const char* filename) {
	int pipefd[2];
	if (pipe(pipefd) == -1) {
		PLOG(ERROR) << "pipe failed";

		// Fall back to traditional logging mode without timestamps.
		// If these fail, there's not really anywhere to complain...
		freopen(filename, "a", stdout); setbuf(stdout, NULL);
		freopen(filename, "a", stderr); setbuf(stderr, NULL);

		return;
	}

	pid_t pid = fork();
	if (pid == -1) {
		PLOG(ERROR) << "fork failed";

		// Fall back to traditional logging mode without timestamps.
		// If these fail, there's not really anywhere to complain...
		freopen(filename, "a", stdout); setbuf(stdout, NULL);
		freopen(filename, "a", stderr); setbuf(stderr, NULL);

		return;
	}

	if (pid == 0) {
		/// Close the unused write end.
		close(pipefd[1]);

		auto start = std::chrono::steady_clock::now();

		// Child logger to actually write to the log file.
		FILE* log_fp = fopen(filename, "ae");
		if (log_fp == nullptr) {
			PLOG(ERROR) << "fopen \"" << filename << "\" failed";
			close(pipefd[0]);
			_exit(EXIT_FAILURE);
		}

		FILE* pipe_fp = fdopen(pipefd[0], "r");
		if (pipe_fp == nullptr) {
			PLOG(ERROR) << "fdopen failed";
			check_and_fclose(log_fp, filename);
			close(pipefd[0]);
			_exit(EXIT_FAILURE);
		}

		char* line = nullptr;
		size_t len = 0;
		while (getline(&line, &len, pipe_fp) != -1) {
			auto now = std::chrono::steady_clock::now();
			double duration = std::chrono::duration_cast<std::chrono::duration<double>>(
					now - start).count();
			if (line[0] == '\n') {
				fprintf(log_fp, "[%12.6lf]\n", duration);
			} else {
				fprintf(log_fp, "[%12.6lf] %s", duration, line);
			}
			fflush(log_fp);
		}

		PLOG(ERROR) << "getline failed";

		free(line);
		check_and_fclose(log_fp, filename);
		close(pipefd[0]);
		_exit(EXIT_FAILURE);
	} else {
		// Redirect stdout/stderr to the logger process.
		// Close the unused read end.
		close(pipefd[0]);

		setbuf(stdout, nullptr);
		setbuf(stderr, nullptr);

		if (dup2(pipefd[1], STDOUT_FILENO) == -1) {
			PLOG(ERROR) << "dup2 stdout failed";
		}
		if (dup2(pipefd[1], STDERR_FILENO) == -1) {
			PLOG(ERROR) << "dup2 stderr failed";
		}

		close(pipefd[1]);
	}
}

static void UpdaterLogger(android::base::LogId /* id */, android::base::LogSeverity /* severity */,
                          const char* /* tag */, const char* /* file */, unsigned int /* line */,
                          const char* message) {
	fprintf(stdout, "%s\n", message);
}

int main(void) {
	FILE *f;
	int i;
	uint32_t cur_slot = 2;
	char update_abl[40] = {0};
	char pval[PROPERTY_VALUE_MAX] = {0};
	int ret = EX_OK;

	setbuf(stdout, nullptr);
	setbuf(stderr, nullptr);
	android::base::InitLogging(NULL, &UpdaterLogger);
	if (access(LOG_FILE, R_OK | W_OK) == 0){
		redirect_stdio(LOG_FILE);
	}

	property_get("ro.boot.slot_suffix", pval, "none");
	LOG(INFO) << "Try to update misc info " << pval;
	if (!strcmp(pval, "_a"))
		cur_slot = 2;
	else
		cur_slot = 1;

	sprintf(update_abl, "m%d:@0", cur_slot);

	f = fopen(CAPSULE_SYSFS_ENTRY, "w+");
	if (!f) {
		LOG(ERROR) << "Cannot access " << CAPSULE_SYSFS_ENTRY;
		ret = EXIT_FAILURE;
	}

	i = fprintf(f, "%s", update_abl);
	if (i < 0) {
		LOG(ERROR) << "Cannot write "<< CAPSULE_SYSFS_ENTRY;
		ret = EXIT_FAILURE;
	}
	else
		LOG(INFO) << "Set abl update misc at " << CAPSULE_SYSFS_ENTRY << " with slot info " << update_abl;
	fclose(f);

	return ret;
}
