Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF5302D1F20
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728480AbgLHAjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:39:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgLHAjL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:39:11 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3233AC0611CC
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:38:31 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qw4so22146747ejb.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x3EHUPkL70HlyKVB+n5bDV2NTA2TeWYMrsf4zc9uRWc=;
        b=tazcftDdhrH5Siz3vGPCkHIw5jTrupE0v8r0/N+j1BdLFSfuGPwZv/t5NCx7BWXmaz
         pzqAgixJPmxmKf9xisHP3PHOVYHXU72hIJNxpETgpYFU+kjrnF0/Xcw21gnfSO2AlcWX
         dE7+Do5RAUfQ+AV0+rrFcbRV9J03t8+v+hNJLXuYQRDIYyMvJc2xuZW26u3SXHbWMge6
         i3BXYrH7QweNGMhM0kdb6+3LL6flma+xWsugezogcadlwvWWs36zDyqvFj7EMUXRrK/3
         xCbI6ZV6irdeZUJtjR36PHnr+waw8IW3QOGM9m7OezCK0TNFwgTw4pmtmGb/KVcSctUe
         nC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=x3EHUPkL70HlyKVB+n5bDV2NTA2TeWYMrsf4zc9uRWc=;
        b=cf7wSBTGXNP/ZLGpIXnowIBADZtGi9+IdiiU5ITkfBCFTcEvK6fWWQIIlFiQGnJglY
         V+uiDUrAaIwMamV296lnLp9CPiXnaxQ8usr7ccEX7yT5j26zhhm0meM/h9zFub0bQfUM
         5ej/Ygq1VYU9pDHa0peEAGrhWMkR9xMsYmc06Eq/Efy5zFr6a1iT9IxFtZsXUq8VR231
         MMsRke/O/xuGlI0OCgxyS8UPL6vXnW/opA3jAtYjOyJezVVImDeAuv115K3SMmGoYcaq
         ISeB1iFgqwWgr1bTSdqwAWhc4GgBdPUZ1I1kfDcRnCU9QMag+yjHbZtu8F6KVOeFRFsV
         HZuA==
X-Gm-Message-State: AOAM533o4IfQAw97WYmLbl+wKbk/MJ5giVFQAERyMW18ynek1Hdsjjgj
        620LjQTII6WHnRcdBjeya04=
X-Google-Smtp-Source: ABdhPJy9vmqIycYCXzmH4+3/R4YJU0CpD/y+Mx6BvObtS63jSrNwW1BfO7jCjPNhnnEx8gI4kz5l/w==
X-Received: by 2002:a17:906:9acc:: with SMTP id ah12mr17761833ejc.386.1607387909940;
        Mon, 07 Dec 2020 16:38:29 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id ng1sm13094570ejb.112.2020.12.07.16.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:38:29 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 16/17] target/mips: Introduce decode tree bindings for MSA opcodes
Date:   Tue,  8 Dec 2020 01:37:01 +0100
Message-Id: <20201208003702.4088927-17-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
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
 target/mips/translate.h         |  1 +
 target/mips/mod-msa32.decode    | 24 ++++++++++++++++++++++++
 target/mips/mod-msa_translate.c | 31 +++++++++++++++++++++++++++++++
 target/mips/meson.build         |  5 +++++
 4 files changed, 61 insertions(+)
 create mode 100644 target/mips/mod-msa32.decode

diff --git a/target/mips/translate.h b/target/mips/translate.h
index c26b0d9155d..c4fe18d187e 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -84,5 +84,6 @@ extern TCGv bcond;
 void msa_translate_init(void);
 void gen_msa(DisasContext *ctx);
 void gen_msa_branch(DisasContext *ctx, uint32_t op1);
+bool decode_msa32(DisasContext *ctx, uint32_t insn);
 
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
index 55c2a2f1acc..02df39c6b6c 100644
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
@@ -17,6 +18,9 @@
 #include "fpu_helper.h"
 #include "internal.h"
 
+/* Include the auto-generated decoder.  */
+#include "decode-mod-msa32.c.inc"
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
@@ -391,6 +405,16 @@ static bool gen_msa_BxZ(DisasContext *ctx, int df, int wt, int s16, bool if_not)
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
@@ -2264,3 +2288,10 @@ void gen_msa(DisasContext *ctx)
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
diff --git a/target/mips/meson.build b/target/mips/meson.build
index b6697e2fd72..7d0414bbe23 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,4 +1,9 @@
+gen = [
+  decodetree.process('mod-msa32.decode', extra_args: [ '--decode=decode_msa32' ]),
+]
+
 mips_ss = ss.source_set()
+mips_ss.add(gen)
 mips_ss.add(files(
   'cpu.c',
   'dsp_helper.c',
-- 
2.26.2

