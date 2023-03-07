Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D512F6ADD4A
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 12:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjCGL3N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 06:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbjCGL2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 06:28:55 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464524988E
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 03:28:50 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id q16so11778230wrw.2
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 03:28:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678188529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvU4odtmFG0yriCdCjX1llQlR53t2clwEw3b2MaCF30=;
        b=GCUZMqJdfw1a7fk1JDHPv+Htzinnh8j+FRq/z4hykmiROq+bXKtGu8omqQJ1dGn545
         1zTEOPOHtwlskLuy4D+kJzonfs6zkylh1LLzcv+J+KjIyCw9YgegHBlURpSI7qN7MGeC
         8cAsHB1UoSeeizX7gut65eRhL0kjcQAEmYZeSb2T5wKVZhOLD9G56pwsgVo8g6IVTZEi
         RfWKleFSAZxZzUCgBRvdzdkwXpQzxnM132P4DfgXvv50FkVOsheNqOZRHxrWsYHlLziT
         H6GH/5kf94Tz2Yw0L1ZRtdMGetLuE7ee+c5ke63iiSosvf2+Y0DSPaGui3QS4FX4ZZg1
         nS6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678188529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvU4odtmFG0yriCdCjX1llQlR53t2clwEw3b2MaCF30=;
        b=aV+m/cUBXuaeqwDhadNvdHkbt4yGvACLczDg0tbST19A9f9mL2qkOZeAlfOd5RH/Ar
         CmZuS8MdHP3dP69nfI0dyZumRBUxPTRQzATy+RzlFE9Zo/xriFAcfLKGdwy3FHwG6pcJ
         a6+KhrF9ucOYK+GKnyjN1geb9xwLHOdZXNc3uvimjbGw9KPVBeaEezzu/HmwOOE0Lju0
         2WnUADeN577MKAhsb1IzfdVxjLPANecZYP8n5AcIRl97oTgfC0E0QUooiKpHJDg24Ph6
         xqv7fOJEWdhloL2Ho+VDnK5BMVDqsziWkyIiOsEAyTmjSDcpRl5SwHYbCi5v4AvCY/q+
         OS7g==
X-Gm-Message-State: AO0yUKVGIpP2aNdbMgk64kLuZbDaWaX2ml8n9Dbl7+MoMyHTMedfSeNe
        wruzYdTeeQL+DrKs/hjXVB5iyA==
X-Google-Smtp-Source: AK7set+ONgiHZuM1z1BT4PXIExSHAQZBd8dFPyGPiNmkoXtcW5hTssTHr+3reu0uUGuN7pTmWHi/4Q==
X-Received: by 2002:a5d:45c2:0:b0:2c7:1b4c:da75 with SMTP id b2-20020a5d45c2000000b002c71b4cda75mr8599072wrs.69.1678188528647;
        Tue, 07 Mar 2023 03:28:48 -0800 (PST)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id o1-20020a5d4081000000b002c71a32394dsm12415137wrp.64.2023.03.07.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 03:28:47 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 18A801FFBE;
        Tue,  7 Mar 2023 11:28:46 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.linux.dev,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Will Deacon <will@kernel.org>
Subject: [kvm-unit-tests PATCH v10 6/7] arm/barrier-litmus-tests: add simple mp and sal litmus tests
Date:   Tue,  7 Mar 2023 11:28:44 +0000
Message-Id: <20230307112845.452053-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307112845.452053-1-alex.bennee@linaro.org>
References: <20230307112845.452053-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a framework for adding simple barrier litmus tests against
ARM. The litmus tests aren't as comprehensive as the academic exercises
which will attempt to do all sorts of things to keep racing CPUs synced
up. These tests do honour the "sync" parameter to do a poor-mans
equivalent.

The two litmus tests are:
  - message passing
  - store-after-load

They both have case that should fail (although won't on single-threaded
TCG setups). If barriers aren't working properly the store-after-load
test will fail even on an x86 backend as x86 allows re-ording of non
aliased stores.

I've imported a few more of the barrier primatives from the Linux source
tree so we consistently use macros.

The arm64 barrier primitives trip up on -Wstrict-aliasing so this is
disabled in the Makefile.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
CC: Will Deacon <will@kernel.org>
Message-Id: <20211118184650.661575-9-alex.bennee@linaro.org>

---
v9
  - return to unittests.cfg, drop accel=tcg
  - use compiler.h for barriers instead of defining outselves
  - s/printf/report_info/
v10
  - use compiler WRITE/READ_ONCE macros
---
 arm/Makefile.common       |   1 +
 lib/arm/asm/barrier.h     |  19 ++
 lib/arm64/asm/barrier.h   |  50 +++++
 arm/barrier-litmus-test.c | 450 ++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg         |  31 +++
 5 files changed, 551 insertions(+)
 create mode 100644 arm/barrier-litmus-test.c

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 3089e3bf..0a2bdcfc 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -13,6 +13,7 @@ tests-common += $(TEST_DIR)/sieve.flat
 tests-common += $(TEST_DIR)/pl031.flat
 tests-common += $(TEST_DIR)/tlbflush-code.flat
 tests-common += $(TEST_DIR)/locking-test.flat
+tests-common += $(TEST_DIR)/barrier-litmus-test.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/lib/arm/asm/barrier.h b/lib/arm/asm/barrier.h
index 7f868314..0f3670b8 100644
--- a/lib/arm/asm/barrier.h
+++ b/lib/arm/asm/barrier.h
@@ -8,6 +8,9 @@
  * This work is licensed under the terms of the GNU GPL, version 2.
  */
 
+#include <stdint.h>
+#include <linux/compiler.h>
+
 #define sev()		asm volatile("sev" : : : "memory")
 #define wfe()		asm volatile("wfe" : : : "memory")
 #define wfi()		asm volatile("wfi" : : : "memory")
@@ -25,4 +28,20 @@
 #define smp_rmb()	smp_mb()
 #define smp_wmb()	dmb(ishst)
 
+extern void abort(void);
+
+#define smp_store_release(p, v)						\
+do {									\
+	smp_mb();							\
+	WRITE_ONCE(*p, v);						\
+} while (0)
+
+
+#define smp_load_acquire(p)						\
+({									\
+	typeof(*p) ___p1 = READ_ONCE(*p);				\
+	smp_mb();							\
+	___p1;								\
+})
+
 #endif /* _ASMARM_BARRIER_H_ */
diff --git a/lib/arm64/asm/barrier.h b/lib/arm64/asm/barrier.h
index 0e1904cf..5e405190 100644
--- a/lib/arm64/asm/barrier.h
+++ b/lib/arm64/asm/barrier.h
@@ -24,4 +24,54 @@
 #define smp_rmb()	dmb(ishld)
 #define smp_wmb()	dmb(ishst)
 
+#define smp_store_release(p, v)						\
+do {									\
+	switch (sizeof(*p)) {						\
+	case 1:								\
+		asm volatile ("stlrb %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 2:								\
+		asm volatile ("stlrh %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 4:								\
+		asm volatile ("stlr %w1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	case 8:								\
+		asm volatile ("stlr %1, %0"				\
+				: "=Q" (*p) : "r" (v) : "memory");	\
+		break;							\
+	}								\
+} while (0)
+
+#define smp_load_acquire(p)						\
+({									\
+	union { typeof(*p) __val; char __c[1]; } __u;			\
+	switch (sizeof(*p)) {						\
+	case 1:								\
+		asm volatile ("ldarb %w0, %1"				\
+			: "=r" (*(u8 *)__u.__c)				\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	case 2:								\
+		asm volatile ("ldarh %w0, %1"				\
+			: "=r" (*(u16 *)__u.__c)			\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	case 4:								\
+		asm volatile ("ldar %w0, %1"				\
+			: "=r" (*(u32 *)__u.__c)			\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	case 8:								\
+		asm volatile ("ldar %0, %1"				\
+			: "=r" (*(u64 *)__u.__c)			\
+			: "Q" (*p) : "memory");				\
+		break;							\
+	}								\
+	__u.__val;							\
+})
+
 #endif /* _ASMARM64_BARRIER_H_ */
diff --git a/arm/barrier-litmus-test.c b/arm/barrier-litmus-test.c
new file mode 100644
index 00000000..5d7e61d1
--- /dev/null
+++ b/arm/barrier-litmus-test.c
@@ -0,0 +1,450 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ARM Barrier Litmus Tests
+ *
+ * This test provides a framework for testing barrier conditions on
+ * the processor. It's simpler than the more involved barrier testing
+ * frameworks as we are looking for simple failures of QEMU's TCG not
+ * weird edge cases the silicon gets wrong.
+ */
+
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <asm/cpumask.h>
+#include <asm/barrier.h>
+#include <asm/mmu.h>
+
+#define MAX_CPUS 8
+
+/* Array size and access controls */
+static int array_size = 100000;
+static int wait_if_ahead;
+
+static cpumask_t cpu_mask;
+
+/*
+ * These test_array_* structures are a contiguous array modified by two or more
+ * competing CPUs. The padding is to ensure the variables do not share
+ * cache lines.
+ *
+ * All structures start zeroed.
+ */
+
+typedef struct test_array {
+	volatile unsigned int x;
+	uint8_t dummy[64];
+	volatile unsigned int y;
+	uint8_t dummy2[64];
+	volatile unsigned int r[MAX_CPUS];
+} test_array;
+
+volatile test_array *array;
+
+/* Test definition structure
+ *
+ * The first function will always run on the primary CPU, it is
+ * usually the one that will detect any weirdness and trigger the
+ * failure of the test.
+ */
+
+typedef void (*test_fn)(void);
+
+typedef struct {
+	const char *test_name;
+	bool  should_pass;
+	test_fn main_fn;
+	test_fn secondary_fns[MAX_CPUS-1];
+} test_descr_t;
+
+/* Litmus tests */
+
+static unsigned long sync_start(void)
+{
+	const unsigned long gate_mask = ~0x3ffff;
+	unsigned long gate, now;
+
+	gate = get_cntvct() & gate_mask;
+	do {
+		now = get_cntvct();
+	} while ((now & gate_mask) == gate);
+
+	return now;
+}
+
+/* Simple Message Passing
+ *
+ * x is the message data
+ * y is the flag to indicate the data is ready
+ *
+ * Reading x == 0 when y == 1 is a failure.
+ */
+
+static void message_passing_write(void)
+{
+	int i;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		entry->x = 1;
+		entry->y = 1;
+	}
+
+	halt();
+}
+
+static void message_passing_read(void)
+{
+	int i;
+	int errors = 0, ready = 0;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int x, y;
+
+		y = entry->y;
+		x = entry->x;
+
+		if (y && !x)
+			errors++;
+		ready += y;
+	}
+
+	/*
+	 * We expect this to fail but with STO backends you often get
+	 * away with it. Fudge xfail if we did actually pass.
+	 */
+	report_xfail(errors == 0 ? false : true, errors == 0,
+		     "mp: %d errors, %d ready", errors, ready);
+}
+
+/* Simple Message Passing with barriers */
+static void message_passing_write_barrier(void)
+{
+	int i;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		entry->x = 1;
+		smp_wmb();
+		entry->y = 1;
+	}
+
+	halt();
+}
+
+static void message_passing_read_barrier(void)
+{
+	int i;
+	int errors = 0, ready = 0, not_ready = 0;
+
+	sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int x, y;
+
+		y = entry->y;
+		smp_rmb();
+		x = entry->x;
+
+		if (y && !x)
+			errors++;
+
+		if (y) {
+			ready++;
+		} else {
+			not_ready++;
+
+			if (not_ready > 2) {
+				entry = &array[i+1];
+				do {
+					not_ready = 0;
+				} while (wait_if_ahead && !entry->y);
+			}
+		}
+	}
+
+	report(errors == 0, "mp barrier: %d errors, %d ready", errors, ready);
+}
+
+/* Simple Message Passing with Acquire/Release */
+static void message_passing_write_release(void)
+{
+	int i;
+
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		entry->x = 1;
+		smp_store_release(&entry->y, 1);
+	}
+
+	halt();
+}
+
+static void message_passing_read_acquire(void)
+{
+	int i;
+	int errors = 0, ready = 0, not_ready = 0;
+
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int x, y;
+
+		y = smp_load_acquire(&entry->y);
+		x = entry->x;
+
+		if (y && !x)
+			errors++;
+
+		if (y) {
+			ready++;
+		} else {
+			not_ready++;
+
+			if (not_ready > 2) {
+				entry = &array[i+1];
+				do {
+					not_ready = 0;
+				} while (wait_if_ahead && !entry->y);
+			}
+		}
+	}
+
+	report(errors == 0, "mp acqrel: %d errors, %d ready", errors, ready);
+}
+
+/*
+ * Store after load
+ *
+ * T1: write 1 to x, load r from y
+ * T2: write 1 to y, load r from x
+ *
+ * Without memory fence r[0] && r[1] == 0
+ * With memory fence both == 0 should be impossible
+ */
+
+static void check_store_and_load_results(const char *name, int thread,
+					 bool xfail, unsigned long start,
+					 unsigned long end)
+{
+	int i;
+	int neither = 0;
+	int only_first = 0;
+	int only_second = 0;
+	int both = 0;
+
+	for ( i= 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+
+		if (entry->r[0] == 0 &&
+		    entry->r[1] == 0)
+			neither++;
+		else if (entry->r[0] &&
+			entry->r[1])
+			both++;
+		else if (entry->r[0])
+			only_first++;
+		else
+			only_second++;
+	}
+
+	report_info("T%d: %08lx->%08lx neither=%d only_t1=%d only_t2=%d both=%d\n",
+		    thread, start, end, neither, only_first, only_second, both);
+
+	if (thread == 1)
+		report_xfail(xfail, neither==0, "%s: errors=%d", name, neither);
+
+}
+
+/*
+ * This attempts to synchronise the start of both threads to roughly
+ * the same time. On real hardware there is a little latency as the
+ * secondary vCPUs are powered up however this effect it much more
+ * exaggerated on a TCG host.
+ *
+ * Busy waits until the we pass a future point in time, returns final
+ * start time.
+ */
+
+static void store_and_load_1(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->x = 1;
+		r = entry->y;
+		entry->r[0] = r;
+	}
+	end = get_cntvct();
+
+	smp_mb();
+
+	while (!cpumask_test_cpu(1, &cpu_mask))
+		cpu_relax();
+
+	check_store_and_load_results("sal", 1, true, start, end);
+}
+
+static void store_and_load_2(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->y = 1;
+		r = entry->x;
+		entry->r[1] = r;
+	}
+	end = get_cntvct();
+
+	check_store_and_load_results("sal", 2, true, start, end);
+
+	cpumask_set_cpu(1, &cpu_mask);
+
+	halt();
+}
+
+static void store_and_load_barrier_1(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->x = 1;
+		smp_mb();
+		r = entry->y;
+		entry->r[0] = r;
+	}
+	end = get_cntvct();
+
+	smp_mb();
+
+	while (!cpumask_test_cpu(1, &cpu_mask))
+		cpu_relax();
+
+	check_store_and_load_results("sal_barrier", 1, false, start, end);
+}
+
+static void store_and_load_barrier_2(void)
+{
+	int i;
+	unsigned long start, end;
+
+	start = sync_start();
+	for (i = 0; i < array_size; i++) {
+		volatile test_array *entry = &array[i];
+		unsigned int r;
+
+		entry->y = 1;
+		smp_mb();
+		r = entry->x;
+		entry->r[1] = r;
+	}
+	end = get_cntvct();
+
+	check_store_and_load_results("sal_barrier", 2, false, start, end);
+
+	cpumask_set_cpu(1, &cpu_mask);
+
+	halt();
+}
+
+
+/* Test array */
+static test_descr_t tests[] = {
+
+	{ "mp",         false,
+	  message_passing_read,
+	  { message_passing_write }
+	},
+
+	{ "mp_barrier", true,
+	  message_passing_read_barrier,
+	  { message_passing_write_barrier }
+	},
+
+	{ "mp_acqrel", true,
+	  message_passing_read_acquire,
+	  { message_passing_write_release }
+	},
+
+	{ "sal",       false,
+	  store_and_load_1,
+	  { store_and_load_2 }
+	},
+
+	{ "sal_barrier", true,
+	  store_and_load_barrier_1,
+	  { store_and_load_barrier_2 }
+	},
+};
+
+
+static void setup_and_run_litmus(test_descr_t *test)
+{
+	array = calloc(array_size, sizeof(test_array));
+
+	if (array) {
+		int i = 0;
+
+		report_info("Allocated test array @ %p", array);
+
+		while (test->secondary_fns[i]) {
+			smp_boot_secondary(i+1, test->secondary_fns[i]);
+			i++;
+		}
+
+		test->main_fn();
+	} else
+		report(false, "%s: failed to allocate memory", test->test_name);
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+	unsigned int j;
+	test_descr_t *test = NULL;
+
+	for (i = 0; i < argc; i++) {
+		char *arg = argv[i];
+
+		for (j = 0; j < ARRAY_SIZE(tests); j++) {
+			if (strcmp(arg, tests[j].test_name) == 0)
+				test = &tests[j];
+		}
+
+		/* Test modifiers */
+		if (strstr(arg, "count=") != NULL) {
+			char *p = strstr(arg, "=");
+
+			array_size = atol(p+1);
+		} else if (strcmp(arg, "wait") == 0) {
+			wait_if_ahead = 1;
+		}
+	}
+
+	if (test)
+		setup_and_run_litmus(test);
+	else
+		report(false, "Unknown test");
+
+	return report_summary();
+}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 45ac61c8..3d73e308 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -330,3 +330,34 @@ smp = $(($MAX_SMP>4?4:$MAX_SMP))
 extra_params = -append 'excl'
 groups = nodefault mttcg locking
 
+# Barrier Litmus tests
+[barrier-litmus::mp]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'mp'
+groups = nodefault mttcg barrier
+
+[barrier-litmus::mp-barrier]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'mp_barrier'
+groups = nodefault mttcg barrier
+
+[barrier-litmus::mp-acqrel]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'mp_acqrel'
+groups = nodefault mttcg barrier
+
+[barrier-litmus::sal]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'sal'
+groups = nodefault mttcg barrier
+
+[barrier-litmus::sal-barrier]
+file = barrier-litmus-test.flat
+smp = 2
+extra_params = -append 'sal_barrier'
+groups = nodefault mttcg barrier
+
-- 
2.39.2

