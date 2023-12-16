Return-Path: <kvm+bounces-4628-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE6F681597F
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 14:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D04461C20B53
	for <lists+kvm@lfdr.de>; Sat, 16 Dec 2023 13:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF83F31A66;
	Sat, 16 Dec 2023 13:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHZpZaeo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3442D31A64
	for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-20373729148so955627fac.0
        for <kvm@vger.kernel.org>; Sat, 16 Dec 2023 05:44:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702734284; x=1703339084; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXhx0dEQqA27dPQgMv49h/VabjNlnjfNK0b6EribS3U=;
        b=FHZpZaeoESaBiLSyXfz9hV3AuGeeIUcbHf43OPNz1ze/Sqfz7+APxzPbVZyWlwZenN
         pfUYGRgSI2UqxROio18jZf0pqV2lpbjFTV2hn2HNEBQwffU2sv3a3hYzsGIelU19uRox
         efi2QthZsv+xKbyJJEN1WOriMjQjFN6Hv9TgFbQk7yk2VaQj+09b8hNuA/3TKpa+67ct
         E2HE5Oe9mlBGCDsFFpzDfahltRwNouBbXaYmdMBXAqaI/23CuOuOOb5XKMm6M6h0YgmX
         U6MpGz3SBYHZJpTLHgKnumGiPIrtb6qwcP7RtM5ZNAgH0oKZP4CSJAmh5JXxjRBVoDAp
         ojtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702734284; x=1703339084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tXhx0dEQqA27dPQgMv49h/VabjNlnjfNK0b6EribS3U=;
        b=QYx7OH3eviToChWRxFsqdJpLhNrrgyPNahFywJE++DdeYkoemZ3AvgujeW3c6QtH/0
         EyTP+LY2rj4Yr70CG4uNpdZCqr4xga/nzep2sMNfeCuhz/+4UdYyKZLmOzzDc9PnNBva
         BmoiKoLGmYe4w5+sgP4mtvif+F40Tcw++IsS0XvY0M+hhjNI05aafMMIVjHaSkjgpohG
         22UhVfZ/R2P7FqT0Pp/yvlIW2WSXl6nTf1EP9zpSnFyYn5uNKWdLgLZXvPxJguVTpq16
         AILNUpU8o/za1eC5A8f1af6iMxnFuGMcajmepg1FrucG/R1GDRgs9XsazfRfXqNrHj5P
         JAZg==
X-Gm-Message-State: AOJu0Ywb9k46GFF7x852lj5lNMLa76m17209oKSg6tJkacALWzuhb2Jd
	cuAI2kPnUYntNy2vzoXnmRfp1Boz/to=
X-Google-Smtp-Source: AGHT+IGsQe24pcU1e9vxlLacrHDOUgexMGRsq19H2rN9GVKzLNTUGCKl2TKpGsipuQi2+IIRZKlb+g==
X-Received: by 2002:a05:6870:9f14:b0:1fb:75a:de6f with SMTP id xl20-20020a0568709f1400b001fb075ade6fmr17401083oab.93.1702734283840;
        Sat, 16 Dec 2023 05:44:43 -0800 (PST)
Received: from wheely.local0.net (203-221-42-190.tpgi.com.au. [203.221.42.190])
        by smtp.gmail.com with ESMTPSA id w2-20020a654102000000b005c65ed23b65sm12663631pgp.94.2023.12.16.05.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Dec 2023 05:44:43 -0800 (PST)
From: Nicholas Piggin <npiggin@gmail.com>
To: kvm@vger.kernel.org
Cc: Nicholas Piggin <npiggin@gmail.com>,
	linuxppc-dev@lists.ozlabs.org,
	Laurent Vivier <lvivier@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	"Shaoqin Huang" <shahuang@redhat.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	Nico Boehr <nrb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [kvm-unit-tests PATCH v5 21/29] powerpc: Support powernv machine with QEMU TCG
Date: Sat, 16 Dec 2023 23:42:48 +1000
Message-ID: <20231216134257.1743345-22-npiggin@gmail.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231216134257.1743345-1-npiggin@gmail.com>
References: <20231216134257.1743345-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add support for QEMU's powernv machine. This uses standard firmware
(skiboot) rather than a minimal firmware shim.

Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 lib/powerpc/asm/ppc_asm.h   |  6 +++
 lib/powerpc/asm/processor.h | 13 +++++++
 lib/powerpc/hcall.c         |  4 +-
 lib/powerpc/io.c            | 27 ++++++++++++-
 lib/powerpc/io.h            |  6 +++
 lib/powerpc/processor.c     | 37 ++++++++++++++++++
 lib/powerpc/setup.c         | 10 +++--
 lib/ppc64/asm/opal.h        | 15 ++++++++
 lib/ppc64/opal-calls.S      | 46 ++++++++++++++++++++++
 lib/ppc64/opal.c            | 76 +++++++++++++++++++++++++++++++++++++
 powerpc/Makefile.ppc64      |  2 +
 powerpc/cstart64.S          |  7 ++++
 powerpc/run                 | 38 ++++++++++++++++---
 powerpc/unittests.cfg       |  8 ++++
 14 files changed, 282 insertions(+), 13 deletions(-)
 create mode 100644 lib/ppc64/asm/opal.h
 create mode 100644 lib/ppc64/opal-calls.S
 create mode 100644 lib/ppc64/opal.c

diff --git a/lib/powerpc/asm/ppc_asm.h b/lib/powerpc/asm/ppc_asm.h
index 46b4be00..ef2d91dd 100644
--- a/lib/powerpc/asm/ppc_asm.h
+++ b/lib/powerpc/asm/ppc_asm.h
@@ -39,7 +39,13 @@
 #define SPR_HSRR1	0x13B
 
 /* Machine State Register definitions: */
+#define MSR_LE_BIT	0
 #define MSR_EE_BIT	15			/* External Interrupts Enable */
+#define MSR_HV_BIT	60			/* Hypervisor mode */
 #define MSR_SF_BIT	63			/* 64-bit mode */
+#define MSR_ME		0x1000ULL
+
+#define SPR_HSRR0	0x13A
+#define SPR_HSRR1	0x13B
 
 #endif /* _ASMPOWERPC_PPC_ASM_H */
diff --git a/lib/powerpc/asm/processor.h b/lib/powerpc/asm/processor.h
index 4ad6612b..6368a9ee 100644
--- a/lib/powerpc/asm/processor.h
+++ b/lib/powerpc/asm/processor.h
@@ -3,6 +3,7 @@
 
 #include <libcflat.h>
 #include <asm/ptrace.h>
+#include <asm/ppc_asm.h>
 
 #ifndef __ASSEMBLY__
 void handle_exception(int trap, void (*func)(struct pt_regs *, void *), void *);
@@ -43,6 +44,15 @@ static inline void mtmsr(uint64_t msr)
 	asm volatile ("mtmsrd %[msr]" :: [msr] "r" (msr) : "memory");
 }
 
+/*
+ * This returns true on PowerNV / OPAL machines which run in hypervisor
+ * mode. False on pseries / PAPR machines that run in guest mode.
+ */
+static inline bool machine_is_powernv(void)
+{
+	return !!(mfmsr() & (1ULL << MSR_HV_BIT));
+}
+
 static inline uint64_t get_tb(void)
 {
 	return mfspr(SPR_TB);
@@ -64,4 +74,7 @@ static inline void msleep(uint64_t ms)
 	usleep(ms * 1000);
 }
 
+void enable_mcheck(void);
+void disable_mcheck(void);
+
 #endif /* _ASMPOWERPC_PROCESSOR_H_ */
diff --git a/lib/powerpc/hcall.c b/lib/powerpc/hcall.c
index 711cb1b0..37e52f54 100644
--- a/lib/powerpc/hcall.c
+++ b/lib/powerpc/hcall.c
@@ -25,7 +25,7 @@ int hcall_have_broken_sc1(void)
 	return r3 == (unsigned long)H_PRIVILEGE;
 }
 
-void putchar(int c)
+void papr_putchar(int c)
 {
 	unsigned long vty = 0;		/* 0 == default */
 	unsigned long nr_chars = 1;
@@ -34,7 +34,7 @@ void putchar(int c)
 	hcall(H_PUT_TERM_CHAR, vty, nr_chars, chars);
 }
 
-int __getchar(void)
+int __papr_getchar(void)
 {
 	register unsigned long r3 asm("r3") = H_GET_TERM_CHAR;
 	register unsigned long r4 asm("r4") = 0; /* 0 == default vty */
diff --git a/lib/powerpc/io.c b/lib/powerpc/io.c
index a381688b..ab7bb843 100644
--- a/lib/powerpc/io.c
+++ b/lib/powerpc/io.c
@@ -9,13 +9,33 @@
 #include <asm/spinlock.h>
 #include <asm/rtas.h>
 #include <asm/setup.h>
+#include <asm/processor.h>
 #include "io.h"
 
 static struct spinlock print_lock;
 
+void putchar(int c)
+{
+	if (machine_is_powernv())
+		opal_putchar(c);
+	else
+		papr_putchar(c);
+}
+
+int __getchar(void)
+{
+	if (machine_is_powernv())
+		return __opal_getchar();
+	else
+		return __papr_getchar();
+}
+
 void io_init(void)
 {
-	rtas_init();
+	if (machine_is_powernv())
+		assert(!opal_init());
+	else
+		rtas_init();
 }
 
 void puts(const char *s)
@@ -38,7 +58,10 @@ void exit(int code)
 // FIXME: change this print-exit/rtas-poweroff to chr_testdev_exit(),
 //        maybe by plugging chr-testdev into a spapr-vty.
 	printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);
-	rtas_power_off();
+	if (machine_is_powernv())
+		opal_power_off();
+	else
+		rtas_power_off();
 	halt(code);
 	__builtin_unreachable();
 }
diff --git a/lib/powerpc/io.h b/lib/powerpc/io.h
index d4f21ba1..943bf142 100644
--- a/lib/powerpc/io.h
+++ b/lib/powerpc/io.h
@@ -8,6 +8,12 @@
 #define _POWERPC_IO_H_
 
 extern void io_init(void);
+extern int opal_init(void);
+extern void opal_power_off(void);
 extern void putchar(int c);
+extern void opal_putchar(int c);
+extern void papr_putchar(int c);
+extern int __opal_getchar(void);
+extern int __papr_getchar(void);
 
 #endif
diff --git a/lib/powerpc/processor.c b/lib/powerpc/processor.c
index b224fc8e..ef184d8d 100644
--- a/lib/powerpc/processor.c
+++ b/lib/powerpc/processor.c
@@ -71,6 +71,16 @@ void sleep_tb(uint64_t cycles)
 {
 	uint64_t start, end, now;
 
+	if (machine_is_powernv()) {
+		/*
+		 * Could use 'stop' to sleep here which would be interesting.
+		 * stop with ESL=0 should be simple enough, ESL=1 would require
+		 * SRESET based wakeup which is more involved.
+		 */
+		delay(cycles);
+		return;
+	}
+
 	start = now = get_tb();
 	end = start + cycles;
 
@@ -107,3 +117,30 @@ void usleep(uint64_t us)
 {
 	sleep_tb((us * tb_hz) / 1000000);
 }
+
+static void rfid_msr(uint64_t msr)
+{
+	uint64_t tmp;
+
+	asm volatile(
+		"mtsrr1	%1		\n\
+		 bl	0f		\n\
+		 0:			\n\
+		 mflr	%0		\n\
+		 addi	%0,%0,1f-0b	\n\
+		 mtsrr0	%0		\n\
+		 rfid			\n\
+		 1:			\n"
+		: "=r"(tmp) : "r"(msr) : "lr");
+}
+
+void enable_mcheck(void)
+{
+	/* This is a no-op on pseries */
+	rfid_msr(mfmsr() | MSR_ME);
+}
+
+void disable_mcheck(void)
+{
+	rfid_msr(mfmsr() & ~MSR_ME);
+}
diff --git a/lib/powerpc/setup.c b/lib/powerpc/setup.c
index d98f66fa..2b7e27b0 100644
--- a/lib/powerpc/setup.c
+++ b/lib/powerpc/setup.c
@@ -19,6 +19,7 @@
 #include <asm/setup.h>
 #include <asm/page.h>
 #include <asm/ptrace.h>
+#include <asm/processor.h>
 #include <asm/hcall.h>
 #include "io.h"
 
@@ -98,12 +99,13 @@ static void cpu_init(void)
 	tb_hz = params.tb_hz;
 
 	/* Interrupt Endianness */
-
+	if (!machine_is_powernv()) {
 #if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-        hcall(H_SET_MODE, 1, 4, 0, 0);
+		hcall(H_SET_MODE, 1, 4, 0, 0);
 #else
-        hcall(H_SET_MODE, 0, 4, 0, 0);
+		hcall(H_SET_MODE, 0, 4, 0, 0);
 #endif
+	}
 }
 
 static void mem_init(phys_addr_t freemem_start)
@@ -159,6 +161,8 @@ void setup(const void *fdt)
 	u32 fdt_size;
 	int ret;
 
+	enable_mcheck();
+
 	/*
 	 * Before calling mem_init we need to move the fdt and initrd
 	 * to safe locations. We move them to construct the memory
diff --git a/lib/ppc64/asm/opal.h b/lib/ppc64/asm/opal.h
new file mode 100644
index 00000000..7b1299f7
--- /dev/null
+++ b/lib/ppc64/asm/opal.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _ASMPPC64_HCALL_H_
+#define _ASMPPC64_HCALL_H_
+
+#define OPAL_SUCCESS				0
+
+#define OPAL_CONSOLE_WRITE			1
+#define OPAL_CONSOLE_READ			2
+#define OPAL_CEC_POWER_DOWN			5
+#define OPAL_POLL_EVENTS			10
+#define OPAL_REINIT_CPUS			70
+# define OPAL_REINIT_CPUS_HILE_BE		(1 << 0)
+# define OPAL_REINIT_CPUS_HILE_LE		(1 << 1)
+
+#endif
diff --git a/lib/ppc64/opal-calls.S b/lib/ppc64/opal-calls.S
new file mode 100644
index 00000000..1833358c
--- /dev/null
+++ b/lib/ppc64/opal-calls.S
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2016 IBM Corporation.
+ */
+
+#include <asm/ppc_asm.h>
+
+	.text
+	.globl opal_call
+opal_call:
+	mr	r0,r3
+	mr	r3,r4
+	mr	r4,r5
+	mr	r5,r6
+	mr	r6,r7
+	mflr	r11
+	std	r11,16(r1)
+	mfcr	r12
+	stw	r12,8(r1)
+	mr	r13,r2
+
+	/* Set opal return address */
+	LOAD_REG_ADDR(r11, opal_return)
+	mtlr	r11
+	mfmsr	r12
+
+	/* switch to BE when we enter OPAL */
+	li	r11,(1 << MSR_LE_BIT)
+	andc	r12,r12,r11
+	mtspr	SPR_HSRR1,r12
+
+	/* load the opal call entry point and base */
+	LOAD_REG_ADDR(r11, opal)
+	ld	r12,8(r11)
+	ld	r2,0(r11)
+	mtspr	SPR_HSRR0,r12
+	hrfid
+
+opal_return:
+	FIXUP_ENDIAN
+	mr	r2,r13;
+	lwz	r11,8(r1);
+	ld	r12,16(r1)
+	mtcr	r11;
+	mtlr	r12
+	blr
diff --git a/lib/ppc64/opal.c b/lib/ppc64/opal.c
new file mode 100644
index 00000000..63fe42ae
--- /dev/null
+++ b/lib/ppc64/opal.c
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * OPAL call helpers
+ */
+#include <asm/opal.h>
+#include <libcflat.h>
+#include <libfdt/libfdt.h>
+#include <devicetree.h>
+#include <asm/io.h>
+#include "../powerpc/io.h"
+
+struct opal {
+	uint64_t base;
+	uint64_t entry;
+} opal;
+
+extern int64_t opal_call(int64_t token, int64_t arg1, int64_t arg2, int64_t arg3);
+
+int opal_init(void)
+{
+	const struct fdt_property *prop;
+	int node, len;
+
+	node = fdt_path_offset(dt_fdt(), "/ibm,opal");
+	if (node < 0)
+		return -1;
+
+	prop = fdt_get_property(dt_fdt(), node, "opal-base-address", &len);
+	if (!prop)
+		return -1;
+	opal.base = fdt64_to_cpu(*(uint64_t *)prop->data);
+
+	prop = fdt_get_property(dt_fdt(), node, "opal-entry-address", &len);
+	if (!prop)
+		return -1;
+	opal.entry = fdt64_to_cpu(*(uint64_t *)prop->data);
+
+#if  __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	if (opal_call(OPAL_REINIT_CPUS, OPAL_REINIT_CPUS_HILE_LE, 0, 0) != OPAL_SUCCESS)
+		return -1;
+#endif
+
+	return 0;
+}
+
+extern void opal_power_off(void)
+{
+	opal_call(OPAL_CEC_POWER_DOWN, 0, 0, 0);
+	while (true)
+		opal_call(OPAL_POLL_EVENTS, 0, 0, 0);
+}
+
+void opal_putchar(int c)
+{
+	unsigned long vty = 0;		/* 0 == default */
+	unsigned long nr_chars = cpu_to_be64(1);
+	char ch = c;
+
+	opal_call(OPAL_CONSOLE_WRITE, (int64_t)vty, (int64_t)&nr_chars, (int64_t)&ch);
+}
+
+int __opal_getchar(void)
+{
+	unsigned long vty = 0;		/* 0 == default */
+	unsigned long nr_chars = cpu_to_be64(1);
+	char ch;
+	int rc;
+
+	rc = opal_call(OPAL_CONSOLE_READ, (int64_t)vty, (int64_t)&nr_chars, (int64_t)&ch);
+	if (rc != OPAL_SUCCESS)
+		return -1;
+	if (nr_chars == 0)
+		return -1;
+
+	return ch;
+}
diff --git a/powerpc/Makefile.ppc64 b/powerpc/Makefile.ppc64
index b0ed2b10..06a7cf67 100644
--- a/powerpc/Makefile.ppc64
+++ b/powerpc/Makefile.ppc64
@@ -17,6 +17,8 @@ cstart.o = $(TEST_DIR)/cstart64.o
 reloc.o  = $(TEST_DIR)/reloc64.o
 
 OBJDIRS += lib/ppc64
+cflatobjs += lib/ppc64/opal.o
+cflatobjs += lib/ppc64/opal-calls.o
 
 # ppc64 specific tests
 tests = $(TEST_DIR)/spapr_vpa.elf
diff --git a/powerpc/cstart64.S b/powerpc/cstart64.S
index 14ab0c6c..51d632da 100644
--- a/powerpc/cstart64.S
+++ b/powerpc/cstart64.S
@@ -100,6 +100,13 @@ start:
 	sync
 	isync
 
+	/* powernv machine does not check broken_sc1 */
+	mfmsr	r3
+	li	r4,1
+	sldi	r4,r4,MSR_HV_BIT
+	and.	r3,r3,r4
+	bne	1f
+
 	/* patch sc1 if needed */
 	bl	hcall_have_broken_sc1
 	cmpwi	r3, 0
diff --git a/powerpc/run b/powerpc/run
index e469f1eb..6fe6d31b 100755
--- a/powerpc/run
+++ b/powerpc/run
@@ -1,5 +1,14 @@
 #!/usr/bin/env bash
 
+get_qemu_machine ()
+{
+	if [ "$MACHINE" ]; then
+		echo $MACHINE
+	else
+		echo pseries
+	fi
+}
+
 if [ -z "$KUT_STANDALONE" ]; then
 	if [ ! -f config.mak ]; then
 		echo "run ./configure && make first. See ./configure -h"
@@ -11,22 +20,39 @@ fi
 
 set_qemu_accelerator || exit $?
 
+MACHINE=$(get_qemu_machine) ||
+	exit $?
+
+if [[ "$MACHINE" == "powernv"* ]] && [ "$ACCEL" = "kvm" ]; then
+	echo "PowerNV machine does not support KVM. ACCEL=tcg must be specified."
+	exit 2
+fi
+
 qemu=$(search_qemu_binary) ||
 	exit $?
 
-if ! $qemu -machine '?' 2>&1 | grep 'pseries' > /dev/null; then
-	echo "$qemu doesn't support pSeries ('-machine pseries'). Exiting."
+if ! $qemu -machine '?' 2>&1 | grep $MACHINE > /dev/null; then
+	echo "$qemu doesn't support '-machine $MACHINE'. Exiting."
 	exit 2
 fi
 
-M='-machine pseries'
+M="-machine $MACHINE"
 M+=",accel=$ACCEL$ACCEL_PROPS"
+B=""
+D=""
+
+if [[ "$MACHINE" == "pseries"* ]] ; then
+	if [[ "$ACCEL" == "tcg" ]] ; then
+		M+=",cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off"
+	fi
+	B+="-bios $FIRMWARE"
+fi
 
-if [[ "$ACCEL" == "tcg" ]] ; then
-	M+=",cap-cfpc=broken,cap-sbbc=broken,cap-ibs=broken,cap-ccf-assist=off"
+if [[ "$MACHINE" == "powernv"* ]] ; then
+	D+="-device ipmi-bmc-sim,id=bmc0 -device isa-ipmi-bt,bmc=bmc0,irq=10"
 fi
 
-command="$qemu -nodefaults $M -bios $FIRMWARE"
+command="$qemu -nodefaults $M $B $D"
 command+=" -display none -serial stdio -kernel"
 command="$(migration_cmd) $(timeout_cmd) $command"
 
diff --git a/powerpc/unittests.cfg b/powerpc/unittests.cfg
index e71140aa..5d6ba852 100644
--- a/powerpc/unittests.cfg
+++ b/powerpc/unittests.cfg
@@ -32,30 +32,36 @@
 #
 [selftest-setup]
 file = selftest.elf
+machine = pseries
 smp = 2
 extra_params = -m 256 -append 'setup smp=2 mem=256'
 groups = selftest
 
 [spapr_hcall]
 file = spapr_hcall.elf
+machine = pseries
 
 [spapr_vpa]
 file = spapr_vpa.elf
+machine = pseries
 
 [rtas-get-time-of-day]
 file = rtas.elf
+machine = pseries
 timeout = 5
 extra_params = -append "get-time-of-day date=$(date +%s)"
 groups = rtas
 
 [rtas-get-time-of-day-base]
 file = rtas.elf
+machine = pseries
 timeout = 5
 extra_params = -rtc base="2006-06-17" -append "get-time-of-day date=$(date --date="2006-06-17 UTC" +%s)"
 groups = rtas
 
 [rtas-set-time-of-day]
 file = rtas.elf
+machine = pseries
 extra_params = -append "set-time-of-day"
 timeout = 5
 groups = rtas
@@ -65,6 +71,7 @@ file = emulator.elf
 
 [h_cede_tm]
 file = tm.elf
+machine = pseries
 accel = kvm
 smp = 2,threads=2
 extra_params = -machine cap-htm=on -append "h_cede_tm"
@@ -75,5 +82,6 @@ file = sprs.elf
 
 [sprs-migration]
 file = sprs.elf
+machine = pseries
 extra_params = -append '-w'
 groups = migration
-- 
2.42.0


