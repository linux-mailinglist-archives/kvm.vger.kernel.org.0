Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52CA7CBF85
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 11:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343506AbjJQJeT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 05:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343747AbjJQJeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 05:34:07 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8939DF7;
        Tue, 17 Oct 2023 02:33:55 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1c9d407bb15so45647325ad.0;
        Tue, 17 Oct 2023 02:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697535235; x=1698140035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rfykykDvSR3lgn/h7SgbJEFcK1W+zU64G3sv5ZleFao=;
        b=F9/TPO+jJQUPD6OeVtQY9dqyRs1mV1HrsGTTbnzV9ewfEp7qeoc+BThAxITpSdw2Wk
         Cmq/JZ3bz/degCX1tNCm5sYKM+6m4eUVGcQtw62gYCJ/DTi0hj/VEeGWlvoKir7KHKIr
         tYeIEAJikpbPBZ2aQKv8bVB7RgwJ9p28MjPGBGMwgOClX+ki2bZ90QmCWluuRxqUry44
         Za240ya+RRXsDvxj9Rv4InPWKvafyPLCfcrag5IBp42pqKEfmGfH2WE89Rp4/k+PZjjn
         OESdCtH82GcgXgyeALl3+yQLvZ3qqPMyxyiZJkNTgQ17o5gDqmXlFVNxeXCHaglESMJ8
         hsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697535235; x=1698140035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rfykykDvSR3lgn/h7SgbJEFcK1W+zU64G3sv5ZleFao=;
        b=q/IfyF2QjfAUtrG29lW8BwOkGuc2culfNVInrxgP0LtGT/ZiAWq+57Dj0flruVLsFq
         7cnrXQNLDB/w4/8zArhGXgdr7bhyHu1NqFHANs56IZOs3Lx5IAVvsFgX5UxpB/Fs6Z1H
         IVBInQmtkezsamoJOpi6sGUIqKP4yucu+d0C82f0OT+F3PeOkD+NkfqrCm/ioJEEExlj
         OWqA4lZAHHz+jJtvW9XKW00aXZi/L5P//K4KknAKA9DwtEYQPo8ubo2B092P8NXG323J
         8SDGHIP5OyUihz+od1kTNrygeS//bGnthRCX1277UPBp9N8bqhk7z6KxH7+EHwLfhJpd
         8kQw==
X-Gm-Message-State: AOJu0Yx/W74uJN3uqJ5LQ9r9UnEuPlWtj1I2HOHSijeyynl4gCZlhR3+
        v3R2JJy4HLc9c413vlITg0w=
X-Google-Smtp-Source: AGHT+IFR9LmZdCC9OR0TUaODi5nFR7AToyyJqTqNHgbMqhADT6R9U1v3Px32u12INXd9dO01q6Hy4A==
X-Received: by 2002:a17:902:c404:b0:1ca:3e64:2378 with SMTP id k4-20020a170902c40400b001ca3e642378mr2349965plk.4.1697535234682;
        Tue, 17 Oct 2023 02:33:54 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id je3-20020a170903264300b001c9c5a1b477sm1054752plb.169.2023.10.17.02.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 02:33:53 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: Clean up included but non-essential header declarations
Date:   Tue, 17 Oct 2023 17:33:35 +0800
Message-ID: <20231017093335.18216-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Clean up some headers declarations within the kvm/x86 tree that are
no longer needed or duplicately included more or less.

It is difficult for the naked eye to discern the most basic and effective
header declarations required for each C file, and it's easy to get stuck in
"Dependency Hell [*]" on finding the state-of-art declaration. The strategy
used here is to take advantage of a LLVM tool "include-what-you-use [**]",
which allows any CI to use "make LLVM=1 C=1 CHECK=include-what-you-use" to
quickly find header declarations that may be removable, but the results are
fraught with false positives. Thus, automated compilation (x86_64/i386)
testing is applied to validate each header declaration removal proposal.

Removing these declarations as part of KVM code refactoring can also (when
the compiler isn't so smart) reduce compile time, compile warnings, and the
size of compiled artefacts, and more importantly can help developers better
consider decoupling when adding/refactoring unmerged code, thus relieving
some of the burden on the code review process.

Specific header declaration is supposed to be retained if it makes more
sense for reviewers to understand. No functional changes intended.

[*] https://lore.kernel.org/all/YdIfz+LMewetSaEB@gmail.com/
[**] https://include-what-you-use.org/

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/cpuid.c           |  3 ---
 arch/x86/kvm/cpuid.h           |  1 -
 arch/x86/kvm/emulate.c         |  2 --
 arch/x86/kvm/hyperv.c          |  3 ---
 arch/x86/kvm/i8259.c           |  1 -
 arch/x86/kvm/ioapic.c          | 10 ----------
 arch/x86/kvm/irq.c             |  3 ---
 arch/x86/kvm/irq.h             |  3 ---
 arch/x86/kvm/irq_comm.c        |  2 --
 arch/x86/kvm/lapic.c           |  8 --------
 arch/x86/kvm/mmu.h             |  1 -
 arch/x86/kvm/mmu/mmu.c         | 11 -----------
 arch/x86/kvm/mmu/spte.c        |  1 -
 arch/x86/kvm/mmu/tdp_iter.h    |  1 -
 arch/x86/kvm/mmu/tdp_mmu.c     |  3 ---
 arch/x86/kvm/mmu/tdp_mmu.h     |  4 ----
 arch/x86/kvm/smm.c             |  1 -
 arch/x86/kvm/smm.h             |  3 ---
 arch/x86/kvm/svm/avic.c        |  2 --
 arch/x86/kvm/svm/hyperv.h      |  2 --
 arch/x86/kvm/svm/nested.c      |  2 --
 arch/x86/kvm/svm/pmu.c         |  4 ----
 arch/x86/kvm/svm/sev.c         |  7 -------
 arch/x86/kvm/svm/svm.c         | 29 -----------------------------
 arch/x86/kvm/svm/svm.h         |  3 ---
 arch/x86/kvm/vmx/hyperv.c      |  4 ----
 arch/x86/kvm/vmx/hyperv.h      |  7 -------
 arch/x86/kvm/vmx/nested.c      |  2 --
 arch/x86/kvm/vmx/nested.h      |  1 -
 arch/x86/kvm/vmx/pmu_intel.c   |  1 -
 arch/x86/kvm/vmx/posted_intr.c |  1 -
 arch/x86/kvm/vmx/sgx.h         |  5 -----
 arch/x86/kvm/vmx/vmx.c         | 11 -----------
 arch/x86/kvm/x86.c             | 17 -----------------
 arch/x86/kvm/xen.c             |  1 -
 virt/kvm/async_pf.c            |  2 --
 virt/kvm/binary_stats.c        |  1 -
 virt/kvm/coalesced_mmio.h      |  2 --
 virt/kvm/eventfd.c             |  2 --
 virt/kvm/irqchip.c             |  1 -
 virt/kvm/kvm_main.c            | 13 -------------
 virt/kvm/pfncache.c            |  1 -
 virt/kvm/vfio.c                |  2 --
 43 files changed, 184 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 464b23ac5f93..ca4e640e8076 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -12,13 +12,10 @@
 
 #include <linux/kvm_host.h>
 #include "linux/lockdep.h"
-#include <linux/export.h>
-#include <linux/vmalloc.h>
 #include <linux/uaccess.h>
 #include <linux/sched/stat.h>
 
 #include <asm/processor.h>
-#include <asm/user.h>
 #include <asm/fpu/xstate.h>
 #include <asm/sgx.h>
 #include <asm/cpuid.h>
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 0b90532b6e26..f13eff330b38 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -5,7 +5,6 @@
 #include "x86.h"
 #include "reverse_cpuid.h"
 #include <asm/cpu.h>
-#include <asm/processor.h>
 #include <uapi/asm/kvm_para.h>
 
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 2673cd5c46cb..c4f450a4860c 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -20,9 +20,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
-#include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
-#include <linux/stringify.h>
 #include <asm/debugreg.h>
 #include <asm/nospec-branch.h>
 #include <asm/ibt.h>
diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 7c2dac6824e2..ab221264f1f5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -21,15 +21,12 @@
 
 #include "x86.h"
 #include "lapic.h"
-#include "ioapic.h"
 #include "cpuid.h"
 #include "hyperv.h"
 #include "mmu.h"
 #include "xen.h"
 
-#include <linux/cpu.h>
 #include <linux/kvm_host.h>
-#include <linux/highmem.h>
 #include <linux/sched/cputime.h>
 #include <linux/spinlock.h>
 #include <linux/eventfd.h>
diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
index 8dec646e764b..293baea22a1d 100644
--- a/arch/x86/kvm/i8259.c
+++ b/arch/x86/kvm/i8259.c
@@ -28,7 +28,6 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/bitops.h>
 #include "irq.h"
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 995eb5054360..c1324314a9e0 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -29,18 +29,8 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
-#include <linux/kvm.h>
-#include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/smp.h>
-#include <linux/hrtimer.h>
-#include <linux/io.h>
 #include <linux/slab.h>
-#include <linux/export.h>
 #include <linux/nospec.h>
-#include <asm/processor.h>
-#include <asm/page.h>
-#include <asm/current.h>
 #include <trace/events/kvm.h>
 
 #include "ioapic.h"
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index b2c397dd2bc6..8a9284e376b8 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -9,12 +9,9 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/export.h>
 #include <linux/kvm_host.h>
 
 #include "irq.h"
-#include "i8254.h"
-#include "x86.h"
 #include "xen.h"
 
 /*
diff --git a/arch/x86/kvm/irq.h b/arch/x86/kvm/irq.h
index c2d7cfe82d00..f4dd4ace9370 100644
--- a/arch/x86/kvm/irq.h
+++ b/arch/x86/kvm/irq.h
@@ -10,10 +10,7 @@
 #ifndef __IRQ_H
 #define __IRQ_H
 
-#include <linux/mm_types.h>
-#include <linux/hrtimer.h>
 #include <linux/kvm_host.h>
-#include <linux/spinlock.h>
 
 #include <kvm/iodev.h>
 #include "lapic.h"
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index 16d076a1b91a..1a76c452c6ec 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -11,8 +11,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
-#include <linux/slab.h>
-#include <linux/export.h>
 #include <linux/rculist.h>
 
 #include <trace/events/kvm.h>
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 245b20973cae..ca5e55fd8644 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -20,18 +20,10 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/mm.h>
-#include <linux/highmem.h>
-#include <linux/smp.h>
 #include <linux/hrtimer.h>
-#include <linux/io.h>
-#include <linux/export.h>
 #include <linux/math64.h>
-#include <linux/slab.h>
-#include <asm/processor.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
-#include <asm/page.h>
-#include <asm/current.h>
 #include <asm/apicdef.h>
 #include <asm/delay.h>
 #include <linux/atomic.h>
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bb8c86eefac0..6d3e27ae697b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -4,7 +4,6 @@
 
 #include <linux/kvm_host.h>
 #include "kvm_cache_regs.h"
-#include "cpuid.h"
 
 extern bool __read_mostly enable_mmio_caching;
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5d3dc7119e57..2012ea028fe0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -16,8 +16,6 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include "irq.h"
-#include "ioapic.h"
 #include "mmu.h"
 #include "mmu_internal.h"
 #include "tdp_mmu.h"
@@ -33,25 +31,16 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-#include <linux/highmem.h>
 #include <linux/moduleparam.h>
-#include <linux/export.h>
-#include <linux/swap.h>
-#include <linux/hugetlb.h>
-#include <linux/compiler.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <linux/sched/signal.h>
-#include <linux/uaccess.h>
 #include <linux/hash.h>
-#include <linux/kern_levels.h>
 #include <linux/kstrtox.h>
 #include <linux/kthread.h>
 
 #include <asm/page.h>
-#include <asm/memtype.h>
 #include <asm/cmpxchg.h>
-#include <asm/io.h>
 #include <asm/set_memory.h>
 #include <asm/vmx.h>
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4a599130e9c9..0cbf5f828d4d 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -12,7 +12,6 @@
 #include <linux/kvm_host.h>
 #include "mmu.h"
 #include "mmu_internal.h"
-#include "x86.h"
 #include "spte.h"
 
 #include <asm/e820/api.h>
diff --git a/arch/x86/kvm/mmu/tdp_iter.h b/arch/x86/kvm/mmu/tdp_iter.h
index fae559559a80..873a087f1f39 100644
--- a/arch/x86/kvm/mmu/tdp_iter.h
+++ b/arch/x86/kvm/mmu/tdp_iter.h
@@ -5,7 +5,6 @@
 
 #include <linux/kvm_host.h>
 
-#include "mmu.h"
 #include "spte.h"
 
 /*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6cd4dd631a2f..6e2a92b6d2c4 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -8,9 +8,6 @@
 #include "tdp_mmu.h"
 #include "spte.h"
 
-#include <asm/cmpxchg.h>
-#include <trace/events/kvm.h>
-
 /* Initializes the TDP MMU for the VM, if enabled. */
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 733a3aef3a96..66afdf3e262a 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -3,10 +3,6 @@
 #ifndef __KVM_X86_MMU_TDP_MMU_H
 #define __KVM_X86_MMU_TDP_MMU_H
 
-#include <linux/kvm_host.h>
-
-#include "spte.h"
-
 void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index dc3d95fdca7d..3c8979ef87ef 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -2,7 +2,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kvm_host.h>
-#include "x86.h"
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 #include "smm.h"
diff --git a/arch/x86/kvm/smm.h b/arch/x86/kvm/smm.h
index a1cf2ac5bd78..3e067ce1ea1d 100644
--- a/arch/x86/kvm/smm.h
+++ b/arch/x86/kvm/smm.h
@@ -2,11 +2,8 @@
 #ifndef ASM_KVM_SMM_H
 #define ASM_KVM_SMM_H
 
-#include <linux/build_bug.h>
-
 #ifdef CONFIG_KVM_SMM
 
-
 /*
  * 32 bit KVM's emulated SMM layout. Based on Intel P6 layout
  * (https://www.sandpile.org/x86/smm.htm).
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2092db892d7d..e5dea4230347 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -14,7 +14,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kvm_types.h>
 #include <linux/hashtable.h>
 #include <linux/amd-iommu.h>
 #include <linux/kvm_host.h>
@@ -23,7 +22,6 @@
 
 #include "trace.h"
 #include "lapic.h"
-#include "x86.h"
 #include "irq.h"
 #include "svm.h"
 
diff --git a/arch/x86/kvm/svm/hyperv.h b/arch/x86/kvm/svm/hyperv.h
index 02f4784b5d44..f546736ce0b3 100644
--- a/arch/x86/kvm/svm/hyperv.h
+++ b/arch/x86/kvm/svm/hyperv.h
@@ -6,8 +6,6 @@
 #ifndef __ARCH_X86_KVM_SVM_HYPERV_H__
 #define __ARCH_X86_KVM_SVM_HYPERV_H__
 
-#include <asm/mshyperv.h>
-
 #include "../hyperv.h"
 #include "svm.h"
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index dd496c9e5f91..ca525c440b63 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -16,10 +16,8 @@
 
 #include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
-#include <linux/kernel.h>
 
 #include <asm/msr-index.h>
-#include <asm/debugreg.h>
 
 #include "kvm_emulate.h"
 #include "trace.h"
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 373ff6a6687b..1c5f2d3e7248 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -13,12 +13,8 @@
 
 #include <linux/types.h>
 #include <linux/kvm_host.h>
-#include <linux/perf_event.h>
-#include "x86.h"
 #include "cpuid.h"
-#include "lapic.h"
 #include "pmu.h"
-#include "svm.h"
 
 enum pmu_type {
 	PMU_TYPE_COUNTER = 0,
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..f0ef5f3ecb85 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -8,27 +8,20 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
 #include <linux/kernel.h>
-#include <linux/highmem.h>
 #include <linux/psp.h>
 #include <linux/psp-sev.h>
-#include <linux/pagemap.h>
 #include <linux/swap.h>
 #include <linux/misc_cgroup.h>
-#include <linux/processor.h>
-#include <linux/trace_events.h>
 
 #include <asm/pkru.h>
-#include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
 #include <asm/debugreg.h>
 
 #include "mmu.h"
 #include "x86.h"
 #include "svm.h"
-#include "svm_ops.h"
 #include "cpuid.h"
 #include "trace.h"
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b7472ad183b9..50641dd810b0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -9,46 +9,17 @@
 #include "smm.h"
 #include "cpuid.h"
 #include "pmu.h"
-
-#include <linux/module.h>
-#include <linux/mod_devicetable.h>
-#include <linux/kernel.h>
-#include <linux/vmalloc.h>
-#include <linux/highmem.h>
-#include <linux/amd-iommu.h>
-#include <linux/sched.h>
-#include <linux/trace_events.h>
-#include <linux/slab.h>
-#include <linux/hashtable.h>
-#include <linux/objtool.h>
-#include <linux/psp-sev.h>
-#include <linux/file.h>
-#include <linux/pagemap.h>
-#include <linux/swap.h>
 #include <linux/rwsem.h>
-#include <linux/cc_platform.h>
-#include <linux/smp.h>
-
-#include <asm/apic.h>
-#include <asm/perf_event.h>
-#include <asm/tlbflush.h>
-#include <asm/desc.h>
-#include <asm/debugreg.h>
-#include <asm/kvm_para.h>
-#include <asm/irq_remapping.h>
 #include <asm/spec-ctrl.h>
 #include <asm/cpu_device_id.h>
 #include <asm/traps.h>
 #include <asm/reboot.h>
-#include <asm/fpu/api.h>
 
 #include <trace/events/ipi.h>
 
 #include "trace.h"
-
 #include "svm.h"
 #include "svm_ops.h"
-
 #include "kvm_onhyperv.h"
 #include "svm_onhyperv.h"
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd10..1f4ef7a12975 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -15,10 +15,7 @@
 #ifndef __SVM_SVM_H
 #define __SVM_SVM_H
 
-#include <linux/kvm_types.h>
 #include <linux/kvm_host.h>
-#include <linux/bits.h>
-
 #include <asm/svm.h>
 #include <asm/sev-common.h>
 
diff --git a/arch/x86/kvm/vmx/hyperv.c b/arch/x86/kvm/vmx/hyperv.c
index 313b8bb5b8a7..4b0a0abcc9f1 100644
--- a/arch/x86/kvm/vmx/hyperv.c
+++ b/arch/x86/kvm/vmx/hyperv.c
@@ -1,13 +1,9 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/errno.h>
-#include <linux/smp.h>
-
 #include "../cpuid.h"
 #include "hyperv.h"
 #include "nested.h"
-#include "vmcs.h"
 #include "vmx.h"
 #include "trace.h"
 
diff --git a/arch/x86/kvm/vmx/hyperv.h b/arch/x86/kvm/vmx/hyperv.h
index 9623fe1651c4..6a3dd2ee893c 100644
--- a/arch/x86/kvm/vmx/hyperv.h
+++ b/arch/x86/kvm/vmx/hyperv.h
@@ -2,15 +2,8 @@
 #ifndef __KVM_X86_VMX_HYPERV_H
 #define __KVM_X86_VMX_HYPERV_H
 
-#include <linux/jump_label.h>
-
-#include <asm/hyperv-tlfs.h>
 #include <asm/mshyperv.h>
-#include <asm/vmx.h>
 
-#include "../hyperv.h"
-
-#include "capabilities.h"
 #include "vmcs.h"
 #include "vmcs12.h"
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..5899d5bc4c5a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/objtool.h>
-#include <linux/percpu.h>
 
 #include <asm/debugreg.h>
 #include <asm/mmu_context.h>
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index b4b9d51438c6..432743d66bb0 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -2,7 +2,6 @@
 #ifndef __KVM_X86_VMX_NESTED_H
 #define __KVM_X86_VMX_NESTED_H
 
-#include "kvm_cache_regs.h"
 #include "vmcs12.h"
 #include "vmx.h"
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..64f1e395acbf 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -16,7 +16,6 @@
 #include <asm/perf_event.h>
 #include "x86.h"
 #include "cpuid.h"
-#include "lapic.h"
 #include "nested.h"
 #include "pmu.h"
 
diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index af662312fd07..cfb61921e322 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -4,7 +4,6 @@
 #include <linux/kvm_host.h>
 
 #include <asm/irq_remapping.h>
-#include <asm/cpu.h>
 
 #include "lapic.h"
 #include "irq.h"
diff --git a/arch/x86/kvm/vmx/sgx.h b/arch/x86/kvm/vmx/sgx.h
index a400888b376d..3c8af99d3d4c 100644
--- a/arch/x86/kvm/vmx/sgx.h
+++ b/arch/x86/kvm/vmx/sgx.h
@@ -2,11 +2,6 @@
 #ifndef __KVM_X86_SGX_H
 #define __KVM_X86_SGX_H
 
-#include <linux/kvm_host.h>
-
-#include "capabilities.h"
-#include "vmx_ops.h"
-
 #ifdef CONFIG_X86_SGX_KVM
 extern bool __read_mostly enable_sgx;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 86ce9efe6c66..9814569c0b37 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -14,7 +14,6 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/highmem.h>
 #include <linux/hrtimer.h>
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
@@ -22,12 +21,8 @@
 #include <linux/moduleparam.h>
 #include <linux/mod_devicetable.h>
 #include <linux/mm.h>
-#include <linux/objtool.h>
 #include <linux/sched.h>
 #include <linux/sched/smt.h>
-#include <linux/slab.h>
-#include <linux/tboot.h>
-#include <linux/trace_events.h>
 #include <linux/entry-kvm.h>
 
 #include <asm/apic.h>
@@ -36,17 +31,11 @@
 #include <asm/cpu_device_id.h>
 #include <asm/debugreg.h>
 #include <asm/desc.h>
-#include <asm/fpu/api.h>
-#include <asm/fpu/xstate.h>
-#include <asm/idtentry.h>
 #include <asm/io.h>
-#include <asm/irq_remapping.h>
 #include <asm/reboot.h>
 #include <asm/perf_event.h>
 #include <asm/mmu_context.h>
 #include <asm/mshyperv.h>
-#include <asm/mwait.h>
-#include <asm/spec-ctrl.h>
 #include <asm/vmx.h>
 
 #include "capabilities.h"
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 530d4bc2259b..be0b77835e6f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -22,7 +22,6 @@
 #include "ioapic.h"
 #include "mmu.h"
 #include "i8254.h"
-#include "tss.h"
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 #include "mmu/page_track.h"
@@ -35,33 +34,22 @@
 #include "smm.h"
 
 #include <linux/clocksource.h>
-#include <linux/interrupt.h>
 #include <linux/kvm.h>
 #include <linux/fs.h>
-#include <linux/vmalloc.h>
-#include <linux/export.h>
 #include <linux/moduleparam.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
-#include <linux/iommu.h>
 #include <linux/cpufreq.h>
 #include <linux/user-return-notifier.h>
-#include <linux/srcu.h>
-#include <linux/slab.h>
 #include <linux/perf_event.h>
-#include <linux/uaccess.h>
 #include <linux/hash.h>
 #include <linux/pci.h>
 #include <linux/timekeeper_internal.h>
-#include <linux/pvclock_gtod.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/irqbypass.h>
-#include <linux/sched/stat.h>
 #include <linux/sched/isolation.h>
-#include <linux/mem_encrypt.h>
 #include <linux/entry-kvm.h>
 #include <linux/suspend.h>
-#include <linux/smp.h>
 
 #include <trace/events/ipi.h>
 #include <trace/events/kvm.h>
@@ -71,18 +59,13 @@
 #include <asm/desc.h>
 #include <asm/mce.h>
 #include <asm/pkru.h>
-#include <linux/kernel_stat.h>
 #include <asm/fpu/api.h>
 #include <asm/fpu/xcr.h>
-#include <asm/fpu/xstate.h>
 #include <asm/pvclock.h>
-#include <asm/div64.h>
 #include <asm/irq_remapping.h>
 #include <asm/mshyperv.h>
 #include <asm/hypervisor.h>
-#include <asm/tlbflush.h>
 #include <asm/intel_pt.h>
-#include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
 #include <clocksource/hyperv_timer.h>
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index e53fad915a62..4c82d084852e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -16,7 +16,6 @@
 #include <linux/kvm_host.h>
 #include <linux/sched/stat.h>
 
-#include <trace/events/kvm.h>
 #include <xen/interface/xen.h>
 #include <xen/interface/vcpu.h>
 #include <xen/interface/version.h>
diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
index e033c79d528e..d3c4751ec8c6 100644
--- a/virt/kvm/async_pf.c
+++ b/virt/kvm/async_pf.c
@@ -10,8 +10,6 @@
 
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/mmu_context.h>
 #include <linux/sched/mm.h>
 
 #include "async_pf.h"
diff --git a/virt/kvm/binary_stats.c b/virt/kvm/binary_stats.c
index eefca6c69f51..77cbbf6c2aba 100644
--- a/virt/kvm/binary_stats.c
+++ b/virt/kvm/binary_stats.c
@@ -7,7 +7,6 @@
 
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
-#include <linux/errno.h>
 #include <linux/uaccess.h>
 
 /**
diff --git a/virt/kvm/coalesced_mmio.h b/virt/kvm/coalesced_mmio.h
index 36f84264ed25..40b07fb3ed61 100644
--- a/virt/kvm/coalesced_mmio.h
+++ b/virt/kvm/coalesced_mmio.h
@@ -13,8 +13,6 @@
 
 #ifdef CONFIG_KVM_MMIO
 
-#include <linux/list.h>
-
 struct kvm_coalesced_mmio_dev {
 	struct list_head list;
 	struct kvm_io_device dev;
diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 89912a17f5d5..f7863a0ce75f 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -13,13 +13,11 @@
 #include <linux/kvm.h>
 #include <linux/kvm_irqfd.h>
 #include <linux/workqueue.h>
-#include <linux/syscalls.h>
 #include <linux/wait.h>
 #include <linux/poll.h>
 #include <linux/file.h>
 #include <linux/list.h>
 #include <linux/eventfd.h>
-#include <linux/kernel.h>
 #include <linux/srcu.h>
 #include <linux/slab.h>
 #include <linux/seqlock.h>
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..f3bfa56bb0dc 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -15,7 +15,6 @@
 #include <linux/kvm_host.h>
 #include <linux/slab.h>
 #include <linux/srcu.h>
-#include <linux/export.h>
 #include <trace/events/kvm.h>
 
 int kvm_irq_map_gsi(struct kvm *kvm,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 486800a7024b..aff195e03bfc 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -19,42 +19,29 @@
 #include <linux/kvm.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/percpu.h>
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 #include <linux/vmalloc.h>
-#include <linux/reboot.h>
 #include <linux/debugfs.h>
-#include <linux/highmem.h>
 #include <linux/file.h>
 #include <linux/syscore_ops.h>
 #include <linux/cpu.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/mm.h>
-#include <linux/sched/stat.h>
 #include <linux/cpumask.h>
 #include <linux/smp.h>
 #include <linux/anon_inodes.h>
-#include <linux/profile.h>
-#include <linux/kvm_para.h>
-#include <linux/pagemap.h>
-#include <linux/mman.h>
 #include <linux/swap.h>
-#include <linux/bitops.h>
 #include <linux/spinlock.h>
 #include <linux/compat.h>
 #include <linux/srcu.h>
 #include <linux/hugetlb.h>
 #include <linux/slab.h>
-#include <linux/sort.h>
 #include <linux/bsearch.h>
 #include <linux/io.h>
 #include <linux/lockdep.h>
 #include <linux/kthread.h>
 #include <linux/suspend.h>
-
-#include <asm/processor.h>
-#include <asm/ioctl.h>
 #include <linux/uaccess.h>
 
 #include "coalesced_mmio.h"
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 2d6aba677830..805e51f35d73 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include <linux/kvm.h>
 #include <linux/highmem.h>
 #include <linux/module.h>
 #include <linux/errno.h>
diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index ca24ce120906..de410402da8c 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -6,14 +6,12 @@
  *     Author: Alex Williamson <alex.williamson@redhat.com>
  */
 
-#include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/kvm_host.h>
 #include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
-#include <linux/uaccess.h>
 #include <linux/vfio.h>
 #include "vfio.h"
 

base-commit: 2bf2d3d16b8d7fe346a88569b6d786a3b18913dc
-- 
2.42.0

