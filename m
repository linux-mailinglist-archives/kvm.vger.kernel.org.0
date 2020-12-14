Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595702D9F63
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408840AbgLNSlj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408903AbgLNSjF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:05 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECC1C0613D3
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:49 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id e25so16195278wme.0
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sGSxHagedQ+yelQida/tJJ2/RA7bkSvNOfSJ4MvCHXk=;
        b=PdSHiahu3St5VPIxw5aGKQa7K7soukaPOYYVdf/QPSoLLOBPUeVCn0gowQsQAr7YYE
         NLJhufzfKz0zIQTMtTCQ+ocR6odMrWjCl5njCq8vxlTqVrRn7MLPY/bj13uxoVZks4kZ
         lI+YMmJ87KZKix9XH12FDURZPfZooNyoIpqMNq9ZxMbdsm+QEKq+CJDzIkxxELwFrKdc
         2E0yD6cHl61TCXsXrz+BOta+Rv8tB4cV1GGBwt2tggbizC7hTjEKeXgtgwreqtgmi4hx
         a7fLRTp+OcP0pDMU7cfusvzEfSGdMGQ34/dd+RypzUSU5dvpgFmrqMNDzVV8svgQVGkM
         wKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=sGSxHagedQ+yelQida/tJJ2/RA7bkSvNOfSJ4MvCHXk=;
        b=Hl5ZLnPwhcx1Js8PbE7V+mFL+DOsUbtnk+UL45wLVnbT00Fq8A7hLeuhDHJWbKmR3C
         TTKT7tCVlRWJm3LgpbKbGqYpkDQ0v4tA2x8wq0Rt2LGlZooD1GTZ0WsTRMA+7yqj/FZy
         Fgob/EsYllGh6ckvJkM0OXZBgNWEem1WYlJR/J9ufbOJ0DhhKIqGJo7Hnc8PwH/4VGqA
         pfUoKYPB4u9mW3c9Rqd+IgCVYUtoDIvylg7Dz77s+j2G6i1b5DwTTuAdbKBQ/mBhk1Ql
         a72+ZR6NS9pweMz3JmqiqRC5oj70vUcsLR/59258/D+mTgzHjc8/6JlGyhhLKzFoXSDt
         5Qsg==
X-Gm-Message-State: AOAM530cNAugtBCQ2fzDLwuEQIaRQXKM2mtpwMnEu7BLRkkba6ShS1Wu
        htNv9tZguD9LGv+4DQnIu44=
X-Google-Smtp-Source: ABdhPJwlWmaCfmRQI8uZTvnZeWtXOWcn1UpyDEcuDiHJq+ZLXK9T69n/wJpn/e+Xd/au+GiANqM0BA==
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr29697641wmm.122.1607971128564;
        Mon, 14 Dec 2020 10:38:48 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id q1sm31550246wrj.8.2020.12.14.10.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:47 -0800 (PST)
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
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v2 13/16] target/mips/translate: Add declarations for generic code
Date:   Mon, 14 Dec 2020 19:37:36 +0100
Message-Id: <20201214183739.500368-14-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some CPU translation functions / registers / macros and
definitions can be used by ISA / ASE / extensions out of
the big translate.c file. Declare them in "translate.h".

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201207235539.4070364-3-f4bug@amsat.org>
---
 target/mips/translate.h | 38 ++++++++++++++++++++++++++++++++
 target/mips/translate.c | 48 +++++++++++++----------------------------
 2 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index fcda1a99001..989d6c43207 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -10,6 +10,8 @@
 
 #include "exec/translator.h"
 
+#define MIPS_DEBUG_DISAS 0
+
 typedef struct DisasContext {
     DisasContextBase base;
     target_ulong saved_pc;
@@ -47,4 +49,40 @@ typedef struct DisasContext {
     int gi;
 } DisasContext;
 
+/* MIPS major opcodes */
+#define MASK_OP_MAJOR(op)   (op & (0x3F << 26))
+
+void generate_exception_err(DisasContext *ctx, int excp, int err);
+void generate_exception_end(DisasContext *ctx, int excp);
+void gen_reserved_instruction(DisasContext *ctx);
+void check_insn(DisasContext *ctx, uint64_t flags);
+#ifdef TARGET_MIPS64
+void check_mips_64(DisasContext *ctx);
+#endif
+
+void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
+void gen_load_gpr(TCGv t, int reg);
+void gen_store_gpr(TCGv t, int reg);
+
+extern TCGv cpu_gpr[32], cpu_PC;
+extern TCGv bcond;
+
+#define LOG_DISAS(...)                                                        \
+    do {                                                                      \
+        if (MIPS_DEBUG_DISAS) {                                               \
+            qemu_log_mask(CPU_LOG_TB_IN_ASM, ## __VA_ARGS__);                 \
+        }                                                                     \
+    } while (0)
+
+#define MIPS_INVAL(op)                                                        \
+    do {                                                                      \
+        if (MIPS_DEBUG_DISAS) {                                               \
+            qemu_log_mask(CPU_LOG_TB_IN_ASM,                                  \
+                          TARGET_FMT_lx ": %08x Invalid %s %03x %03x %03x\n", \
+                          ctx->base.pc_next, ctx->opcode, op,                 \
+                          ctx->opcode >> 26, ctx->opcode & 0x3F,              \
+                          ((ctx->opcode >> 16) & 0x1F));                      \
+        }                                                                     \
+    } while (0)
+
 #endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 0db0fce3789..318642cbcfe 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -38,11 +38,6 @@
 #include "fpu_helper.h"
 #include "translate.h"
 
-#define MIPS_DEBUG_DISAS 0
-
-/* MIPS major opcodes */
-#define MASK_OP_MAJOR(op)       (op & (0x3F << 26))
-
 enum {
     /* indirect opcode tables */
     OPC_SPECIAL  = (0x00 << 26),
@@ -2491,9 +2486,10 @@ enum {
 };
 
 /* global register indices */
-static TCGv cpu_gpr[32], cpu_PC;
+TCGv cpu_gpr[32], cpu_PC;
 static TCGv cpu_HI[MIPS_DSP_ACC], cpu_LO[MIPS_DSP_ACC];
-static TCGv cpu_dspctrl, btarget, bcond;
+static TCGv cpu_dspctrl, btarget;
+TCGv bcond;
 static TCGv cpu_lladdr, cpu_llval;
 static TCGv_i32 hflags;
 static TCGv_i32 fpu_fcr0, fpu_fcr31;
@@ -2606,26 +2602,8 @@ static const char * const mxuregnames[] = {
 };
 #endif
 
-#define LOG_DISAS(...)                                                        \
-    do {                                                                      \
-        if (MIPS_DEBUG_DISAS) {                                               \
-            qemu_log_mask(CPU_LOG_TB_IN_ASM, ## __VA_ARGS__);                 \
-        }                                                                     \
-    } while (0)
-
-#define MIPS_INVAL(op)                                                        \
-    do {                                                                      \
-        if (MIPS_DEBUG_DISAS) {                                               \
-            qemu_log_mask(CPU_LOG_TB_IN_ASM,                                  \
-                          TARGET_FMT_lx ": %08x Invalid %s %03x %03x %03x\n", \
-                          ctx->base.pc_next, ctx->opcode, op,                 \
-                          ctx->opcode >> 26, ctx->opcode & 0x3F,              \
-                          ((ctx->opcode >> 16) & 0x1F));                      \
-        }                                                                     \
-    } while (0)
-
 /* General purpose registers moves. */
-static inline void gen_load_gpr(TCGv t, int reg)
+void gen_load_gpr(TCGv t, int reg)
 {
     if (reg == 0) {
         tcg_gen_movi_tl(t, 0);
@@ -2634,7 +2612,7 @@ static inline void gen_load_gpr(TCGv t, int reg)
     }
 }
 
-static inline void gen_store_gpr(TCGv t, int reg)
+void gen_store_gpr(TCGv t, int reg)
 {
     if (reg != 0) {
         tcg_gen_mov_tl(cpu_gpr[reg], t);
@@ -2763,7 +2741,7 @@ static inline void restore_cpu_state(CPUMIPSState *env, DisasContext *ctx)
     }
 }
 
-static inline void generate_exception_err(DisasContext *ctx, int excp, int err)
+void generate_exception_err(DisasContext *ctx, int excp, int err)
 {
     TCGv_i32 texcp = tcg_const_i32(excp);
     TCGv_i32 terr = tcg_const_i32(err);
@@ -2779,11 +2757,16 @@ static inline void generate_exception(DisasContext *ctx, int excp)
     gen_helper_0e0i(raise_exception, excp);
 }
 
-static inline void generate_exception_end(DisasContext *ctx, int excp)
+void generate_exception_end(DisasContext *ctx, int excp)
 {
     generate_exception_err(ctx, excp, 0);
 }
 
+void gen_reserved_instruction(DisasContext *ctx)
+{
+    generate_exception_end(ctx, EXCP_RI);
+}
+
 /* Floating point register moves. */
 static void gen_load_fpr32(DisasContext *ctx, TCGv_i32 t, int reg)
 {
@@ -3013,7 +2996,7 @@ static inline void check_dsp_r3(DisasContext *ctx)
  * This code generates a "reserved instruction" exception if the
  * CPU does not support the instruction set corresponding to flags.
  */
-static inline void check_insn(DisasContext *ctx, uint64_t flags)
+void check_insn(DisasContext *ctx, uint64_t flags)
 {
     if (unlikely(!(ctx->insn_flags & flags))) {
         gen_reserved_instruction(ctx);
@@ -3064,7 +3047,7 @@ static inline void check_ps(DisasContext *ctx)
  * This code generates a "reserved instruction" exception if 64-bit
  * instructions are not enabled.
  */
-static inline void check_mips_64(DisasContext *ctx)
+void check_mips_64(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_64))) {
         gen_reserved_instruction(ctx);
@@ -3390,8 +3373,7 @@ OP_LD_ATOMIC(lld, ld64);
 #endif
 #undef OP_LD_ATOMIC
 
-static void gen_base_offset_addr(DisasContext *ctx, TCGv addr,
-                                 int base, int offset)
+void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset)
 {
     if (base == 0) {
         tcg_gen_movi_tl(addr, offset);
-- 
2.26.2

