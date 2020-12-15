Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948832DB6C8
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730627AbgLOXBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 18:01:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730644AbgLOXAq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 18:00:46 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCC4C06179C
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:00:05 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id v22so22800724edt.9
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 15:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qhCr51gZzmCyhfb9yAybvFXb3H9tr37qgZdUgiwOt1k=;
        b=DU0zSBFj/RMVXWs8OhS0o+DuJ6AcJiRFIB8npmjbOIkvcNs3XsVXLPX1qOB/uVGfLT
         ZW38qaWpj7Xs0kAkp81wUSK7F+PF88TlKDKF1A5wmUiTCE+Uu+aWba0eT1nyvonOi11u
         iMpCecYUP6ZbZGuKJwvQe+5QJt91nRUUGf09Z5zT5HWsDTfm7jbjwNws6ZUa5bEWjYuy
         DHExeNr6sHkQJFwVCLD7V9drOYr6O4KpF5DxUDW8vdlZAyuwALeTuzCBkFAkFkuPQEwN
         kbhKYAs6zlQnQitEi0j/OULmfJWmsEFSrDx26MrVl3621TQDCLp2/x8JKEpMh+9gicqS
         N+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=qhCr51gZzmCyhfb9yAybvFXb3H9tr37qgZdUgiwOt1k=;
        b=NwfsGpDnBXX+uJ/sasEGE7v8gMz0+IiqX1gbmQlY0N5PBopzm1HPjMrk7cCmimFTUK
         9HzEMZ3jiV3XpqVRKbyoqXYzKGKEpCvx0njQs073U/erKurhZ2d3c36rj/LKlv5Qu3nm
         1wpL8WevxOXCm/ve9qE/Or2q5H8QCfthCTg6419RiIYq0od0sRjGcXh8cnpYNRx1G0EG
         c74pB7MvGNbY8rdxdINFbpX/5r4n5TM14JBFEm/xzQCL5DsFl5I+lkELhJwxIlmp/aVt
         QzJAt9/sR3aaU8zGBg+9W7beTGIdlAA1hoq7nOUP20lzBMFQfO8bVnHGqJ+R7XNFgSc+
         TExw==
X-Gm-Message-State: AOAM5325Pfi2IdHTzXYtfCjQ0Ceqd3HPtQt7Wt5jZuAsqcvVG5Ps3U8O
        Vct5VOAsiMrR/xdzZGW9Vv0=
X-Google-Smtp-Source: ABdhPJwAw/3qzdrXTqpeeUEUWGq0bTt6nV1n5heKOXy582bqGD3WN1pilgWUPaMuIGw9eYMAorR4Aw==
X-Received: by 2002:aa7:d94e:: with SMTP id l14mr4310053eds.98.1608073203992;
        Tue, 15 Dec 2020 15:00:03 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id v16sm19120925eds.64.2020.12.15.15.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:00:03 -0800 (PST)
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
Subject: [PATCH v2 22/24] target/mips: Introduce decodetree helpers for MSA LSA/DLSA opcodes
Date:   Tue, 15 Dec 2020 23:57:55 +0100
Message-Id: <20201215225757.764263-23-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the LSA opcode to the MSA32 decodetree config, add DLSA
to a new config for the MSA64 ASE, and call decode_msa64()
in the main decode_opc() loop.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/mod-msa32.decode    |  4 ++++
 target/mips/mod-msa64.decode    | 17 +++++++++++++++++
 target/mips/mod-msa_translate.c | 14 ++++++++++++++
 target/mips/meson.build         |  2 ++
 4 files changed, 37 insertions(+)
 create mode 100644 target/mips/mod-msa64.decode

diff --git a/target/mips/mod-msa32.decode b/target/mips/mod-msa32.decode
index d69675132b8..0b2f0863251 100644
--- a/target/mips/mod-msa32.decode
+++ b/target/mips/mod-msa32.decode
@@ -10,11 +10,15 @@
 #       (Document Number: MD00866-2B-MSA32-AFP-01.12)
 #
 
+&lsa                rd rt rs sa
 &msa_bz             df wt s16
 
+@lsa                ...... rs:5 rt:5 rd:5 ... sa:2 ......   &lsa
 @bz                 ...... ... ..   wt:5 s16:16             &msa_bz df=3
 @bz_df              ...... ... df:2 wt:5 s16:16             &msa_bz
 
+LSA                 000000 ..... ..... ..... 000 .. 000101  @lsa
+
 BZ_V                010001 01011  ..... ................    @bz
 BNZ_V               010001 01111  ..... ................    @bz
 
diff --git a/target/mips/mod-msa64.decode b/target/mips/mod-msa64.decode
new file mode 100644
index 00000000000..8dcbbcd8538
--- /dev/null
+++ b/target/mips/mod-msa64.decode
@@ -0,0 +1,17 @@
+# MIPS SIMD Architecture Module instruction set
+#
+# Copyright (C) 2020  Philippe Mathieu-Daudé
+#
+# SPDX-License-Identifier: LGPL-2.1-or-later
+#
+# Reference:
+#       MIPS Architecture for Programmers Volume IV-j
+#       The MIPS64 SIMD Architecture Module, Revision 1.12
+#       (Document Number: MD00868-1D-MSA64-AFP-01.12)
+#
+
+&lsa                rd rt rs sa !extern
+
+@lsa                ...... rs:5 rt:5 rd:5 ... sa:2 ......   &lsa
+
+DLSA                 000000 ..... ..... ..... 000 .. 010101 @lsa
diff --git a/target/mips/mod-msa_translate.c b/target/mips/mod-msa_translate.c
index d1a8a95e62e..f139ba784dc 100644
--- a/target/mips/mod-msa_translate.c
+++ b/target/mips/mod-msa_translate.c
@@ -19,6 +19,7 @@
 
 /* Include the auto-generated decoder.  */
 #include "decode-mod-msa32.c.inc"
+#include "decode-mod-msa64.c.inc"
 
 #define OPC_MSA (0x1E << 26)
 
@@ -2268,7 +2269,20 @@ static bool trans_MSA(DisasContext *ctx, arg_MSA *a)
     return true;
 }
 
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
 bool decode_ase_msa(DisasContext *ctx, uint32_t insn)
 {
+    if (TARGET_LONG_BITS == 64 && decode_msa64(ctx, insn)) {
+        return true;
+    }
     return decode_msa32(ctx, insn);
 }
diff --git a/target/mips/meson.build b/target/mips/meson.build
index dce0ca96527..8e2e5fa40b8 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,5 +1,6 @@
 gen = [
   decodetree.process('mod-msa32.decode', extra_args: [ '--static-decode=decode_msa32' ]),
+  decodetree.process('mod-msa64.decode', extra_args: [ '--static-decode=decode_msa64' ]),
 ]
 
 mips_ss = ss.source_set()
@@ -19,6 +20,7 @@
   'translate_addr_const.c',
   'mod-msa_translate.c',
 ))
+
 mips_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
 mips_softmmu_ss = ss.source_set()
-- 
2.26.2

