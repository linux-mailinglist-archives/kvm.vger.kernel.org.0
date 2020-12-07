Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 029A02D1EA1
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgLGX4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbgLGX4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:56:33 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6A9C06179C
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:55:53 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id lt17so22117703ejb.3
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=id6OmDgw7iWNDI7dt45hX8qgU9Twf4yyUu+1zQG1NFY=;
        b=aHsv2dYNJ008+x9hkHPl4FOfen0SZ1OFwpinszYcZJUz+aP9aeyUN1ZcOLNMeTPR50
         lI/ejL8HdgXAZsiY57Jl0QAHgMmoysWwCL0l1Tu3q5n2BHqwGYzDOVivI3p5jFxkcnCE
         ABPkRxp4fIbSxeoVy1JEPiu9fcIy99yx87VuzMAlAZ26vmcwgEAQs3XhzyV1awnZO4QV
         MaxrHcvUbDk+RaQY0ffo5n19JOVoRUoLIepHvym3qPUjzBLRH/o/K/+R/vt26JDro9Rd
         l+pAm0HYemD2BOkeugi7F/xLOSs7N4iGMsaxc5wXGRescT5+e0Owb8p+i42BUISEP28K
         0tDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=id6OmDgw7iWNDI7dt45hX8qgU9Twf4yyUu+1zQG1NFY=;
        b=rJAR1jXzUN5jo5bVPb7Fshbfr5ML87sO050jaKSJlzNwRinq+1RZv1pLYACZpOnhu0
         tJeDz3OQWyGDZNPMep0AknXfkrc5bZpB6cdrrdtiGRph6yE9bjnBS8xdbcRS1keTVItn
         hksTCHgKY9oFgc2+cjjQcdhvy/H3pzBaYf7spq30QUPh6o9I5fl2r6aaUT59YcO5QXqE
         mh4sEL4E1Q5VlIFXf1RvQmZNwSLQe3KqvSUn9KRffXLGKRm6I4lvzNoRpHRpvLe8Ldog
         4IVHOyz2WgX/fv1w4HKiVxO2+wCGPiuYoh1dhQxltfFtxmuHyI/ct8EnXWsgVoLP89Sz
         yOKg==
X-Gm-Message-State: AOAM53323AYUKhDcZKWg9T54s194jaJ2dNSA3aKAkysYCXfVSAt+imsh
        Owl45Cu1qCgshnlEAyPrLxM=
X-Google-Smtp-Source: ABdhPJxc/ZEpdrjqB80I8uVnrTgzwjQBANtrdvqXUbG5/8NG8ImZsDEWaQuhsSszKycsr6gLE2fCTA==
X-Received: by 2002:a17:906:229a:: with SMTP id p26mr21204396eja.291.1607385352216;
        Mon, 07 Dec 2020 15:55:52 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id be6sm15474616edb.29.2020.12.07.15.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:55:51 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 2/7] target/mips/translate: Add declarations for generic code
Date:   Tue,  8 Dec 2020 00:55:34 +0100
Message-Id: <20201207235539.4070364-3-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207235539.4070364-1-f4bug@amsat.org>
References: <20201207235539.4070364-1-f4bug@amsat.org>
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
---
 target/mips/translate.h | 33 ++++++++++++++++++++++++++++++++
 target/mips/translate.c | 42 ++++++++++++-----------------------------
 2 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index fcda1a99001..dbf7df7ba6d 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -10,6 +10,8 @@
 
 #include "exec/translator.h"
 
+#define MIPS_DEBUG_DISAS 0
+
 typedef struct DisasContext {
     DisasContextBase base;
     target_ulong saved_pc;
@@ -47,4 +49,35 @@ typedef struct DisasContext {
     int gi;
 } DisasContext;
 
+/* MIPS major opcodes */
+#define MASK_OP_MAJOR(op)   (op & (0x3F << 26))
+
+void generate_exception_end(DisasContext *ctx, int excp);
+void gen_reserved_instruction(DisasContext *ctx);
+void check_insn(DisasContext *ctx, uint64_t flags);
+void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
+
+void gen_load_gpr(TCGv t, int reg);
+void gen_store_gpr(TCGv t, int reg);
+
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
index d7f5a1e8d84..46aab26b868 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -41,11 +41,6 @@
 #include "qemu/qemu-print.h"
 #include "translate.h"
 
-#define MIPS_DEBUG_DISAS 0
-
-/* MIPS major opcodes */
-#define MASK_OP_MAJOR(op)       (op & (0x3F << 26))
-
 enum {
     /* indirect opcode tables */
     OPC_SPECIAL  = (0x00 << 26),
@@ -2496,7 +2491,8 @@ enum {
 /* global register indices */
 static TCGv cpu_gpr[32], cpu_PC;
 static TCGv cpu_HI[MIPS_DSP_ACC], cpu_LO[MIPS_DSP_ACC];
-static TCGv cpu_dspctrl, btarget, bcond;
+static TCGv cpu_dspctrl, btarget;
+TCGv bcond;
 static TCGv cpu_lladdr, cpu_llval;
 static TCGv_i32 hflags;
 static TCGv_i32 fpu_fcr0, fpu_fcr31;
@@ -2609,26 +2605,8 @@ static const char * const mxuregnames[] = {
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
@@ -2637,7 +2615,7 @@ static inline void gen_load_gpr(TCGv t, int reg)
     }
 }
 
-static inline void gen_store_gpr(TCGv t, int reg)
+void gen_store_gpr(TCGv t, int reg)
 {
     if (reg != 0) {
         tcg_gen_mov_tl(cpu_gpr[reg], t);
@@ -2782,11 +2760,16 @@ static inline void generate_exception(DisasContext *ctx, int excp)
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
@@ -3016,7 +2999,7 @@ static inline void check_dsp_r3(DisasContext *ctx)
  * This code generates a "reserved instruction" exception if the
  * CPU does not support the instruction set corresponding to flags.
  */
-static inline void check_insn(DisasContext *ctx, uint64_t flags)
+void check_insn(DisasContext *ctx, uint64_t flags)
 {
     if (unlikely(!(ctx->insn_flags & flags))) {
         generate_exception_end(ctx, EXCP_RI);
@@ -3393,8 +3376,7 @@ OP_LD_ATOMIC(lld, ld64);
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

