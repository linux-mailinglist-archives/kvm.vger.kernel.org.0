Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF502D9F53
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408909AbgLNSit (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:38:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408895AbgLNSit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:38:49 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042A5C0613D3
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:09 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d26so4229364wrb.12
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=35iXDZeU1/ndOktt2O4X9ATnWZ6nXG6x/rceHWRoTA0=;
        b=tBRSMIu6NzbVXjf3kPj/Qm9VfXdPqPMDdFPreznoNjiHORdK9vRa9pkfieDv+sGlbe
         MQoKiNx+ycUodFcc5q5Xc1DiVDW6v+m3HlI+6Ixj5cJaxdUxS9RgGBcvhpWCsgJoUkyG
         BilUjY9090lHE8FRyLBcMm6VjJBtWLeBdJSMaY1CIcYG4YT9qrW1wQ8LcSlC9guoK2n3
         7KC0e9S8zw3Qen3YUVQR3gWDUEWRpMLj5KhW/TGks+xQ7GRQ16Ip9p2hSEg5jyF90j1+
         CP6XnTKRRWYC65fywUq4BhlPftAVXBjgPWZL4zmFiaiYjtqw3Ist99Am6Jjh4mkItEN2
         YIpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=35iXDZeU1/ndOktt2O4X9ATnWZ6nXG6x/rceHWRoTA0=;
        b=gYxvU+i4cqoQKVUoEEJe8lRZBf6TTxS4yq71/SAibI1Ah1EiunjRY7CGAfFGBxVc1J
         y/7kgXejp7XhUInaPS7g9t43BictDRa/4opRAk3iLSw9QT2KpOulkbmsAGYLZfjM4IXc
         4GnMnpIGYQ3XnV+asedW+EsVXvS6ZhKGGxR/4iblOs/tZ7/xyKrLhn9IfE96diLkQPhq
         75MKSevKdzbF0lVZ/Or5uO9A/xCSq9zB8U/14H0Umwk6p5WMNM0SKlVcftBrFRBw6lqz
         K+KGGwm94DUIzhy+ozLOScB7Rt1Zrjk9RWp9nxTaUGH/lNBf4dmiDv5BejMOE2HZyUIh
         1J7w==
X-Gm-Message-State: AOAM533ugoChtgWZff40ptN6yQZ7pc3eL4P+vSgtijg4f3VvTyg1DyJ/
        Np3n6urSOKg0D6hrN/xYH3o=
X-Google-Smtp-Source: ABdhPJzOy3HrSvo4JfYrDgPumHlTtg+Y0kA0lzttaDAXBEXF7YA8bLQlFtHcqal6W3UXiziMszSZKg==
X-Received: by 2002:adf:a388:: with SMTP id l8mr30321919wrb.354.1607971087743;
        Mon, 14 Dec 2020 10:38:07 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m17sm36097710wrn.0.2020.12.14.10.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:06 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 05/16] target/mips: Extract common helpers from helper.c to common_helper.c
Date:   Mon, 14 Dec 2020 19:37:28 +0100
Message-Id: <20201214183739.500368-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
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
 target/mips/internal.h |   2 +
 target/mips/cpu.c      | 215 +++++++++++++++++++++++++++++++++++++++--
 target/mips/helper.c   | 201 --------------------------------------
 3 files changed, 211 insertions(+), 207 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 24d9f0d6a5c..c1401492c46 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -399,6 +399,8 @@ void sync_c0_status(CPUMIPSState *env, CPUMIPSState *cpu, int tc);
 void cpu_mips_store_status(CPUMIPSState *env, target_ulong val);
 void cpu_mips_store_cause(CPUMIPSState *env, target_ulong val);
 
+const char *mips_exception_name(int32_t exception);
+
 void QEMU_NORETURN do_raise_exception_err(CPUMIPSState *env, uint32_t exception,
                                           int error_code, uintptr_t pc);
 
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 7a0dcb11ecd..a54be034a2b 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -34,6 +34,215 @@
 #include "hw/semihosting/semihost.h"
 #include "qapi/qapi-commands-machine-target.h"
 
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
+    if (ase_mt_available(env)) {
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
+static const char * const excp_names[EXCP_LAST + 1] = {
+    [EXCP_RESET] = "reset",
+    [EXCP_SRESET] = "soft reset",
+    [EXCP_DSS] = "debug single step",
+    [EXCP_DINT] = "debug interrupt",
+    [EXCP_NMI] = "non-maskable interrupt",
+    [EXCP_MCHECK] = "machine check",
+    [EXCP_EXT_INTERRUPT] = "interrupt",
+    [EXCP_DFWATCH] = "deferred watchpoint",
+    [EXCP_DIB] = "debug instruction breakpoint",
+    [EXCP_IWATCH] = "instruction fetch watchpoint",
+    [EXCP_AdEL] = "address error load",
+    [EXCP_AdES] = "address error store",
+    [EXCP_TLBF] = "TLB refill",
+    [EXCP_IBE] = "instruction bus error",
+    [EXCP_DBp] = "debug breakpoint",
+    [EXCP_SYSCALL] = "syscall",
+    [EXCP_BREAK] = "break",
+    [EXCP_CpU] = "coprocessor unusable",
+    [EXCP_RI] = "reserved instruction",
+    [EXCP_OVERFLOW] = "arithmetic overflow",
+    [EXCP_TRAP] = "trap",
+    [EXCP_FPE] = "floating point",
+    [EXCP_DDBS] = "debug data break store",
+    [EXCP_DWATCH] = "data watchpoint",
+    [EXCP_LTLBL] = "TLB modify",
+    [EXCP_TLBL] = "TLB load",
+    [EXCP_TLBS] = "TLB store",
+    [EXCP_DBE] = "data bus error",
+    [EXCP_DDBL] = "debug data break load",
+    [EXCP_THREAD] = "thread",
+    [EXCP_MDMX] = "MDMX",
+    [EXCP_C2E] = "precise coprocessor 2",
+    [EXCP_CACHE] = "cache error",
+    [EXCP_TLBXI] = "TLB execute-inhibit",
+    [EXCP_TLBRI] = "TLB read-inhibit",
+    [EXCP_MSADIS] = "MSA disabled",
+    [EXCP_MSAFPE] = "MSA floating point",
+};
+
+const char *mips_exception_name(int32_t exception)
+{
+    if (exception < 0 || exception > EXCP_LAST) {
+        return "unknown";
+    }
+    return excp_names[exception];
+}
+
+void cpu_set_exception_base(int vp_index, target_ulong address)
+{
+    MIPSCPU *vp = MIPS_CPU(qemu_get_cpu(vp_index));
+    vp->env.exception_base = address;
+}
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
+    qemu_log_mask(CPU_LOG_INT, "%s: %d (%s) %d\n",
+                  __func__, exception, mips_exception_name(exception),
+                  error_code);
+    cs->exception_index = exception;
+    env->error_code = error_code;
+
+    cpu_loop_exit_restore(cs, pc);
+}
+
 static void mips_cpu_set_pc(CPUState *cs, vaddr value)
 {
     MIPSCPU *cpu = MIPS_CPU(cs);
@@ -591,9 +800,3 @@ bool cpu_type_supports_cps_smp(const char *cpu_type)
     const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
     return (mcc->cpu_def->CP0_Config3 & (1 << CP0C3_CMGCR)) != 0;
 }
-
-void cpu_set_exception_base(int vp_index, target_ulong address)
-{
-    MIPSCPU *vp = MIPS_CPU(qemu_get_cpu(vp_index));
-    vp->env.exception_base = address;
-}
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 0692e232f0a..59787b870b8 100644
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
-    if (ase_mt_available(env)) {
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
@@ -977,75 +878,7 @@ hwaddr cpu_mips_translate_address(CPUMIPSState *env, target_ulong address,
         return physical;
     }
 }
-#endif /* !CONFIG_USER_ONLY */
 
-static const char * const excp_names[EXCP_LAST + 1] = {
-    [EXCP_RESET] = "reset",
-    [EXCP_SRESET] = "soft reset",
-    [EXCP_DSS] = "debug single step",
-    [EXCP_DINT] = "debug interrupt",
-    [EXCP_NMI] = "non-maskable interrupt",
-    [EXCP_MCHECK] = "machine check",
-    [EXCP_EXT_INTERRUPT] = "interrupt",
-    [EXCP_DFWATCH] = "deferred watchpoint",
-    [EXCP_DIB] = "debug instruction breakpoint",
-    [EXCP_IWATCH] = "instruction fetch watchpoint",
-    [EXCP_AdEL] = "address error load",
-    [EXCP_AdES] = "address error store",
-    [EXCP_TLBF] = "TLB refill",
-    [EXCP_IBE] = "instruction bus error",
-    [EXCP_DBp] = "debug breakpoint",
-    [EXCP_SYSCALL] = "syscall",
-    [EXCP_BREAK] = "break",
-    [EXCP_CpU] = "coprocessor unusable",
-    [EXCP_RI] = "reserved instruction",
-    [EXCP_OVERFLOW] = "arithmetic overflow",
-    [EXCP_TRAP] = "trap",
-    [EXCP_FPE] = "floating point",
-    [EXCP_DDBS] = "debug data break store",
-    [EXCP_DWATCH] = "data watchpoint",
-    [EXCP_LTLBL] = "TLB modify",
-    [EXCP_TLBL] = "TLB load",
-    [EXCP_TLBS] = "TLB store",
-    [EXCP_DBE] = "data bus error",
-    [EXCP_DDBL] = "debug data break load",
-    [EXCP_THREAD] = "thread",
-    [EXCP_MDMX] = "MDMX",
-    [EXCP_C2E] = "precise coprocessor 2",
-    [EXCP_CACHE] = "cache error",
-    [EXCP_TLBXI] = "TLB execute-inhibit",
-    [EXCP_TLBRI] = "TLB read-inhibit",
-    [EXCP_MSADIS] = "MSA disabled",
-    [EXCP_MSAFPE] = "MSA floating point",
-};
-
-static const char *mips_exception_name(int32_t exception)
-{
-    if (exception < 0 || exception > EXCP_LAST) {
-        return "unknown";
-    }
-    return excp_names[exception];
-}
-
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
@@ -1400,24 +1233,6 @@ void mips_cpu_do_interrupt(CPUState *cs)
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
@@ -1484,19 +1299,3 @@ void r4k_invalidate_tlb(CPUMIPSState *env, int idx, int use_extra)
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
-    qemu_log_mask(CPU_LOG_INT, "%s: %d (%s) %d\n",
-                  __func__, exception, mips_exception_name(exception),
-                  error_code);
-    cs->exception_index = exception;
-    env->error_code = error_code;
-
-    cpu_loop_exit_restore(cs, pc);
-}
-- 
2.26.2

