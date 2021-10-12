Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09B5429A27
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 02:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhJLAJA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Oct 2021 20:09:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51552 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbhJLAI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Oct 2021 20:08:29 -0400
Message-ID: <20211011223612.087345195@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1633997187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=TiGpirlAJA6MaUuc3ToQrsUucBGkUhNodaDfeSM0MTo=;
        b=PhDlrmff52Dw9LGMebVnt8SswA9VzSykG8BW7tp7ofPTqgPA11TUUPN2EKd4fAGf7mRLpr
        aLFtun55Fhu5PqBFeBbnvbmyQc6a+ymHKfvq1Hirkvo/JMJMjTTmnVujfm/jejexcqxkA1
        h3ZOu0h56A4r6nwSnHfX0ByjF6sdySSH66NACNI8ayQRNRazRu8WT30m9hpf+eMK6rS3bX
        wW6ZNf4UxP1X7WOWa3YxLqRZdAX+mlpBJLebCZ1UsR+TviQtFcLg/RphNa5+qePggxc5fk
        9zeo/q0di2ac0eVJv7YrjNeLlbHqm2Yl+wlyFw1c7j4aOiUmKPCPaEbKo1lgEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1633997187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=TiGpirlAJA6MaUuc3ToQrsUucBGkUhNodaDfeSM0MTo=;
        b=4OH/xQP4AcDYVc3zliMEb5ZloeSOAxNG3aXZXRa+bFtaSDYMDs0UAbBI/vML9VDZBk+c5q
        5yo7pb7zF2eoY+Cg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 30/31] x86/fpu: Replace the includes of fpu/internal.h
References: <20211011215813.558681373@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 12 Oct 2021 02:00:44 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the file is empty, fixup all references with the proper includes
and delete the former kitchen sink.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/internal.h |   26 --------------------------
 arch/x86/kernel/cpu/bugs.c          |    2 +-
 arch/x86/kernel/cpu/common.c        |    2 +-
 arch/x86/kernel/fpu/bugs.c          |    2 +-
 arch/x86/kernel/fpu/core.c          |    2 +-
 arch/x86/kernel/fpu/init.c          |    2 +-
 arch/x86/kernel/fpu/regset.c        |    2 +-
 arch/x86/kernel/fpu/xstate.c        |    1 -
 arch/x86/kernel/smpboot.c           |    2 +-
 arch/x86/kernel/traps.c             |    2 +-
 arch/x86/kvm/vmx/vmx.c              |    2 +-
 arch/x86/power/cpu.c                |    2 +-
 12 files changed, 10 insertions(+), 37 deletions(-)

--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -1,26 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 1994 Linus Torvalds
- *
- * Pentium III FXSR, SSE support
- * General FPU state handling cleanups
- *	Gareth Hughes <gareth@valinux.com>, May 2000
- * x86-64 work by Andi Kleen 2002
- */
-
-#ifndef _ASM_X86_FPU_INTERNAL_H
-#define _ASM_X86_FPU_INTERNAL_H
-
-#include <linux/compat.h>
-#include <linux/sched.h>
-#include <linux/slab.h>
-#include <linux/mm.h>
-
-#include <asm/user.h>
-#include <asm/fpu/api.h>
-#include <asm/fpu/xstate.h>
-#include <asm/fpu/xcr.h>
-#include <asm/cpufeature.h>
-#include <asm/trace/fpu.h>
-
-#endif /* _ASM_X86_FPU_INTERNAL_H */
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -22,7 +22,7 @@
 #include <asm/bugs.h>
 #include <asm/processor.h>
 #include <asm/processor-flags.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/msr.h>
 #include <asm/vmx.h>
 #include <asm/paravirt.h>
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -42,7 +42,7 @@
 #include <asm/setup.h>
 #include <asm/apic.h>
 #include <asm/desc.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/mtrr.h>
 #include <asm/hwcap2.h>
 #include <linux/numa.h>
--- a/arch/x86/kernel/fpu/bugs.c
+++ b/arch/x86/kernel/fpu/bugs.c
@@ -2,7 +2,7 @@
 /*
  * x86 FPU bug checks:
  */
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 
 /*
  * Boot time CPU/FPU FDIV bug detection code:
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -6,7 +6,7 @@
  *  General FPU state handling cleanups
  *	Gareth Hughes <gareth@valinux.com>, May 2000
  */
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/fpu/regset.h>
 #include <asm/fpu/sched.h>
 #include <asm/fpu/signal.h>
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -2,7 +2,7 @@
 /*
  * x86 FPU boot time init code:
  */
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/tlbflush.h>
 #include <asm/setup.h>
 
--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -5,7 +5,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/vmalloc.h>
 
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/regset.h>
 #include <asm/fpu/xstate.h>
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -13,7 +13,6 @@
 #include <linux/proc_fs.h>
 
 #include <asm/fpu/api.h>
-#include <asm/fpu/internal.h>
 #include <asm/fpu/regset.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/xcr.h>
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -70,7 +70,7 @@
 #include <asm/mwait.h>
 #include <asm/apic.h>
 #include <asm/io_apic.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/setup.h>
 #include <asm/uv/uv.h>
 #include <linux/mc146818rtc.h>
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -48,7 +48,7 @@
 #include <asm/ftrace.h>
 #include <asm/traps.h>
 #include <asm/desc.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/cpu.h>
 #include <asm/cpu_entry_area.h>
 #include <asm/mce.h>
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -35,7 +35,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/debugreg.h>
 #include <asm/desc.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -20,7 +20,7 @@
 #include <asm/page.h>
 #include <asm/mce.h>
 #include <asm/suspend.h>
-#include <asm/fpu/internal.h>
+#include <asm/fpu/api.h>
 #include <asm/debugreg.h>
 #include <asm/cpu.h>
 #include <asm/mmu_context.h>

