Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 940212EE8A4
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728650AbhAGW21 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbhAGW20 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:26 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A95C0612F8
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:46 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id d13so7074204wrc.13
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6z86y274+C7xcqFi/N79ZkHJjYYrdiH8WHVp+WKoviw=;
        b=uAZJuAqMkllQrDsX4nqlkrU8Zg8x3UjM+OgNNBVR4QmmaHScOqdeMJekk7Ngsa5czr
         FLoqi6FvROm/AQm0m97Ha3v7RG2n07jsRrJ4YKJrhNJdvO8Fhj29/NEHBrr2FLPcKLhG
         KggXA8Z4oj9RArPyrxA/7nU6b+zKcGhpsP0y7m4aIIcH0iZQY84xPVrawno0eBsQ9qKL
         I3bI6dBJMzTZ4O+GWDjqPGRUWTCmRX03nCptX8NG8pJ62YCw8zHLyBz4/SEf1peBhRnr
         Uc9TnQj0chhf/il1UeibVhUwUP1dhjduUb6Yh8g1gGeygwQxvFBPESMWfAZQXAl5g6vf
         6avw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=6z86y274+C7xcqFi/N79ZkHJjYYrdiH8WHVp+WKoviw=;
        b=gcdspGZscu5Gb4eyQlhbi71xhvghYZOcw21ivZuUH8Lz87eaxenqUcy4i+ZSTKwCsP
         yjqiM+gZ10gLDSjbo9Cwhg0CsexmwnAiPMm3RqPn5hDkkUDo1WexwVfgS2CTnXtwstWR
         B63l3Hawu2uJebZUHfL6o0lG1GnOOoY6kPVHs85rPkn9BE2hfs+5yKQTApr99iVNdjg0
         R0FvCtBKMgMzkad8g/lQIfEwc6d+1Xd5A2vlbF2hf7iDdSXSf4EvrwYhbciZ4z3Meutv
         ZOMlq29sli3bQAsgfwsLK94S4AndIp/C1lWC8xRcDl01XwTwVSXLmFvLSEThtwidfXA6
         4Yow==
X-Gm-Message-State: AOAM533NFDhYi2XZulUYEgRD0FYqiale9PFAJ5/HvH1xQIl9NIsyVtuT
        gfF+LxV4sL0H0uNhmqTQ/XM=
X-Google-Smtp-Source: ABdhPJyL6kNVJRlZ5scQksDQQqnFk6VuaNfLcIavVG3srQbvSUfFrJCIe0JFD6edKv135PKwSec01w==
X-Received: by 2002:a05:6000:1811:: with SMTP id m17mr660527wrh.67.1610058464943;
        Thu, 07 Jan 2021 14:27:44 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id m2sm9138739wml.34.2021.01.07.14.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:44 -0800 (PST)
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
Subject: [PULL 56/66] target/mips: Introduce decodetree helpers for Release6 LSA/DLSA opcodes
Date:   Thu,  7 Jan 2021 23:22:43 +0100
Message-Id: <20210107222253.20382-57-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-24-f4bug@amsat.org>
---
 target/mips/translate.h      |  1 +
 target/mips/mips32r6.decode  | 17 +++++++++++++++++
 target/mips/mips64r6.decode  | 17 +++++++++++++++++
 target/mips/rel6_translate.c | 37 ++++++++++++++++++++++++++++++++++++
 target/mips/translate.c      |  5 +++++
 target/mips/meson.build      |  3 +++
 6 files changed, 80 insertions(+)
 create mode 100644 target/mips/mips32r6.decode
 create mode 100644 target/mips/mips64r6.decode
 create mode 100644 target/mips/rel6_translate.c

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 50281c93369..11730f5b2e6 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -162,6 +162,7 @@ extern TCGv bcond;
 void msa_translate_init(void);
 
 /* decodetree generated */
+bool decode_isa_rel6(DisasContext *ctx, uint32_t insn);
 bool decode_ase_msa(DisasContext *ctx, uint32_t insn);
 
 #endif
diff --git a/target/mips/mips32r6.decode b/target/mips/mips32r6.decode
new file mode 100644
index 00000000000..027585ee042
--- /dev/null
+++ b/target/mips/mips32r6.decode
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
diff --git a/target/mips/mips64r6.decode b/target/mips/mips64r6.decode
new file mode 100644
index 00000000000..e812224341e
--- /dev/null
+++ b/target/mips/mips64r6.decode
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
diff --git a/target/mips/rel6_translate.c b/target/mips/rel6_translate.c
new file mode 100644
index 00000000000..631d0b87748
--- /dev/null
+++ b/target/mips/rel6_translate.c
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
+#include "decode-mips32r6.c.inc"
+#include "decode-mips64r6.c.inc"
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
index e9730d95131..cd34b06faae 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -29027,6 +29027,11 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         return;
     }
 
+    /* ISA (from latest to oldest) */
+    if (cpu_supports_isa(env, ISA_MIPS_R6) && decode_isa_rel6(ctx, ctx->opcode)) {
+        return;
+    }
+
     if (!decode_opc_legacy(env, ctx)) {
         gen_reserved_instruction(ctx);
     }
diff --git a/target/mips/meson.build b/target/mips/meson.build
index 21b75254047..ab01123013a 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,4 +1,6 @@
 gen = [
+  decodetree.process('mips32r6.decode', extra_args: [ '--static-decode=decode_mips32r6' ]),
+  decodetree.process('mips64r6.decode', extra_args: [ '--static-decode=decode_mips64r6' ]),
   decodetree.process('msa32.decode', extra_args: [ '--static-decode=decode_msa32' ]),
   decodetree.process('msa64.decode', extra_args: [ '--static-decode=decode_msa64' ]),
 ]
@@ -16,6 +18,7 @@
   'msa_helper.c',
   'msa_translate.c',
   'op_helper.c',
+  'rel6_translate.c',
   'tlb_helper.c',
   'translate.c',
   'translate_addr_const.c',
-- 
2.26.2

