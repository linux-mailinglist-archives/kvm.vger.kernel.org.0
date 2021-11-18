Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C424562D5
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhKRSuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhKRSuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:50:01 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43181C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:01 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id 137so2718972wma.1
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xmjowUqqjsoP8AlfmYKLxnopZGHsSI/gJkyk5037USk=;
        b=dwUsDJypNTWzxb1xCgM9KxqhEwspTtdc1biqJsMlafe4KQ1f1qyY6m0l0Z0zHPQOsF
         d7enZDzFRQjVFro/FbUb7GXF2YQ2Zxv+nyIcw944ptCa5d5jXcOQtc3KLyyfneQN5pX0
         fWqT2VYYD359OBstUPubP14iAhvDit6Pkg2L1WRSYKtv4HRgiuQzRQvUJmNkFzQS2R0d
         I8Vn9Z5+Yax2xgIxMTu5AYd9ddW5k5a75PSGL0uH0sc/qq3hGTdeNAWciRMDKPN77Myo
         Ee1Pzw1Jca5tEv1dN9YFT6ELo8PZ2aKiu6y1gOrIAwFnD0oplu1WfU1Ut0RN6kEaXHn6
         pdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xmjowUqqjsoP8AlfmYKLxnopZGHsSI/gJkyk5037USk=;
        b=T/hXpWpHbLsWALxsinI7pL96NdC2s3tEEMr3T9f0/KyOMVlmhFPTQzqT6bmgsz3yIF
         Eg8eKYVui54zyA67RaKobCgokcNEy7vSmQNmyp0VHszmEIHz6Fmw2eTLRjJCf3vgMNiP
         xph6ZbfWZ8dbSfBjwaCja7E6quMsJAn/J3Z0tTVmGgXItl8+QC8ra6Iw4OraOGVqwOKV
         e7Xn3r3859jB/vLMFPD6dpL3fS7SpFEJGpz0ofe4XCIH6ssT51Q5XqaBzqV3YAo4AXQI
         ePIf4ekeLvnUGVF/ed2S1e76fKHKt/kfIovAI1L4DNXDw4O6zHbpYsFMTF1wkBEIXpBy
         e75Q==
X-Gm-Message-State: AOAM5308PLMDvsZEhO/tQ1yanxYSD7qh4zWVQtY3wvJ64GBe7pBEyuzq
        se2T9zTI6nTWzPa5TxntkOUPNA==
X-Google-Smtp-Source: ABdhPJzYwdTN3EnbaeoJv0JEGoIzLR7U4UyTyp2tmsc/2jx3IUjE2VKN+I4X+3k0ACY//b/8iKbVvQ==
X-Received: by 2002:a05:600c:a05:: with SMTP id z5mr12420976wmp.73.1637261219751;
        Thu, 18 Nov 2021 10:46:59 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id g124sm9269456wme.28.2021.11.18.10.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:46:55 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 67B9E1FF9D;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [kvm-unit-tests PATCH v8 06/10] arm/tlbflush-code: TLB flush during code execution
Date:   Thu, 18 Nov 2021 18:46:46 +0000
Message-Id: <20211118184650.661575-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a fairly brain dead torture test for TLB flushes intended
for stressing the MTTCG QEMU build. It takes the usual -smp option for
multiple CPUs.

By default it CPU0 will do a TLBIALL flush after each cycle. You can
pass options via -append to control additional aspects of the test:

  - "page" flush each page in turn (one per function)
  - "self" do the flush after each computation cycle
  - "verbose" report progress on each computation cycle

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
CC: Mark Rutland <mark.rutland@arm.com>

---
v2
  - rename to tlbflush-test
  - made makefile changes cleaner
  - added self/other flush mode
  - create specific prefix
  - whitespace fixes
v3
  - using new SMP framework for test runing
v4
  - merge in the unitests.cfg
v5
  - max out at -smp 4
  - printf fmtfix
v7
  - rename to tlbflush-code
  - int -> bool flags
v8
  - kernel style fixes
  - move to separate mttcgtests.cfg
---
 arm/Makefile.common |   1 +
 arm/tlbflush-code.c | 209 ++++++++++++++++++++++++++++++++++++++++++++
 arm/mttcgtests.cfg  |  30 +++++++
 3 files changed, 240 insertions(+)
 create mode 100644 arm/tlbflush-code.c
 create mode 100644 arm/mttcgtests.cfg

diff --git a/arm/Makefile.common b/arm/Makefile.common
index 99bcf3f..e3f04f2 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -12,6 +12,7 @@ tests-common += $(TEST_DIR)/gic.flat
 tests-common += $(TEST_DIR)/psci.flat
 tests-common += $(TEST_DIR)/sieve.flat
 tests-common += $(TEST_DIR)/pl031.flat
+tests-common += $(TEST_DIR)/tlbflush-code.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/tlbflush-code.c b/arm/tlbflush-code.c
new file mode 100644
index 0000000..ca98c82
--- /dev/null
+++ b/arm/tlbflush-code.c
@@ -0,0 +1,209 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * TLB Flush Race Tests
+ *
+ * These tests are designed to test for incorrect TLB flush semantics
+ * under emulation. The initial CPU will set all the others working a
+ * compuation task and will then trigger TLB flushes across the
+ * system. It doesn't actually need to re-map anything but the flushes
+ * themselves will trigger QEMU's TCG self-modifying code detection
+ * which will invalidate any generated  code causing re-translation.
+ * Eventually the code buffer will fill and a general tb_lush() will
+ * be triggered.
+ *
+ * Copyright (C) 2016-2021, Linaro, Alex Bennée <alex.bennee@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ */
+
+#include <libcflat.h>
+#include <asm/smp.h>
+#include <asm/cpumask.h>
+#include <asm/barrier.h>
+#include <asm/mmu.h>
+
+#define SEQ_LENGTH 10
+#define SEQ_HASH 0x7cd707fe
+
+static cpumask_t smp_test_complete;
+static int flush_count = 1000000;
+static bool flush_self;
+static bool flush_page;
+static bool flush_verbose;
+
+/*
+ * Work functions
+ *
+ * These work functions need to be:
+ *
+ *  - page aligned, so we can flush one function at a time
+ *  - have branches, so QEMU TCG generates multiple basic blocks
+ *  - call across pages, so we exercise the TCG basic block slow path
+ */
+
+/* Adler32 */
+__attribute__((aligned(PAGE_SIZE))) static
+uint32_t hash_array(const void *buf, size_t buflen)
+{
+	const uint8_t *data = (uint8_t *) buf;
+	uint32_t s1 = 1;
+	uint32_t s2 = 0;
+
+	for (size_t n = 0; n < buflen; n++) {
+		s1 = (s1 + data[n]) % 65521;
+		s2 = (s2 + s1) % 65521;
+	}
+	return (s2 << 16) | s1;
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+void create_fib_sequence(int length, unsigned int *array)
+{
+	int i;
+
+	/* first two values */
+	array[0] = 0;
+	array[1] = 1;
+	for (i = 2; i < length; i++)
+		array[i] = array[i-2] + array[i-1];
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+unsigned long long factorial(unsigned int n)
+{
+	unsigned int i;
+	unsigned long long fac = 1;
+
+	for (i = 1; i <= n; i++)
+		fac = fac * i;
+	return fac;
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+void factorial_array(unsigned int n, unsigned int *input,
+		     unsigned long long *output)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		output[i] = factorial(input[i]);
+}
+
+__attribute__((aligned(PAGE_SIZE))) static
+unsigned int do_computation(void)
+{
+	unsigned int fib_array[SEQ_LENGTH];
+	unsigned long long facfib_array[SEQ_LENGTH];
+	uint32_t fib_hash, facfib_hash;
+
+	create_fib_sequence(SEQ_LENGTH, &fib_array[0]);
+	fib_hash = hash_array(&fib_array[0], sizeof(fib_array));
+	factorial_array(SEQ_LENGTH, &fib_array[0], &facfib_array[0]);
+	facfib_hash = hash_array(&facfib_array[0], sizeof(facfib_array));
+
+	return (fib_hash ^ facfib_hash);
+}
+
+/* This provides a table of the work functions so we can flush each
+ * page individually
+ */
+static void *pages[] = {&hash_array, &create_fib_sequence, &factorial,
+			&factorial_array, &do_computation};
+
+static void do_flush(int i)
+{
+	if (flush_page)
+		flush_tlb_page((unsigned long)pages[i % ARRAY_SIZE(pages)]);
+	else
+		flush_tlb_all();
+}
+
+
+static void just_compute(void)
+{
+	int i, errors = 0;
+	int cpu = smp_processor_id();
+
+	uint32_t result;
+
+	printf("CPU%d online\n", cpu);
+
+	for (i = 0 ; i < flush_count; i++) {
+		result = do_computation();
+
+		if (result != SEQ_HASH) {
+			errors++;
+			printf("CPU%d: seq%d 0x%"PRIx32"!=0x%x\n",
+				cpu, i, result, SEQ_HASH);
+		}
+
+		if (flush_verbose && (i % 1000) == 0)
+			printf("CPU%d: seq%d\n", cpu, i);
+
+		if (flush_self)
+			do_flush(i);
+	}
+
+	report(errors == 0, "CPU%d: Done - Errors: %d\n", cpu, errors);
+
+	cpumask_set_cpu(cpu, &smp_test_complete);
+	if (cpu != 0)
+		halt();
+}
+
+static void just_flush(void)
+{
+	int cpu = smp_processor_id();
+	int i = 0;
+
+	/*
+	 * Set our CPU as done, keep flushing until everyone else
+	 * finished
+	 */
+	cpumask_set_cpu(cpu, &smp_test_complete);
+
+	while (!cpumask_full(&smp_test_complete))
+		do_flush(i++);
+
+	report_info("CPU%d: Done - Triggered %d flushes\n", cpu, i);
+}
+
+int main(int argc, char **argv)
+{
+	int cpu, i;
+	char prefix[100];
+
+	for (i = 0; i < argc; i++) {
+		char *arg = argv[i];
+
+		if (strcmp(arg, "page") == 0)
+			flush_page = true;
+
+		if (strcmp(arg, "self") == 0)
+			flush_self = true;
+
+		if (strcmp(arg, "verbose") == 0)
+			flush_verbose = true;
+	}
+
+	snprintf(prefix, sizeof(prefix), "tlbflush_%s_%s",
+		 flush_page?"page":"all",
+		 flush_self?"self":"other");
+	report_prefix_push(prefix);
+
+	for_each_present_cpu(cpu) {
+		if (cpu == 0)
+			continue;
+		smp_boot_secondary(cpu, just_compute);
+	}
+
+	if (flush_self)
+		just_compute();
+	else
+		just_flush();
+
+	while (!cpumask_full(&smp_test_complete))
+		cpu_relax();
+
+	return report_summary();
+}
diff --git a/arm/mttcgtests.cfg b/arm/mttcgtests.cfg
new file mode 100644
index 0000000..d3ff102
--- /dev/null
+++ b/arm/mttcgtests.cfg
@@ -0,0 +1,30 @@
+##############################################################################
+# MTTCG unit tests configuration
+#
+# These are torture tests for QEMU's Multi-threaded TCG (MTTCG) which
+# aim to trigger various races in its emulation code. You can run them
+# on a real system if you like but they shouldn't fail.
+#
+# See unittests.cfg for the file format
+##############################################################################
+
+# TLB Torture Tests
+[tlbflush-code::all_other]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+
+[tlbflush-code::page_other]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'page'
+
+[tlbflush-code::all_self]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'self'
+
+[tlbflush-code::page_self]
+file = tlbflush-code.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'page self'
+
-- 
2.30.2

