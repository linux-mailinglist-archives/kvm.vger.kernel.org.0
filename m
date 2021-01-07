Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E551A2EE871
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbhAGWY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727669AbhAGWY4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:56 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812A9C061282
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:15 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id g185so6830187wmf.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PSq/MNApcem6+6+pS1q24pjrL0M72OS3waZH/uk8OxE=;
        b=LftUvc+VmPrjeZsJN4mvB3mnOJOA7VTCbhOO7Vi38GsmaXIS+8b7w2dq4m3F6pKJp8
         QojMkIsss5Z2aBE9Z0rCSQmNlgaK/gwx6XvuFtzktzT21giJGZ/xI/iJnhFIn5x6KyvH
         IqweS6e5Dfh7Oy/UT8MuBqmhrfM1hTQ3WMlZN+kUGDfelPIxz5ljU386b/2pTnR4T3C2
         RJ8jVaabFxVoJa3KSHmwV8mDsI+IpIQCByvUggsS4FZT2Ne6adahxGNFvs/04Lo4YDPD
         SgbGYDMsOdcwlX0FCPecnMRMY25Hm74OsoPNp0hKCFy9AU9/RfOE9OgTWsLUQGZtwe+k
         BTag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=PSq/MNApcem6+6+pS1q24pjrL0M72OS3waZH/uk8OxE=;
        b=t6tM0uY1S6uaG5iQMPLSBqOZwvv6j8u74hbZHtvU1UC3PQDQyYEvl+lAxHxyzi1+0G
         NYfHce10alPlG6s5qj2J9iOo+zIuogL8k8WTeGodcGh6zt7cEE5nY0HMjZNwvqx2BTID
         x9qiA5U1Pbx2DBOab6Kp40z2cRBoixAa4n+zcRKZZbRQT+7t1NWZ1jlAsm/+DkgdblmR
         ARDgtoR1uEjxGG/UuDCH4KpEq2Q9NRaLQqFB+bB1cnxzPIZacjmPqtla+GEm0OTFQo0n
         V1gC0bB4w0DKJSceW1tX9S8+dmlLIyl4V+yxatcNeWY6xl1RNbBpA0NN9Cm+grZB0ujn
         cf4w==
X-Gm-Message-State: AOAM533W4Tp72HBAJBgkrIzAB1xPvvXnpk31fJXOGwJP1wiTtUJpHxQS
        Hvl3VKzH6i86Cz0wkLWy40U=
X-Google-Smtp-Source: ABdhPJxkdtu2+piHi8ggwZy0CKNAQ/DOAHJboo1RmGQh5DqoYYk/6XXz0rCaM32+EMiHGnVxKgyxCw==
X-Received: by 2002:a1c:b78a:: with SMTP id h132mr490513wmf.141.1610058254155;
        Thu, 07 Jan 2021 14:24:14 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id h184sm9757605wmh.23.2021.01.07.14.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:13 -0800 (PST)
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
Subject: [PULL 15/66] target/mips/mips-defs: Rename ISA_MIPS32R2 as ISA_MIPS_R2
Date:   Thu,  7 Jan 2021 23:22:02 +0100
Message-Id: <20210107222253.20382-16-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MIPS ISA release 2 is common to 32/64-bit CPUs.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-13-f4bug@amsat.org>
---
 target/mips/internal.h     |   2 +-
 target/mips/mips-defs.h    |   4 +-
 linux-user/mips/cpu_loop.c |   2 +-
 target/mips/cp0_timer.c    |   4 +-
 target/mips/helper.c       |   2 +-
 target/mips/translate.c    | 138 ++++++++++++++++++-------------------
 6 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 94910f75a61..23ae31ef989 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -407,7 +407,7 @@ static inline void compute_hflags(CPUMIPSState *env)
         }
 
     }
-    if (env->insn_flags & ISA_MIPS32R2) {
+    if (env->insn_flags & ISA_MIPS_R2) {
         if (env->active_fpu.fcr0 & (1 << FCR0_F64)) {
             env->hflags |= MIPS_HFLAG_COP1X;
         }
diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index a7048ffaffe..d1eeb69dfd7 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -17,7 +17,7 @@
 #define ISA_MIPS4         0x0000000000000008ULL
 #define ISA_MIPS5         0x0000000000000010ULL
 #define ISA_MIPS_R1       0x0000000000000020ULL
-#define ISA_MIPS32R2      0x0000000000000040ULL
+#define ISA_MIPS_R2       0x0000000000000040ULL
 #define ISA_MIPS32R3      0x0000000000000200ULL
 #define ISA_MIPS32R5      0x0000000000000800ULL
 #define ISA_MIPS32R6      0x0000000000002000ULL
@@ -73,7 +73,7 @@
 #define CPU_MIPS64R1    (CPU_MIPS5 | CPU_MIPS32R1)
 
 /* MIPS Technologies "Release 2" */
-#define CPU_MIPS32R2    (CPU_MIPS32R1 | ISA_MIPS32R2)
+#define CPU_MIPS32R2    (CPU_MIPS32R1 | ISA_MIPS_R2)
 #define CPU_MIPS64R2    (CPU_MIPS64R1 | CPU_MIPS32R2)
 
 /* MIPS Technologies "Release 3" */
diff --git a/linux-user/mips/cpu_loop.c b/linux-user/mips/cpu_loop.c
index e400166c583..748e1c664f1 100644
--- a/linux-user/mips/cpu_loop.c
+++ b/linux-user/mips/cpu_loop.c
@@ -384,7 +384,7 @@ void target_cpu_copy_regs(CPUArchState *env, struct target_pt_regs *regs)
     prog_req.frdefault &= interp_req.frdefault;
     prog_req.fre &= interp_req.fre;
 
-    bool cpu_has_mips_r2_r6 = env->insn_flags & ISA_MIPS32R2 ||
+    bool cpu_has_mips_r2_r6 = env->insn_flags & ISA_MIPS_R2 ||
                               env->insn_flags & ISA_MIPS32R6;
 
     if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1) {
diff --git a/target/mips/cp0_timer.c b/target/mips/cp0_timer.c
index 5ec0d6249e9..70de95d338f 100644
--- a/target/mips/cp0_timer.c
+++ b/target/mips/cp0_timer.c
@@ -44,7 +44,7 @@ static void cpu_mips_timer_update(CPUMIPSState *env)
 static void cpu_mips_timer_expire(CPUMIPSState *env)
 {
     cpu_mips_timer_update(env);
-    if (env->insn_flags & ISA_MIPS32R2) {
+    if (env->insn_flags & ISA_MIPS_R2) {
         env->CP0_Cause |= 1 << CP0Ca_TI;
     }
     qemu_irq_raise(env->irq[(env->CP0_IntCtl >> CP0IntCtl_IPTI) & 0x7]);
@@ -93,7 +93,7 @@ void cpu_mips_store_compare(CPUMIPSState *env, uint32_t value)
     if (!(env->CP0_Cause & (1 << CP0Ca_DC))) {
         cpu_mips_timer_update(env);
     }
-    if (env->insn_flags & ISA_MIPS32R2) {
+    if (env->insn_flags & ISA_MIPS_R2) {
         env->CP0_Cause &= ~(1 << CP0Ca_TI);
     }
     qemu_irq_lower(env->irq[(env->CP0_IntCtl >> CP0IntCtl_IPTI) & 0x7]);
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 5b74815beb0..98d6ecaa65e 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -431,7 +431,7 @@ void cpu_mips_store_cause(CPUMIPSState *env, target_ulong val)
     uint32_t old = env->CP0_Cause;
     int i;
 
-    if (env->insn_flags & ISA_MIPS32R2) {
+    if (env->insn_flags & ISA_MIPS_R2) {
         mask |= 1 << CP0Ca_DC;
     }
     if (env->insn_flags & ISA_MIPS32R6) {
diff --git a/target/mips/translate.c b/target/mips/translate.c
index a59fbd94bac..9c71d306ee5 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -7612,7 +7612,7 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PageMask";
             break;
         case CP0_REG05__PAGEGRAIN:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_PageGrain));
             register_name = "PageGrain";
             break;
@@ -7660,27 +7660,27 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Wired";
             break;
         case CP0_REG06__SRSCONF0:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf0));
             register_name = "SRSConf0";
             break;
         case CP0_REG06__SRSCONF1:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf1));
             register_name = "SRSConf1";
             break;
         case CP0_REG06__SRSCONF2:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf2));
             register_name = "SRSConf2";
             break;
         case CP0_REG06__SRSCONF3:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf3));
             register_name = "SRSConf3";
             break;
         case CP0_REG06__SRSCONF4:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf4));
             register_name = "SRSConf4";
             break;
@@ -7696,7 +7696,7 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     case CP0_REGISTER_07:
         switch (sel) {
         case CP0_REG07__HWRENA:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_HWREna));
             register_name = "HWREna";
             break;
@@ -7791,17 +7791,17 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Status";
             break;
         case CP0_REG12__INTCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_IntCtl));
             register_name = "IntCtl";
             break;
         case CP0_REG12__SRSCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSCtl));
             register_name = "SRSCtl";
             break;
         case CP0_REG12__SRSMAP:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSMap));
             register_name = "SRSMap";
             break;
@@ -7837,13 +7837,13 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PRid";
             break;
         case CP0_REG15__EBASE:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             tcg_gen_ld_tl(arg, cpu_env, offsetof(CPUMIPSState, CP0_EBase));
             tcg_gen_ext32s_tl(arg, arg);
             register_name = "EBase";
             break;
         case CP0_REG15__CMGCRBASE:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             CP0_CHECK(ctx->cmgcr);
             tcg_gen_ld_tl(arg, cpu_env, offsetof(CPUMIPSState, CP0_CMGCRBase));
             tcg_gen_ext32s_tl(arg, arg);
@@ -8357,7 +8357,7 @@ static void gen_mtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PageMask";
             break;
         case CP0_REG05__PAGEGRAIN:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_pagegrain(cpu_env, arg);
             register_name = "PageGrain";
             ctx->base.is_jmp = DISAS_STOP;
@@ -8403,27 +8403,27 @@ static void gen_mtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Wired";
             break;
         case CP0_REG06__SRSCONF0:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf0(cpu_env, arg);
             register_name = "SRSConf0";
             break;
         case CP0_REG06__SRSCONF1:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf1(cpu_env, arg);
             register_name = "SRSConf1";
             break;
         case CP0_REG06__SRSCONF2:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf2(cpu_env, arg);
             register_name = "SRSConf2";
             break;
         case CP0_REG06__SRSCONF3:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf3(cpu_env, arg);
             register_name = "SRSConf3";
             break;
         case CP0_REG06__SRSCONF4:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf4(cpu_env, arg);
             register_name = "SRSConf4";
             break;
@@ -8439,7 +8439,7 @@ static void gen_mtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     case CP0_REGISTER_07:
         switch (sel) {
         case CP0_REG07__HWRENA:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_hwrena(cpu_env, arg);
             ctx->base.is_jmp = DISAS_STOP;
             register_name = "HWREna";
@@ -8522,21 +8522,21 @@ static void gen_mtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Status";
             break;
         case CP0_REG12__INTCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_intctl(cpu_env, arg);
             /* Stop translation as we may have switched the execution mode */
             ctx->base.is_jmp = DISAS_STOP;
             register_name = "IntCtl";
             break;
         case CP0_REG12__SRSCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsctl(cpu_env, arg);
             /* Stop translation as we may have switched the execution mode */
             ctx->base.is_jmp = DISAS_STOP;
             register_name = "SRSCtl";
             break;
         case CP0_REG12__SRSMAP:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mtc0_store32(arg, offsetof(CPUMIPSState, CP0_SRSMap));
             /* Stop translation as we may have switched the execution mode */
             ctx->base.is_jmp = DISAS_STOP;
@@ -8581,7 +8581,7 @@ static void gen_mtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PRid";
             break;
         case CP0_REG15__EBASE:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_ebase(cpu_env, arg);
             register_name = "EBase";
             break;
@@ -9120,7 +9120,7 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PageMask";
             break;
         case CP0_REG05__PAGEGRAIN:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_PageGrain));
             register_name = "PageGrain";
             break;
@@ -9165,27 +9165,27 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Wired";
             break;
         case CP0_REG06__SRSCONF0:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf0));
             register_name = "SRSConf0";
             break;
         case CP0_REG06__SRSCONF1:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf1));
             register_name = "SRSConf1";
             break;
         case CP0_REG06__SRSCONF2:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf2));
             register_name = "SRSConf2";
             break;
         case CP0_REG06__SRSCONF3:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf3));
             register_name = "SRSConf3";
             break;
         case CP0_REG06__SRSCONF4:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSConf4));
             register_name = "SRSConf4";
             break;
@@ -9201,7 +9201,7 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     case CP0_REGISTER_07:
         switch (sel) {
         case CP0_REG07__HWRENA:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_HWREna));
             register_name = "HWREna";
             break;
@@ -9294,17 +9294,17 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Status";
             break;
         case CP0_REG12__INTCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_IntCtl));
             register_name = "IntCtl";
             break;
         case CP0_REG12__SRSCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSCtl));
             register_name = "SRSCtl";
             break;
         case CP0_REG12__SRSMAP:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mfc0_load32(arg, offsetof(CPUMIPSState, CP0_SRSMap));
             register_name = "SRSMap";
             break;
@@ -9339,12 +9339,12 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PRid";
             break;
         case CP0_REG15__EBASE:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             tcg_gen_ld_tl(arg, cpu_env, offsetof(CPUMIPSState, CP0_EBase));
             register_name = "EBase";
             break;
         case CP0_REG15__CMGCRBASE:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             CP0_CHECK(ctx->cmgcr);
             tcg_gen_ld_tl(arg, cpu_env, offsetof(CPUMIPSState, CP0_CMGCRBase));
             register_name = "CMGCRBase";
@@ -9847,7 +9847,7 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PageMask";
             break;
         case CP0_REG05__PAGEGRAIN:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_pagegrain(cpu_env, arg);
             register_name = "PageGrain";
             break;
@@ -9892,27 +9892,27 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Wired";
             break;
         case CP0_REG06__SRSCONF0:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf0(cpu_env, arg);
             register_name = "SRSConf0";
             break;
         case CP0_REG06__SRSCONF1:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf1(cpu_env, arg);
             register_name = "SRSConf1";
             break;
         case CP0_REG06__SRSCONF2:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf2(cpu_env, arg);
             register_name = "SRSConf2";
             break;
         case CP0_REG06__SRSCONF3:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf3(cpu_env, arg);
             register_name = "SRSConf3";
             break;
         case CP0_REG06__SRSCONF4:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsconf4(cpu_env, arg);
             register_name = "SRSConf4";
             break;
@@ -9928,7 +9928,7 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     case CP0_REGISTER_07:
         switch (sel) {
         case CP0_REG07__HWRENA:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_hwrena(cpu_env, arg);
             ctx->base.is_jmp = DISAS_STOP;
             register_name = "HWREna";
@@ -10015,21 +10015,21 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "Status";
             break;
         case CP0_REG12__INTCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_intctl(cpu_env, arg);
             /* Stop translation as we may have switched the execution mode */
             ctx->base.is_jmp = DISAS_STOP;
             register_name = "IntCtl";
             break;
         case CP0_REG12__SRSCTL:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_srsctl(cpu_env, arg);
             /* Stop translation as we may have switched the execution mode */
             ctx->base.is_jmp = DISAS_STOP;
             register_name = "SRSCtl";
             break;
         case CP0_REG12__SRSMAP:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_mtc0_store32(arg, offsetof(CPUMIPSState, CP0_SRSMap));
             /* Stop translation as we may have switched the execution mode */
             ctx->base.is_jmp = DISAS_STOP;
@@ -10074,7 +10074,7 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
             register_name = "PRid";
             break;
         case CP0_REG15__EBASE:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_helper_mtc0_ebase(cpu_env, arg);
             register_name = "EBase";
             break;
@@ -13453,7 +13453,7 @@ static void gen_rdhwr(DisasContext *ctx, int rt, int rd, int sel)
      * The Linux kernel will emulate rdhwr if it's not supported natively.
      * Therefore only check the ISA in system mode.
      */
-    check_insn(ctx, ISA_MIPS32R2);
+    check_insn(ctx, ISA_MIPS_R2);
 #endif
     t0 = tcg_temp_new();
 
@@ -16269,12 +16269,12 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
         switch (minor) {
         case RDPGPR:
             check_cp0_enabled(ctx);
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_load_srsgpr(rs, rt);
             break;
         case WRPGPR:
             check_cp0_enabled(ctx);
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_store_srsgpr(rs, rt);
             break;
         default:
@@ -24984,7 +24984,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         switch ((ctx->opcode >> 21) & 0x1f) {
         case 1:
             /* rotr is decoded as srl on non-R2 CPUs */
-            if (ctx->insn_flags & ISA_MIPS32R2) {
+            if (ctx->insn_flags & ISA_MIPS_R2) {
                 op1 = OPC_ROTR;
             }
             /* Fallthrough */
@@ -25010,7 +25010,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         switch ((ctx->opcode >> 6) & 0x1f) {
         case 1:
             /* rotrv is decoded as srlv on non-R2 CPUs */
-            if (ctx->insn_flags & ISA_MIPS32R2) {
+            if (ctx->insn_flags & ISA_MIPS_R2) {
                 op1 = OPC_ROTRV;
             }
             /* Fallthrough */
@@ -25083,7 +25083,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         switch ((ctx->opcode >> 21) & 0x1f) {
         case 1:
             /* drotr is decoded as dsrl on non-R2 CPUs */
-            if (ctx->insn_flags & ISA_MIPS32R2) {
+            if (ctx->insn_flags & ISA_MIPS_R2) {
                 op1 = OPC_DROTR;
             }
             /* Fallthrough */
@@ -25101,7 +25101,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         switch ((ctx->opcode >> 21) & 0x1f) {
         case 1:
             /* drotr32 is decoded as dsrl32 on non-R2 CPUs */
-            if (ctx->insn_flags & ISA_MIPS32R2) {
+            if (ctx->insn_flags & ISA_MIPS_R2) {
                 op1 = OPC_DROTR32;
             }
             /* Fallthrough */
@@ -25133,7 +25133,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         switch ((ctx->opcode >> 6) & 0x1f) {
         case 1:
             /* drotrv is decoded as dsrlv on non-R2 CPUs */
-            if (ctx->insn_flags & ISA_MIPS32R2) {
+            if (ctx->insn_flags & ISA_MIPS_R2) {
                 op1 = OPC_DROTRV;
             }
             /* Fallthrough */
@@ -28594,7 +28594,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
     switch (op1) {
     case OPC_EXT:
     case OPC_INS:
-        check_insn(ctx, ISA_MIPS32R2);
+        check_insn(ctx, ISA_MIPS_R2);
         gen_bitops(ctx, op1, rt, rs, sa, rd);
         break;
     case OPC_BSHFL:
@@ -28609,7 +28609,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
             decode_opc_special3_r6(env, ctx);
             break;
         default:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_bshfl(ctx, op2, rt, rd);
             break;
         }
@@ -28621,7 +28621,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
     case OPC_DINSM:
     case OPC_DINSU:
     case OPC_DINS:
-        check_insn(ctx, ISA_MIPS32R2);
+        check_insn(ctx, ISA_MIPS_R2);
         check_mips_64(ctx);
         gen_bitops(ctx, op1, rt, rs, sa, rd);
         break;
@@ -28641,7 +28641,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
             decode_opc_special3_r6(env, ctx);
             break;
         default:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             check_mips_64(ctx);
             op2 = MASK_DBSHFL(ctx->opcode);
             gen_bshfl(ctx, op2, rt, rd);
@@ -30741,7 +30741,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             generate_exception_end(ctx, EXCP_RI);
             break;
         case OPC_SYNCI:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             /*
              * Break the TB to be able to sync copied instructions
              * immediately.
@@ -30858,7 +30858,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
                     }
                     break;
                 case OPC_DI:
-                    check_insn(ctx, ISA_MIPS32R2);
+                    check_insn(ctx, ISA_MIPS_R2);
                     save_cpu_state(ctx, 1);
                     gen_helper_di(t0, cpu_env);
                     gen_store_gpr(t0, rt);
@@ -30869,7 +30869,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
                     ctx->base.is_jmp = DISAS_STOP;
                     break;
                 case OPC_EI:
-                    check_insn(ctx, ISA_MIPS32R2);
+                    check_insn(ctx, ISA_MIPS_R2);
                     save_cpu_state(ctx, 1);
                     gen_helper_ei(t0, cpu_env);
                     gen_store_gpr(t0, rt);
@@ -30890,11 +30890,11 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
 #endif /* !CONFIG_USER_ONLY */
             break;
         case OPC_RDPGPR:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_load_srsgpr(rt, rd);
             break;
         case OPC_WRPGPR:
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             gen_store_srsgpr(rt, rd);
             break;
         default:
@@ -31056,7 +31056,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         case OPC_MFHC1:
         case OPC_MTHC1:
             check_cp1_enabled(ctx);
-            check_insn(ctx, ISA_MIPS32R2);
+            check_insn(ctx, ISA_MIPS_R2);
             /* fall through */
         case OPC_MFC1:
         case OPC_CFC1:
@@ -31250,21 +31250,21 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             switch (op1) {
             case OPC_LUXC1:
             case OPC_SUXC1:
-                check_insn(ctx, ISA_MIPS5 | ISA_MIPS32R2);
+                check_insn(ctx, ISA_MIPS5 | ISA_MIPS_R2);
                 /* Fallthrough */
             case OPC_LWXC1:
             case OPC_LDXC1:
             case OPC_SWXC1:
             case OPC_SDXC1:
-                check_insn(ctx, ISA_MIPS4 | ISA_MIPS32R2);
+                check_insn(ctx, ISA_MIPS4 | ISA_MIPS_R2);
                 gen_flt3_ldst(ctx, op1, sa, rd, rs, rt);
                 break;
             case OPC_PREFX:
-                check_insn(ctx, ISA_MIPS4 | ISA_MIPS32R2);
+                check_insn(ctx, ISA_MIPS4 | ISA_MIPS_R2);
                 /* Treat as NOP. */
                 break;
             case OPC_ALNV_PS:
-                check_insn(ctx, ISA_MIPS5 | ISA_MIPS32R2);
+                check_insn(ctx, ISA_MIPS5 | ISA_MIPS_R2);
                 /* Fallthrough */
             case OPC_MADD_S:
             case OPC_MADD_D:
@@ -31278,7 +31278,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
             case OPC_NMSUB_S:
             case OPC_NMSUB_D:
             case OPC_NMSUB_PS:
-                check_insn(ctx, ISA_MIPS4 | ISA_MIPS32R2);
+                check_insn(ctx, ISA_MIPS4 | ISA_MIPS_R2);
                 gen_flt3_arith(ctx, op1, sa, rs, rd, rt);
                 break;
             default:
-- 
2.26.2

