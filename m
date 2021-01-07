Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3432EE89D
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbhAGW1l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbhAGW1l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:41 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D92C0612F4
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:25 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id r3so7145524wrt.2
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gjB8bSNOV3jK0kQvU1bZejwEpXnNKlR5+WxJ3oM/DJ4=;
        b=PU3XqAa4BYeNMoZIxAy6I2AgQiJaVnK77ogvCg+xEnqHGMYT44Q8XQqLMuQZS3OMc4
         BH6ydZ3jiPQFw4w7ujUAneoJXDGAymLsiFy/d8Kuuy04v7pHsGgApouhSmlEVRL7V7+x
         v0KPqIqs7GQafgcS7X7K0cF4btSwTJ1sNiwTocQtPO7ZJ2YlxS/CfltLzu80U1+2LbzW
         bMXNEv13zSCP/C4dfhE+sVwSXs+9O2JKT+tPXRpzGh2pEr08ug/d6jQmFqgqFEDUnbq/
         upTfXilz8SEwUQ9ROf2eIscQ5OB9g2i/FJvodHKkPn4w4mqQdL+8R1mVJXOtLuabEiFH
         UzLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=gjB8bSNOV3jK0kQvU1bZejwEpXnNKlR5+WxJ3oM/DJ4=;
        b=JmKKdfNIE3VFOzzescEUlznEJXS97/t1uggvEOpjBd9Y6x1LEdfF8OiBvONkzRmbjb
         juYzSiXYqIk1SCgd7MKVLHgOVES8G3L3TK42nW195PMUuUQaaVSyHv2NHqH/GtQSluer
         EDbEceJvzsIdy2zz+IWDql/PDcG930V+ZYzOcGjL06k4aM57eJu1JGHEoNfplX46EnFl
         OK39VOuGVwXedACEDpUscukIOsFqfKUeMNZSj3cASiwF2583m9Y6SUs7aaPSm4CtDsId
         ViVqxjPMa0owsq6qVY7rhO1Niv/lqnzKp2VYfiKfRDB6qxu/OXoH5Pfw4LR3BoHmj5Va
         ovJA==
X-Gm-Message-State: AOAM531DeUTa/LpaQolxLd+DNHDHFo4gSSanaaltXUHmFcPv7jED7Iyq
        TAnXOZcIQENAVSpui4ZxO5c=
X-Google-Smtp-Source: ABdhPJz2mhf6HC/yzYIQFD2jHFGCi1FU5ZgTRDBf8Mb3coydjvfxWtxN8gwuIWOi82ze45o+vViPiw==
X-Received: by 2002:a5d:6983:: with SMTP id g3mr705027wru.168.1610058444739;
        Thu, 07 Jan 2021 14:27:24 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id x18sm11886030wrg.55.2021.01.07.14.27.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:24 -0800 (PST)
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
Subject: [PULL 52/66] target/mips: Introduce decode tree bindings for MSA ASE
Date:   Thu,  7 Jan 2021 23:22:39 +0100
Message-Id: <20210107222253.20382-53-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the 'msa32' decodetree config for the 32-bit MSA ASE.

We start by decoding:
- the branch instructions,
- all instructions based on the MSA opcode.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-20-f4bug@amsat.org>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
---
 target/mips/translate.h     |  3 +++
 target/mips/msa32.decode    | 24 ++++++++++++++++++++++++
 target/mips/msa_translate.c | 36 ++++++++++++++++++++++++++++++++++++
 target/mips/meson.build     |  5 +++++
 4 files changed, 68 insertions(+)
 create mode 100644 target/mips/msa32.decode

diff --git a/target/mips/translate.h b/target/mips/translate.h
index c61c11978c2..858e47cf833 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -167,4 +167,7 @@ void msa_translate_init(void);
 void gen_msa(DisasContext *ctx);
 void gen_msa_branch(DisasContext *ctx, uint32_t op1);
 
+/* decodetree generated */
+bool decode_ase_msa(DisasContext *ctx, uint32_t insn);
+
 #endif
diff --git a/target/mips/msa32.decode b/target/mips/msa32.decode
new file mode 100644
index 00000000000..d69675132b8
--- /dev/null
+++ b/target/mips/msa32.decode
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
diff --git a/target/mips/msa_translate.c b/target/mips/msa_translate.c
index 52bd428759a..5efb0a1fc8a 100644
--- a/target/mips/msa_translate.c
+++ b/target/mips/msa_translate.c
@@ -6,6 +6,7 @@
  *  Copyright (c) 2006 Thiemo Seufer (MIPS32R2 support)
  *  Copyright (c) 2009 CodeSourcery (MIPS16 and microMIPS support)
  *  Copyright (c) 2012 Jia Liu & Dongxue Zhang (MIPS ASE DSP support)
+ *  Copyright (c) 2020 Philippe Mathieu-Daudé
  *
  * SPDX-License-Identifier: LGPL-2.1-or-later
  */
@@ -16,6 +17,9 @@
 #include "fpu_helper.h"
 #include "internal.h"
 
+/* Include the auto-generated decoder.  */
+#include "decode-msa32.c.inc"
+
 #define OPC_MSA (0x1E << 26)
 
 #define MASK_MSA_MINOR(op)          (MASK_OP_MAJOR(op) | (op & 0x3F))
@@ -370,6 +374,16 @@ static bool gen_msa_BxZ_V(DisasContext *ctx, int wt, int s16, TCGCond cond)
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
@@ -388,6 +402,16 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
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
@@ -2261,3 +2285,15 @@ void gen_msa(DisasContext *ctx)
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
diff --git a/target/mips/meson.build b/target/mips/meson.build
index 2aa4d81300b..e6285abd044 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,4 +1,9 @@
+gen = [
+  decodetree.process('msa32.decode', extra_args: [ '--static-decode=decode_msa32' ]),
+]
+
 mips_ss = ss.source_set()
+mips_ss.add(gen)
 mips_ss.add(files(
   'cpu.c',
   'gdbstub.c',
-- 
2.26.2

