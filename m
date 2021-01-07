Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2E362EE878
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbhAGWZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727009AbhAGWZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:12 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52BEC0612FE
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:56 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id i9so7141852wrc.4
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xuQvuHCVEZAh72d2SismUVVThKi2PJBBdEAx4eAa8xA=;
        b=Q2omS1dTQ5l9zZI9kwOfN7yqVmBr2Fi6m2ULr4cO413bbIB9O8O9MMRGEz1A/4nsVb
         GuUBUTqw6Zj5Km24Oxtm4E+Xu7O+SSbDyAHafGtqrusWWnslBz6p0mzv9D9FJOJ6AMdf
         vcR1B3MsCtMcHU/i+3oOZVUo4VkGnrspog8i/b1Qfx2DaADiZESMGp7Gg7KfoEPd4B0G
         o2q5R/D4HcfeBuEG1UIY4ZWYu0kujQVE9LNoyv4XHVnGl4cZ6F9eXLRz1uEyBL+Jc38q
         uxNnjetg36dkZJUbPxcwisll8nn61YHQpdxCnEqWUrT5A5ChZsjTWessqn8RvJb6gqnU
         g/Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=xuQvuHCVEZAh72d2SismUVVThKi2PJBBdEAx4eAa8xA=;
        b=cxFy/rFAXIgQ4SjC05fucLubhNe07CEGbfgXdJZ1r6lRdL5sU5Z5nm3yEMZXTh5Swv
         SAprBIBJv7VYQIrT0UDVpm2UTKgN1LZRjlrO0rxr5Li+sU+yMcbj1JrFp/H8mkC1yP90
         Rv4AlDPnYFvG4Cd6N1Vgd8V2cLId9HpRY+Y51nepRAJQT2iK800WG9d0JkIMJenA4TQV
         fqWphMLpR5sCEkdcpD9LggNnMeqW/hb98VfB/Hq87ZZthUrTLNTj1KDGZNPFd8P8OUJT
         gW2iOtX3t/be1xnQIFCIb6LrmdEqUiDo/5WmOPGbbJibbd86QNMoQRKHG5f3F2jdZSmq
         ZyEA==
X-Gm-Message-State: AOAM531Xyaw3ssoK5xYNBGIRKciisOa6mb7wehZ7BjQ8M124LOyLjpyP
        RQx02LYJ4pzeFo96nNfu/9c=
X-Google-Smtp-Source: ABdhPJxq3F0JGBmt7EbcwdQWI7gMPkSM0l1prQN7QshireE7IIB2B4smMCPKyoPIy8z+koUNe2rRCw==
X-Received: by 2002:adf:ec86:: with SMTP id z6mr670954wrn.17.1610058295678;
        Thu, 07 Jan 2021 14:24:55 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id u9sm9799784wmb.32.2021.01.07.14.24.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:55 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     libvir-list@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 23/66] target/mips: Move common helpers from helper.c to cpu.c
Date:   Thu,  7 Jan 2021 23:22:10 +0100
Message-Id: <20210107222253.20382-24-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The rest of helper.c is TLB related. Extract the non TLB
specific functions to cpu.c, so we can rename helper.c as
tlb_helper.c in the next commit.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201214183739.500368-6-f4bug@amsat.org>
---
 target/mips/internal.h |   2 +
 target/mips/cpu.c      | 215 +++++++++++++++++++++++++++++++++++++++--
 target/mips/helper.c   | 201 --------------------------------------
 3 files changed, 211 insertions(+), 207 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index f159187b246..ae1181d2029 100644
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
index 4a251e2d3e8..26b4c3e9cd5 100644
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
+    if (env->insn_flags & ISA_MIPS_R6) {
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
+    if (env->insn_flags & ISA_MIPS_R2) {
+        mask |= 1 << CP0Ca_DC;
+    }
+    if (env->insn_flags & ISA_MIPS_R6) {
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
@@ -587,9 +796,3 @@ bool cpu_type_supports_cps_smp(const char *cpu_type)
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
index cfb6d82fd33..68804b84b15 100644
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
-    if (env->insn_flags & ISA_MIPS_R6) {
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
-    if (env->insn_flags & ISA_MIPS_R2) {
-        mask |= 1 << CP0Ca_DC;
-    }
-    if (env->insn_flags & ISA_MIPS_R6) {
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

