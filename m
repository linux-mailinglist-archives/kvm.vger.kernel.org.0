Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8005F2EE879
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbhAGWZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbhAGWZM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:12 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA523C0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:31 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 190so6376193wmz.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ROz8kLr0ajAbCB92YY9f25vBRbsoSaL9vHc2JZ+ss8=;
        b=fB7VCg1QQsnwio0EOVmK2I6MPPMaih/S2jk6lDfltCLipmZvHWODclDO6WPdZqF7fy
         K/rIoKzXnyAhrCCqoA+CNH6u7oncbanzy9g0gtcxwePlWhp1MgH60DSXIUbGoax5N5mi
         bpRUN8xYDRUmpvgV1tTNi6I3+Vhr5uTHy5LdIm1KVBJrRmdFA51Xsld5MzuLQ6mtBTFR
         k54HlfZtEJ+j8Vl8qzQ4cL4XZC5G3o8MdxBiiy+U6GWUGr6nJuSj5Oq+SBHzTIySIfWg
         rPUg1EX1g9MtnT3TROS+Fee8rcfq8vrPrA8f0IgpqRC/oVHE76KL/JPCdEVTmlqneHgM
         TheQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+ROz8kLr0ajAbCB92YY9f25vBRbsoSaL9vHc2JZ+ss8=;
        b=m9Ecux1gaVCB2e2Mm3cykJtZoZMVoJovHIaHIcE8RQk5pIKjtpzQ7ORc2SC7IxB/Tz
         J9m4iXht1zcUiU1z9F9Oj2qczAxxHklJay7GcOHYTECr2otuBmVWA0uR2fA62QF/I7C6
         h89MyJlNKL5LEDSzednh5ZyUMDfFHjgouyFI6QD6Low6E/mKH8ggSbPcYD2tHqkn4s4C
         R5FqvwqTnTjxsw8dIDxBCkV0dCEqGyVloDNXCJLWmTEZKQuNP2aPWm2O1Rnp/+LaM6RY
         QiDLxi/yMxRes9RDso/cCzw0wmsAxt8R6u6tk4gL18qYXsRVhZmCg8ZYDWPJl/xArZQA
         qGww==
X-Gm-Message-State: AOAM530wy+Y9ak6/bLWxoc9740BQBRGYr2l5yUIH4DFkai2YcjkZ2czY
        nFS2+3nYpaNgDSmDM7xoFYw=
X-Google-Smtp-Source: ABdhPJxwWscDAiHyLTrAjJD6T/GRX0C8xYRGrmQkZmOfM5+DX831TdHpamk/8zSO30HOdhSH3zKuRg==
X-Received: by 2002:a1c:40d6:: with SMTP id n205mr544750wma.0.1610058270263;
        Thu, 07 Jan 2021 14:24:30 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id m8sm10082986wmc.27.2021.01.07.14.24.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:29 -0800 (PST)
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
Subject: [PULL 18/66] target/mips/mips-defs: Rename ISA_MIPS32R6 as ISA_MIPS_R6
Date:   Thu,  7 Jan 2021 23:22:05 +0100
Message-Id: <20210107222253.20382-19-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MIPS ISA release 6 is common to 32/64-bit CPUs.

To avoid holes in the insn_flags type, update the
definition with the next available bit.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-16-f4bug@amsat.org>
---
 target/mips/internal.h     |   4 +-
 target/mips/mips-defs.h    |   4 +-
 linux-user/mips/cpu_loop.c |   2 +-
 target/mips/cp0_helper.c   |  18 +-
 target/mips/cpu.c          |   6 +-
 target/mips/fpu_helper.c   |   4 +-
 target/mips/helper.c       |  10 +-
 target/mips/translate.c    | 426 ++++++++++++++++++-------------------
 8 files changed, 237 insertions(+), 237 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 23ae31ef989..77a648bcf9c 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -354,7 +354,7 @@ static inline void compute_hflags(CPUMIPSState *env)
     } else if (((env->hflags & MIPS_HFLAG_KSU) == MIPS_HFLAG_UM) &&
                !(env->CP0_Status & (1 << CP0St_UX))) {
         env->hflags |= MIPS_HFLAG_AWRAP;
-    } else if (env->insn_flags & ISA_MIPS32R6) {
+    } else if (env->insn_flags & ISA_MIPS_R6) {
         /* Address wrapping for Supervisor and Kernel is specified in R6 */
         if ((((env->hflags & MIPS_HFLAG_KSU) == MIPS_HFLAG_SM) &&
              !(env->CP0_Status & (1 << CP0St_SX))) ||
@@ -365,7 +365,7 @@ static inline void compute_hflags(CPUMIPSState *env)
     }
 #endif
     if (((env->CP0_Status & (1 << CP0St_CU0)) &&
-         !(env->insn_flags & ISA_MIPS32R6)) ||
+         !(env->insn_flags & ISA_MIPS_R6)) ||
         !(env->hflags & MIPS_HFLAG_KSU)) {
         env->hflags |= MIPS_HFLAG_CP0;
     }
diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 181f3715472..97866019a72 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -20,7 +20,7 @@
 #define ISA_MIPS_R2       0x0000000000000040ULL
 #define ISA_MIPS_R3       0x0000000000000080ULL
 #define ISA_MIPS_R5       0x0000000000000100ULL
-#define ISA_MIPS32R6      0x0000000000002000ULL
+#define ISA_MIPS_R6       0x0000000000000200ULL
 #define ISA_NANOMIPS32    0x0000000000008000ULL
 /*
  *   bits 24-39: MIPS ASEs
@@ -85,7 +85,7 @@
 #define CPU_MIPS64R5    (CPU_MIPS64R3 | CPU_MIPS32R5)
 
 /* MIPS Technologies "Release 6" */
-#define CPU_MIPS32R6    (CPU_MIPS32R5 | ISA_MIPS32R6)
+#define CPU_MIPS32R6    (CPU_MIPS32R5 | ISA_MIPS_R6)
 #define CPU_MIPS64R6    (CPU_MIPS64R5 | CPU_MIPS32R6)
 
 /* Wave Computing: "nanoMIPS" */
diff --git a/linux-user/mips/cpu_loop.c b/linux-user/mips/cpu_loop.c
index 748e1c664f1..19947448a25 100644
--- a/linux-user/mips/cpu_loop.c
+++ b/linux-user/mips/cpu_loop.c
@@ -385,7 +385,7 @@ void target_cpu_copy_regs(CPUArchState *env, struct target_pt_regs *regs)
     prog_req.fre &= interp_req.fre;
 
     bool cpu_has_mips_r2_r6 = env->insn_flags & ISA_MIPS_R2 ||
-                              env->insn_flags & ISA_MIPS32R6;
+                              env->insn_flags & ISA_MIPS_R6;
 
     if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1) {
         env->CP0_Config5 |= (1 << CP0C5_FRE);
diff --git a/target/mips/cp0_helper.c b/target/mips/cp0_helper.c
index 36a92857bfb..aae2af6eccc 100644
--- a/target/mips/cp0_helper.c
+++ b/target/mips/cp0_helper.c
@@ -527,7 +527,7 @@ void helper_mtc0_index(CPUMIPSState *env, target_ulong arg1)
     uint32_t index_p = env->CP0_Index & 0x80000000;
     uint32_t tlb_index = arg1 & 0x7fffffff;
     if (tlb_index < env->tlb->nb_tlb) {
-        if (env->insn_flags & ISA_MIPS32R6) {
+        if (env->insn_flags & ISA_MIPS_R6) {
             index_p |= arg1 & 0x80000000;
         }
         env->CP0_Index = index_p | tlb_index;
@@ -960,7 +960,7 @@ void helper_mtc0_pwfield(CPUMIPSState *env, target_ulong arg1)
     uint32_t old_ptei = (env->CP0_PWField >> CP0PF_PTEI) & 0x3FULL;
     uint32_t new_ptei = (arg1 >> CP0PF_PTEI) & 0x3FULL;
 
-    if ((env->insn_flags & ISA_MIPS32R6)) {
+    if ((env->insn_flags & ISA_MIPS_R6)) {
         if (((arg1 >> CP0PF_BDI) & 0x3FULL) < 12) {
             mask &= ~(0x3FULL << CP0PF_BDI);
         }
@@ -980,7 +980,7 @@ void helper_mtc0_pwfield(CPUMIPSState *env, target_ulong arg1)
     env->CP0_PWField = arg1 & mask;
 
     if ((new_ptei >= 32) ||
-            ((env->insn_flags & ISA_MIPS32R6) &&
+            ((env->insn_flags & ISA_MIPS_R6) &&
                     (new_ptei == 0 || new_ptei == 1))) {
         env->CP0_PWField = (env->CP0_PWField & ~0x3FULL) |
                 (old_ptei << CP0PF_PTEI);
@@ -990,7 +990,7 @@ void helper_mtc0_pwfield(CPUMIPSState *env, target_ulong arg1)
     uint32_t old_ptew = (env->CP0_PWField >> CP0PF_PTEW) & 0x3F;
     uint32_t new_ptew = (arg1 >> CP0PF_PTEW) & 0x3F;
 
-    if ((env->insn_flags & ISA_MIPS32R6)) {
+    if ((env->insn_flags & ISA_MIPS_R6)) {
         if (((arg1 >> CP0PF_GDW) & 0x3F) < 12) {
             mask &= ~(0x3F << CP0PF_GDW);
         }
@@ -1007,7 +1007,7 @@ void helper_mtc0_pwfield(CPUMIPSState *env, target_ulong arg1)
     env->CP0_PWField = arg1 & mask;
 
     if ((new_ptew >= 32) ||
-            ((env->insn_flags & ISA_MIPS32R6) &&
+            ((env->insn_flags & ISA_MIPS_R6) &&
                     (new_ptew == 0 || new_ptew == 1))) {
         env->CP0_PWField = (env->CP0_PWField & ~0x3F) |
                 (old_ptew << CP0PF_PTEW);
@@ -1026,7 +1026,7 @@ void helper_mtc0_pwsize(CPUMIPSState *env, target_ulong arg1)
 
 void helper_mtc0_wired(CPUMIPSState *env, target_ulong arg1)
 {
-    if (env->insn_flags & ISA_MIPS32R6) {
+    if (env->insn_flags & ISA_MIPS_R6) {
         if (arg1 < env->tlb->nb_tlb) {
             env->CP0_Wired = arg1;
         }
@@ -1075,10 +1075,10 @@ void helper_mtc0_hwrena(CPUMIPSState *env, target_ulong arg1)
     uint32_t mask = 0x0000000F;
 
     if ((env->CP0_Config1 & (1 << CP0C1_PC)) &&
-        (env->insn_flags & ISA_MIPS32R6)) {
+        (env->insn_flags & ISA_MIPS_R6)) {
         mask |= (1 << 4);
     }
-    if (env->insn_flags & ISA_MIPS32R6) {
+    if (env->insn_flags & ISA_MIPS_R6) {
         mask |= (1 << 5);
     }
     if (env->CP0_Config3 & (1 << CP0C3_ULRI)) {
@@ -1149,7 +1149,7 @@ void helper_mtc0_entryhi(CPUMIPSState *env, target_ulong arg1)
 
     /* 1k pages not implemented */
 #if defined(TARGET_MIPS64)
-    if (env->insn_flags & ISA_MIPS32R6) {
+    if (env->insn_flags & ISA_MIPS_R6) {
         int entryhi_r = extract64(arg1, 62, 2);
         int config0_at = extract32(env->CP0_Config0, 13, 2);
         bool no_supervisor = (env->CP0_Status_rw_bitmask & 0x8) == 0;
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 2283214c879..12126d37f16 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -71,7 +71,7 @@ static bool mips_cpu_has_work(CPUState *cs)
     if ((cs->interrupt_request & CPU_INTERRUPT_HARD) &&
         cpu_mips_hw_interrupts_pending(env)) {
         if (cpu_mips_hw_interrupts_enabled(env) ||
-            (env->insn_flags & ISA_MIPS32R6)) {
+            (env->insn_flags & ISA_MIPS_R6)) {
             has_work = true;
         }
     }
@@ -287,13 +287,13 @@ static void cpu_state_reset(CPUMIPSState *env)
     /* XKPhys (note, SegCtl2.XR = 0, so XAM won't be used) */
     env->CP0_SegCtl1 |= (CP0SC_AM_UK << CP0SC1_XAM);
 #endif /* !CONFIG_USER_ONLY */
-    if ((env->insn_flags & ISA_MIPS32R6) &&
+    if ((env->insn_flags & ISA_MIPS_R6) &&
         (env->active_fpu.fcr0 & (1 << FCR0_F64))) {
         /* Status.FR = 0 mode in 64-bit FPU not allowed in R6 */
         env->CP0_Status |= (1 << CP0St_FR);
     }
 
-    if (env->insn_flags & ISA_MIPS32R6) {
+    if (env->insn_flags & ISA_MIPS_R6) {
         /* PTW  =  1 */
         env->CP0_PWSize = 0x40;
         /* GDI  = 12 */
diff --git a/target/mips/fpu_helper.c b/target/mips/fpu_helper.c
index bdb65065ee7..91b6a2e11fc 100644
--- a/target/mips/fpu_helper.c
+++ b/target/mips/fpu_helper.c
@@ -145,7 +145,7 @@ void helper_ctc1(CPUMIPSState *env, target_ulong arg1, uint32_t fs, uint32_t rt)
         }
         break;
     case 25:
-        if ((env->insn_flags & ISA_MIPS32R6) || (arg1 & 0xffffff00)) {
+        if ((env->insn_flags & ISA_MIPS_R6) || (arg1 & 0xffffff00)) {
             return;
         }
         env->active_fpu.fcr31 = (env->active_fpu.fcr31 & 0x017fffff) |
@@ -172,7 +172,7 @@ void helper_ctc1(CPUMIPSState *env, target_ulong arg1, uint32_t fs, uint32_t rt)
                (env->active_fpu.fcr31 & ~(env->active_fpu.fcr31_rw_bitmask));
         break;
     default:
-        if (env->insn_flags & ISA_MIPS32R6) {
+        if (env->insn_flags & ISA_MIPS_R6) {
             do_raise_exception(env, EXCP_RI, GETPC());
         }
         return;
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 98d6ecaa65e..d1b6bb6fb23 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -397,7 +397,7 @@ void cpu_mips_store_status(CPUMIPSState *env, target_ulong val)
     uint32_t mask = env->CP0_Status_rw_bitmask;
     target_ulong old = env->CP0_Status;
 
-    if (env->insn_flags & ISA_MIPS32R6) {
+    if (env->insn_flags & ISA_MIPS_R6) {
         bool has_supervisor = extract32(mask, CP0St_KSU, 2) == 0x3;
 #if defined(TARGET_MIPS64)
         uint32_t ksux = (1 << CP0St_KX) & val;
@@ -434,7 +434,7 @@ void cpu_mips_store_cause(CPUMIPSState *env, target_ulong val)
     if (env->insn_flags & ISA_MIPS_R2) {
         mask |= 1 << CP0Ca_DC;
     }
-    if (env->insn_flags & ISA_MIPS32R6) {
+    if (env->insn_flags & ISA_MIPS_R6) {
         mask &= ~((1 << CP0Ca_WP) & val);
     }
 
@@ -1145,7 +1145,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
  enter_debug_mode:
         if (env->insn_flags & ISA_MIPS3) {
             env->hflags |= MIPS_HFLAG_64;
-            if (!(env->insn_flags & ISA_MIPS32R6) ||
+            if (!(env->insn_flags & ISA_MIPS_R6) ||
                 env->CP0_Status & (1 << CP0St_KX)) {
                 env->hflags &= ~MIPS_HFLAG_AWRAP;
             }
@@ -1174,7 +1174,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
         env->CP0_Status |= (1 << CP0St_ERL) | (1 << CP0St_BEV);
         if (env->insn_flags & ISA_MIPS3) {
             env->hflags |= MIPS_HFLAG_64;
-            if (!(env->insn_flags & ISA_MIPS32R6) ||
+            if (!(env->insn_flags & ISA_MIPS_R6) ||
                 env->CP0_Status & (1 << CP0St_KX)) {
                 env->hflags &= ~MIPS_HFLAG_AWRAP;
             }
@@ -1360,7 +1360,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
             env->CP0_Status |= (1 << CP0St_EXL);
             if (env->insn_flags & ISA_MIPS3) {
                 env->hflags |= MIPS_HFLAG_64;
-                if (!(env->insn_flags & ISA_MIPS32R6) ||
+                if (!(env->insn_flags & ISA_MIPS_R6) ||
                     env->CP0_Status & (1 << CP0St_KX)) {
                     env->hflags &= ~MIPS_HFLAG_AWRAP;
                 }
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 83fd6c473a5..e813add99c5 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -4014,7 +4014,7 @@ static void gen_logic_imm(DisasContext *ctx, uint32_t opc,
         }
         break;
     case OPC_LUI:
-        if (rs != 0 && (ctx->insn_flags & ISA_MIPS32R6)) {
+        if (rs != 0 && (ctx->insn_flags & ISA_MIPS_R6)) {
             /* OPC_AUI */
             tcg_gen_addi_tl(cpu_gpr[rt], cpu_gpr[rs], imm << 16);
             tcg_gen_ext32s_tl(cpu_gpr[rt], cpu_gpr[rt]);
@@ -7399,7 +7399,7 @@ cp0_unimplemented:
 
 static inline void gen_mfc0_unimplemented(DisasContext *ctx, TCGv arg)
 {
-    if (ctx->insn_flags & ISA_MIPS32R6) {
+    if (ctx->insn_flags & ISA_MIPS_R6) {
         tcg_gen_movi_tl(arg, 0);
     } else {
         tcg_gen_movi_tl(arg, ~0);
@@ -7448,7 +7448,7 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     case CP0_REGISTER_01:
         switch (sel) {
         case CP0_REG01__RANDOM:
-            CP0_CHECK(!(ctx->insn_flags & ISA_MIPS32R6));
+            CP0_CHECK(!(ctx->insn_flags & ISA_MIPS_R6));
             gen_helper_mfc0_random(arg, cpu_env);
             register_name = "Random";
             break;
@@ -7964,7 +7964,7 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
         break;
     case CP0_REGISTER_21:
        /* Officially reserved, but sel 0 is used for R1x000 framemask */
-        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS32R6));
+        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS_R6));
         switch (sel) {
         case 0:
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_Framemask));
@@ -8709,7 +8709,7 @@ static void gen_mtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
         break;
     case CP0_REGISTER_21:
        /* Officially reserved, but sel 0 is used for R1x000 framemask */
-        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS32R6));
+        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS_R6));
         switch (sel) {
         case 0:
             gen_helper_mtc0_framemask(cpu_env, arg);
@@ -8980,7 +8980,7 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     case CP0_REGISTER_01:
         switch (sel) {
         case CP0_REG01__RANDOM:
-            CP0_CHECK(!(ctx->insn_flags & ISA_MIPS32R6));
+            CP0_CHECK(!(ctx->insn_flags & ISA_MIPS_R6));
             gen_helper_mfc0_random(arg, cpu_env);
             register_name = "Random";
             break;
@@ -9461,7 +9461,7 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
         break;
     case CP0_REGISTER_21:
         /* Officially reserved, but sel 0 is used for R1x000 framemask */
-        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS32R6));
+        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS_R6));
         switch (sel) {
         case 0:
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_Framemask));
@@ -10191,7 +10191,7 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
         break;
     case CP0_REGISTER_21:
        /* Officially reserved, but sel 0 is used for R1x000 framemask */
-        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS32R6));
+        CP0_CHECK(!(ctx->insn_flags & ISA_MIPS_R6));
         switch (sel) {
         case 0:
             gen_helper_mtc0_framemask(cpu_env, arg);
@@ -10985,7 +10985,7 @@ static void gen_cp0(CPUMIPSState *env, DisasContext *ctx, uint32_t opc,
         gen_helper_tlbr(cpu_env);
         break;
     case OPC_ERET: /* OPC_ERETNC */
-        if ((ctx->insn_flags & ISA_MIPS32R6) &&
+        if ((ctx->insn_flags & ISA_MIPS_R6) &&
             (ctx->hflags & MIPS_HFLAG_BMASK)) {
             goto die;
         } else {
@@ -11007,7 +11007,7 @@ static void gen_cp0(CPUMIPSState *env, DisasContext *ctx, uint32_t opc,
     case OPC_DERET:
         opn = "deret";
         check_insn(ctx, ISA_MIPS_R1);
-        if ((ctx->insn_flags & ISA_MIPS32R6) &&
+        if ((ctx->insn_flags & ISA_MIPS_R6) &&
             (ctx->hflags & MIPS_HFLAG_BMASK)) {
             goto die;
         }
@@ -11022,7 +11022,7 @@ static void gen_cp0(CPUMIPSState *env, DisasContext *ctx, uint32_t opc,
     case OPC_WAIT:
         opn = "wait";
         check_insn(ctx, ISA_MIPS3 | ISA_MIPS_R1);
-        if ((ctx->insn_flags & ISA_MIPS32R6) &&
+        if ((ctx->insn_flags & ISA_MIPS_R6) &&
             (ctx->hflags & MIPS_HFLAG_BMASK)) {
             goto die;
         }
@@ -11050,7 +11050,7 @@ static void gen_compute_branch1(DisasContext *ctx, uint32_t op,
     target_ulong btarget;
     TCGv_i32 t0 = tcg_temp_new_i32();
 
-    if ((ctx->insn_flags & ISA_MIPS32R6) && (ctx->hflags & MIPS_HFLAG_BMASK)) {
+    if ((ctx->insn_flags & ISA_MIPS_R6) && (ctx->hflags & MIPS_HFLAG_BMASK)) {
         generate_exception_end(ctx, EXCP_RI);
         goto out;
     }
@@ -11906,23 +11906,23 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_SEL_S:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_sel_s(ctx, op1, fd, ft, fs);
         break;
     case OPC_SELEQZ_S:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_sel_s(ctx, op1, fd, ft, fs);
         break;
     case OPC_SELNEZ_S:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_sel_s(ctx, op1, fd, ft, fs);
         break;
     case OPC_MOVCF_S:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         gen_movcf_s(ctx, fs, fd, (ft >> 2) & 0x7, ft & 0x1);
         break;
     case OPC_MOVZ_S:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         {
             TCGLabel *l1 = gen_new_label();
             TCGv_i32 fp0;
@@ -11938,7 +11938,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MOVN_S:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         {
             TCGLabel *l1 = gen_new_label();
             TCGv_i32 fp0;
@@ -11974,7 +11974,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MADDF_S:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i32 fp0 = tcg_temp_new_i32();
             TCGv_i32 fp1 = tcg_temp_new_i32();
@@ -11990,7 +11990,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MSUBF_S:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i32 fp0 = tcg_temp_new_i32();
             TCGv_i32 fp1 = tcg_temp_new_i32();
@@ -12006,7 +12006,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_RINT_S:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i32 fp0 = tcg_temp_new_i32();
             gen_load_fpr32(ctx, fp0, fs);
@@ -12016,7 +12016,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_CLASS_S:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i32 fp0 = tcg_temp_new_i32();
             gen_load_fpr32(ctx, fp0, fs);
@@ -12026,7 +12026,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MIN_S: /* OPC_RECIP2_S */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MIN_S */
             TCGv_i32 fp0 = tcg_temp_new_i32();
             TCGv_i32 fp1 = tcg_temp_new_i32();
@@ -12055,7 +12055,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MINA_S: /* OPC_RECIP1_S */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MINA_S */
             TCGv_i32 fp0 = tcg_temp_new_i32();
             TCGv_i32 fp1 = tcg_temp_new_i32();
@@ -12081,7 +12081,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MAX_S: /* OPC_RSQRT1_S */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MAX_S */
             TCGv_i32 fp0 = tcg_temp_new_i32();
             TCGv_i32 fp1 = tcg_temp_new_i32();
@@ -12105,7 +12105,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MAXA_S: /* OPC_RSQRT2_S */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MAXA_S */
             TCGv_i32 fp0 = tcg_temp_new_i32();
             TCGv_i32 fp1 = tcg_temp_new_i32();
@@ -12207,7 +12207,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
     case OPC_CMP_NGE_S:
     case OPC_CMP_LE_S:
     case OPC_CMP_NGT_S:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->opcode & (1 << 6)) {
             gen_cmpabs_s(ctx, func - 48, ft, fs, cc);
         } else {
@@ -12450,23 +12450,23 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_SEL_D:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_sel_d(ctx, op1, fd, ft, fs);
         break;
     case OPC_SELEQZ_D:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_sel_d(ctx, op1, fd, ft, fs);
         break;
     case OPC_SELNEZ_D:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_sel_d(ctx, op1, fd, ft, fs);
         break;
     case OPC_MOVCF_D:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         gen_movcf_d(ctx, fs, fd, (ft >> 2) & 0x7, ft & 0x1);
         break;
     case OPC_MOVZ_D:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         {
             TCGLabel *l1 = gen_new_label();
             TCGv_i64 fp0;
@@ -12482,7 +12482,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MOVN_D:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         {
             TCGLabel *l1 = gen_new_label();
             TCGv_i64 fp0;
@@ -12520,7 +12520,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MADDF_D:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i64 fp0 = tcg_temp_new_i64();
             TCGv_i64 fp1 = tcg_temp_new_i64();
@@ -12536,7 +12536,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MSUBF_D:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i64 fp0 = tcg_temp_new_i64();
             TCGv_i64 fp1 = tcg_temp_new_i64();
@@ -12552,7 +12552,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_RINT_D:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i64 fp0 = tcg_temp_new_i64();
             gen_load_fpr64(ctx, fp0, fs);
@@ -12562,7 +12562,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_CLASS_D:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         {
             TCGv_i64 fp0 = tcg_temp_new_i64();
             gen_load_fpr64(ctx, fp0, fs);
@@ -12572,7 +12572,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MIN_D: /* OPC_RECIP2_D */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MIN_D */
             TCGv_i64 fp0 = tcg_temp_new_i64();
             TCGv_i64 fp1 = tcg_temp_new_i64();
@@ -12599,7 +12599,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MINA_D: /* OPC_RECIP1_D */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MINA_D */
             TCGv_i64 fp0 = tcg_temp_new_i64();
             TCGv_i64 fp1 = tcg_temp_new_i64();
@@ -12623,7 +12623,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MAX_D: /*  OPC_RSQRT1_D */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MAX_D */
             TCGv_i64 fp0 = tcg_temp_new_i64();
             TCGv_i64 fp1 = tcg_temp_new_i64();
@@ -12647,7 +12647,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
         }
         break;
     case OPC_MAXA_D: /* OPC_RSQRT2_D */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_MAXA_D */
             TCGv_i64 fp0 = tcg_temp_new_i64();
             TCGv_i64 fp1 = tcg_temp_new_i64();
@@ -12689,7 +12689,7 @@ static void gen_farith(DisasContext *ctx, enum fopcode op1,
     case OPC_CMP_NGE_D:
     case OPC_CMP_LE_D:
     case OPC_CMP_NGT_D:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->opcode & (1 << 6)) {
             gen_cmpabs_d(ctx, func - 48, ft, fs, cc);
         } else {
@@ -13485,7 +13485,7 @@ static void gen_rdhwr(DisasContext *ctx, int rt, int rd, int sel)
         gen_store_gpr(t0, rt);
         break;
     case 4:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         if (sel != 0) {
             /*
              * Performance counter registers are not implemented other than
@@ -13497,7 +13497,7 @@ static void gen_rdhwr(DisasContext *ctx, int rt, int rd, int sel)
         gen_store_gpr(t0, rt);
         break;
     case 5:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_helper_rdhwr_xnp(t0, cpu_env);
         gen_store_gpr(t0, rt);
         break;
@@ -16160,7 +16160,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
     case 0x2c:
         switch (minor) {
         case BITSWAP:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             gen_bitswap(ctx, OPC_BITSWAP, rs, rt);
             break;
         case SEB:
@@ -16179,26 +16179,26 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
             gen_cl(ctx, mips32_op, rt, rs);
             break;
         case RDHWR:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_rdhwr(ctx, rt, rs, 0);
             break;
         case WSBH:
             gen_bshfl(ctx, OPC_WSBH, rs, rt);
             break;
         case MULT:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_MULT;
             goto do_mul;
         case MULTU:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_MULTU;
             goto do_mul;
         case DIV:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_DIV;
             goto do_div;
         case DIVU:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_DIVU;
             goto do_div;
         do_div:
@@ -16206,19 +16206,19 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
             gen_muldiv(ctx, mips32_op, 0, rs, rt);
             break;
         case MADD:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_MADD;
             goto do_mul;
         case MADDU:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_MADDU;
             goto do_mul;
         case MSUB:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_MSUB;
             goto do_mul;
         case MSUBU:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_MSUBU;
         do_mul:
             check_insn(ctx, ISA_MIPS_R1);
@@ -16246,7 +16246,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
         switch (minor) {
         case JALR:    /* JALRC */
         case JALR_HB: /* JALRC_HB */
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 /* JALRC, JALRC_HB */
                 gen_compute_branch(ctx, OPC_JALR, 4, rs, rt, 0, 0);
             } else {
@@ -16257,7 +16257,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
             break;
         case JALRS:
         case JALRS_HB:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_JALR, 4, rs, rt, 0, 2);
             ctx->hflags |= MIPS_HFLAG_BDS_STRICT;
             break;
@@ -16400,7 +16400,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
         }
         break;
     case 0x35:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         switch (minor) {
         case MFHI32:
             gen_HILO(ctx, OPC_MFHI, 0, rs);
@@ -16674,7 +16674,7 @@ static void gen_pool32fxf(DisasContext *ctx, int rt, int rs)
     case COND_FLOAT_MOV(MOVT, 5):
     case COND_FLOAT_MOV(MOVT, 6):
     case COND_FLOAT_MOV(MOVT, 7):
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         gen_movci(ctx, rt, rs, (ctx->opcode >> 13) & 0x7, 1);
         break;
     case COND_FLOAT_MOV(MOVF, 0):
@@ -16685,7 +16685,7 @@ static void gen_pool32fxf(DisasContext *ctx, int rt, int rs)
     case COND_FLOAT_MOV(MOVF, 5):
     case COND_FLOAT_MOV(MOVF, 6):
     case COND_FLOAT_MOV(MOVF, 7):
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         gen_movci(ctx, rt, rs, (ctx->opcode >> 13) & 0x7, 0);
         break;
     default:
@@ -16736,15 +16736,15 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 gen_shift_imm(ctx, mips32_op, rt, rs, rd);
                 break;
             case SELEQZ:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_cond_move(ctx, OPC_SELEQZ, rd, rs, rt);
                 break;
             case SELNEZ:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_cond_move(ctx, OPC_SELNEZ, rd, rs, rt);
                 break;
             case R6_RDHWR:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_rdhwr(ctx, rt, rs, extract32(ctx->opcode, 11, 3));
                 break;
             default:
@@ -16768,7 +16768,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 mips32_op = OPC_SUBU;
                 goto do_arith;
             case MUL:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_MUL;
             do_arith:
                 gen_arith(ctx, mips32_op, rd, rs, rt);
@@ -16821,7 +16821,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             switch (minor) {
                 /* Conditional moves */
             case MOVN: /* MUL */
-                if (ctx->insn_flags & ISA_MIPS32R6) {
+                if (ctx->insn_flags & ISA_MIPS_R6) {
                     /* MUL */
                     gen_r6_muldiv(ctx, R6_OPC_MUL, rd, rs, rt);
                 } else {
@@ -16830,7 +16830,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case MOVZ: /* MUH */
-                if (ctx->insn_flags & ISA_MIPS32R6) {
+                if (ctx->insn_flags & ISA_MIPS_R6) {
                     /* MUH */
                     gen_r6_muldiv(ctx, R6_OPC_MUH, rd, rs, rt);
                 } else {
@@ -16839,15 +16839,15 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case MULU:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_r6_muldiv(ctx, R6_OPC_MULU, rd, rs, rt);
                 break;
             case MUHU:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_r6_muldiv(ctx, R6_OPC_MUHU, rd, rs, rt);
                 break;
             case LWXS: /* DIV */
-                if (ctx->insn_flags & ISA_MIPS32R6) {
+                if (ctx->insn_flags & ISA_MIPS_R6) {
                     /* DIV */
                     gen_r6_muldiv(ctx, R6_OPC_DIV, rd, rs, rt);
                 } else {
@@ -16856,15 +16856,15 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case MOD:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_r6_muldiv(ctx, R6_OPC_MOD, rd, rs, rt);
                 break;
             case R6_DIVU:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_r6_muldiv(ctx, R6_OPC_DIVU, rd, rs, rt);
                 break;
             case MODU:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_r6_muldiv(ctx, R6_OPC_MODU, rd, rs, rt);
                 break;
             default:
@@ -16875,12 +16875,12 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             gen_bitops(ctx, OPC_INS, rt, rs, rr, rd);
             return;
         case LSA:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             gen_lsa(ctx, OPC_LSA, rd, rs, rt,
                     extract32(ctx->opcode, 9, 2));
             break;
         case ALIGN:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             gen_align(ctx, 32, rd, rs, rt, extract32(ctx->opcode, 9, 2));
             break;
         case EXT:
@@ -16893,7 +16893,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             generate_exception_end(ctx, EXCP_BREAK);
             break;
         case SIGRIE:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             generate_exception_end(ctx, EXCP_RI);
             break;
         default:
@@ -16951,61 +16951,61 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             check_cp1_enabled(ctx);
             switch (minor) {
             case ALNV_PS:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_ALNV_PS;
                 goto do_madd;
             case MADD_S:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_MADD_S;
                 goto do_madd;
             case MADD_D:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_MADD_D;
                 goto do_madd;
             case MADD_PS:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_MADD_PS;
                 goto do_madd;
             case MSUB_S:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_MSUB_S;
                 goto do_madd;
             case MSUB_D:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_MSUB_D;
                 goto do_madd;
             case MSUB_PS:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_MSUB_PS;
                 goto do_madd;
             case NMADD_S:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_NMADD_S;
                 goto do_madd;
             case NMADD_D:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_NMADD_D;
                 goto do_madd;
             case NMADD_PS:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_NMADD_PS;
                 goto do_madd;
             case NMSUB_S:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_NMSUB_S;
                 goto do_madd;
             case NMSUB_D:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_NMSUB_D;
                 goto do_madd;
             case NMSUB_PS:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_NMSUB_PS;
             do_madd:
                 gen_flt3_arith(ctx, mips32_op, rd, rr, rs, rt);
                 break;
             case CABS_COND_FMT:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 cond = (ctx->opcode >> 6) & 0xf;
                 cc = (ctx->opcode >> 13) & 0x7;
                 fmt = (ctx->opcode >> 10) & 0x3;
@@ -17024,7 +17024,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case C_COND_FMT:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 cond = (ctx->opcode >> 6) & 0xf;
                 cc = (ctx->opcode >> 13) & 0x7;
                 fmt = (ctx->opcode >> 10) & 0x3;
@@ -17043,11 +17043,11 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case CMP_CONDN_S:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_r6_cmp_s(ctx, (ctx->opcode >> 6) & 0x1f, rt, rs, rd);
                 break;
             case CMP_CONDN_D:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 gen_r6_cmp_d(ctx, (ctx->opcode >> 6) & 0x1f, rt, rs, rd);
                 break;
             case POOL32FXF:
@@ -17069,7 +17069,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     mips32_op = OPC_PUU_PS;
                     goto do_ps;
                 case CVT_PS_S:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     mips32_op = OPC_CVT_PS_S;
                 do_ps:
                     gen_farith(ctx, mips32_op, rt, rs, rd, 0);
@@ -17079,7 +17079,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case MIN_FMT:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 switch ((ctx->opcode >> 9) & 0x3) {
                 case FMT_SDPS_S:
                     gen_farith(ctx, OPC_MIN_S, rt, rs, rd, 0);
@@ -17095,27 +17095,27 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 /* [LS][WDU]XC1 */
                 switch ((ctx->opcode >> 6) & 0x7) {
                 case LWXC1:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     mips32_op = OPC_LWXC1;
                     goto do_ldst_cp1;
                 case SWXC1:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     mips32_op = OPC_SWXC1;
                     goto do_ldst_cp1;
                 case LDXC1:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     mips32_op = OPC_LDXC1;
                     goto do_ldst_cp1;
                 case SDXC1:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     mips32_op = OPC_SDXC1;
                     goto do_ldst_cp1;
                 case LUXC1:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     mips32_op = OPC_LUXC1;
                     goto do_ldst_cp1;
                 case SUXC1:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     mips32_op = OPC_SUXC1;
                 do_ldst_cp1:
                     gen_flt3_ldst(ctx, mips32_op, rd, rd, rt, rs);
@@ -17125,7 +17125,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case MAX_FMT:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 switch ((ctx->opcode >> 9) & 0x3) {
                 case FMT_SDPS_S:
                     gen_farith(ctx, OPC_MAX_S, rt, rs, rd, 0);
@@ -17139,7 +17139,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 break;
             case 0x18:
                 /* 3D insns */
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 fmt = (ctx->opcode >> 9) & 0x3;
                 switch ((ctx->opcode >> 6) & 0x7) {
                 case RSQRT2_FMT:
@@ -17190,7 +17190,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 fmt = (ctx->opcode >> 9) & 0x3;
                 switch ((ctx->opcode >> 6) & 0x7) {
                 case MOVF_FMT: /* RINT_FMT */
-                    if (ctx->insn_flags & ISA_MIPS32R6) {
+                    if (ctx->insn_flags & ISA_MIPS_R6) {
                         /* RINT_FMT */
                         switch (fmt) {
                         case FMT_SDPS_S:
@@ -17221,7 +17221,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     }
                     break;
                 case MOVT_FMT: /* CLASS_FMT */
-                    if (ctx->insn_flags & ISA_MIPS32R6) {
+                    if (ctx->insn_flags & ISA_MIPS_R6) {
                         /* CLASS_FMT */
                         switch (fmt) {
                         case FMT_SDPS_S:
@@ -17252,7 +17252,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     }
                     break;
                 case PREFX:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     break;
                 default:
                     goto pool32f_invalid;
@@ -17274,7 +17274,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     goto pool32f_invalid;               \
                 }
             case MINA_FMT:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 switch ((ctx->opcode >> 9) & 0x3) {
                 case FMT_SDPS_S:
                     gen_farith(ctx, OPC_MINA_S, rt, rs, rd, 0);
@@ -17287,7 +17287,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 }
                 break;
             case MAXA_FMT:
-                check_insn(ctx, ISA_MIPS32R6);
+                check_insn(ctx, ISA_MIPS_R6);
                 switch ((ctx->opcode >> 9) & 0x3) {
                 case FMT_SDPS_S:
                     gen_farith(ctx, OPC_MAXA_S, rt, rs, rd, 0);
@@ -17329,7 +17329,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 /* cmovs */
                 switch ((ctx->opcode >> 6) & 0x7) {
                 case MOVN_FMT: /* SELEQZ_FMT */
-                    if (ctx->insn_flags & ISA_MIPS32R6) {
+                    if (ctx->insn_flags & ISA_MIPS_R6) {
                         /* SELEQZ_FMT */
                         switch ((ctx->opcode >> 9) & 0x3) {
                         case FMT_SDPS_S:
@@ -17347,11 +17347,11 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     }
                     break;
                 case MOVN_FMT_04:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     FINSN_3ARG_SDPS(MOVN);
                     break;
                 case MOVZ_FMT: /* SELNEZ_FMT */
-                    if (ctx->insn_flags & ISA_MIPS32R6) {
+                    if (ctx->insn_flags & ISA_MIPS_R6) {
                         /* SELNEZ_FMT */
                         switch ((ctx->opcode >> 9) & 0x3) {
                         case FMT_SDPS_S:
@@ -17369,11 +17369,11 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     }
                     break;
                 case MOVZ_FMT_05:
-                    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                    check_insn_opc_removed(ctx, ISA_MIPS_R6);
                     FINSN_3ARG_SDPS(MOVZ);
                     break;
                 case SEL_FMT:
-                    check_insn(ctx, ISA_MIPS32R6);
+                    check_insn(ctx, ISA_MIPS_R6);
                     switch ((ctx->opcode >> 9) & 0x3) {
                     case FMT_SDPS_S:
                         gen_sel_s(ctx, OPC_SEL_S, rd, rt, rs);
@@ -17386,7 +17386,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     }
                     break;
                 case MADDF_FMT:
-                    check_insn(ctx, ISA_MIPS32R6);
+                    check_insn(ctx, ISA_MIPS_R6);
                     switch ((ctx->opcode >> 9) & 0x3) {
                     case FMT_SDPS_S:
                         mips32_op = OPC_MADDF_S;
@@ -17399,7 +17399,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                     }
                     break;
                 case MSUBF_FMT:
-                    check_insn(ctx, ISA_MIPS32R6);
+                    check_insn(ctx, ISA_MIPS_R6);
                     switch ((ctx->opcode >> 9) & 0x3) {
                     case FMT_SDPS_S:
                         mips32_op = OPC_MSUBF_S;
@@ -17432,45 +17432,45 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         minor = (ctx->opcode >> 21) & 0x1f;
         switch (minor) {
         case BLTZ:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BLTZ, 4, rs, -1, imm << 1, 4);
             break;
         case BLTZAL:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BLTZAL, 4, rs, -1, imm << 1, 4);
             ctx->hflags |= MIPS_HFLAG_BDS_STRICT;
             break;
         case BLTZALS:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BLTZAL, 4, rs, -1, imm << 1, 2);
             ctx->hflags |= MIPS_HFLAG_BDS_STRICT;
             break;
         case BGEZ:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BGEZ, 4, rs, -1, imm << 1, 4);
             break;
         case BGEZAL:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BGEZAL, 4, rs, -1, imm << 1, 4);
             ctx->hflags |= MIPS_HFLAG_BDS_STRICT;
             break;
         case BGEZALS:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BGEZAL, 4, rs, -1, imm << 1, 2);
             ctx->hflags |= MIPS_HFLAG_BDS_STRICT;
             break;
         case BLEZ:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BLEZ, 4, rs, -1, imm << 1, 4);
             break;
         case BGTZ:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, OPC_BGTZ, 4, rs, -1, imm << 1, 4);
             break;
 
             /* Traps */
         case TLTI: /* BC1EQZC */
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 /* BC1EQZC */
                 check_cp1_enabled(ctx);
                 gen_compute_branch1_r6(ctx, OPC_BC1EQZ, rs, imm << 1, 0);
@@ -17481,7 +17481,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             }
             break;
         case TGEI: /* BC1NEZC */
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 /* BC1NEZC */
                 check_cp1_enabled(ctx);
                 gen_compute_branch1_r6(ctx, OPC_BC1NEZ, rs, imm << 1, 0);
@@ -17492,15 +17492,15 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             }
             break;
         case TLTIU:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_TLTIU;
             goto do_trapi;
         case TGEIU:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_TGEIU;
             goto do_trapi;
         case TNEI: /* SYNCI */
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 /* SYNCI */
                 /*
                  * Break the TB to be able to sync copied instructions
@@ -17514,7 +17514,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             }
             break;
         case TEQI:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_TEQI;
         do_trapi:
             gen_trap(ctx, mips32_op, rs, -1, imm);
@@ -17522,7 +17522,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
 
         case BNEZC:
         case BEQZC:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch(ctx, minor == BNEZC ? OPC_BNE : OPC_BEQ,
                                4, rs, 0, imm << 1, 0);
             /*
@@ -17532,11 +17532,11 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
              */
             break;
         case LUI:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_logic_imm(ctx, OPC_LUI, rs, 0, imm);
             break;
         case SYNCI:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             /*
              * Break the TB to be able to sync copied instructions
              * immediately.
@@ -17545,24 +17545,24 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             break;
         case BC2F:
         case BC2T:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             /* COP2: Not implemented. */
             generate_exception_err(ctx, EXCP_CpU, 2);
             break;
         case BC1F:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = (ctx->opcode & (1 << 16)) ? OPC_BC1FANY2 : OPC_BC1F;
             goto do_cp1branch;
         case BC1T:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = (ctx->opcode & (1 << 16)) ? OPC_BC1TANY2 : OPC_BC1T;
             goto do_cp1branch;
         case BC1ANY4F:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_BC1FANY4;
             goto do_cp1mips3d;
         case BC1ANY4T:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_BC1TANY4;
         do_cp1mips3d:
             check_cop1x(ctx);
@@ -17590,47 +17590,47 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
     case POOL32C:
         minor = (ctx->opcode >> 12) & 0xf;
         offset = sextract32(ctx->opcode, 0,
-                            (ctx->insn_flags & ISA_MIPS32R6) ? 9 : 12);
+                            (ctx->insn_flags & ISA_MIPS_R6) ? 9 : 12);
         switch (minor) {
         case LWL:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_LWL;
             goto do_ld_lr;
         case SWL:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_SWL;
             goto do_st_lr;
         case LWR:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_LWR;
             goto do_ld_lr;
         case SWR:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_SWR;
             goto do_st_lr;
 #if defined(TARGET_MIPS64)
         case LDL:
             check_insn(ctx, ISA_MIPS3);
             check_mips_64(ctx);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_LDL;
             goto do_ld_lr;
         case SDL:
             check_insn(ctx, ISA_MIPS3);
             check_mips_64(ctx);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_SDL;
             goto do_st_lr;
         case LDR:
             check_insn(ctx, ISA_MIPS3);
             check_mips_64(ctx);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_LDR;
             goto do_ld_lr;
         case SDR:
             check_insn(ctx, ISA_MIPS3);
             check_mips_64(ctx);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             mips32_op = OPC_SDR;
             goto do_st_lr;
         case LWU:
@@ -17681,11 +17681,11 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
                 mips32_op = OPC_LHUE;
                 goto do_ld_lr;
             case LWLE:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_LWLE;
                 goto do_ld_lr;
             case LWRE:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_LWRE;
                 goto do_ld_lr;
             case LBE:
@@ -17714,16 +17714,16 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             offset = sextract32(ctx->opcode, 0, 9);
             switch (minor2) {
             case SWLE:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_SWLE;
                 goto do_st_lr;
             case SWRE:
-                check_insn_opc_removed(ctx, ISA_MIPS32R6);
+                check_insn_opc_removed(ctx, ISA_MIPS_R6);
                 mips32_op = OPC_SWRE;
                 goto do_st_lr;
             case PREFE:
                 /* Treat as no-op */
-                if ((ctx->insn_flags & ISA_MIPS32R6) && (rt >= 24)) {
+                if ((ctx->insn_flags & ISA_MIPS_R6) && (rt >= 24)) {
                     /* hint codes 24-31 are reserved and signal RI */
                     generate_exception(ctx, EXCP_RI);
                 }
@@ -17750,7 +17750,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             break;
         case PREF:
             /* Treat as no-op */
-            if ((ctx->insn_flags & ISA_MIPS32R6) && (rt >= 24)) {
+            if ((ctx->insn_flags & ISA_MIPS_R6) && (rt >= 24)) {
                 /* hint codes 24-31 are reserved and signal RI */
                 generate_exception(ctx, EXCP_RI);
             }
@@ -17762,7 +17762,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case ADDI32: /* AUI, LUI */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* AUI, LUI */
             gen_logic_imm(ctx, OPC_LUI, rt, rs, imm);
         } else {
@@ -17800,13 +17800,13 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_slt_imm(ctx, mips32_op, rt, rs, imm);
         break;
     case JALX32:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         offset = (int32_t)(ctx->opcode & 0x3FFFFFF) << 2;
         gen_compute_branch(ctx, OPC_JALX, 4, rt, rs, offset, 4);
         ctx->hflags |= MIPS_HFLAG_BDS_STRICT;
         break;
     case JALS32: /* BOVC, BEQC, BEQZALC */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             if (rs >= rt) {
                 /* BOVC */
                 mips32_op = OPC_BOVC;
@@ -17826,7 +17826,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case BEQ32: /* BC */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* BC */
             gen_compute_compact_branch(ctx, OPC_BC, 0, 0,
                                        sextract32(ctx->opcode << 1, 0, 27));
@@ -17836,7 +17836,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case BNE32: /* BALC */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* BALC */
             gen_compute_compact_branch(ctx, OPC_BALC, 0, 0,
                                        sextract32(ctx->opcode << 1, 0, 27));
@@ -17846,7 +17846,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case J32: /* BGTZC, BLTZC, BLTC */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             if (rs == 0 && rt != 0) {
                 /* BGTZC */
                 mips32_op = OPC_BGTZC;
@@ -17865,7 +17865,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case JAL32: /* BLEZC, BGEZC, BGEC */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             if (rs == 0 && rt != 0) {
                 /* BLEZC */
                 mips32_op = OPC_BLEZC;
@@ -17900,7 +17900,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_cop1_ldst(ctx, mips32_op, rt, rs, imm);
         break;
     case ADDIUPC: /* PCREL: ADDIUPC, AUIPC, ALUIPC, LWPC */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* PCREL: ADDIUPC, AUIPC, ALUIPC, LWPC */
             switch ((ctx->opcode >> 16) & 0x1f) {
             case ADDIUPC_00:
@@ -17942,7 +17942,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case BNVC: /* BNEC, BNEZALC */
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         if (rs >= rt) {
             /* BNVC */
             mips32_op = OPC_BNVC;
@@ -17956,7 +17956,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_compute_compact_branch(ctx, mips32_op, rs, rt, imm << 1);
         break;
     case R6_BNEZC: /* JIALC */
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         if (rt != 0) {
             /* BNEZC */
             gen_compute_compact_branch(ctx, OPC_BNEZC, rt, 0,
@@ -17967,7 +17967,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case R6_BEQZC: /* JIC */
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         if (rt != 0) {
             /* BEQZC */
             gen_compute_compact_branch(ctx, OPC_BEQZC, rt, 0,
@@ -17978,7 +17978,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case BLEZALC: /* BGEZALC, BGEUC */
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         if (rs == 0 && rt != 0) {
             /* BLEZALC */
             mips32_op = OPC_BLEZALC;
@@ -17992,7 +17992,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_compute_compact_branch(ctx, mips32_op, rs, rt, imm << 1);
         break;
     case BGTZALC: /* BLTZALC, BLTUC */
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         if (rs == 0 && rt != 0) {
             /* BGTZALC */
             mips32_op = OPC_BGTZALC;
@@ -18114,7 +18114,7 @@ static int decode_micromips_opc(CPUMIPSState *env, DisasContext *ctx)
                 opc = OPC_SUBU;
                 break;
             }
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 /*
                  * In the Release 6, the register number location in
                  * the instruction encoding has changed.
@@ -18146,7 +18146,7 @@ static int decode_micromips_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case POOL16C:
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             gen_pool16c_r6_insn(ctx);
         } else {
             gen_pool16c_insn(ctx);
@@ -18162,7 +18162,7 @@ static int decode_micromips_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case POOL16F:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->opcode & 1) {
             generate_exception_end(ctx, EXCP_RI);
         } else {
@@ -18280,14 +18280,14 @@ static int decode_micromips_opc(CPUMIPSState *env, DisasContext *ctx)
     case B16: /* BC16 */
         gen_compute_branch(ctx, OPC_BEQ, 2, 0, 0,
                            sextract32(ctx->opcode, 0, 10) << 1,
-                           (ctx->insn_flags & ISA_MIPS32R6) ? 0 : 4);
+                           (ctx->insn_flags & ISA_MIPS_R6) ? 0 : 4);
         break;
     case BNEZ16: /* BNEZC16 */
     case BEQZ16: /* BEQZC16 */
         gen_compute_branch(ctx, op == BNEZ16 ? OPC_BNE : OPC_BEQ, 2,
                            mmreg(uMIPS_RD(ctx->opcode)),
                            0, sextract32(ctx->opcode, 0, 7) << 1,
-                           (ctx->insn_flags & ISA_MIPS32R6) ? 0 : 4);
+                           (ctx->insn_flags & ISA_MIPS_R6) ? 0 : 4);
 
         break;
     case LI16:
@@ -24970,7 +24970,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
     case OPC_SLL:          /* Shift with immediate */
         if (sa == 5 && rd == 0 &&
             rs == 0 && rt == 0) { /* PAUSE */
-            if ((ctx->insn_flags & ISA_MIPS32R6) &&
+            if ((ctx->insn_flags & ISA_MIPS_R6) &&
                 (ctx->hflags & MIPS_HFLAG_BMASK)) {
                 generate_exception_end(ctx, EXCP_RI);
                 break;
@@ -25045,7 +25045,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         gen_trap(ctx, op1, rs, rt, -1);
         break;
     case OPC_LSA: /* OPC_PMON */
-        if ((ctx->insn_flags & ISA_MIPS32R6) ||
+        if ((ctx->insn_flags & ISA_MIPS_R6) ||
             (env->CP0_Config3 & (1 << CP0C3_MSAP))) {
             decode_opc_special_r6(env, ctx);
         } else {
@@ -25148,14 +25148,14 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case OPC_DLSA:
-        if ((ctx->insn_flags & ISA_MIPS32R6) ||
+        if ((ctx->insn_flags & ISA_MIPS_R6) ||
             (env->CP0_Config3 & (1 << CP0C3_MSAP))) {
             decode_opc_special_r6(env, ctx);
         }
         break;
 #endif
     default:
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             decode_opc_special_r6(env, ctx);
         } else if (ctx->insn_flags & INSN_R5900) {
             decode_opc_special_tx79(env, ctx);
@@ -27565,7 +27565,7 @@ static void decode_opc_special2_legacy(CPUMIPSState *env, DisasContext *ctx)
     int rs, rt, rd;
     uint32_t op1;
 
-    check_insn_opc_removed(ctx, ISA_MIPS32R6);
+    check_insn_opc_removed(ctx, ISA_MIPS_R6);
 
     rs = (ctx->opcode >> 21) & 0x1f;
     rt = (ctx->opcode >> 16) & 0x1f;
@@ -28552,7 +28552,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
         switch (op1) {
         case OPC_LWLE:
         case OPC_LWRE:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             /* fall through */
         case OPC_LBUE:
         case OPC_LHUE:
@@ -28565,7 +28565,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
             return;
         case OPC_SWLE:
         case OPC_SWRE:
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             /* fall through */
         case OPC_SBE:
         case OPC_SHE:
@@ -28605,7 +28605,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
         case OPC_ALIGN_2:
         case OPC_ALIGN_3:
         case OPC_BITSWAP:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             decode_opc_special3_r6(env, ctx);
             break;
         default:
@@ -28637,7 +28637,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
         case OPC_DALIGN_6:
         case OPC_DALIGN_7:
         case OPC_DBITSWAP:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             decode_opc_special3_r6(env, ctx);
             break;
         default:
@@ -28677,7 +28677,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     default:
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             decode_opc_special3_r6(env, ctx);
         } else {
             decode_opc_special3_legacy(env, ctx);
@@ -30706,7 +30706,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         case OPC_BLTZALL:
         case OPC_BGEZALL:
             check_insn(ctx, ISA_MIPS2);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             /* Fallthrough */
         case OPC_BLTZ:
         case OPC_BGEZ:
@@ -30714,7 +30714,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             break;
         case OPC_BLTZAL:
         case OPC_BGEZAL:
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 if (rs == 0) {
                     /* OPC_NAL, OPC_BAL */
                     gen_compute_branch(ctx, op1, 4, 0, -1, imm << 2, 4);
@@ -30733,11 +30733,11 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
 
         case OPC_TNEI:
             check_insn(ctx, ISA_MIPS2);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_trap(ctx, op1, rs, -1, imm);
             break;
         case OPC_SIGRIE:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             generate_exception_end(ctx, EXCP_RI);
             break;
         case OPC_SYNCI:
@@ -30757,14 +30757,14 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             break;
 #if defined(TARGET_MIPS64)
         case OPC_DAHI:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             check_mips_64(ctx);
             if (rs != 0) {
                 tcg_gen_addi_tl(cpu_gpr[rs], cpu_gpr[rs], (int64_t)imm << 32);
             }
             break;
         case OPC_DATI:
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             check_mips_64(ctx);
             if (rs != 0) {
                 tcg_gen_addi_tl(cpu_gpr[rs], cpu_gpr[rs], (int64_t)imm << 48);
@@ -30844,14 +30844,14 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
                     gen_store_gpr(t0, rt);
                     break;
                 case OPC_DVP:
-                    check_insn(ctx, ISA_MIPS32R6);
+                    check_insn(ctx, ISA_MIPS_R6);
                     if (ctx->vp) {
                         gen_helper_dvp(t0, cpu_env);
                         gen_store_gpr(t0, rt);
                     }
                     break;
                 case OPC_EVP:
-                    check_insn(ctx, ISA_MIPS32R6);
+                    check_insn(ctx, ISA_MIPS_R6);
                     if (ctx->vp) {
                         gen_helper_evp(t0, cpu_env);
                         gen_store_gpr(t0, rt);
@@ -30904,7 +30904,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case OPC_BOVC: /* OPC_BEQZALC, OPC_BEQC, OPC_ADDI */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_BOVC, OPC_BEQZALC, OPC_BEQC */
             gen_compute_compact_branch(ctx, op, rs, rt, imm << 2);
         } else {
@@ -30933,7 +30933,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
          break;
     /* Branch */
     case OPC_BLEZC: /* OPC_BGEZC, OPC_BGEC, OPC_BLEZL */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             if (rt == 0) {
                 generate_exception_end(ctx, EXCP_RI);
                 break;
@@ -30946,7 +30946,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case OPC_BGTZC: /* OPC_BLTZC, OPC_BLTC, OPC_BGTZL */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             if (rt == 0) {
                 generate_exception_end(ctx, EXCP_RI);
                 break;
@@ -30963,7 +30963,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             /* OPC_BLEZ */
             gen_compute_branch(ctx, op, 4, rs, rt, imm << 2, 4);
         } else {
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             /* OPC_BLEZALC, OPC_BGEZALC, OPC_BGEUC */
             gen_compute_compact_branch(ctx, op, rs, rt, imm << 2);
         }
@@ -30973,7 +30973,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             /* OPC_BGTZ */
             gen_compute_branch(ctx, op, 4, rs, rt, imm << 2, 4);
         } else {
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             /* OPC_BGTZALC, OPC_BLTZALC, OPC_BLTUC */
             gen_compute_compact_branch(ctx, op, rs, rt, imm << 2);
         }
@@ -30981,7 +30981,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
     case OPC_BEQL:
     case OPC_BNEL:
         check_insn(ctx, ISA_MIPS2);
-         check_insn_opc_removed(ctx, ISA_MIPS32R6);
+         check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* Fallthrough */
     case OPC_BEQ:
     case OPC_BNE:
@@ -30995,7 +30995,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         /* Fallthrough */
     case OPC_LWL:
     case OPC_LWR:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
          /* Fallthrough */
     case OPC_LB:
     case OPC_LH:
@@ -31007,7 +31007,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
          break;
     case OPC_SWL:
     case OPC_SWR:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* fall through */
     case OPC_SB:
     case OPC_SH:
@@ -31016,14 +31016,14 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
          break;
     case OPC_SC:
         check_insn(ctx, ISA_MIPS2);
-         check_insn_opc_removed(ctx, ISA_MIPS32R6);
+         check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
         }
         gen_st_cond(ctx, rt, rs, imm, MO_TESL, false);
         break;
     case OPC_CACHE:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         check_cp0_enabled(ctx);
         check_insn(ctx, ISA_MIPS3 | ISA_MIPS_R1);
         if (ctx->hflags & MIPS_HFLAG_ITC_CACHE) {
@@ -31032,7 +31032,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         /* Treat as NOP. */
         break;
     case OPC_PREF:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->insn_flags & INSN_R5900) {
             /* Treat as NOP. */
         } else {
@@ -31076,7 +31076,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
 #endif
         case OPC_BC1EQZ: /* OPC_BC1ANY2 */
             check_cp1_enabled(ctx);
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 /* OPC_BC1EQZ */
                 gen_compute_branch1_r6(ctx, MASK_CP1(ctx->opcode),
                                        rt, imm << 2, 4);
@@ -31090,19 +31090,19 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             break;
         case OPC_BC1NEZ:
             check_cp1_enabled(ctx);
-            check_insn(ctx, ISA_MIPS32R6);
+            check_insn(ctx, ISA_MIPS_R6);
             gen_compute_branch1_r6(ctx, MASK_CP1(ctx->opcode),
                                    rt, imm << 2, 4);
             break;
         case OPC_BC1ANY4:
             check_cp1_enabled(ctx);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             check_cop1x(ctx);
             check_insn(ctx, ASE_MIPS3D);
             /* fall through */
         case OPC_BC1:
             check_cp1_enabled(ctx);
-            check_insn_opc_removed(ctx, ISA_MIPS32R6);
+            check_insn_opc_removed(ctx, ISA_MIPS_R6);
             gen_compute_branch1(ctx, MASK_BC1(ctx->opcode),
                                 (rt >> 2) & 0x7, imm << 2);
             break;
@@ -31120,7 +31120,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         {
             int r6_op = ctx->opcode & FOP(0x3f, 0x1f);
             check_cp1_enabled(ctx);
-            if (ctx->insn_flags & ISA_MIPS32R6) {
+            if (ctx->insn_flags & ISA_MIPS_R6) {
                 switch (r6_op) {
                 case R6_OPC_CMP_AF_S:
                 case R6_OPC_CMP_UN_S:
@@ -31205,7 +31205,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
     /* Compact branches [R6] and COP2 [non-R6] */
     case OPC_BC: /* OPC_LWC2 */
     case OPC_BALC: /* OPC_SWC2 */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_BC, OPC_BALC */
             gen_compute_compact_branch(ctx, op, 0, 0,
                                        sextract32(ctx->opcode << 2, 0, 28));
@@ -31219,7 +31219,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         break;
     case OPC_BEQZC: /* OPC_JIC, OPC_LDC2 */
     case OPC_BNEZC: /* OPC_JIALC, OPC_SDC2 */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             if (rs != 0) {
                 /* OPC_BEQZC, OPC_BNEZC */
                 gen_compute_compact_branch(ctx, op, rs, 0,
@@ -31243,7 +31243,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         break;
 
     case OPC_CP3:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         if (ctx->CP0_Config1 & (1 << CP0C1_FP)) {
             check_cp1_enabled(ctx);
             op1 = MASK_CP3(ctx->opcode);
@@ -31300,7 +31300,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         /* fall through */
     case OPC_LDL:
     case OPC_LDR:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* fall through */
     case OPC_LWU:
     case OPC_LD:
@@ -31310,7 +31310,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         break;
     case OPC_SDL:
     case OPC_SDR:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         /* fall through */
     case OPC_SD:
         check_insn(ctx, ISA_MIPS3);
@@ -31318,7 +31318,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_st(ctx, op, rt, rs, imm);
         break;
     case OPC_SCD:
-        check_insn_opc_removed(ctx, ISA_MIPS32R6);
+        check_insn_opc_removed(ctx, ISA_MIPS_R6);
         check_insn(ctx, ISA_MIPS3);
         if (ctx->insn_flags & INSN_R5900) {
             check_insn_opc_user_only(ctx, INSN_R5900);
@@ -31327,7 +31327,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         gen_st_cond(ctx, rt, rs, imm, MO_TEQ, false);
         break;
     case OPC_BNVC: /* OPC_BNEZALC, OPC_BNEC, OPC_DADDI */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             /* OPC_BNVC, OPC_BNEZALC, OPC_BNEC */
             gen_compute_compact_branch(ctx, op, rs, rt, imm << 2);
         } else {
@@ -31344,7 +31344,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         break;
 #else
     case OPC_BNVC: /* OPC_BNEZALC, OPC_BNEC */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
             gen_compute_compact_branch(ctx, op, rs, rt, imm << 2);
         } else {
             MIPS_INVAL("major opcode");
@@ -31353,7 +31353,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         break;
 #endif
     case OPC_DAUI: /* OPC_JALX */
-        if (ctx->insn_flags & ISA_MIPS32R6) {
+        if (ctx->insn_flags & ISA_MIPS_R6) {
 #if defined(TARGET_MIPS64)
             /* OPC_DAUI */
             check_mips_64(ctx);
@@ -31387,7 +31387,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case OPC_PCREL:
-        check_insn(ctx, ISA_MIPS32R6);
+        check_insn(ctx, ISA_MIPS_R6);
         gen_pcrel(ctx, ctx->opcode, ctx->base.pc_next, rs);
         break;
     default:            /* Invalid */
@@ -31438,7 +31438,7 @@ static void mips_tr_init_disas_context(DisasContextBase *dcbase, CPUState *cs)
 #else
         ctx->mem_idx = hflags_mmu_index(ctx->hflags);
 #endif
-    ctx->default_tcg_memop_mask = (ctx->insn_flags & (ISA_MIPS32R6 |
+    ctx->default_tcg_memop_mask = (ctx->insn_flags & (ISA_MIPS_R6 |
                                   INSN_LOONGSON3A)) ? MO_UNALN : MO_ALIGN;
 
     LOG_DISAS("\ntb %p idx %d hflags %04x\n", ctx->base.tb, ctx->mem_idx,
-- 
2.26.2

