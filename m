Return-Path: <kvm+bounces-4636-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FA18815988
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:46:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F4B3280C48
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:46:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E16533CCD;
	Sat, 16 Dec 2023 13:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HFzfV98K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF2633082
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-20306386deaso1209561fac.1
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734316; x=1703339116; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LJmrD4DH3cdeEkRHraBHWWLs8eEQ/ZsCK6qzMNjQ7GM=;
        b=HFzfV98K5E0HesrxioWYtvsyKY6mAb2i22AFHTNjJJkXUF/Sy7o4JYKpI1zqOEKS3c
         wbzqaMKcYfELaEIy+Vv0+OmuXjYPn3vW000zd+XN5E0NwMfdbPGlgphHkG/+/5PUs361
         IJ+ykfE6qNYz8YyJcMgmjrGTrXfVODsTa5omve7a6r8hAu+d2Tv2jj/MiuVRIca1OqY6
         JY5rRc/kMTuO5PscsE95U20IXd77oaUS8u6DsOPZHyUHfAn8Ig/ZnkiRcWD4fdCfdyFm
         T3Hlse9UrS1MZ9x/LpV1T2cPG4/2OdvCP6hAXKapjVuPFiPQGinV9uMpAkKrnp/pwsbU
         /o6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734316; x=1703339116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LJmrD4DH3cdeEkRHraBHWWLs8eEQ/ZsCK6qzMNjQ7GM=;
        b=QwnEpWWoUfugbh47wcnJdIWwFa2VbrD0tV1+rgKcH122zqKXp4er1LfCjCXGHpdjwy
         dVXkjXwYWtFONbAzmODGWzyTFIQFRxDuzaetvQ0kCKl2JcANJMZxgjG+G0AfdJ0mq0Sa
         JHTD1FVeNdaxai4Fl7Jkpuq0zIGcs8jnNF8v9uHjSsX9FUS+aEeqkTP/Jk2LSmSwKR4g
         IJh7iC8Vqg4kX+zkTqmZqEhpep92n8T64z1TpRX97I9b/cDJpJnXv4Uw3KOXtGwGk6N+
         mw73dcrz7EsZAkOB/qpaGIcByNhfr1DCPG3bEDe0VENjCxGfOfzWv3d9shuKmMy01CpB
         qiVA==
X-Gm-Message-State: AOJu0Yx37pTsdLW30bQyMsCVqezCgavmmKUFtyTWu0T1QOtN8vCMz0uf
	vtJt7iEHy7oA9nclqLtJUORcohpFYp0=
X-Google-Smtp-Source: AGHT+IGGeAlho+mZSPmtOQg/Jfr0/6REw+iNG0NCoMDzCHLm7jtFw3n1MNH2qehR2hFQfCQ9R1VbDw==
X-Received: by 2002:a05:6870:9110:b0:203:c7a:618a with SMTP id o16-20020a056870911000b002030c7a618amr8315250oae.94.1702734316393;
        Sat, 16 Dec 2023 05:45:16 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:45:16 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v5 29/29] powerpc: Add timebase tests
Date: Sat, 16 Dec 2023 23:42:56 +1000
Message-ID: <20231216134257.1743345-30-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231216134257.1743345-1-npiggin@gmail.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This has a known failure on QEMU TCG machines where the decrementer
interrupt is not lowered when the DEC wraps from -ve to +ve.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/ppc_asm.h   |   1 +
 lib/powerpc/asm/processor.h |  22 +++
 powerpc/Makefile.common     |   1 +
 powerpc/smp.c               |  22 ---
 powerpc/timebase.c          | 328 ++++++++++++++++++++++++++++++++++++
 powerpc/unittests.cfg       |   8 +
 6 files changed, 360 insertions(+), 22 deletions(-)
 create mode 100644 powerpc/timebase.c

diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 778e78ee..18b25fe0 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -47,6 +47,7 @@
 #define SPR_HSRR1	0x13B
 #define SPR_LPCR	0x13E
 #define   LPCR_HDICE	0x1UL
+#define   LPCR_LD	0x20000UL
 #define SPR_HEIR	0x153
 #define SPR_SIAR	0x31C
 
diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index 924451da..995656b6 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -45,6 +45,28 @@ static inline void mtmsr(uint64_t msr)
 	asm volatile ("mtmsrd %[msr]" :: [msr] "r" (msr) : "memory");
 }
 
+static inline void local_irq_enable(void)
+{
+	unsigned long msr;
+
+	asm volatile(
+"		mfmsr	%0		\n \
+		ori	%0,%0,%1	\n \
+		mtmsrd	%0,1		"
+		: "=r"(msr) : "i"(MSR_EE): "memory");
+}
+
+static inline void local_irq_disable(void)
+{
+	unsigned long msr;
+
+	asm volatile(
+"		mfmsr	%0		\n \
+		andc	%0,%0,%1	\n \
+		mtmsrd	%0,1		"
+		: "=r"(msr) : "r"(MSR_EE): "memory");
+}
+
 /*
  * This returns true on PowerNV / OPAL machines which run in hypervisor
  * mode. False on pseries / PAPR machines that run in guest mode.
diff --git a/powerpc/Makefile.common b/powerpc/Makefile.common
index 697f5735..448b0ded 100644
--- a/powerpc/Makefile.common
+++ b/powerpc/Makefile.common
@@ -14,6 +14,7 @@ tests-common = \
 	$(TEST_DIR)/tm.elf \
 	$(TEST_DIR)/smp.elf \
 	$(TEST_DIR)/sprs.elf \
+	$(TEST_DIR)/timebase.elf \
 	$(TEST_DIR)/interrupts.elf
 
 tests-all = $(tests-common) $(tests)
diff --git a/powerpc/smp.c b/powerpc/smp.c
index b0a99069..60503977 100644
--- a/powerpc/smp.c
+++ b/powerpc/smp.c
@@ -43,28 +43,6 @@ static void ipi_handler(struct pt_regs *regs, void *data)
 	atomic_fetch_inc(&nr_cpus_ipi);
 }
 
-static void local_irq_enable(void)
-{
-	unsigned long msr;
-
-	asm volatile(
-"		mfmsr	%0		\n \
-		ori	%0,%0,%1	\n \
-		mtmsrd	%0,1		"
-		: "=r"(msr) : "i"(MSR_EE): "memory");
-}
-
-static void local_irq_disable(void)
-{
-	unsigned long msr;
-
-	asm volatile(
-"		mfmsr	%0		\n \
-		andc	%0,%0,%1	\n \
-		mtmsrd	%0,1		"
-		: "=r"(msr) : "r"(MSR_EE): "memory");
-}
-
 static volatile bool ipi_test_running = true;
 
 static void ipi_fn(int cpu_id)
diff --git a/powerpc/timebase.c b/powerpc/timebase.c
new file mode 100644
index 00000000..4d80ea09
--- /dev/null
+++ b/powerpc/timebase.c
@@ -0,0 +1,328 @@
+/*
+ * Test Timebase
+ *
+ * Copyright 2017  Thomas Huth, Red Hat Inc.
+ *
+ * This work is licensed under the terms of the GNU LGPL, version 2.
+ *
+ * This contains tests of timebase facility, TB, DEC, etc.
+ */
+#include <libcflat.h>
+#include <util.h>
+#include <migrate.h>
+#include <alloc.h>
+#include <asm/handlers.h>
+#include <devicetree.h>
+#include <asm/hcall.h>
+#include <asm/processor.h>
+#include <asm/barrier.h>
+
+static int dec_bits = 0;
+
+static void cpu_dec_bits(int fdtnode, u64 regval __unused, void *arg __unused)
+{
+	const struct fdt_property *prop;
+	int plen;
+
+	prop = fdt_get_property(dt_fdt(), fdtnode, "ibm,dec-bits", &plen);
+	if (!prop) {
+		dec_bits = 32;
+		return;
+	}
+
+	/* Sanity check for the property layout (first two bytes are header) */
+	assert(plen == 4);
+
+	dec_bits = fdt32_to_cpu(*(uint32_t *)prop->data);
+}
+
+/* Check amount of CPUs nodes that have the TM flag */
+static int find_dec_bits(void)
+{
+	int ret;
+
+	ret = dt_for_each_cpu_node(cpu_dec_bits, NULL);
+	if (ret < 0)
+		return ret;
+
+	return dec_bits;
+}
+
+
+static bool do_migrate = false;
+static volatile bool got_interrupt;
+static volatile struct pt_regs recorded_regs;
+
+static uint64_t dec_max;
+static uint64_t dec_min;
+
+static void test_tb(int argc, char **argv)
+{
+	uint64_t tb;
+
+	tb = get_tb();
+	if (do_migrate)
+		migrate();
+	report(get_tb() >= tb, "timebase is incrementing");
+}
+
+static void dec_stop_handler(struct pt_regs *regs, void *data)
+{
+	mtspr(SPR_DEC, dec_max);
+}
+
+static void dec_handler(struct pt_regs *regs, void *data)
+{
+	got_interrupt = true;
+	memcpy((void *)&recorded_regs, regs, sizeof(struct pt_regs));
+	regs->msr &= ~MSR_EE;
+}
+
+static void test_dec(int argc, char **argv)
+{
+	uint64_t tb1, tb2, dec;
+
+	handle_exception(0x900, &dec_handler, NULL);
+
+	tb1 = get_tb();
+	mtspr(SPR_DEC, dec_max);
+	dec = mfspr(SPR_DEC);
+	tb2 = get_tb();
+	report(tb2 - tb1 >= dec_max - dec, "decrementer remains within TB");
+	assert(tb2 - tb1 >= dec_max - dec);
+
+	tb1 = get_tb();
+	mtspr(SPR_DEC, dec_max);
+	mdelay(1000);
+	dec = mfspr(SPR_DEC);
+	tb2 = get_tb();
+	report(tb2 - tb1 >= dec_max - dec, "decrementer remains within TB after 1s");
+	assert(tb2 - tb1 >= dec_max - dec);
+
+	mtspr(SPR_DEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	if (mfspr(SPR_DEC) <= dec_max) {
+		report(!got_interrupt, "no interrupt on decrementer positive");
+	}
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, 1);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer underflow");
+	got_interrupt = false;
+
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer still underflown");
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, 0);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "DEC deal with set to 0");
+	got_interrupt = false;
+
+	/* Test for level-triggered decrementer */
+	mtspr(SPR_DEC, -1ULL);
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer write MSB");
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, dec_max);
+	local_irq_enable();
+	if (do_migrate)
+		migrate();
+	mtspr(SPR_DEC, -1);
+	local_irq_disable();
+	report(got_interrupt, "interrupt on decrementer write MSB with irqs on");
+	got_interrupt = false;
+
+	mtspr(SPR_DEC, dec_min + 1);
+	mdelay(100);
+	local_irq_enable();
+	local_irq_disable();
+	report(!got_interrupt, "no interrupt after wrap to positive");
+	got_interrupt = false;
+
+	handle_exception(0x900, NULL, NULL);
+}
+
+static void test_hdec(int argc, char **argv)
+{
+	uint64_t tb1, tb2, hdec;
+
+	if (!machine_is_powernv()) {
+		report_skip("skipping on !powernv machine");
+		return;
+	}
+
+	handle_exception(0x900, &dec_stop_handler, NULL);
+	handle_exception(0x980, &dec_handler, NULL);
+
+	mtspr(SPR_HDEC, dec_max);
+	mtspr(SPR_LPCR, mfspr(SPR_LPCR) | LPCR_HDICE);
+
+	tb1 = get_tb();
+	mtspr(SPR_HDEC, dec_max);
+	hdec = mfspr(SPR_HDEC);
+	tb2 = get_tb();
+	report(tb2 - tb1 >= dec_max - hdec, "hdecrementer remains within TB");
+	assert(tb2 - tb1 >= dec_max - hdec);
+
+	tb1 = get_tb();
+	mtspr(SPR_HDEC, dec_max);
+	mdelay(1000);
+	hdec = mfspr(SPR_HDEC);
+	tb2 = get_tb();
+	report(tb2 - tb1 >= dec_max - hdec, "hdecrementer remains within TB after 1s");
+	assert(tb2 - tb1 >= dec_max - hdec);
+
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	if (mfspr(SPR_HDEC) <= dec_max) {
+		report(!got_interrupt, "no interrupt on decrementer positive");
+	}
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, 1);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	/* HDEC is edge triggered so ensure it still fires */
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "interrupt on hdecrementer underflow");
+	got_interrupt = false;
+
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(!got_interrupt, "no interrupt on hdecrementer still underflown");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, -1ULL);
+	if (do_migrate)
+		migrate();
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "no interrupt on hdecrementer underflown write MSB");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, 0);
+	mdelay(100); /* Give the timer a chance to run */
+	if (do_migrate)
+		migrate();
+	/* HDEC is edge triggered so ensure it still fires */
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "HDEC deal with set to 0");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, dec_max);
+	local_irq_enable();
+	if (do_migrate)
+		migrate();
+	mtspr(SPR_HDEC, -1ULL);
+	local_irq_disable();
+	report(got_interrupt, "interrupt on hdecrementer write MSB with irqs on");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, dec_max);
+	got_interrupt = false;
+	mtspr(SPR_HDEC, dec_min + 1);
+	if (do_migrate)
+		migrate();
+	mdelay(100);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "got interrupt after wrap to positive");
+	got_interrupt = false;
+
+	mtspr(SPR_HDEC, -1ULL);
+	local_irq_enable();
+	local_irq_disable();
+	got_interrupt = false;
+	mtspr(SPR_HDEC, dec_min + 1000000);
+	if (do_migrate)
+		migrate();
+	mdelay(100);
+	mtspr(SPR_HDEC, -1ULL);
+	local_irq_enable();
+	local_irq_disable();
+	report(got_interrupt, "edge re-armed after wrap to positive");
+	got_interrupt = false;
+
+	mtspr(SPR_LPCR, mfspr(SPR_LPCR) & ~LPCR_HDICE);
+
+	handle_exception(0x900, NULL, NULL);
+	handle_exception(0x980, NULL, NULL);
+}
+
+struct {
+	const char *name;
+	void (*func)(int argc, char **argv);
+} hctests[] = {
+	{ "tb", test_tb },
+	{ "dec", test_dec },
+	{ "hdec", test_hdec },
+	{ NULL, NULL }
+};
+
+int main(int argc, char **argv)
+{
+	bool all;
+	int i;
+
+	all = argc == 1 || !strcmp(argv[1], "all");
+
+	for (i = 1; i < argc; i++) {
+		if (!strcmp(argv[i], "-w")) {
+			do_migrate = true;
+			if (!all && argc == 2)
+				all = true;
+		}
+	}
+
+	find_dec_bits();
+	dec_max = (1ULL << (dec_bits - 1)) - 1;
+	dec_min = (1ULL << (dec_bits - 1));
+
+	if (machine_is_powernv() && dec_bits > 32) {
+		mtspr(SPR_LPCR, mfspr(SPR_LPCR) | LPCR_LD);
+	}
+
+	report_prefix_push("timebase");
+
+	for (i = 0; hctests[i].name != NULL; i++) {
+		if (all || strcmp(argv[1], hctests[i].name) == 0) {
+			report_prefix_push(hctests[i].name);
+			hctests[i].func(argc, argv);
+			report_prefix_pop();
+		}
+	}
+
+	report_prefix_pop();
+
+	if (machine_is_powernv() && dec_bits > 32) {
+		mtspr(SPR_LPCR, mfspr(SPR_LPCR) & ~LPCR_LD);
+	}
+
+	return report_summary();
+}
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index 9f71ea93..882d48da 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -89,6 +89,14 @@ machine = pseries
 extra_params = -append '-m'
 groups = migration
 
+[timebase]
+file = timebase.elf
+
+[timebase-icount]
+file = timebase.elf
+accel = tcg
+extra_params = -icount shift=0
+
 [h_cede_tm]
 file = tm.elf
 machine = pseries
-- 
2.42.0


