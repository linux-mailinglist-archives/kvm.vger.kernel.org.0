Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82FD72F3181
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 14:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732994AbhALNWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 08:22:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58594 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726970AbhALNV7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 08:21:59 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CDDBgp134454;
        Tue, 12 Jan 2021 08:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kb3RxL14zkqTl2ty5OLmSTF/wnQ3HNAg/GbY+IUoiN0=;
 b=NY5UCIvqemegjz41y5h2ioRXnIlET8S7xza0yVBUNd0ues1kKpV5uGddcjX4AYD2LAPs
 kvR2STfNAlov8zgaeuc/lVi3UP9Srb415vSon9JD0GZ0E+Lq8vdgvw7RSRlA87sW06Fn
 OvRa8pQJMYHjQuVo+3Cho555S4aa69tED5YY8Bp13w0XFKeFzxxxKttIM3EBoFeo/yAE
 ilO9VO0THHDVWU2ZwRs5hsNelFjeeczzPfz4SX1wioFSU4cJ5pxW32WcbsBrWftQt981
 HNjj3/ESvywc/+9XpuuqNBDgqg0ej/IxzRM3hsmYEudLPQ7ZmBCFN3jTN8VVmqiCsQXU Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361cey08nj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:19 -0500
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CDDAX3134406;
        Tue, 12 Jan 2021 08:21:18 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361cey08mk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:21:18 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CDH1wu021733;
        Tue, 12 Jan 2021 13:21:16 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04fra.de.ibm.com with ESMTP id 3604h9964y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:21:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CDL8i030802252
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 13:21:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F17394C052;
        Tue, 12 Jan 2021 13:21:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CB0A4C040;
        Tue, 12 Jan 2021 13:21:12 +0000 (GMT)
Received: from linux01.pok.stglabs.ibm.com (unknown [9.114.17.81])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 13:21:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, david@redhat.com, borntraeger@de.ibm.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 4/9] s390x: Split assembly into multiple files
Date:   Tue, 12 Jan 2021 08:20:49 -0500
Message-Id: <20210112132054.49756-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210112132054.49756-1-frankja@linux.ibm.com>
References: <20210112132054.49756-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_07:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 phishscore=0 impostorscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120071
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've added too much to cstart64.S which is not start related
already. Now that I want to add even more code it's time to split
cstart64.S. lib.S has functions that are used in tests. macros.S
contains macros which are used in cstart64.S and lib.S

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/Makefile   |   6 +--
 s390x/cstart64.S | 119 ++---------------------------------------------
 s390x/lib.S      |  65 ++++++++++++++++++++++++++
 s390x/macros.S   |  77 ++++++++++++++++++++++++++++++
 4 files changed, 149 insertions(+), 118 deletions(-)
 create mode 100644 s390x/lib.S
 create mode 100644 s390x/macros.S

diff --git a/s390x/Makefile b/s390x/Makefile
index b079a26..e0bccc8 100644
--- a/s390x/Makefile
+++ b/s390x/Makefile
@@ -66,10 +66,10 @@ cflatobjs += lib/s390x/css_lib.o
 
 OBJDIRS += lib/s390x
 
-cstart.o = $(TEST_DIR)/cstart64.o
+asmlib = $(TEST_DIR)/cstart64.o $(TEST_DIR)/lib.o
 
 FLATLIBS = $(libcflat)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(cstart.o)
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/s390x/flat.lds $(asmlib)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) \
 		$(SRCDIR)/lib/auxinfo.c -DPROGNAME=\"$@\"
 	$(CC) $(LDFLAGS) -o $@ -T $(SRCDIR)/s390x/flat.lds \
@@ -90,4 +90,4 @@ arch_clean: asm_offsets_clean
 	$(RM) $(TEST_DIR)/*.{o,elf,bin} $(TEST_DIR)/.*.d lib/s390x/.*.d
 
 generated-files = $(asm-offsets)
-$(tests:.elf=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests:.elf=.o) $(asmlib) $(cflatobjs): $(generated-files)
diff --git a/s390x/cstart64.S b/s390x/cstart64.S
index cc86fc7..ace0c0d 100644
--- a/s390x/cstart64.S
+++ b/s390x/cstart64.S
@@ -3,14 +3,17 @@
  * s390x startup code
  *
  * Copyright (c) 2017 Red Hat Inc
+ * Copyright (c) 2019 IBM Corp.
  *
  * Authors:
  *  Thomas Huth <thuth@redhat.com>
  *  David Hildenbrand <david@redhat.com>
+ *  Janosch Frank <frankja@linux.ibm.com>
  */
 #include <asm/asm-offsets.h>
 #include <asm/sigp.h>
 
+#include "macros.S"
 .section .init
 
 /*
@@ -87,120 +90,7 @@ clear_bss_remainder:
 memsetxc:
 	xc 0(1,%r1),0(%r1)
 
-	.macro SAVE_REGS
-	/* save grs 0-15 */
-	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
-	/* save crs 0-15 */
-	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
-	/* load a cr0 that has the AFP control bit which enables all FPRs */
-	larl	%r1, initial_cr0
-	lctlg	%c0, %c0, 0(%r1)
-	/* save fprs 0-15 + fpc */
-	la	%r1, GEN_LC_SW_INT_FPRS
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	std	\i, \i * 8(%r1)
-	.endr
-	stfpc	GEN_LC_SW_INT_FPC
-	.endm
-
-	.macro RESTORE_REGS
-	/* restore fprs 0-15 + fpc */
-	la	%r1, GEN_LC_SW_INT_FPRS
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	ld	\i, \i * 8(%r1)
-	.endr
-	lfpc	GEN_LC_SW_INT_FPC
-	/* restore crs 0-15 */
-	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
-	/* restore grs 0-15 */
-	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
-	.endm
-
-/* Save registers on the stack (r15), so we can have stacked interrupts. */
-	.macro SAVE_REGS_STACK
-	/* Allocate a stack frame for 15 general registers */
-	slgfi   %r15, 15 * 8
-	/* Store registers r0 to r14 on the stack */
-	stmg    %r0, %r14, 0(%r15)
-	/* Allocate a stack frame for 16 floating point registers */
-	/* The size of a FP register is the size of an double word */
-	slgfi   %r15, 16 * 8
-	/* Save fp register on stack: offset to SP is multiple of reg number */
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	std	\i, \i * 8(%r15)
-	.endr
-	/* Save fpc, but keep stack aligned on 64bits */
-	slgfi   %r15, 8
-	efpc	%r0
-	stg	%r0, 0(%r15)
-	.endm
-
-/* Restore the register in reverse order */
-	.macro RESTORE_REGS_STACK
-	/* Restore fpc */
-	lfpc	0(%r15)
-	algfi	%r15, 8
-	/* Restore fp register from stack: SP still where it was left */
-	/* and offset to SP is a multiple of reg number */
-	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-	ld	\i, \i * 8(%r15)
-	.endr
-	/* Now that we're done, rewind the stack pointer by 16 double word */
-	algfi   %r15, 16 * 8
-	/* Load the registers from stack */
-	lmg     %r0, %r14, 0(%r15)
-	/* Rewind the stack by 15 double word */
-	algfi   %r15, 15 * 8
-	.endm
-
 .section .text
-/*
- * load_reset calling convention:
- * %r2 subcode (0 or 1)
- */
-.globl diag308_load_reset
-diag308_load_reset:
-	SAVE_REGS
-	/* Backup current PSW mask, as we have to restore it on success */
-	epsw	%r0, %r1
-	st	%r0, GEN_LC_SW_INT_PSW
-	st	%r1, GEN_LC_SW_INT_PSW + 4
-	/* Load reset psw mask (short psw, 64 bit) */
-	lg	%r0, reset_psw
-	/* Load the success label address */
-	larl    %r1, 0f
-	/* Or it to the mask */
-	ogr	%r0, %r1
-	/* Store it at the reset PSW location (real 0x0) */
-	stg	%r0, 0
-	/* Do the reset */
-	diag    %r0,%r2,0x308
-	/* Failure path */
-	xgr	%r2, %r2
-	br	%r14
-	/* Success path */
-	/* load a cr0 that has the AFP control bit which enables all FPRs */
-0:	larl	%r1, initial_cr0
-	lctlg	%c0, %c0, 0(%r1)
-	RESTORE_REGS
-	lhi	%r2, 1
-	larl	%r0, 1f
-	stg	%r0, GEN_LC_SW_INT_PSW + 8
-	lpswe	GEN_LC_SW_INT_PSW
-1:	br	%r14
-
-.globl smp_cpu_setup_state
-smp_cpu_setup_state:
-	xgr	%r1, %r1
-	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
-	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
-	/* We should only go once through cpu setup and not for every restart */
-	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
-	larl	%r14, 0f
-	lpswe	GEN_LC_SW_INT_PSW
-	/* If the function returns, just loop here */
-0:	j	0
-
 pgm_int:
 	SAVE_REGS
 	brasl	%r14, handle_pgm_int
@@ -232,8 +122,6 @@ svc_int:
 	lpswe	GEN_LC_SVC_OLD_PSW
 
 	.align	8
-reset_psw:
-	.quad	0x0008000180000000
 initial_psw:
 	.quad	0x0000000180000000, clear_bss_start
 pgm_int_psw:
@@ -246,6 +134,7 @@ io_int_psw:
 	.quad	0x0000000180000000, io_int
 svc_int_psw:
 	.quad	0x0000000180000000, svc_int
+.globl initial_cr0
 initial_cr0:
 	/* enable AFP-register control, so FP regs (+BFP instr) can be used */
 	.quad	0x0000000000040000
diff --git a/s390x/lib.S b/s390x/lib.S
new file mode 100644
index 0000000..4d78ec6
--- /dev/null
+++ b/s390x/lib.S
@@ -0,0 +1,65 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * s390x assembly library
+ *
+ * Copyright (c) 2019 IBM Corp.
+ *
+ * Authors:
+ *    Janosch Frank <frankja@linux.ibm.com>
+ */
+#include <asm/asm-offsets.h>
+#include <asm/sigp.h>
+
+#include "macros.S"
+
+/*
+ * load_reset calling convention:
+ * %r2 subcode (0 or 1)
+ */
+.globl diag308_load_reset
+diag308_load_reset:
+	SAVE_REGS
+	/* Backup current PSW mask, as we have to restore it on success */
+	epsw	%r0, %r1
+	st	%r0, GEN_LC_SW_INT_PSW
+	st	%r1, GEN_LC_SW_INT_PSW + 4
+	/* Load reset psw mask (short psw, 64 bit) */
+	lg	%r0, reset_psw
+	/* Load the success label address */
+	larl    %r1, 0f
+	/* Or it to the mask */
+	ogr	%r0, %r1
+	/* Store it at the reset PSW location (real 0x0) */
+	stg	%r0, 0
+	/* Do the reset */
+	diag    %r0,%r2,0x308
+	/* Failure path */
+	xgr	%r2, %r2
+	br	%r14
+	/* Success path */
+	/* load a cr0 that has the AFP control bit which enables all FPRs */
+0:	larl	%r1, initial_cr0
+	lctlg	%c0, %c0, 0(%r1)
+	RESTORE_REGS
+	lhi	%r2, 1
+	larl	%r0, 1f
+	stg	%r0, GEN_LC_SW_INT_PSW + 8
+	lpswe	GEN_LC_SW_INT_PSW
+1:	br	%r14
+
+/* Sets up general registers and cr0 when a new cpu is brought online. */
+.globl smp_cpu_setup_state
+smp_cpu_setup_state:
+	xgr	%r1, %r1
+	lmg     %r0, %r15, GEN_LC_SW_INT_GRS
+	lctlg   %c0, %c0, GEN_LC_SW_INT_CRS
+	/* We should only go once through cpu setup and not for every restart */
+	stg	%r14, GEN_LC_RESTART_NEW_PSW + 8
+	larl	%r14, 0f
+	lpswe	GEN_LC_SW_INT_PSW
+	/* If the function returns, just loop here */
+0:	j	0
+
+	.align	8
+reset_psw:
+	.quad	0x0008000180000000
diff --git a/s390x/macros.S b/s390x/macros.S
new file mode 100644
index 0000000..37a6a63
--- /dev/null
+++ b/s390x/macros.S
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * s390x assembly macros
+ *
+ * Copyright (c) 2017 Red Hat Inc
+ * Copyright (c) 2020 IBM Corp.
+ *
+ * Authors:
+ *  Pierre Morel <pmorel@linux.ibm.com>
+ *  David Hildenbrand <david@redhat.com>
+ */
+#include <asm/asm-offsets.h>
+	.macro SAVE_REGS
+	/* save grs 0-15 */
+	stmg	%r0, %r15, GEN_LC_SW_INT_GRS
+	/* save crs 0-15 */
+	stctg	%c0, %c15, GEN_LC_SW_INT_CRS
+	/* load a cr0 that has the AFP control bit which enables all FPRs */
+	larl	%r1, initial_cr0
+	lctlg	%c0, %c0, 0(%r1)
+	/* save fprs 0-15 + fpc */
+	la	%r1, GEN_LC_SW_INT_FPRS
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8(%r1)
+	.endr
+	stfpc	GEN_LC_SW_INT_FPC
+	.endm
+
+	.macro RESTORE_REGS
+	/* restore fprs 0-15 + fpc */
+	la	%r1, GEN_LC_SW_INT_FPRS
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8(%r1)
+	.endr
+	lfpc	GEN_LC_SW_INT_FPC
+	/* restore crs 0-15 */
+	lctlg	%c0, %c15, GEN_LC_SW_INT_CRS
+	/* restore grs 0-15 */
+	lmg	%r0, %r15, GEN_LC_SW_INT_GRS
+	.endm
+
+/* Save registers on the stack (r15), so we can have stacked interrupts. */
+	.macro SAVE_REGS_STACK
+	/* Allocate a stack frame for 15 general registers */
+	slgfi   %r15, 15 * 8
+	/* Store registers r0 to r14 on the stack */
+	stmg    %r0, %r14, 0(%r15)
+	/* Allocate a stack frame for 16 floating point registers */
+	/* The size of a FP register is the size of an double word */
+	slgfi   %r15, 16 * 8
+	/* Save fp register on stack: offset to SP is multiple of reg number */
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	std	\i, \i * 8(%r15)
+	.endr
+	/* Save fpc, but keep stack aligned on 64bits */
+	slgfi   %r15, 8
+	efpc	%r0
+	stg	%r0, 0(%r15)
+	.endm
+
+/* Restore the register in reverse order */
+	.macro RESTORE_REGS_STACK
+	/* Restore fpc */
+	lfpc	0(%r15)
+	algfi	%r15, 8
+	/* Restore fp register from stack: SP still where it was left */
+	/* and offset to SP is a multiple of reg number */
+	.irp i, 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
+	ld	\i, \i * 8(%r15)
+	.endr
+	/* Now that we're done, rewind the stack pointer by 16 double word */
+	algfi   %r15, 16 * 8
+	/* Load the registers from stack */
+	lmg     %r0, %r14, 0(%r15)
+	/* Rewind the stack by 15 double word */
+	algfi   %r15, 15 * 8
+	.endm
-- 
2.25.1

