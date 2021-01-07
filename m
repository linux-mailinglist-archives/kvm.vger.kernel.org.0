Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7732EE89E
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbhAGW15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728686AbhAGW14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:56 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DA8EC0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:41 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id k10so6364759wmi.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXnJoY5COKKqaViQrzHGXO3P7g2CyIkmu5oDvOAw7V8=;
        b=O1qK4uUowbfAgF0pV9XHWYIIQaO0chpA4tklBN1Up+BJAoLZE0wIKBO2VDRscoKz56
         jP19Q0Su11gLV1fKdsc1opLqlp0xzAdFetHHneRdQYTnl+6xTxrrBj7KrPV0kV6GKgAj
         X8xAA414trpxr67UU5Ql/dfJgwK/7urzxPBQhCWsQlujCpSFopxKqz4JxUd9rF1p6uu4
         vLdWXdse1VirzPhq9L+qIM6HEMP1LUN/ph3DM0wpVzV5Snu9+D8z/kFvumRq4WXJmHXv
         ucjGtmwWYBC2YnRooDlKESI02N1uCeeo3bpQQSIDEM6L8UyDSi4V0ePyts1KFHLOpH78
         uoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=fXnJoY5COKKqaViQrzHGXO3P7g2CyIkmu5oDvOAw7V8=;
        b=AZxWp3MMbWNyhUrkO4b9EkS5Lzko6jbBlcDF5fWm62xVW6xREbDWhFa5baDlvBzLOC
         Y00PKRyEqp5I6Aqro/hbQvO36Q+v9+zy1ZksCd3GKc+OB2EYN084Vuz3+6V25/TcIBIf
         HD53F+Uf0opHzoJstg/4DdsKbzpWCnEc3/HKyntKcInUU1KCFICgyx9UcEzQ7Ei1aetx
         /UOsoZ0s+qoHGGAOhiUC8NgbGhIVJDTXoFg6qyvkWnErDQ6s3rzX7qah7pPS068N4Qbu
         /+Py9zQcO95OdWOlMvE7NzvtexmgCbG+YXsTTd8Sc4/4ckTBSVKUfZUYRLeGKLaZGWWD
         hWPQ==
X-Gm-Message-State: AOAM532X3OE1783cvDENeWA9/ErhweCVMQUi0zUlli1qmK5utRecIPVx
        m7YAqh274CICckBGAGbX1wU=
X-Google-Smtp-Source: ABdhPJx4Sw9YkvyMOSz1j6l4//C+swB7Ehawld7rbm9wWnEhdS49W2zJ3bBVSKrxYAHspGHLrfxgpA==
X-Received: by 2002:a7b:c19a:: with SMTP id y26mr519327wmi.20.1610058459860;
        Thu, 07 Jan 2021 14:27:39 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id w8sm10003601wrl.91.2021.01.07.14.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:39 -0800 (PST)
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
Subject: [PULL 55/66] target/mips: Introduce decodetree helpers for MSA LSA/DLSA opcodes
Date:   Thu,  7 Jan 2021 23:22:42 +0100
Message-Id: <20210107222253.20382-56-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201215225757.764263-23-f4bug@amsat.org>
---
 target/mips/msa32.decode    |  4 ++++
 target/mips/msa64.decode    | 17 +++++++++++++++++
 target/mips/msa_translate.c | 14 ++++++++++++++
 target/mips/meson.build     |  1 +
 4 files changed, 36 insertions(+)
 create mode 100644 target/mips/msa64.decode

diff --git a/target/mips/msa32.decode b/target/mips/msa32.decode
index d69675132b8..0b2f0863251 100644
--- a/target/mips/msa32.decode
+++ b/target/mips/msa32.decode
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
 
diff --git a/target/mips/msa64.decode b/target/mips/msa64.decode
new file mode 100644
index 00000000000..8dcbbcd8538
--- /dev/null
+++ b/target/mips/msa64.decode
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
diff --git a/target/mips/msa_translate.c b/target/mips/msa_translate.c
index 8a48f889aa2..e97370e54c2 100644
--- a/target/mips/msa_translate.c
+++ b/target/mips/msa_translate.c
@@ -19,6 +19,7 @@
 
 /* Include the auto-generated decoder.  */
 #include "decode-msa32.c.inc"
+#include "decode-msa64.c.inc"
 
 #define OPC_MSA (0x1E << 26)
 
@@ -2266,7 +2267,20 @@ static bool trans_MSA(DisasContext *ctx, arg_MSA *a)
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
index 9afee0ca955..21b75254047 100644
--- a/target/mips/meson.build
+++ b/target/mips/meson.build
@@ -1,5 +1,6 @@
 gen = [
   decodetree.process('msa32.decode', extra_args: [ '--static-decode=decode_msa32' ]),
+  decodetree.process('msa64.decode', extra_args: [ '--static-decode=decode_msa64' ]),
 ]
 
 mips_ss = ss.source_set()
-- 
2.26.2

