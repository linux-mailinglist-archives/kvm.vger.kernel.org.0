Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1E802EE8A2
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbhAGW2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbhAGW2Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:16 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D87CC0612FB
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:36 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c5so7111446wrp.6
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ccUqeFnMhpxujrGGkccrptJlKtmDtdTT+pOY6u5+VKc=;
        b=N4aGvCIOqt6CVFIXHJSDbWRRmNKXYi5aAKh0HCKgGogOmTgieiFSpq+BWLMvbxACeN
         vZbQWVf0588aGrJ2dpI7cqUslHllqItH25MgxkIaFbgItkDAprY/tJr1V/fc7Ld5bTNz
         saZHeQtYCOIY0J8ifGDHNOad9iw4oZkF0T5A5M2n3BbBuTywnnyFcEmz5s/5JZlHbQ0t
         C80xezTdCuxN9F7qHZKxXmVA2PbPLsu+O51yRelc4KmxqDEMvyz0HcbQw3Wt21rHB76U
         h35YaXzjHVvcGcVd4UPHwVfhTCL2aiNAMzkkZEd+R8l1TBo6iNK4l4DYj1osfQkLybPu
         jTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ccUqeFnMhpxujrGGkccrptJlKtmDtdTT+pOY6u5+VKc=;
        b=aeFLunufgu7HWmpo65hv9mrCwtC58sLKRy2xUvlezhpAijHC2OZ6Rho9D5sJg+eCfR
         D+4ISvl9f61H20Cp/84miXOaYPsoxmgLmwsQZEfRYn8dx1fV12SdzuLoETyMf1YSPdsT
         hiSubqRHVIFrmfqYSewFWzpQPkvqtGhj1BOYfjh1WRsqgjSC/541OybvZoThW1875wY8
         DJo/td7oFLJBXXN80gZfwgEE88Vixm8K+r7hmwCLICKCppLwJsU0RAkLDhfZTdmGQNVr
         cDIspwCYdl7GfkTZPGRZuyFW42brVSn00zg4rTbyABN1SBr0er0w0J665ZlKTcE21T/K
         ER3g==
X-Gm-Message-State: AOAM533Vtik8+01Jq26GUkBBvTCmqlFLsI0na3tEJZ8Eo7FNexdDNMu5
        69/8CDYhfXNe13wlVsXKJFe0gmsAtGM=
X-Google-Smtp-Source: ABdhPJxQWmRIx7MeLpcmbSI97z96a23zdfgCxvCqjxgZWoVHageDGrXX0id/exUl0a/Cule2yoD4TA==
X-Received: by 2002:a5d:6cad:: with SMTP id a13mr639387wra.275.1610058454893;
        Thu, 07 Jan 2021 14:27:34 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id h16sm9920371wrq.29.2021.01.07.14.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:34 -0800 (PST)
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
Subject: [PULL 54/66] target/mips: Extract LSA/DLSA translation generators
Date:   Thu,  7 Jan 2021 23:22:41 +0100
Message-Id: <20210107222253.20382-55-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract gen_lsa() from translate.c and explode it as
gen_LSA() and gen_DLSA().

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-22-f4bug@amsat.org>
---
 target/mips/translate.h            |  6 +++
 target/mips/translate.c            | 35 ++---------------
 target/mips/translate_addr_const.c | 61 ++++++++++++++++++++++++++++++
 target/mips/meson.build            |  1 +
 4 files changed, 72 insertions(+), 31 deletions(-)
 create mode 100644 target/mips/translate_addr_const.c

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 35e9c4cd135..50281c93369 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -129,6 +129,12 @@ void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg);
 void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg);
 int get_fp_bit(int cc);
 
+/*
+ * Address Computation and Large Constant Instructions
+ */
+bool gen_LSA(DisasContext *ctx, int rd, int rt, int rs, int sa);
+bool gen_DLSA(DisasContext *ctx, int rd, int rt, int rs, int sa);
+
 extern TCGv cpu_gpr[32], cpu_PC;
 extern TCGv_i32 fpu_fcr0, fpu_fcr31;
 extern TCGv_i64 fpu_f64[32];
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 3da12e31351..e9730d95131 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -6616,31 +6616,6 @@ static void gen_bshfl(DisasContext *ctx, uint32_t op2, int rt, int rd)
     tcg_temp_free(t0);
 }
 
-static void gen_lsa(DisasContext *ctx, int opc, int rd, int rs, int rt,
-                    int imm2)
-{
-    TCGv t0;
-    TCGv t1;
-    if (rd == 0) {
-        /* Treat as NOP. */
-        return;
-    }
-    t0 = tcg_temp_new();
-    t1 = tcg_temp_new();
-    gen_load_gpr(t0, rs);
-    gen_load_gpr(t1, rt);
-    tcg_gen_shli_tl(t0, t0, imm2 + 1);
-    tcg_gen_add_tl(cpu_gpr[rd], t0, t1);
-    if (opc == OPC_LSA) {
-        tcg_gen_ext32s_tl(cpu_gpr[rd], cpu_gpr[rd]);
-    }
-
-    tcg_temp_free(t1);
-    tcg_temp_free(t0);
-
-    return;
-}
-
 static void gen_align_bits(DisasContext *ctx, int wordsz, int rd, int rs,
                            int rt, int bits)
 {
@@ -16496,8 +16471,7 @@ static void decode_micromips32_opc(CPUMIPSState *env, DisasContext *ctx)
             return;
         case LSA:
             check_insn(ctx, ISA_MIPS_R6);
-            gen_lsa(ctx, OPC_LSA, rd, rs, rt,
-                    extract32(ctx->opcode, 9, 2));
+            gen_LSA(ctx, rd, rt, rs, extract32(ctx->opcode, 9, 2));
             break;
         case ALIGN:
             check_insn(ctx, ISA_MIPS_R6);
@@ -21460,8 +21434,7 @@ static int decode_nanomips_32_48_opc(CPUMIPSState *env, DisasContext *ctx)
                  * amount, meaning that the supported shift values are in
                  * the range 0 to 3 (instead of 1 to 4 in MIPSR6).
                  */
-                gen_lsa(ctx, OPC_LSA, rd, rs, rt,
-                        extract32(ctx->opcode, 9, 2) - 1);
+                gen_LSA(ctx, rd, rt, rs, extract32(ctx->opcode, 9, 2) - 1);
                 break;
             case NM_EXTW:
                 gen_ext(ctx, 32, rd, rs, rt, extract32(ctx->opcode, 6, 5));
@@ -24347,7 +24320,7 @@ static void decode_opc_special_r6(CPUMIPSState *env, DisasContext *ctx)
     op1 = MASK_SPECIAL(ctx->opcode);
     switch (op1) {
     case OPC_LSA:
-        gen_lsa(ctx, op1, rd, rs, rt, extract32(ctx->opcode, 6, 2));
+        gen_LSA(ctx, rd, rt, rs, extract32(ctx->opcode, 6, 2));
         break;
     case OPC_MULT:
     case OPC_MULTU:
@@ -24401,7 +24374,7 @@ static void decode_opc_special_r6(CPUMIPSState *env, DisasContext *ctx)
 #if defined(TARGET_MIPS64)
     case OPC_DLSA:
         check_mips_64(ctx);
-        gen_lsa(ctx, op1, rd, rs, rt, extract32(ctx->opcode, 6, 2));
+        gen_DLSA(ctx, rd, rt, rs, extract32(ctx->opcode, 6, 2));
         break;
     case R6_OPC_DCLO:
     case R6_OPC_DCLZ:
diff --git a/target/mips/translate_addr_const.c b/target/mips/translate_addr_const.c
new file mode 100644
index 00000000000..1c6f61c3dd2
--- /dev/null
+++ b/target/mips/translate_addr_const.c
@@ -0,0 +1,61 @@
+/*
+ * Address Computation and Large Constant Instructions
+ *
+ *  Copyright (c) 2004-2005 Jocelyn Mayer
+ *  Copyright (c) 2006 Marius Groeger (FPU operations)
+ *  Copyright (c) 2006 Thiemo Seufer (MIPS32R2 support)
+ *  Copyright (c) 2009 CodeSourcery (MIPS16 and microMIPS support)
+ *  Copyright (c) 2012 Jia Liu & Dongxue Zhang (MIPS ASE DSP support)
+ *  Copyright (c) 2020 Philippe Mathieu-Daudé
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+#include "qemu/osdep.h"
+#include "tcg/tcg-op.h"
+#include "translate.h"
+
+bool gen_LSA(DisasContext *ctx, int rd, int rt, int rs, int sa)
+{
+    TCGv t0;
+    TCGv t1;
+
+    if (rd == 0) {
+        /* Treat as NOP. */
+        return true;
+    }
+    t0 = tcg_temp_new();
+    t1 = tcg_temp_new();
+    gen_load_gpr(t0, rs);
+    gen_load_gpr(t1, rt);
+    tcg_gen_shli_tl(t0, t0, sa + 1);
+    tcg_gen_add_tl(cpu_gpr[rd], t0, t1);
+    tcg_gen_ext32s_tl(cpu_gpr[rd], cpu_gpr[rd]);
+
+    tcg_temp_free(t1);
+    tcg_temp_free(t0);
+
+    return true;
+}
+
+bool gen_DLSA(DisasContext *ctx, int rd, int rt, int rs, int sa)
+{
+    TCGv t0;
+    TCGv t1;
+
+    check_mips_64(ctx);
+
+    if (rd == 0) {
+        /* Treat as NOP. */
+        return true;
+    }
+    t0 = tcg_temp_new();
+    t1 = tcg_temp_new();
+    gen_load_gpr(t0, rs);
+    gen_load_gpr(t1, rt);
+    tcg_gen_shli_tl(t0, t0, sa + 1);
+    tcg_gen_add_tl(cpu_gpr[rd], t0, t1);
+    tcg_temp_free(t1);
+    tcg_temp_free(t0);
+
+    return true;
+}
diff --git a/target/mips/meson.build b/target/mips/meson.build
index e6285abd044..9afee0ca955 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -17,6 +17,7 @@
   'op_helper.c',
   'tlb_helper.c',
   'translate.c',
+  'translate_addr_const.c',
 ))
 mips_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
-- 
2.26.2

