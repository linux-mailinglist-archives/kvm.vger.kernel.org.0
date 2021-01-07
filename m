Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E12602EE886
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbhAGW0I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAGW0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:07 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FDEC0612FA
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:27 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id v14so6365521wml.1
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Md8yMDtPFL047sc9GnACrU93Gm/4UH0JKJe4iaxMljk=;
        b=X4nwephvCpgQ7l/2883pUwoLMNiDzUE1j1rfFaJVmSKy4o29ohYBVuxWnjIBfD3Eiq
         XgIbI1Oz5zyYVFgWt2gI1ANeQ3yYpWQT3AmrSnOoj9lp+q4g+VR6ISX4BexFkPVACS0v
         21pBZEbtyrYqgT4Ea6MoCeUx2N9F8lARCyaToUTZ9X73k03/O6zBHQhr157eHOqIIz9E
         MoBC6QayCgUCLAEZQe4vnl8FyFfTvzIXbey3n2C3r1q3I+yQrH5MVVR55MtapRjlLOAT
         104sNE59nM9TfgrrcQafz4lpk4hUlZEntTCeUuKXMT5cIV+XAhrkRvdh4G7cxPOiSrU5
         bAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Md8yMDtPFL047sc9GnACrU93Gm/4UH0JKJe4iaxMljk=;
        b=JJvpZtc2AAr6x2UrYthvmHmjI0KABSvBtsv1aFsUKQkVTZDyxjXDqU9KHqfPTB8OG+
         1a5QSE13OGFaNM9nzQT82qxOFKbhpbY9lhyFxaXF6YzKEp25NrJMVF8HERZnBfUybzdF
         X57ifMMih10JR2+tm59OnPb1kh1ZWRW/C4Pj2I1Pe3U0nn2R3Z8pfSlCp/UfyVyamJoO
         mDdaHT5DgVwHMf+TxvheV+jox4dDdyvk7R36SAVCdmj5SUJ0R7OE1WLRCwLRXQe5T+59
         eH0Fjd8prR4hAs/yhB5U91Rj0qBOEp9N894HsLfUDvf8WxoEfWK4qiQ5RTmO9y9ugaMm
         jeqw==
X-Gm-Message-State: AOAM532RGmXC4RuOpsPnoN8HD5DQQ7jq8NeiYVWnul47eKLUZ5vabpUN
        XLlii8w0Xxep7bbl4nmro1I=
X-Google-Smtp-Source: ABdhPJx/wlXEytr69sTyc89ncUwNXATKyBRfUcaBAbtdnUC6Nhbkylim6JvAaQ2HSmkJNXRQw6PVOQ==
X-Received: by 2002:a7b:c7d3:: with SMTP id z19mr521782wmk.31.1610058326194;
        Thu, 07 Jan 2021 14:25:26 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id w21sm9110700wmi.45.2021.01.07.14.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:25 -0800 (PST)
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
Subject: [PULL 29/66] target/mips/translate: Add declarations for generic code
Date:   Thu,  7 Jan 2021 23:22:16 +0100
Message-Id: <20210107222253.20382-30-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
 target/mips/translate.h | 38 ++++++++++++++++++++++++++++++++++
 target/mips/translate.c | 45 ++++++++++-------------------------------
 2 files changed, 49 insertions(+), 34 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index fcda1a99001..d9d4d3943af 100644
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
+void generate_exception(DisasContext *ctx, int excp);
+void generate_exception_err(DisasContext *ctx, int excp, int err);
+void generate_exception_end(DisasContext *ctx, int excp);
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
index 9e824e12d44..5889d24eb65 100644
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
@@ -2774,12 +2752,12 @@ static inline void generate_exception_err(DisasContext *ctx, int excp, int err)
     ctx->base.is_jmp = DISAS_NORETURN;
 }
 
-static inline void generate_exception(DisasContext *ctx, int excp)
+void generate_exception(DisasContext *ctx, int excp)
 {
     gen_helper_0e0i(raise_exception, excp);
 }
 
-static inline void generate_exception_end(DisasContext *ctx, int excp)
+void generate_exception_end(DisasContext *ctx, int excp)
 {
     generate_exception_err(ctx, excp, 0);
 }
@@ -3013,7 +2991,7 @@ static inline void check_dsp_r3(DisasContext *ctx)
  * This code generates a "reserved instruction" exception if the
  * CPU does not support the instruction set corresponding to flags.
  */
-static inline void check_insn(DisasContext *ctx, uint64_t flags)
+void check_insn(DisasContext *ctx, uint64_t flags)
 {
     if (unlikely(!(ctx->insn_flags & flags))) {
         generate_exception_end(ctx, EXCP_RI);
@@ -3064,7 +3042,7 @@ static inline void check_ps(DisasContext *ctx)
  * This code generates a "reserved instruction" exception if 64-bit
  * instructions are not enabled.
  */
-static inline void check_mips_64(DisasContext *ctx)
+void check_mips_64(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_64))) {
         generate_exception_end(ctx, EXCP_RI);
@@ -3390,8 +3368,7 @@ OP_LD_ATOMIC(lld, ld64);
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

