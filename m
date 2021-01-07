Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CBF2EE866
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbhAGWY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbhAGWY1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:27 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E893C0612FF
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:10 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id y23so6836709wmi.1
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lyrz/PhO4KF7gD9TiETRABWrYhrHwF0TOd6pyZtd8B4=;
        b=sQ6N6WefI+pC37et7AQvNKqPmeZHt6XZFKQmnwsHv8LaWG/5fcjRKYNQhzeYW0+eA3
         aajtada7+Gx/A27Awl6VL8x380j+VuZ+2GQHroqs+tYY8dCPm31+w1klsLJ7SWpVD7Fl
         KiE37Xsji1u3IP6rrkaRIOV7qKnr4JgnalFVNSqq4P5QA5NclmRWwihL1hiqb9k5ltIj
         u1BLS9kHQIEwSo0JgEFlrKDsvQCebe+SeE1G9lAQIWVwy8fnld4WBgvpcOLNAG63ZqHs
         EKiZrzP3xpuRrkXpDYeXJr0/0RP1Hubb5xHvhpmR/YZIlWBSglUQvN48BFMJ3XKoef8Z
         uBuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=lyrz/PhO4KF7gD9TiETRABWrYhrHwF0TOd6pyZtd8B4=;
        b=HXniGyXRu5xeKVij+IoNTY6HWbaj877ciwW+ynLjihGpfptu9xrIfR4zSCLQM6tV5l
         MpJbTGxMDZK64xdo7dL++kD4q6/Qrw1DDfQYNLWmlAnTO4gjYJ6IgHBR6eY+LNaxgIGs
         3uHZFMUOmuJIVLE7Vh3f90ve4oYugFDiEl9vmh4afijNOQTYf604jDbvSpGS3bT08LjJ
         qWMpqdM1LtEL+Jsx1rC6+3sMgOMV/nwdfQ//UfaA1bAtZZFbzRUWJIkx1Uh998+uxTm4
         dtyPPAERqoeiFJJsaUZlP5k2uMsffxoWJaXuKjJc/14frj+vwVxieO3H1ylvt2mmynWz
         twiQ==
X-Gm-Message-State: AOAM533PZaRBb0f0hN8oJuWcGO4thOp65eVo7agxUJoJcXFrOgec9NVg
        nZipzUcCK3DxDbS7U/QExUI=
X-Google-Smtp-Source: ABdhPJx2m9NGD8CwX3+QH+HzByCdi2UV+8vXuh4fZXwBIItQJi1frALwUcovpoTq6hhtRZJjFBfv9Q==
X-Received: by 2002:a1c:df85:: with SMTP id w127mr527600wmg.166.1610058249087;
        Thu, 07 Jan 2021 14:24:09 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id x25sm9186197wmc.3.2021.01.07.14.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:08 -0800 (PST)
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
Subject: [PULL 14/66] target/mips/mips-defs: Rename ISA_MIPS32 as ISA_MIPS_R1
Date:   Thu,  7 Jan 2021 23:22:01 +0100
Message-Id: <20210107222253.20382-15-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MIPS ISA release '1' is common to 32/64-bit CPUs.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-12-f4bug@amsat.org>
---
 target/mips/internal.h  |  2 +-
 target/mips/mips-defs.h |  4 +--
 target/mips/translate.c | 54 ++++++++++++++++++++---------------------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/target/mips/internal.h b/target/mips/internal.h
index 3466725b761..94910f75a61 100644
--- a/target/mips/internal.h
+++ b/target/mips/internal.h
@@ -411,7 +411,7 @@ static inline void compute_hflags(CPUMIPSState *env)
         if (env->active_fpu.fcr0 & (1 << FCR0_F64)) {
             env->hflags |= MIPS_HFLAG_COP1X;
         }
-    } else if (env->insn_flags & ISA_MIPS32) {
+    } else if (env->insn_flags & ISA_MIPS_R1) {
         if (env->hflags & MIPS_HFLAG_64) {
             env->hflags |= MIPS_HFLAG_COP1X;
         }
diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index fea547508f0..a7048ffaffe 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -16,7 +16,7 @@
 #define ISA_MIPS3         0x0000000000000004ULL /* 64-bit */
 #define ISA_MIPS4         0x0000000000000008ULL
 #define ISA_MIPS5         0x0000000000000010ULL
-#define ISA_MIPS32        0x0000000000000020ULL
+#define ISA_MIPS_R1       0x0000000000000020ULL
 #define ISA_MIPS32R2      0x0000000000000040ULL
 #define ISA_MIPS32R3      0x0000000000000200ULL
 #define ISA_MIPS32R5      0x0000000000000800ULL
@@ -69,7 +69,7 @@
 #define CPU_MIPS64      (ISA_MIPS3)
 
 /* MIPS Technologies "Release 1" */
-#define CPU_MIPS32R1    (CPU_MIPS2 | ISA_MIPS32)
+#define CPU_MIPS32R1    (CPU_MIPS2 | ISA_MIPS_R1)
 #define CPU_MIPS64R1    (CPU_MIPS5 | CPU_MIPS32R1)
 
 /* MIPS Technologies "Release 2" */
diff --git a/target/mips/translate.c b/target/mips/translate.c
index fc93b9da8eb..a59fbd94bac 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -7411,7 +7411,7 @@ static void gen_mfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     const char *register_name = "invalid";
 
     if (sel != 0) {
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
     }
 
     switch (reg) {
@@ -8179,7 +8179,7 @@ static void gen_mtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     const char *register_name = "invalid";
 
     if (sel != 0) {
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
     }
 
     if (tb_cflags(ctx->base.tb) & CF_USE_ICOUNT) {
@@ -8943,7 +8943,7 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     const char *register_name = "invalid";
 
     if (sel != 0) {
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
     }
 
     switch (reg) {
@@ -9669,7 +9669,7 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     const char *register_name = "invalid";
 
     if (sel != 0) {
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
     }
 
     if (tb_cflags(ctx->base.tb) & CF_USE_ICOUNT) {
@@ -11006,7 +11006,7 @@ static void gen_cp0(CPUMIPSState *env, DisasContext *ctx, uint32_t opc,
         break;
     case OPC_DERET:
         opn = "deret";
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
         if ((ctx->insn_flags & ISA_MIPS32R6) &&
             (ctx->hflags & MIPS_HFLAG_BMASK)) {
             goto die;
@@ -11021,7 +11021,7 @@ static void gen_cp0(CPUMIPSState *env, DisasContext *ctx, uint32_t opc,
         break;
     case OPC_WAIT:
         opn = "wait";
-        check_insn(ctx, ISA_MIPS3 | ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS3 | ISA_MIPS_R1);
         if ((ctx->insn_flags & ISA_MIPS32R6) &&
             (ctx->hflags & MIPS_HFLAG_BMASK)) {
             goto die;
@@ -11056,7 +11056,7 @@ static void gen_compute_branch1(DisasContext *ctx, uint32_t op,
     }
 
     if (cc != 0) {
-        check_insn(ctx, ISA_MIPS4 | ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS4 | ISA_MIPS_R1);
     }
 
     btarget = ctx->base.pc_next + 4 + offset;
@@ -14425,7 +14425,7 @@ static int decode_extended_mips16_opc(CPUMIPSState *env, DisasContext *ctx)
             gen_arith_imm(ctx, OPC_ADDIU, 29, 29, imm);
             break;
         case I8_SVRS:
-            check_insn(ctx, ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS_R1);
             {
                 int xsregs = (ctx->opcode >> 24) & 0x7;
                 int aregs = (ctx->opcode >> 16) & 0xf;
@@ -14675,7 +14675,7 @@ static int decode_mips16_opc(CPUMIPSState *env, DisasContext *ctx)
                               ((int8_t)ctx->opcode) << 3);
                 break;
             case I8_SVRS:
-                check_insn(ctx, ISA_MIPS32);
+                check_insn(ctx, ISA_MIPS_R1);
                 {
                     int do_ra = ctx->opcode & (1 << 6);
                     int do_s0 = ctx->opcode & (1 << 5);
@@ -14819,7 +14819,7 @@ static int decode_mips16_opc(CPUMIPSState *env, DisasContext *ctx)
                 int ra = (ctx->opcode >> 5) & 0x1;
 
                 if (nd) {
-                    check_insn(ctx, ISA_MIPS32);
+                    check_insn(ctx, ISA_MIPS_R1);
                 }
 
                 if (link) {
@@ -14840,7 +14840,7 @@ static int decode_mips16_opc(CPUMIPSState *env, DisasContext *ctx)
                  * XXX: not clear which exception should be raised
                  *      when in debug mode...
                  */
-                check_insn(ctx, ISA_MIPS32);
+                check_insn(ctx, ISA_MIPS_R1);
                 generate_exception_end(ctx, EXCP_DBp);
             }
             break;
@@ -14891,7 +14891,7 @@ static int decode_mips16_opc(CPUMIPSState *env, DisasContext *ctx)
             gen_HILO(ctx, OPC_MFHI, 0, rx);
             break;
         case RR_CNVT:
-            check_insn(ctx, ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS_R1);
             switch (cnvt_op) {
             case RR_RY_CNVT_ZEB:
                 tcg_gen_ext8u_tl(cpu_gpr[rx], cpu_gpr[rx]);
@@ -14907,12 +14907,12 @@ static int decode_mips16_opc(CPUMIPSState *env, DisasContext *ctx)
                 break;
 #if defined(TARGET_MIPS64)
             case RR_RY_CNVT_ZEW:
-                check_insn(ctx, ISA_MIPS32);
+                check_insn(ctx, ISA_MIPS_R1);
                 check_mips_64(ctx);
                 tcg_gen_ext32u_tl(cpu_gpr[rx], cpu_gpr[rx]);
                 break;
             case RR_RY_CNVT_SEW:
-                check_insn(ctx, ISA_MIPS32);
+                check_insn(ctx, ISA_MIPS_R1);
                 check_mips_64(ctx);
                 tcg_gen_ext32s_tl(cpu_gpr[rx], cpu_gpr[rx]);
                 break;
@@ -15831,7 +15831,7 @@ static void gen_pool16c_insn(DisasContext *ctx)
              * XXX: not clear which exception should be raised
              *      when in debug mode...
              */
-            check_insn(ctx, ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS_R1);
             generate_exception_end(ctx, EXCP_DBp);
         }
         break;
@@ -16175,7 +16175,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
         case CLZ:
             mips32_op = OPC_CLZ;
         do_cl:
-            check_insn(ctx, ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS_R1);
             gen_cl(ctx, mips32_op, rt, rs);
             break;
         case RDHWR:
@@ -16202,7 +16202,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
             mips32_op = OPC_DIVU;
             goto do_div;
         do_div:
-            check_insn(ctx, ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS_R1);
             gen_muldiv(ctx, mips32_op, 0, rs, rt);
             break;
         case MADD:
@@ -16221,7 +16221,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
             check_insn_opc_removed(ctx, ISA_MIPS32R6);
             mips32_op = OPC_MSUBU;
         do_mul:
-            check_insn(ctx, ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS_R1);
             gen_muldiv(ctx, mips32_op, 0, rs, rt);
             break;
         default:
@@ -16369,7 +16369,7 @@ static void gen_pool32axf(CPUMIPSState *env, DisasContext *ctx, int rt, int rs)
             if (is_uhi(extract32(ctx->opcode, 16, 10))) {
                 gen_helper_do_semihosting(cpu_env);
             } else {
-                check_insn(ctx, ISA_MIPS32);
+                check_insn(ctx, ISA_MIPS_R1);
                 if (ctx->hflags & MIPS_HFLAG_SBRI) {
                     generate_exception_end(ctx, EXCP_RI);
                 } else {
@@ -24889,7 +24889,7 @@ static void decode_opc_special_legacy(CPUMIPSState *env, DisasContext *ctx)
     switch (op1) {
     case OPC_MOVN:         /* Conditional move */
     case OPC_MOVZ:
-        check_insn(ctx, ISA_MIPS4 | ISA_MIPS32 |
+        check_insn(ctx, ISA_MIPS4 | ISA_MIPS_R1 |
                    INSN_LOONGSON2E | INSN_LOONGSON2F);
         gen_cond_move(ctx, op1, rd, rs, rt);
         break;
@@ -24902,7 +24902,7 @@ static void decode_opc_special_legacy(CPUMIPSState *env, DisasContext *ctx)
         gen_HILO(ctx, op1, rd & 3, rs);
         break;
     case OPC_MOVCI:
-        check_insn(ctx, ISA_MIPS4 | ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS4 | ISA_MIPS_R1);
         if (env->CP0_Config1 & (1 << CP0C1_FP)) {
             check_cp1_enabled(ctx);
             gen_movci(ctx, rd, rs, (ctx->opcode >> 18) & 0x7,
@@ -27577,7 +27577,7 @@ static void decode_opc_special2_legacy(CPUMIPSState *env, DisasContext *ctx)
     case OPC_MADDU:
     case OPC_MSUB:
     case OPC_MSUBU:
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
         gen_muldiv(ctx, op1, rd & 3, rs, rt);
         break;
     case OPC_MUL:
@@ -27594,7 +27594,7 @@ static void decode_opc_special2_legacy(CPUMIPSState *env, DisasContext *ctx)
         break;
     case OPC_CLO:
     case OPC_CLZ:
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
         gen_cl(ctx, op1, rd, rs);
         break;
     case OPC_SDBBP:
@@ -27605,14 +27605,14 @@ static void decode_opc_special2_legacy(CPUMIPSState *env, DisasContext *ctx)
              * XXX: not clear which exception should be raised
              *      when in debug mode...
              */
-            check_insn(ctx, ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS_R1);
             generate_exception_end(ctx, EXCP_DBp);
         }
         break;
 #if defined(TARGET_MIPS64)
     case OPC_DCLO:
     case OPC_DCLZ:
-        check_insn(ctx, ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS_R1);
         check_mips_64(ctx);
         gen_cl(ctx, op1, rd, rs);
         break;
@@ -31025,7 +31025,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
     case OPC_CACHE:
         check_insn_opc_removed(ctx, ISA_MIPS32R6);
         check_cp0_enabled(ctx);
-        check_insn(ctx, ISA_MIPS3 | ISA_MIPS32);
+        check_insn(ctx, ISA_MIPS3 | ISA_MIPS_R1);
         if (ctx->hflags & MIPS_HFLAG_ITC_CACHE) {
             gen_cache_operation(ctx, rt, rs, imm);
         }
@@ -31036,7 +31036,7 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         if (ctx->insn_flags & INSN_R5900) {
             /* Treat as NOP. */
         } else {
-            check_insn(ctx, ISA_MIPS4 | ISA_MIPS32);
+            check_insn(ctx, ISA_MIPS4 | ISA_MIPS_R1);
             /* Treat as NOP. */
         }
         break;
-- 
2.26.2

