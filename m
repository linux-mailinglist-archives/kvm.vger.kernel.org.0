Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4354562DC
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhKRSuJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:50:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231843AbhKRSuI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:50:08 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07D9C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:07 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c4so13400920wrd.9
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TeU0MZFr7GmLIe9/vyMfDVB2g60J2veSoHkG35ZbNRU=;
        b=Pd/DPYoZYGK6uFSc9H3U7K9hIQHjZYDFGKvzgclPl5DPJTFJduZkFHxkmqN0Q0XVt0
         olajLeeHI5UwCkb0zJPcWDdWWZDbTPtD3wcdYmSOMnsUuptkWs3YhGRjmrHUh7leXPgi
         Pxpoyl7z40zimiERppRyHD/OhSekltv6UZDAkxcqCFGoeY677nqcQS3ArwhBnt8zAl+x
         VF7gnJvvDCnGXNM9cYFlx2GqUAlIe1JGZc3z0PB+b7qAfGGb52SX9QofuY2i7UmTmH3S
         0/+TqS5gao/1ItCgFek6FkU8mP4hZ578ua5WVUzrO5sp+Cd3xf0teZhXkE8h4wah0mtx
         6SOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TeU0MZFr7GmLIe9/vyMfDVB2g60J2veSoHkG35ZbNRU=;
        b=FDWqO6+SdDc8DhgxwktXV7gsm+fro1RuIORuVS1juUGAwBTUV5zz02aqRGeHmW+oNe
         qThGfjqypEpKAGGPfZBjRuH+3J9Oa7UMuWgy1pBRpHo+f1CyRky0C8e0zAvbnT6sMW1U
         rmrZrTF28xUNBtzKysDTNV7tFC2L8KmnSpqb9d9kLDtNxEpzk/2awLfTezunQgC0/azR
         9dwuvsaSmJDMt8iSaqxl3DOypOGrTE/s7jZ1zMhUr9n74bkrJfn3a+/QJqZOrsH8xmBB
         VOsEX33OmAta4+7qEHZeOOAGk6UxsF1zTih0sdGUwqk2MEvQmwsnXTnKJoo46815yU7c
         7ITw==
X-Gm-Message-State: AOAM532nASri7fcH7x4flYcc6iDk0L8Z3tkxXewBz5Hy8IJ77W6f11k1
        t2/rGu3MQ3D7BoZOeW1anvaF5w==
X-Google-Smtp-Source: ABdhPJyi4lZaV7tRL7lIlmxYB1gYsRbfsC01Ue6vCZmf4ZgD1grz5/bZa1hgQf17fiTmeFj5lxx75w==
X-Received: by 2002:a5d:5504:: with SMTP id b4mr34601005wrv.307.1637261225964;
        Thu, 18 Nov 2021 10:47:05 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id n32sm537042wms.42.2021.11.18.10.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:47:04 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 877EA1FFA6;
        Thu, 18 Nov 2021 18:46:50 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     kvm@vger.kernel.org
Cc:     idan.horowitz@gmail.com, qemu-arm@nongnu.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        christoffer.dall@arm.com, maz@kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [kvm-unit-tests PATCH v8 10/10] arm/tcg-test: some basic TCG exercising tests
Date:   Thu, 18 Nov 2021 18:46:50 +0000
Message-Id: <20211118184650.661575-11-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118184650.661575-1-alex.bennee@linaro.org>
References: <20211118184650.661575-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These tests are not really aimed at KVM at all but exist to stretch
QEMU's TCG code generator. In particular these exercise the ability of
the TCG to:

  * Chain TranslationBlocks together (tight)
  * Handle heavy usage of the tb_jump_cache (paged)
  * Pathological case of computed local jumps (computed)

In addition the tests can be varied by adding IPI IRQs or SMC sequences
into the mix to stress the tcg_exit and invalidation mechanisms.

To explicitly stress the tb_flush() mechanism you can use the mod/rounds
parameters to force more frequent tb invalidation. Combined with setting
-tb-size 1 in QEMU to limit the code generation buffer size.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v5
  - added armv8 version of the tcg tests
  - max out at -smp 4 in unittests.cfg
  - add up IRQs sent and delivered for PASS/FAIL
  - take into account error count
  - add "rounds=" parameter
  - tweak smc to tb-size=1
  - printf fmt fix
v7
  - merged in IRQ numerology
  - updated to latest IRQ API
v8
  - fix report usage
  - fix checkpatch errors
---
 arm/Makefile.arm     |   2 +
 arm/Makefile.arm64   |   2 +
 arm/Makefile.common  |   1 +
 arm/tcg-test-asm.S   | 171 ++++++++++++++++++++++
 arm/tcg-test-asm64.S | 170 ++++++++++++++++++++++
 arm/tcg-test.c       | 338 +++++++++++++++++++++++++++++++++++++++++++
 arm/mttcgtests.cfg   |  84 +++++++++++
 7 files changed, 768 insertions(+)
 create mode 100644 arm/tcg-test-asm.S
 create mode 100644 arm/tcg-test-asm64.S
 create mode 100644 arm/tcg-test.c

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 3a4cc6b..05e47f1 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -31,4 +31,6 @@ tests =
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
+$(TEST_DIR)/tcg-test.elf: $(cstart.o) $(TEST_DIR)/tcg-test.o $(TEST_DIR)/tcg-test-asm.o
+
 arch_clean: arm_clean
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index e8a38d7..ac94f8e 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -34,5 +34,7 @@ tests += $(TEST_DIR)/cache.flat
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
+$(TEST_DIR)/tcg-test.elf: $(cstart.o) $(TEST_DIR)/tcg-test.o $(TEST_DIR)/tcg-test-asm64.o
+
 arch_clean: arm_clean
 	$(RM) lib/arm64/.*.d
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 861e5c7..abb6948 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -14,6 +14,7 @@ tests-common += $(TEST_DIR)/pl031.flat
 tests-common += $(TEST_DIR)/tlbflush-code.flat
 tests-common += $(TEST_DIR)/locking-test.flat
 tests-common += $(TEST_DIR)/barrier-litmus-test.flat
+tests-common += $(TEST_DIR)/tcg-test.flat
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
diff --git a/arm/tcg-test-asm.S b/arm/tcg-test-asm.S
new file mode 100644
index 0000000..4ec4978
--- /dev/null
+++ b/arm/tcg-test-asm.S
@@ -0,0 +1,171 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * TCG Test assembler functions for armv7 tests.
+ *
+ * Copyright (C) 2016, Linaro Ltd, Alex Bennée <alex.bennee@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ *
+ * These helper functions are written in pure asm to control the size
+ * of the basic blocks and ensure they fit neatly into page
+ * aligned chunks. The pattern of branches they follow is determined by
+ * the 32 bit seed they are passed. It should be the same for each set.
+ *
+ * Calling convention
+ *  - r0, iterations
+ *  - r1, jump pattern
+ *  - r2-r3, scratch
+ *
+ * Returns r0
+ */
+
+.arm
+
+.section .text
+
+/* Tight - all blocks should quickly be patched and should run
+ * very fast unless irqs or smc gets in the way
+ */
+
+.global tight_start
+tight_start:
+        subs    r0, r0, #1
+        beq     tight_end
+
+        ror     r1, r1, #1
+        tst     r1, #1
+        beq     tightA
+        b       tight_start
+
+tightA:
+        subs    r0, r0, #1
+        beq     tight_end
+
+        ror     r1, r1, #1
+        tst     r1, #1
+        beq     tightB
+        b       tight_start
+
+tightB:
+        subs    r0, r0, #1
+        beq     tight_end
+
+        ror     r1, r1, #1
+        tst     r1, #1
+        beq     tight_start
+        b       tightA
+
+.global tight_end
+tight_end:
+        mov     pc, lr
+
+/*
+ * Computed jumps cannot be hardwired into the basic blocks so each one
+ * will cause an exit for the main execution loop to look up the next block.
+ *
+ * There is some caching which should ameliorate the cost a little.
+ */
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+        .global computed_start
+computed_start:
+        subs    r0, r0, #1
+        beq     computed_end
+
+        /* Jump table */
+        ror     r1, r1, #1
+        and     r2, r1, #1
+        adr     r3, computed_jump_table
+        ldr     r2, [r3, r2, lsl #2]
+        mov     pc, r2
+
+        b       computed_err
+
+computed_jump_table:
+        .word   computed_start
+        .word   computedA
+
+computedA:
+        subs    r0, r0, #1
+        beq     computed_end
+
+        /* Jump into code */
+        ror     r1, r1, #1
+        and     r2, r1, #1
+        adr     r3, 1f
+        add	r3, r2, lsl #2
+        mov     pc, r3
+1:      b       computed_start
+        b       computedB
+
+        b       computed_err
+
+
+computedB:
+        subs    r0, r0, #1
+        beq     computed_end
+        ror     r1, r1, #1
+
+        /* Conditional register load */
+        adr     r3, computedA
+        tst     r1, #1
+        adreq   r3, computed_start
+        mov     pc, r3
+
+        b       computed_err
+
+computed_err:
+        mov     r0, #1
+        .global computed_end
+computed_end:
+        mov     pc, lr
+
+
+/*
+ * Page hoping
+ *
+ * Each block is in a different page, hence the blocks never get joined
+ */
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+        .global paged_start
+paged_start:
+        subs    r0, r0, #1
+        beq     paged_end
+
+        ror     r1, r1, #1
+        tst     r1, #1
+        beq     pagedA
+        b       paged_start
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+pagedA:
+        subs    r0, r0, #1
+        beq     paged_end
+
+        ror     r1, r1, #1
+        tst     r1, #1
+        beq     pagedB
+        b       paged_start
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+pagedB:
+        subs    r0, r0, #1
+        beq     paged_end
+
+        ror     r1, r1, #1
+        tst     r1, #1
+        beq     paged_start
+        b       pagedA
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+.global paged_end
+paged_end:
+        mov     pc, lr
+
+.global test_code_end
+test_code_end:
diff --git a/arm/tcg-test-asm64.S b/arm/tcg-test-asm64.S
new file mode 100644
index 0000000..2781eeb
--- /dev/null
+++ b/arm/tcg-test-asm64.S
@@ -0,0 +1,170 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * TCG Test assembler functions for armv8 tests.
+ *
+ * Copyright (C) 2016, Linaro Ltd, Alex Bennée <alex.bennee@linaro.org>
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ *
+ * These helper functions are written in pure asm to control the size
+ * of the basic blocks and ensure they fit neatly into page
+ * aligned chunks. The pattern of branches they follow is determined by
+ * the 32 bit seed they are passed. It should be the same for each set.
+ *
+ * Calling convention
+ *  - x0, iterations
+ *  - x1, jump pattern
+ *  - x2-x3, scratch
+ *
+ * Returns x0
+ */
+
+.section .text
+
+/* Tight - all blocks should quickly be patched and should run
+ * very fast unless irqs or smc gets in the way
+ */
+
+.global tight_start
+tight_start:
+        subs    x0, x0, #1
+        beq     tight_end
+
+        ror     x1, x1, #1
+        tst     x1, #1
+        beq     tightA
+        b       tight_start
+
+tightA:
+        subs    x0, x0, #1
+        beq     tight_end
+
+        ror     x1, x1, #1
+        tst     x1, #1
+        beq     tightB
+        b       tight_start
+
+tightB:
+        subs    x0, x0, #1
+        beq     tight_end
+
+        ror     x1, x1, #1
+        tst     x1, #1
+        beq     tight_start
+        b       tightA
+
+.global tight_end
+tight_end:
+        ret
+
+/*
+ * Computed jumps cannot be hardwired into the basic blocks so each one
+ * will cause an exit for the main execution loop to look up the next block.
+ *
+ * There is some caching which should ameliorate the cost a little.
+ */
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+        .global computed_start
+computed_start:
+        subs    x0, x0, #1
+        beq     computed_end
+
+        /* Jump table */
+        ror     x1, x1, #1
+        and     x2, x1, #1
+        adr     x3, computed_jump_table
+        ldr     x2, [x3, x2, lsl #3]
+        br      x2
+
+        b       computed_err
+
+computed_jump_table:
+        .quad   computed_start
+        .quad   computedA
+
+computedA:
+        subs    x0, x0, #1
+        beq     computed_end
+
+        /* Jump into code */
+        ror     x1, x1, #1
+        and     x2, x1, #1
+        adr     x3, 1f
+        add	x3, x3, x2, lsl #2
+        br      x3
+1:      b       computed_start
+        b       computedB
+
+        b       computed_err
+
+
+computedB:
+        subs    x0, x0, #1
+        beq     computed_end
+        ror     x1, x1, #1
+
+        /* Conditional register load */
+        adr     x2, computedA
+        adr     x3, computed_start
+        tst     x1, #1
+        csel    x2, x3, x2, eq
+        br      x2
+
+        b       computed_err
+
+computed_err:
+        mov     x0, #1
+        .global computed_end
+computed_end:
+        ret
+
+
+/*
+ * Page hoping
+ *
+ * Each block is in a different page, hence the blocks never get joined
+ */
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+        .global paged_start
+paged_start:
+        subs    x0, x0, #1
+        beq     paged_end
+
+        ror     x1, x1, #1
+        tst     x1, #1
+        beq     pagedA
+        b       paged_start
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+pagedA:
+        subs    x0, x0, #1
+        beq     paged_end
+
+        ror     x1, x1, #1
+        tst     x1, #1
+        beq     pagedB
+        b       paged_start
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+pagedB:
+        subs    x0, x0, #1
+        beq     paged_end
+
+        ror     x1, x1, #1
+        tst     x1, #1
+        beq     paged_start
+        b       pagedA
+
+        /* Align << 13 == 4096 byte alignment */
+        .align 13
+.global paged_end
+paged_end:
+        ret
+
+.global test_code_end
+test_code_end:
diff --git a/arm/tcg-test.c b/arm/tcg-test.c
new file mode 100644
index 0000000..fddab7b
--- /dev/null
+++ b/arm/tcg-test.c
@@ -0,0 +1,338 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * ARM TCG Tests
+ *
+ * These tests are explicitly aimed at stretching the QEMU TCG engine.
+ */
+
+#include <libcflat.h>
+#include <asm/processor.h>
+#include <asm/smp.h>
+#include <asm/cpumask.h>
+#include <asm/barrier.h>
+#include <asm/mmu.h>
+#include <asm/gic.h>
+
+#include <prng.h>
+
+#define MAX_CPUS 8
+
+/* These entry points are in the assembly code */
+extern int tight_start(uint32_t count, uint32_t pattern);
+extern int computed_start(uint32_t count, uint32_t pattern);
+extern int paged_start(uint32_t count, uint32_t pattern);
+extern uint32_t tight_end;
+extern uint32_t computed_end;
+extern uint32_t paged_end;
+extern unsigned long test_code_end;
+
+typedef int (*test_fn)(uint32_t count, uint32_t pattern);
+
+typedef struct {
+	const char *test_name;
+	bool       should_pass;
+	test_fn    start_fn;
+	uint32_t   *code_end;
+} test_descr_t;
+
+/* Test array */
+static test_descr_t tests[] = {
+       /*
+	* Tight chain.
+	*
+	* These are a bunch of basic blocks that have fixed branches in
+	* a page aligned space. The branches taken are decided by a
+	* psuedo-random bitmap for each CPU.
+	*
+	* Once the basic blocks have been chained together by the TCG they
+	* should run until they reach their block count. This will be the
+	* most efficient mode in which generated code is run. The only other
+	* exits will be caused by interrupts or TB invalidation.
+	*/
+	{ "tight", true, tight_start, &tight_end },
+	/*
+	 * Computed jumps.
+	 *
+	 * A bunch of basic blocks which just do computed jumps so the basic
+	 * block is never chained but they are all within a page (maybe not
+	 * required). This will exercise the cache lookup but not the new
+	 * generation.
+	 */
+	{ "computed", true, computed_start, &computed_end },
+	/*
+	 * Page ping pong.
+	 *
+	 * Have the blocks are separated by PAGE_SIZE so they can never
+	 * be chained together.
+	 *
+	 */
+	{ "paged", true, paged_start, &paged_end}
+};
+
+static test_descr_t *test;
+
+static int iterations = 1000000;
+static int rounds = 1000;
+static int mod_freq = 5;
+static uint32_t pattern[MAX_CPUS];
+
+/* control flags */
+static int smc;
+static int irq;
+static int check_irq;
+
+/* IRQ accounting */
+#define MAX_IRQ_IDS 16
+static int irqv;
+static unsigned long irq_sent_ts[MAX_CPUS][MAX_CPUS][MAX_IRQ_IDS];
+
+static int irq_recv[MAX_CPUS];
+static int irq_sent[MAX_CPUS];
+static int irq_overlap[MAX_CPUS];  /* if ts > now, i.e a race */
+static int irq_slow[MAX_CPUS];  /* if delay > threshold */
+static unsigned long irq_latency[MAX_CPUS]; /* cumulative time */
+
+static int errors[MAX_CPUS];
+
+static cpumask_t smp_test_complete;
+
+static cpumask_t ready;
+
+static void wait_on_ready(void)
+{
+	cpumask_set_cpu(smp_processor_id(), &ready);
+	while (!cpumask_full(&ready))
+		cpu_relax();
+}
+
+/* This triggers TCGs SMC detection by writing values to the executing
+ * code pages. We are not actually modifying the instructions and the
+ * underlying code will remain unchanged. However this should trigger
+ * invalidation of the Translation Blocks
+ */
+
+static void trigger_smc_detection(uint32_t *start, uint32_t *end)
+{
+	volatile uint32_t *ptr = start;
+
+	while (ptr < end) {
+		uint32_t inst = *ptr;
+		*ptr++ = inst;
+	}
+}
+
+/* Handler for receiving IRQs */
+
+static void irq_handler(struct pt_regs *regs __unused)
+{
+	unsigned long then, now = get_cntvct();
+	int cpu = smp_processor_id();
+	u32 irqstat = gic_read_iar();
+	u32 irqnr = gic_iar_irqnr(irqstat);
+
+	if (irqnr != GICC_INT_SPURIOUS) {
+		unsigned int src_cpu = (irqstat >> 10) & 0x7;
+
+		gic_write_eoir(irqstat);
+		irq_recv[cpu]++;
+
+		then = irq_sent_ts[src_cpu][cpu][irqnr];
+
+		if (then > now) {
+			irq_overlap[cpu]++;
+		} else {
+			unsigned long latency = (now - then);
+
+			if (latency > 30000)
+				irq_slow[cpu]++;
+			else
+				irq_latency[cpu] += latency;
+		}
+	}
+}
+
+/* This triggers cross-CPU IRQs. Each IRQ should cause the basic block
+ * execution to finish the main run-loop get entered again.
+ */
+static int send_cross_cpu_irqs(int this_cpu, int irq)
+{
+	int cpu, sent = 0;
+	cpumask_t mask;
+
+	cpumask_copy(&mask, &cpu_present_mask);
+
+	for_each_present_cpu(cpu) {
+		if (cpu != this_cpu) {
+			irq_sent_ts[this_cpu][cpu][irq] = get_cntvct();
+			cpumask_clear_cpu(cpu, &mask);
+			sent++;
+		}
+	}
+
+	gic_ipi_send_mask(irq, &mask);
+
+	return sent;
+}
+
+static void do_test(void)
+{
+	int cpu = smp_processor_id();
+	int i, irq_id = 0;
+
+	printf("CPU%d: online and setting up with pattern 0x%"PRIx32"\n",
+	       cpu, pattern[cpu]);
+
+	if (irq) {
+		gic_enable_defaults();
+#ifdef __arm__
+		install_exception_handler(EXCPTN_IRQ, irq_handler);
+#else
+		install_irq_handler(EL1H_IRQ, irq_handler);
+#endif
+		local_irq_enable();
+
+		wait_on_ready();
+	}
+
+	for (i = 0; i < rounds; i++) {
+		/* Enter the blocks */
+		errors[cpu] += test->start_fn(iterations, pattern[cpu]);
+
+		if ((i + cpu) % mod_freq == 0) {
+			if (smc)
+				trigger_smc_detection((uint32_t *) test->start_fn,
+						      test->code_end);
+
+			if (irq) {
+				irq_sent[cpu] += send_cross_cpu_irqs(cpu, irq_id);
+				irq_id++;
+				irq_id = irq_id % 15;
+			}
+		}
+	}
+
+	/* ensure everything complete before we finish */
+	smp_wmb();
+
+	cpumask_set_cpu(cpu, &smp_test_complete);
+	if (cpu != 0)
+		halt();
+}
+
+static void report_irq_stats(int cpu)
+{
+	int recv = irq_recv[cpu];
+	int race = irq_overlap[cpu];
+	int slow = irq_slow[cpu];
+
+	unsigned long avg_latency = irq_latency[cpu] / (recv - (race + slow));
+
+	printf("CPU%d: %d irqs (%d races, %d slow,  %ld ticks avg latency)\n",
+		cpu, recv, race, slow, avg_latency);
+}
+
+
+static void setup_and_run_tcg_test(void)
+{
+	static const unsigned char seed[] = "tcg-test";
+	struct isaac_ctx prng_context;
+	int cpu;
+	int total_err = 0, total_sent = 0, total_recv = 0;
+
+	isaac_init(&prng_context, &seed[0], sizeof(seed));
+
+	/* boot other CPUs */
+	for_each_present_cpu(cpu) {
+		pattern[cpu] = isaac_next_uint32(&prng_context);
+
+		if (cpu == 0)
+			continue;
+
+		smp_boot_secondary(cpu, do_test);
+	}
+
+	do_test();
+
+	while (!cpumask_full(&smp_test_complete))
+		cpu_relax();
+
+	/* Ensure everything completes before we check the data */
+	smp_mb();
+
+	/* Now total up errors and irqs */
+	for_each_present_cpu(cpu) {
+		total_err += errors[cpu];
+		total_sent += irq_sent[cpu];
+		total_recv += irq_recv[cpu];
+
+		if (check_irq)
+			report_irq_stats(cpu);
+	}
+
+	if (check_irq)
+		report(total_sent == total_recv && total_err == 0,
+		       "%d IRQs sent, %d received, %d errors\n",
+		       total_sent, total_recv, total_err == 0);
+	else
+		report(total_err == 0, "%d errors, IRQs not checked", total_err);
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+	unsigned int j;
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
+		if (strstr(arg, "mod=") != NULL) {
+			char *p = strstr(arg, "=");
+
+			mod_freq = atol(p+1);
+		}
+
+		if (strstr(arg, "rounds=") != NULL) {
+			char *p = strstr(arg, "=");
+
+			rounds = atol(p+1);
+		}
+
+		if (strcmp(arg, "smc") == 0) {
+			unsigned long test_start = (unsigned long) &tight_start;
+			unsigned long test_end = (unsigned long) &test_code_end;
+
+			smc = 1;
+			mmu_set_range_ptes(mmu_idmap, test_start, test_start, test_end,
+					__pgprot(PTE_WBWA));
+
+			report_prefix_push("smc");
+		}
+
+		if (strcmp(arg, "irq") == 0) {
+			irq = 1;
+			if (!gic_init())
+				report_abort("No supported gic present!");
+			irqv = gic_version();
+			report_prefix_push("irq");
+		}
+
+		if (strcmp(arg, "check_irq") == 0)
+			check_irq = 1;
+	}
+
+	if (test) {
+		/* ensure args visible to all cores */
+		smp_mb();
+		setup_and_run_tcg_test();
+	} else {
+		report(false, "Unknown test");
+	}
+
+	return report_summary();
+}
diff --git a/arm/mttcgtests.cfg b/arm/mttcgtests.cfg
index 2b46756..046a59c 100644
--- a/arm/mttcgtests.cfg
+++ b/arm/mttcgtests.cfg
@@ -90,3 +90,87 @@ smp = 2
 extra_params = -append 'sal_barrier'
 groups = barrier
 
+# TCG Tests
+[tcg::tight]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'tight'
+groups = tcg
+accel = tcg
+
+[tcg::tight-smc]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'tight smc' -accel tcg,tb-size=1
+groups = tcg
+accel = tcg
+
+[tcg::tight-irq]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'tight irq'
+groups = tcg
+accel = tcg
+
+[tcg::tight-smc-irq]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'tight smc irq'
+groups = tcg
+accel = tcg
+
+[tcg::computed]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'computed'
+groups = tcg
+accel = tcg
+
+[tcg::computed-smc]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'computed smc'
+groups = tcg
+accel = tcg
+
+[tcg::computed-irq]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'computed irq'
+groups = tcg
+accel = tcg
+
+[tcg::computed-smc-irq]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'computed smc irq'
+groups = tcg
+accel = tcg
+
+[tcg::paged]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'paged'
+groups = tcg
+accel = tcg
+
+[tcg::paged-smc]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'paged smc'
+groups = tcg
+accel = tcg
+
+[tcg::paged-irq]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'paged irq'
+groups = tcg
+accel = tcg
+
+[tcg::paged-smc-irq]
+file = tcg-test.flat
+smp = $(($MAX_SMP>4?4:$MAX_SMP))
+extra_params = -append 'paged smc irq'
+groups = tcg
+accel = tcg
-- 
2.30.2

