Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D72742E5FB
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 03:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhJOBTg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 21:19:36 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46642 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233835AbhJOBSr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 21:18:47 -0400
Message-ID: <20211015011540.001197214@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634260600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=AYE0o6qd+Xss/eXod7qpO7YIuwEmE4T6tKGyGEEu2BA=;
        b=OLmkoTMCuL2slxYsSMN3UCE9DjARRAQKR3rA+wX/PKJNkXdAKQBIwDvrUeR3FbqJFaJBQj
        ezVQ0PkkuW4+Wc3KlTIDUG/ShpEXZ9gRYrvywhYlik+xIv6DiQxaQ5yx6WMBSEYm0dDJqv
        zmUcNkTDDYAV/OeG/sWK6YJnSCtbTpaXHhFpgeuCzr+iQQ0WVApFZBaRABeqAt7oFMN/ZU
        nNMGc58nmq6CUrO/2CrMwIWWO7XXYgS8Sx3OstJVcNUHJ56FruM2LnnVDj46n9jA9jJMC9
        nLXhD+mV2b9Xnt0pvquwgSwbEQ49pdu0cj+TzJakp/criLVOYzqLhGyeRpZYhA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634260600;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=AYE0o6qd+Xss/eXod7qpO7YIuwEmE4T6tKGyGEEu2BA=;
        b=V7cTOYZXLN8IB3vv5rQpcUmX9fRgYteRLm2KFSxQkhsA3WAmjzzNEyfDYz3SwdM79809eY
        t4mZWUpG5JFHhBAA==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [patch V2 29/30] x86/fpu: Replace the includes of fpu/internal.h
References: <20211015011411.304289784@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 03:16:39 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the file is empty, fixup all references with the proper includes
and delete the former kitchen sink.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/include/asm/fpu/internal.h | 26 --------------------------
 arch/x86/kernel/cpu/bugs.c          |  2 +-
 arch/x86/kernel/cpu/common.c        |  2 +-
 arch/x86/kernel/fpu/bugs.c          |  2 +-
 arch/x86/kernel/fpu/core.c          |  2 +-
 arch/x86/kernel/fpu/init.c          |  2 +-
 arch/x86/kernel/fpu/regset.c        |  2 +-
 arch/x86/kernel/fpu/xstate.c        |  1 -
 arch/x86/kernel/smpboot.c           |  2 +-
 arch/x86/kernel/traps.c             |  2 +-
 arch/x86/kvm/vmx/vmx.c              |  2 +-
 arch/x86/power/cpu.c                |  2 +-
 12 files changed, 10 insertions(+), 37 deletions(-)
---
diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 8df83e887ff6..e69de29bb2d1 100644
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
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index ecfca3bbcd96..6c8a86b58020 100644
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
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index b3410f1ac217..486dc8c1d388 100644
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
diff --git a/arch/x86/kernel/fpu/bugs.c b/arch/x86/kernel/fpu/bugs.c
index 2954fab15e51..794e70151203 100644
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
diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index 4b407215abef..c6d7a47b1b26 100644
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
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index d420d29e58be..23791355ca67 100644
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
 
diff --git a/arch/x86/kernel/fpu/regset.c b/arch/x86/kernel/fpu/regset.c
index 3d8ed45da166..01a1d97c3cb6 100644
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
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index f0305b2b227f..b022df95a302 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -13,7 +13,6 @@
 #include <linux/proc_fs.h>
 
 #include <asm/fpu/api.h>
-#include <asm/fpu/internal.h>
 #include <asm/fpu/regset.h>
 #include <asm/fpu/signal.h>
 #include <asm/fpu/xcr.h>
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 85f6e242b6b4..2577ed3b5e6b 100644
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
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a58800973aed..bae7582c58f5 100644
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 0c2c0d5ae873..e8d5f7963401 100644
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
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 6665f8802098..9f2b251e83c5 100644
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

