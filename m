Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A172DB6CA
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730663AbgLOXBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgLOXAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:00:50 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D38EC0617A6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:00:10 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id g20so30083101ejb.1
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:00:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4FByo0luaRsj+aLeL9XTS/vkQm9Li61qyHi3C9wh89E=;
        b=qbkqTfIDUlwvWOW7Gd7einDqrUc20NC6J69WdA//sX2fo8TGhuEXTmkdAH/RZtkQTb
         MytpnmKRDJ2G3biodDRUNJsm4o2wsUZKKPfrOp9aA2U7ePCJq2nogPiRf7NwhgSC6J5I
         VxoQxzii3zg6w0RPO8fKylTunHuMfAnetvaZD1PE/CPBNe7y9IXnzT1oSIXiMWZK7hyZ
         jTPN568DPQA2XPrg5MRhen2iiHE7wvPlKAtrsO45gOHgbHTnLSpgQzFsYUHNwwRNe4CY
         t7fEqmVjRymZegCRGsKFl6xLMw0pDtbWoJuNd66Y2EkTqcUQAAyDLxkfgy9MQpH/4b93
         yQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=4FByo0luaRsj+aLeL9XTS/vkQm9Li61qyHi3C9wh89E=;
        b=Ke4yFMEW0wo+1UxjFr/by5HwDNcNVilm6+rEKhP57ubNbPM5IDpw4v6htIkU9mmWin
         GZTh62eifvQHX6jMYaq7nIpmqIAeqr1YskVr5dlCpsXLaIyrxl4R5S/0ygCdFA+CSU13
         9d4zqAF8lFyBWcGvDgTmwPAjCsdalI51E8Akbck2JO/bj4bC5tV/fHMbH+uPaTCHIsJL
         rW2s/uneQXeCJfg360iEvY6vMzOItM2L5usszBgQj01Guwgz82u2mYJ6mgrGzfMoOyyS
         xqhNoVhTAcfM6XVuHPManGRi5u30TRdMV1m0SIwfEUU9ioUU0t/qA10kbLyDMPRd8+XX
         9myA==
X-Gm-Message-State: AOAM532YQQOUAI6G8menoYBH3H0z/KFvQGsfMDyivC/ufN6R33c4t03y
        w8GPlIbb2lXGOVYBqvNZNL0=
X-Google-Smtp-Source: ABdhPJwDVfUkiC184zELa5kw8x1BW2v7eil7oduSJGx+lW/j20b1aOWUnA0EMRSvgjtAUsGKyYriMg==
X-Received: by 2002:a17:906:b793:: with SMTP id dt19mr28515625ejb.120.1608073209280;
        Tue, 15 Dec 2020 15:00:09 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h15sm19497149edz.95.2020.12.15.15.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:00:08 -0800 (PST)
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
Subject: [PATCH v2 23/24] target/mips: Introduce decodetree helpers for Release6 LSA/DLSA opcodes
Date:   Tue, 15 Dec 2020 23:57:56 +0100
Message-Id: <20201215225757.764263-24-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

LSA and LDSA opcodes are also available with MIPS release 6.
Introduce the decodetree config files and call the decode()
helpers in the main decode_opc() loop.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h               |  1 +
 target/mips/isa-mips32r6.decode       | 17 ++++++++++++
 target/mips/isa-mips64r6.decode       | 17 ++++++++++++
 target/mips/isa-mips_rel6_translate.c | 37 +++++++++++++++++++++++++++
 target/mips/translate.c               |  5 ++++
 target/mips/meson.build               |  3 +++
 6 files changed, 80 insertions(+)
 create mode 100644 target/mips/isa-mips32r6.decode
 create mode 100644 target/mips/isa-mips64r6.decode
 create mode 100644 target/mips/isa-mips_rel6_translate.c

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 47129de81d9..cbaef53b958 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -161,6 +161,7 @@ extern TCGv bcond;
 void msa_translate_init(void);
 
 /* decodetree generated */
+bool decode_isa_rel6(DisasContext *ctx, uint32_t insn);
 bool decode_ase_msa(DisasContext *ctx, uint32_t insn);
 
 #endif
diff --git a/target/mips/isa-mips32r6.decode b/target/mips/isa-mips32r6.decode
new file mode 100644
index 00000000000..027585ee042
--- /dev/null
+++ b/target/mips/isa-mips32r6.decode
@@ -0,0 +1,17 @@
+# MIPS32 Release 6 instruction set
+#
+# Copyright (C) 2020  Philippe Mathieu-Daudé
+#
+# SPDX-License-Identifier: LGPL-2.1-or-later
+#
+# Reference:
+#       MIPS Architecture for Programmers Volume II-A
+#       The MIPS32 Instruction Set Reference Manual, Revision 6.06
+#       (Document Number: MD00086-2B-MIPS32BIS-AFP-06.06)
+#
+
+&lsa                rd rt rs sa
+
+@lsa                ...... rs:5 rt:5 rd:5 ... sa:2 ......   &lsa
+
+LSA                 000000 ..... ..... ..... 000 .. 000101  @lsa
diff --git a/target/mips/isa-mips64r6.decode b/target/mips/isa-mips64r6.decode
new file mode 100644
index 00000000000..e812224341e
--- /dev/null
+++ b/target/mips/isa-mips64r6.decode
@@ -0,0 +1,17 @@
+# MIPS64 Release 6 instruction set
+#
+# Copyright (C) 2020  Philippe Mathieu-Daudé
+#
+# SPDX-License-Identifier: LGPL-2.1-or-later
+#
+# Reference:
+#       MIPS Architecture for Programmers Volume II-A
+#       The MIPS64 Instruction Set Reference Manual, Revision 6.06
+#       (Document Number: MD00087-2B-MIPS64BIS-AFP-6.06)
+#
+
+&lsa                rd rt rs sa !extern
+
+@lsa                ...... rs:5 rt:5 rd:5 ... sa:2 ......   &lsa
+
+DLSA                000000 ..... ..... ..... 000 .. 010101  @lsa
diff --git a/target/mips/isa-mips_rel6_translate.c b/target/mips/isa-mips_rel6_translate.c
new file mode 100644
index 00000000000..d5872bbf8fc
--- /dev/null
+++ b/target/mips/isa-mips_rel6_translate.c
@@ -0,0 +1,37 @@
+/*
+ *  MIPS emulation for QEMU - # Release 6 translation routines
+ *
+ *  Copyright (c) 2004-2005 Jocelyn Mayer
+ *  Copyright (c) 2006 Marius Groeger (FPU operations)
+ *  Copyright (c) 2006 Thiemo Seufer (MIPS32R2 support)
+ *  Copyright (c) 2020 Philippe Mathieu-Daudé
+ *
+ * This code is licensed under the GNU GPLv2 and later.
+ */
+
+#include "qemu/osdep.h"
+#include "tcg/tcg-op.h"
+#include "exec/helper-gen.h"
+#include "translate.h"
+
+/* Include the auto-generated decoder.  */
+#include "decode-isa-mips32r6.c.inc"
+#include "decode-isa-mips64r6.c.inc"
+
+static bool trans_LSA(DisasContext *ctx, arg_LSA *a)
+{
+    return gen_LSA(ctx, a->rd, a->rt, a->rs, a->sa);
+}
+
+static bool trans_DLSA(DisasContext *ctx, arg_LSA *a)
+{
+    return gen_DLSA(ctx, a->rd, a->rt, a->rs, a->sa);
+}
+
+bool decode_isa_rel6(DisasContext *ctx, uint32_t insn)
+{
+    if (TARGET_LONG_BITS == 64 && decode_mips64r6(ctx, insn)) {
+        return true;
+    }
+    return decode_mips32r6(ctx, insn);
+}
diff --git a/target/mips/translate.c b/target/mips/translate.c
index e0439ba92d8..125b2aac848 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -29027,6 +29027,11 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         return;
     }
 
+    /* ISA */
+    if (isa_rel6_available(env) && decode_isa_rel6(ctx, ctx->opcode)) {
+        return;
+    }
+
     if (!decode_opc_legacy(env, ctx)) {
         gen_reserved_instruction(ctx);
     }
diff --git a/target/mips/meson.build b/target/mips/meson.build
index 8e2e5fa40b8..2d62288d604 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,4 +1,6 @@
 gen = [
+  decodetree.process('isa-mips32r6.decode', extra_args: [ '--static-decode=decode_mips32r6' ]),
+  decodetree.process('isa-mips64r6.decode', extra_args: [ '--static-decode=decode_mips64r6' ]),
   decodetree.process('mod-msa32.decode', extra_args: [ '--static-decode=decode_msa32' ]),
   decodetree.process('mod-msa64.decode', extra_args: [ '--static-decode=decode_msa64' ]),
 ]
@@ -12,6 +14,7 @@
 mips_ss.add(when: 'CONFIG_TCG', if_true: files(
   'dsp_helper.c',
   'fpu_helper.c',
+  'isa-mips_rel6_translate.c',
   'lmmi_helper.c',
   'op_helper.c',
   'mod-msa_helper.c',
-- 
2.26.2

