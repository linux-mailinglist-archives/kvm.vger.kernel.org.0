Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21B72D081E
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 00:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgLFXlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 18:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728559AbgLFXlf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 6 Dec 2020 18:41:35 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50802C0613D2
        for <kvm@vger.kernel.org>; Sun,  6 Dec 2020 15:40:49 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id g25so8475903wmh.1
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 15:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ln1ozzZklmmKqm+Rb52d2EFhNZPiZM6Mxpme95/5JJU=;
        b=jQk92dIVwrdkVPtmX1jJV1rSEKaDAqDXYlCaqujyjc2bEr3l4vFm5AMH5/P7rp1nJ3
         8ZPwZCiovi85lM4lJCqIZoKGzh/uFSOAyFMZ0v1lqw9ceWjKRSJJx/MLuPklrcXaVoe9
         zs4HMyMBdlQnLCvQg8luWTcyLkkVQtePXq32efmFuF2LYf4RO9MMoJakwHP3u/hzAzZ6
         4epyymBDU59e0AD8ZAI56Ilex/yh3WfIS/poeFpjJ9SdbCsyLBi0R1jSTd9vV8s5kZ55
         F2idkqYOzfWmL/BJJ88CSc4DjWSESNPjgQaTPtYWaDavZ/nIhyouy02wpAzHdj5MOgzJ
         6oOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ln1ozzZklmmKqm+Rb52d2EFhNZPiZM6Mxpme95/5JJU=;
        b=Je5pGFxO7WkzF884UfgsJJLN56AJ//M3K9DAdpjAhXMH0Uvda0qDyCFG8YXJUV2hPb
         96/gBIcF5WwkplDg30U40hoXJtH9O+8vQW5bZTHvuqHYhksFfhEGzYXGnwaXxLGJG9TF
         qabSS/50aSbz8U5MSmdbquxX6amTu3hHd7udwJtL/xtPNT3cgKuBlYffPRXf4hAxI1hn
         LIRGejt6WcY1TX+6+EtGnaWgRkI0d+bcIyVniOdczoY8YDX8VlJXCecfX6ViAReeC8nO
         hT4YZgiWwzDR9HRab9wZ2pE8DTgl3oqJAKP2ThSaOwBfCr+1TH87I8W9KFlFdyXL8Ggj
         svIg==
X-Gm-Message-State: AOAM53275JX3yigPWC+i4W8WmDGkzzmfMXAmgiBqjGWQB6uW2sQ2o4hR
        pWg/TChrV+8j/E82m56WIME=
X-Google-Smtp-Source: ABdhPJyLat0nr9LEAy8mnYK9IXYkcFeq8U2izbHXCuIH5Za9odYVdvWamOlM+ykRnsHXCvQZjFx/kg==
X-Received: by 2002:a1c:35c2:: with SMTP id c185mr15673774wma.74.1607298047959;
        Sun, 06 Dec 2020 15:40:47 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id c1sm11434357wml.8.2020.12.06.15.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 15:40:47 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paul Burton <paulburton@kernel.org>, kvm@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 11/19] target/mips: Extract common helpers from helper.c to common_helper.c
Date:   Mon,  7 Dec 2020 00:39:41 +0100
Message-Id: <20201206233949.3783184-12-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201206233949.3783184-1-f4bug@amsat.org>
References: <20201206233949.3783184-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The rest of helper.c is TLB related. Extract the non TLB
specific functions to a new file, so we can rename helper.c
as tlb_helper.c in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
Any better name? xxx_helper.c are usually TCG helpers.
---
 target/mips/common_helper.c | 178 ++++++++++++++++++++++++++++++++++++
 target/mips/helper.c        | 152 ------------------------------
 target/mips/meson.build     |   1 +
 3 files changed, 179 insertions(+), 152 deletions(-)
 create mode 100644 target/mips/common_helper.c

diff --git a/target/mips/common_helper.c b/target/mips/common_helper.c
new file mode 100644
index 00000000000..07c947ecc55
--- /dev/null
+++ b/target/mips/common_helper.c
@@ -0,0 +1,178 @@
+/*
+ *  MIPS emulation helpers for qemu.
+ *
+ *  Copyright (c) 2004-2005 Jocelyn Mayer
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Lesser General Public
+ * License as published by the Free Software Foundation; either
+ * version 2.1 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public
+ * License along with this library; if not, see <http://www.gnu.org/licenses/>.
+ */
+#include "qemu/osdep.h"
+
+#include "cpu.h"
+#include "internal.h"
+#include "exec/exec-all.h"
+#include "exec/log.h"
+
+#if !defined(CONFIG_USER_ONLY)
+
+/* Called for updates to CP0_Status.  */
+void sync_c0_status(CPUMIPSState *env, CPUMIPSState *cpu, int tc)
+{
+    int32_t tcstatus, *tcst;
+    uint32_t v = cpu->CP0_Status;
+    uint32_t cu, mx, asid, ksu;
+    uint32_t mask = ((1 << CP0TCSt_TCU3)
+                       | (1 << CP0TCSt_TCU2)
+                       | (1 << CP0TCSt_TCU1)
+                       | (1 << CP0TCSt_TCU0)
+                       | (1 << CP0TCSt_TMX)
+                       | (3 << CP0TCSt_TKSU)
+                       | (0xff << CP0TCSt_TASID));
+
+    cu = (v >> CP0St_CU0) & 0xf;
+    mx = (v >> CP0St_MX) & 0x1;
+    ksu = (v >> CP0St_KSU) & 0x3;
+    asid = env->CP0_EntryHi & env->CP0_EntryHi_ASID_mask;
+
+    tcstatus = cu << CP0TCSt_TCU0;
+    tcstatus |= mx << CP0TCSt_TMX;
+    tcstatus |= ksu << CP0TCSt_TKSU;
+    tcstatus |= asid;
+
+    if (tc == cpu->current_tc) {
+        tcst = &cpu->active_tc.CP0_TCStatus;
+    } else {
+        tcst = &cpu->tcs[tc].CP0_TCStatus;
+    }
+
+    *tcst &= ~mask;
+    *tcst |= tcstatus;
+    compute_hflags(cpu);
+}
+
+void cpu_mips_store_status(CPUMIPSState *env, target_ulong val)
+{
+    uint32_t mask = env->CP0_Status_rw_bitmask;
+    target_ulong old = env->CP0_Status;
+
+    if (env->insn_flags & ISA_MIPS32R6) {
+        bool has_supervisor = extract32(mask, CP0St_KSU, 2) == 0x3;
+#if defined(TARGET_MIPS64)
+        uint32_t ksux = (1 << CP0St_KX) & val;
+        ksux |= (ksux >> 1) & val; /* KX = 0 forces SX to be 0 */
+        ksux |= (ksux >> 1) & val; /* SX = 0 forces UX to be 0 */
+        val = (val & ~(7 << CP0St_UX)) | ksux;
+#endif
+        if (has_supervisor && extract32(val, CP0St_KSU, 2) == 0x3) {
+            mask &= ~(3 << CP0St_KSU);
+        }
+        mask &= ~(((1 << CP0St_SR) | (1 << CP0St_NMI)) & val);
+    }
+
+    env->CP0_Status = (old & ~mask) | (val & mask);
+#if defined(TARGET_MIPS64)
+    if ((env->CP0_Status ^ old) & (old & (7 << CP0St_UX))) {
+        /* Access to at least one of the 64-bit segments has been disabled */
+        tlb_flush(env_cpu(env));
+    }
+#endif
+    if (env->CP0_Config3 & (1 << CP0C3_MT)) {
+        sync_c0_status(env, env, env->current_tc);
+    } else {
+        compute_hflags(env);
+    }
+}
+
+void cpu_mips_store_cause(CPUMIPSState *env, target_ulong val)
+{
+    uint32_t mask = 0x00C00300;
+    uint32_t old = env->CP0_Cause;
+    int i;
+
+    if (env->insn_flags & ISA_MIPS32R2) {
+        mask |= 1 << CP0Ca_DC;
+    }
+    if (env->insn_flags & ISA_MIPS32R6) {
+        mask &= ~((1 << CP0Ca_WP) & val);
+    }
+
+    env->CP0_Cause = (env->CP0_Cause & ~mask) | (val & mask);
+
+    if ((old ^ env->CP0_Cause) & (1 << CP0Ca_DC)) {
+        if (env->CP0_Cause & (1 << CP0Ca_DC)) {
+            cpu_mips_stop_count(env);
+        } else {
+            cpu_mips_start_count(env);
+        }
+    }
+
+    /* Set/reset software interrupts */
+    for (i = 0 ; i < 2 ; i++) {
+        if ((old ^ env->CP0_Cause) & (1 << (CP0Ca_IP + i))) {
+            cpu_mips_soft_irq(env, i, env->CP0_Cause & (1 << (CP0Ca_IP + i)));
+        }
+    }
+}
+
+#endif /* !CONFIG_USER_ONLY */
+
+target_ulong exception_resume_pc(CPUMIPSState *env)
+{
+    target_ulong bad_pc;
+    target_ulong isa_mode;
+
+    isa_mode = !!(env->hflags & MIPS_HFLAG_M16);
+    bad_pc = env->active_tc.PC | isa_mode;
+    if (env->hflags & MIPS_HFLAG_BMASK) {
+        /*
+         * If the exception was raised from a delay slot, come back to
+         * the jump.
+         */
+        bad_pc -= (env->hflags & MIPS_HFLAG_B16 ? 2 : 4);
+    }
+
+    return bad_pc;
+}
+
+bool mips_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
+{
+    if (interrupt_request & CPU_INTERRUPT_HARD) {
+        MIPSCPU *cpu = MIPS_CPU(cs);
+        CPUMIPSState *env = &cpu->env;
+
+        if (cpu_mips_hw_interrupts_enabled(env) &&
+            cpu_mips_hw_interrupts_pending(env)) {
+            /* Raise it */
+            cs->exception_index = EXCP_EXT_INTERRUPT;
+            env->error_code = 0;
+            mips_cpu_do_interrupt(cs);
+            return true;
+        }
+    }
+    return false;
+}
+
+void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env,
+                                          uint32_t exception,
+                                          int error_code,
+                                          uintptr_t pc)
+{
+    CPUState *cs = env_cpu(env);
+
+    qemu_log_mask(CPU_LOG_INT, "%s: %d %d\n",
+                  __func__, exception, error_code);
+    cs->exception_index = exception;
+    env->error_code = error_code;
+
+    cpu_loop_exit_restore(cs, pc);
+}
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 6d33809fb8b..5db7e80e22b 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -357,105 +357,6 @@ void cpu_mips_tlb_flush(CPUMIPSState *env)
     env->tlb->tlb_in_use = env->tlb->nb_tlb;
 }
 
-/* Called for updates to CP0_Status.  */
-void sync_c0_status(CPUMIPSState *env, CPUMIPSState *cpu, int tc)
-{
-    int32_t tcstatus, *tcst;
-    uint32_t v = cpu->CP0_Status;
-    uint32_t cu, mx, asid, ksu;
-    uint32_t mask = ((1 << CP0TCSt_TCU3)
-                       | (1 << CP0TCSt_TCU2)
-                       | (1 << CP0TCSt_TCU1)
-                       | (1 << CP0TCSt_TCU0)
-                       | (1 << CP0TCSt_TMX)
-                       | (3 << CP0TCSt_TKSU)
-                       | (0xff << CP0TCSt_TASID));
-
-    cu = (v >> CP0St_CU0) & 0xf;
-    mx = (v >> CP0St_MX) & 0x1;
-    ksu = (v >> CP0St_KSU) & 0x3;
-    asid = env->CP0_EntryHi & env->CP0_EntryHi_ASID_mask;
-
-    tcstatus = cu << CP0TCSt_TCU0;
-    tcstatus |= mx << CP0TCSt_TMX;
-    tcstatus |= ksu << CP0TCSt_TKSU;
-    tcstatus |= asid;
-
-    if (tc == cpu->current_tc) {
-        tcst = &cpu->active_tc.CP0_TCStatus;
-    } else {
-        tcst = &cpu->tcs[tc].CP0_TCStatus;
-    }
-
-    *tcst &= ~mask;
-    *tcst |= tcstatus;
-    compute_hflags(cpu);
-}
-
-void cpu_mips_store_status(CPUMIPSState *env, target_ulong val)
-{
-    uint32_t mask = env->CP0_Status_rw_bitmask;
-    target_ulong old = env->CP0_Status;
-
-    if (env->insn_flags & ISA_MIPS32R6) {
-        bool has_supervisor = extract32(mask, CP0St_KSU, 2) == 0x3;
-#if defined(TARGET_MIPS64)
-        uint32_t ksux = (1 << CP0St_KX) & val;
-        ksux |= (ksux >> 1) & val; /* KX = 0 forces SX to be 0 */
-        ksux |= (ksux >> 1) & val; /* SX = 0 forces UX to be 0 */
-        val = (val & ~(7 << CP0St_UX)) | ksux;
-#endif
-        if (has_supervisor && extract32(val, CP0St_KSU, 2) == 0x3) {
-            mask &= ~(3 << CP0St_KSU);
-        }
-        mask &= ~(((1 << CP0St_SR) | (1 << CP0St_NMI)) & val);
-    }
-
-    env->CP0_Status = (old & ~mask) | (val & mask);
-#if defined(TARGET_MIPS64)
-    if ((env->CP0_Status ^ old) & (old & (7 << CP0St_UX))) {
-        /* Access to at least one of the 64-bit segments has been disabled */
-        tlb_flush(env_cpu(env));
-    }
-#endif
-    if (env->CP0_Config3 & (1 << CP0C3_MT)) {
-        sync_c0_status(env, env, env->current_tc);
-    } else {
-        compute_hflags(env);
-    }
-}
-
-void cpu_mips_store_cause(CPUMIPSState *env, target_ulong val)
-{
-    uint32_t mask = 0x00C00300;
-    uint32_t old = env->CP0_Cause;
-    int i;
-
-    if (env->insn_flags & ISA_MIPS32R2) {
-        mask |= 1 << CP0Ca_DC;
-    }
-    if (env->insn_flags & ISA_MIPS32R6) {
-        mask &= ~((1 << CP0Ca_WP) & val);
-    }
-
-    env->CP0_Cause = (env->CP0_Cause & ~mask) | (val & mask);
-
-    if ((old ^ env->CP0_Cause) & (1 << CP0Ca_DC)) {
-        if (env->CP0_Cause & (1 << CP0Ca_DC)) {
-            cpu_mips_stop_count(env);
-        } else {
-            cpu_mips_start_count(env);
-        }
-    }
-
-    /* Set/reset software interrupts */
-    for (i = 0 ; i < 2 ; i++) {
-        if ((old ^ env->CP0_Cause) & (1 << (CP0Ca_IP + i))) {
-            cpu_mips_soft_irq(env, i, env->CP0_Cause & (1 << (CP0Ca_IP + i)));
-        }
-    }
-}
-
 #endif /* !CONFIG_USER_ONLY */
 
 static void raise_mmu_exception(CPUMIPSState *env, target_ulong address,
@@ -1017,27 +918,7 @@ static const char * const excp_names[EXCP_LAST + 1] = {
     [EXCP_MSADIS] = "MSA disabled",
     [EXCP_MSAFPE] = "MSA floating point",
 };
-#endif /* !CONFIG_USER_ONLY */
 
-target_ulong exception_resume_pc(CPUMIPSState *env)
-{
-    target_ulong bad_pc;
-    target_ulong isa_mode;
-
-    isa_mode = !!(env->hflags & MIPS_HFLAG_M16);
-    bad_pc = env->active_tc.PC | isa_mode;
-    if (env->hflags & MIPS_HFLAG_BMASK) {
-        /*
-         * If the exception was raised from a delay slot, come back to
-         * the jump.
-         */
-        bad_pc -= (env->hflags & MIPS_HFLAG_B16 ? 2 : 4);
-    }
-
-    return bad_pc;
-}
-
-#if !defined(CONFIG_USER_ONLY)
 static void set_hflags_for_handler(CPUMIPSState *env)
 {
     /* Exception handlers are entered in 32-bit mode.  */
@@ -1398,24 +1279,6 @@ void mips_cpu_do_interrupt(CPUState *cs)
     cs->exception_index = EXCP_NONE;
 }
 
-bool mips_cpu_exec_interrupt(CPUState *cs, int interrupt_request)
-{
-    if (interrupt_request & CPU_INTERRUPT_HARD) {
-        MIPSCPU *cpu = MIPS_CPU(cs);
-        CPUMIPSState *env = &cpu->env;
-
-        if (cpu_mips_hw_interrupts_enabled(env) &&
-            cpu_mips_hw_interrupts_pending(env)) {
-            /* Raise it */
-            cs->exception_index = EXCP_EXT_INTERRUPT;
-            env->error_code = 0;
-            mips_cpu_do_interrupt(cs);
-            return true;
-        }
-    }
-    return false;
-}
-
 #if !defined(CONFIG_USER_ONLY)
 void r4k_invalidate_tlb(CPUMIPSState *env, int idx, int use_extra)
 {
@@ -1482,18 +1345,3 @@ void r4k_invalidate_tlb(CPUMIPSState *env, int idx, int use_extra)
     }
 }
 #endif /* !CONFIG_USER_ONLY */
-
-void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env,
-                                          uint32_t exception,
-                                          int error_code,
-                                          uintptr_t pc)
-{
-    CPUState *cs = env_cpu(env);
-
-    qemu_log_mask(CPU_LOG_INT, "%s: %d %d\n",
-                  __func__, exception, error_code);
-    cs->exception_index = exception;
-    env->error_code = error_code;
-
-    cpu_loop_exit_restore(cs, pc);
-}
diff --git a/target/mips/meson.build b/target/mips/meson.build
index d980240f9e3..4858bf86ad6 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,5 +1,6 @@
 mips_ss = ss.source_set()
 mips_ss.add(files(
+  'common_helper.c',
   'cp0_helper.c',
   'cpu.c',
   'dsp_helper.c',
-- 
2.26.2

