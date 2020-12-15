Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A53B2DB6C7
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgLOXBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730585AbgLOXA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:00:29 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0208C0613D6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n26so30032948eju.6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ugX7vu8E1u5hECC/REMJKzNtvhnIJCt4SGmKDATm7G0=;
        b=B19fvyYF31auU1m7HeEgEY4427wbbGjGtpQR9PZ8ScXLyvFekkxTe98jsbXiPEJLf9
         MlP/1oUignkLt8kCih3uMMxB/GLcXfeuRzsQggqQsAb2/I/AtD8w+o5EVy38yOFtN2Yg
         uXqmY7eXMkhu5BcRiYyCJTjUoYXxSOSCRzGOJ04Y7KB48RP9vl9cEEOpasi8UZ6d7U65
         ogPx70l+fFIfRrnyPE0/7R9iAwigWInFpfo1b/r3KjUGhSbgQRDYqsYuYn4P4ak7xxT9
         gBZULq/2huNepteDMonXevcNmRN/mGT86c6LEUsM+Cpes2J/maQ1op3iVOl9oMY5U9Lj
         yQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ugX7vu8E1u5hECC/REMJKzNtvhnIJCt4SGmKDATm7G0=;
        b=nu0O8UtMvQtm8zN4uNDTYgGj+asAWDCkTndBwtAgwwJ/FK/lXsh0WG8uTiChreU2bR
         d3V4YwmaztNFgmBhBw89ETZTb2AENgnMrlgYRu++KWA+YuW1ojFDsF6juhIdj2JFOhrE
         LBbEMiVRTMzmigXBFZcLacLWil8FpT2Pd05YWdyqghs7dJ5g6YstvQM2GnfxtT6JiTCu
         U8BTJwZEaRcmjE+ii7olVx0F83c8uK2iJNBDBD7m41tSHdz6fePaRKhw0tEK9Z+oX/YD
         PoJ9jlTy02yVFsDq9SYYF2iJsJOaVZbBJm5CvWm+1EB1CuFW1Y2FIImniSYPr9mURS6Z
         mrsA==
X-Gm-Message-State: AOAM531kYD8fTKPxPYOk8ANDGeFTop7EX7pt+3ob3h0ojV9nzEGJw18L
        lRTbc64ICk6yjzFEVD8dj1o=
X-Google-Smtp-Source: ABdhPJwNLlkALJwGE7A5peSMRHL5rEpwGLTnyYq766LxGTdxyKRhuasqM41nOZ1u6Wg4GyjZOiq6+A==
X-Received: by 2002:a17:906:c254:: with SMTP id bl20mr7663991ejb.336.1608073187404;
        Tue, 15 Dec 2020 14:59:47 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id k3sm6045015eds.87.2020.12.15.14.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:59:46 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     Richard Henderson <richard.henderson@linaro.org>,
        qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v2 19/24] target/mips: Introduce decode tree bindings for MSA opcodes
Date:   Tue, 15 Dec 2020 23:57:52 +0100
Message-Id: <20201215225757.764263-20-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the 'mod-msa32' decodetree config for the 32-bit MSA ASE.

We decode the branch instructions, and all instructions based
on the MSA opcode.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h         |  3 +++
 target/mips/mod-msa32.decode    | 24 +++++++++++++++++++++
 target/mips/mod-msa_translate.c | 37 ++++++++++++++++++++++++++++++++-
 target/mips/translate.c         |  1 -
 target/mips/meson.build         |  5 +++++
 5 files changed, 68 insertions(+), 2 deletions(-)
 create mode 100644 target/mips/mod-msa32.decode

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 77dfec98792..7ca92bd6beb 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -166,4 +166,7 @@ void msa_translate_init(void);
 void gen_msa(DisasContext *ctx);
 void gen_msa_branch(DisasContext *ctx, uint32_t op1);
 
+/* decodetree generated */
+bool decode_ase_msa(DisasContext *ctx, uint32_t insn);
+
 #endif
diff --git a/target/mips/mod-msa32.decode b/target/mips/mod-msa32.decode
new file mode 100644
index 00000000000..d69675132b8
--- /dev/null
+++ b/target/mips/mod-msa32.decode
@@ -0,0 +1,24 @@
+# MIPS SIMD Architecture Module instruction set
+#
+# Copyright (C) 2020  Philippe Mathieu-Daudé
+#
+# SPDX-License-Identifier: LGPL-2.1-or-later
+#
+# Reference:
+#       MIPS Architecture for Programmers Volume IV-j
+#       The MIPS32 SIMD Architecture Module, Revision 1.12
+#       (Document Number: MD00866-2B-MSA32-AFP-01.12)
+#
+
+&msa_bz             df wt s16
+
+@bz                 ...... ... ..   wt:5 s16:16             &msa_bz df=3
+@bz_df              ...... ... df:2 wt:5 s16:16             &msa_bz
+
+BZ_V                010001 01011  ..... ................    @bz
+BNZ_V               010001 01111  ..... ................    @bz
+
+BZ_x                010001 110 .. ..... ................    @bz_df
+BNZ_x               010001 111 .. ..... ................    @bz_df
+
+MSA                 011110 --------------------------
diff --git a/target/mips/mod-msa_translate.c b/target/mips/mod-msa_translate.c
index 63feedcb7ca..d0e393a6831 100644
--- a/target/mips/mod-msa_translate.c
+++ b/target/mips/mod-msa_translate.c
@@ -6,6 +6,7 @@
  *  Copyright (c) 2006 Thiemo Seufer (MIPS32R2 support)
  *  Copyright (c) 2009 CodeSourcery (MIPS16 and microMIPS support)
  *  Copyright (c) 2012 Jia Liu & Dongxue Zhang (MIPS ASE DSP support)
+ *  Copyright (c) 2020 Philippe Mathieu-Daudé
  *
  * SPDX-License-Identifier: LGPL-2.1-or-later
  */
@@ -13,10 +14,12 @@
 #include "tcg/tcg-op.h"
 #include "exec/helper-gen.h"
 #include "translate.h"
-#include "fpu_translate.h"
 #include "fpu_helper.h"
 #include "internal.h"
 
+/* Include the auto-generated decoder.  */
+#include "decode-mod-msa32.c.inc"
+
 #define OPC_MSA (0x1E << 26)
 
 #define MASK_MSA_MINOR(op)          (MASK_OP_MAJOR(op) | (op & 0x3F))
@@ -370,6 +373,16 @@ static bool gen_msa_BxZ_V(DisasContext *ctx, int wt, int s16, TCGCond cond)
     return true;
 }
 
+static bool trans_BZ_V(DisasContext *ctx, arg_msa_bz *a)
+{
+    return gen_msa_BxZ_V(ctx, a->wt, a->s16, TCG_COND_EQ);
+}
+
+static bool trans_BNZ_V(DisasContext *ctx, arg_msa_bz *a)
+{
+    return gen_msa_BxZ_V(ctx, a->wt, a->s16, TCG_COND_NE);
+}
+
 static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
 {
     check_msa_access(ctx);
@@ -391,6 +404,16 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
     return true;
 }
 
+static bool trans_BZ_x(DisasContext *ctx, arg_msa_bz *a)
+{
+    return gen_msa_BxZ(ctx, a->df, a->wt, a->s16, false);
+}
+
+static bool trans_BNZ_x(DisasContext *ctx, arg_msa_bz *a)
+{
+    return gen_msa_BxZ(ctx, a->df, a->wt, a->s16, true);
+}
+
 void gen_msa_branch(DisasContext *ctx, uint32_t op1)
 {
     uint8_t df = (ctx->opcode >> 21) & 0x3;
@@ -2264,3 +2287,15 @@ void gen_msa(DisasContext *ctx)
         break;
     }
 }
+
+static bool trans_MSA(DisasContext *ctx, arg_MSA *a)
+{
+    gen_msa(ctx);
+
+    return true;
+}
+
+bool decode_ase_msa(DisasContext *ctx, uint32_t insn)
+{
+    return decode_msa32(ctx, insn);
+}
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 1e20d426388..f36255f073a 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -2190,7 +2190,6 @@ static TCGv cpu_lladdr, cpu_llval;
 static TCGv_i32 hflags;
 TCGv_i32 fpu_fcr0, fpu_fcr31;
 TCGv_i64 fpu_f64[32];
-static TCGv_i64 msa_wr_d[64];
 
 #if defined(TARGET_MIPS64)
 /* Upper halves of R5900's 128-bit registers: MMRs (multimedia registers) */
diff --git a/target/mips/meson.build b/target/mips/meson.build
index 41c3fe7c5bb..5ccc9ddc6b8 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,4 +1,9 @@
+gen = [
+  decodetree.process('mod-msa32.decode', extra_args: [ '--static-decode=decode_msa32' ]),
+]
+
 mips_ss = ss.source_set()
+mips_ss.add(gen)
 mips_ss.add(files(
   'cpu.c',
   'gdbstub.c',
-- 
2.26.2

