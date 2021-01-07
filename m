Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A742EE870
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728206AbhAGWYs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727758AbhAGWYr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:47 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2348CC0612FE
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:05 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d13so7067623wrc.13
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qSV6cUIXNddxL4SLc4iJCGuI243MH3AVKaHvwWDIY1Q=;
        b=h53HUWqrO/4AwVwoHE3tTOuJnP53ULT/aCSKDv0cGww7ff2JNEXyXE15ldgGokKXYv
         mpBIQnmpQiKlBU0qojdf4Zwc2LGijZNH/7utNvR78Sm8dslOou6nArhC+/FIDNXEZSUE
         4zqNIXTr0ijZFqtEKPZ8gK0ApiJRADp/uyMKhX7V/HtfHO7OrUnGRIcE4OWHew4cX2Wq
         wG86KZPyyQULb9pavGsmaFTR1DZQHGeJ60mxDW+43DtQ1oMBmar5Q2t7oP2fx6QT+BSw
         UMYmaUchRIpvh2p6VKZlpm71yt272/BbeDrI9wA49gIGIgZhbiqwCfyzyzZriNeiAKyt
         ZDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=qSV6cUIXNddxL4SLc4iJCGuI243MH3AVKaHvwWDIY1Q=;
        b=Ug0xlR3jJiWkmEmLmMq4BnMCYJn97t4rK5PE4WBqHwoI5+qmwubRsqiZHy5GV5pHFL
         6rHVEZXMw3ln66vEdqO8qOkJ2R122oxPrwsYeQ463uzsDZekEInQMQ1O39CzlJEa+V0z
         URpgVoXl9D7PhxuGVFChFA50KXYOcZxjMaR5yjvSSRCgCtLSrGJr6RFrvJ9Zbs4ILIP8
         LLqaIXDnH7+L80qrh1z4E2UjzkcfMxxWUzf4PByxfj+pdK/RpjCWfht8t8o83PhLZF4a
         XXloXbtOuqsYiCGYZpTLWgNqJ9tcLN3r2Xjs2G62NYPI7S9Zko17mi92ZDpc21EzrKUk
         5mFw==
X-Gm-Message-State: AOAM532Kdj8RM1G8T9qzKGEJRjF+UwB9bNTc5R5EodT4P49I2OCnoIpy
        zJflAPZQc8V2aa72fLxiphU=
X-Google-Smtp-Source: ABdhPJyzuSYApH/LEUIk3VZce9bmGliTdDaDj8EIBV0nDYtvElZ7LTqhhA8lxJOM0epf3pu5FwmgUg==
X-Received: by 2002:adf:ffc8:: with SMTP id x8mr688100wrs.158.1610058243946;
        Thu, 07 Jan 2021 14:24:03 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c18sm12260023wmk.0.2021.01.07.14.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:03 -0800 (PST)
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
Subject: [PULL 13/66] target/mips/mips-defs: Use ISA_MIPS32R6 definition to check Release 6
Date:   Thu,  7 Jan 2021 23:22:00 +0100
Message-Id: <20210107222253.20382-14-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the single ISA_MIPS32R6 definition to check if the Release 6
ISA is supported, whether the CPU support 32/64-bit.

For now we keep '32' in the definition name, we will rename it
as ISA_MIPS_R6 in few commits.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-11-f4bug@amsat.org>
---
 target/mips/internal.h     | 2 +-
 target/mips/mips-defs.h    | 3 +--
 linux-user/mips/cpu_loop.c | 3 +--
 target/mips/helper.c       | 6 +++---
 target/mips/translate.c    | 2 +-
 5 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index e4d2d9f44f9..3466725b761 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -354,7 +354,7 @@ static inline void compute_hflags(CPUMIPSState *env)
     } else if (((env->hflags & MIPS_HFLAG_KSU) == MIPS_HFLAG_UM) &&
                !(env->CP0_Status & (1 << CP0St_UX))) {
         env->hflags |= MIPS_HFLAG_AWRAP;
-    } else if (env->insn_flags & ISA_MIPS64R6) {
+    } else if (env->insn_flags & ISA_MIPS32R6) {
         /* Address wrapping for Supervisor and Kernel is specified in R6 */
         if ((((env->hflags & MIPS_HFLAG_KSU) == MIPS_HFLAG_SM) &&
              !(env->CP0_Status & (1 << CP0St_SX))) ||
diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index b71127ddd7c..fea547508f0 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -21,7 +21,6 @@
 #define ISA_MIPS32R3      0x0000000000000200ULL
 #define ISA_MIPS32R5      0x0000000000000800ULL
 #define ISA_MIPS32R6      0x0000000000002000ULL
-#define ISA_MIPS64R6      0x0000000000004000ULL
 #define ISA_NANOMIPS32    0x0000000000008000ULL
 /*
  *   bits 24-39: MIPS ASEs
@@ -87,7 +86,7 @@
 
 /* MIPS Technologies "Release 6" */
 #define CPU_MIPS32R6    (CPU_MIPS32R5 | ISA_MIPS32R6)
-#define CPU_MIPS64R6    (CPU_MIPS64R5 | CPU_MIPS32R6 | ISA_MIPS64R6)
+#define CPU_MIPS64R6    (CPU_MIPS64R5 | CPU_MIPS32R6)
 
 /* Wave Computing: "nanoMIPS" */
 #define CPU_NANOMIPS32  (CPU_MIPS32R6 | ISA_NANOMIPS32)
diff --git a/linux-user/mips/cpu_loop.c b/linux-user/mips/cpu_loop.c
index f0831379cc4..e400166c583 100644
--- a/linux-user/mips/cpu_loop.c
+++ b/linux-user/mips/cpu_loop.c
@@ -385,8 +385,7 @@ void target_cpu_copy_regs(CPUArchState *env, struct target_pt_regs *regs)
     prog_req.fre &= interp_req.fre;
 
     bool cpu_has_mips_r2_r6 = env->insn_flags & ISA_MIPS32R2 ||
-                              env->insn_flags & ISA_MIPS32R6 ||
-                              env->insn_flags & ISA_MIPS64R6;
+                              env->insn_flags & ISA_MIPS32R6;
 
     if (prog_req.fre && !prog_req.frdefault && !prog_req.fr1) {
         env->CP0_Config5 |= (1 << CP0C5_FRE);
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 87296fbad69..5b74815beb0 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -1145,7 +1145,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
  enter_debug_mode:
         if (env->insn_flags & ISA_MIPS3) {
             env->hflags |= MIPS_HFLAG_64;
-            if (!(env->insn_flags & ISA_MIPS64R6) ||
+            if (!(env->insn_flags & ISA_MIPS32R6) ||
                 env->CP0_Status & (1 << CP0St_KX)) {
                 env->hflags &= ~MIPS_HFLAG_AWRAP;
             }
@@ -1174,7 +1174,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
         env->CP0_Status |= (1 << CP0St_ERL) | (1 << CP0St_BEV);
         if (env->insn_flags & ISA_MIPS3) {
             env->hflags |= MIPS_HFLAG_64;
-            if (!(env->insn_flags & ISA_MIPS64R6) ||
+            if (!(env->insn_flags & ISA_MIPS32R6) ||
                 env->CP0_Status & (1 << CP0St_KX)) {
                 env->hflags &= ~MIPS_HFLAG_AWRAP;
             }
@@ -1360,7 +1360,7 @@ void mips_cpu_do_interrupt(CPUState *cs)
             env->CP0_Status |= (1 << CP0St_EXL);
             if (env->insn_flags & ISA_MIPS3) {
                 env->hflags |= MIPS_HFLAG_64;
-                if (!(env->insn_flags & ISA_MIPS64R6) ||
+                if (!(env->insn_flags & ISA_MIPS32R6) ||
                     env->CP0_Status & (1 << CP0St_KX)) {
                     env->hflags &= ~MIPS_HFLAG_AWRAP;
                 }
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 9fc9dedf30d..fc93b9da8eb 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31438,7 +31438,7 @@ static void mips_tr_init_disas_context(DisasContextBase *dcbase, CPUState *cs)
 #else
         ctx->mem_idx = hflags_mmu_index(ctx->hflags);
 #endif
-    ctx->default_tcg_memop_mask = (ctx->insn_flags & (ISA_MIPS32R6 | ISA_MIPS64R6 |
+    ctx->default_tcg_memop_mask = (ctx->insn_flags & (ISA_MIPS32R6 |
                                   INSN_LOONGSON3A)) ? MO_UNALN : MO_ALIGN;
 
     LOG_DISAS("\ntb %p idx %d hflags %04x\n", ctx->base.tb, ctx->mem_idx,
-- 
2.26.2

