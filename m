Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC272D9F60
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408833AbgLNSk1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408700AbgLNSjk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:40 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929FBC061282
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:59 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id r7so17451219wrc.5
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jefk5hCY2L0gsAzOu9EGNf66rlI9awBw/Q4VvUHWHU8=;
        b=KRSqAzfDqntubLnrV7+aVcM6D85jfLoU1v3jbobJLTB5GK3AYEZsr0xO95KGZ5eUpu
         uOfAlROUvUKFHg9I0ZEwe8i9Qp0pUebmfbO/ZmsI0swpyVYtfxfBAHozlXHWVLxaIUkR
         2ioe/BepV616gMyfXag+Gls7EJ3fkl5UCrmUWE7hsPHN4dbj+UsQWJ5yZnrYNlddj48e
         qh8Hggj7FFpT76phdy83AmWRdbJMsxzg4+bk3SsEaodxsQGEsiMZSFjLdr3VbyHGZu+J
         QmemRydem9eGnDIFCKmCgxRsZOj6DoSHfWagUZ+TVtIibgftPPUGA9eO5riGGjTdymQd
         MlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Jefk5hCY2L0gsAzOu9EGNf66rlI9awBw/Q4VvUHWHU8=;
        b=Ot3Q26bnC2bpr1hpOGxpigysmvtLIViI5b/MMk3q5y+Edtfl6Vt4i803o2BT83jtYf
         AMTWIyVYHfAxjS3NjmOPk0KZNIm9sDtM+zS7UN3S37v/BfLjcDCEYXEyz4asPQ7tC5HE
         +8hb6ARwsULzXgf6QJZhyaopnBePgeAkhWy05OIRWz40J/lDQQp2XI8ZI/888jwHJZqs
         ry4gwnb0n0PHNCrVwY9y5fn+2QydfEiTv61/9VS5QFQOWRqssrMrHk5HFvje+WQTN9MU
         VZUZH7PiaULHT9dYTxWtUWBPNWW8gIQpDEtv4btwDQCTGgBZpDBMn14QUEQ4VJEEAJbi
         U8YA==
X-Gm-Message-State: AOAM533MUkukw+wxOK3WeyM+6I1g3Su2CrIFRIHcQMZX9gR7JvyrEDpm
        Kc9qNMbe9eGXo8WVmrHpyaY=
X-Google-Smtp-Source: ABdhPJx1mbrTlly834vs9hW8IPNk2JYQANfQHJCwKpzwL+rkNH34bZ9lDG+EmoX+BTQiXr+/H68p3Q==
X-Received: by 2002:adf:e48d:: with SMTP id i13mr30341474wrm.48.1607971138397;
        Mon, 14 Dec 2020 10:38:58 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id m81sm33713025wmf.29.2020.12.14.10.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:57 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 15/16] target/mips: Extract FPU specific definitions to translate.h
Date:   Mon, 14 Dec 2020 19:37:38 +0100
Message-Id: <20201214183739.500368-16-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract FPU specific definitions that can be used by
ISA / ASE / extensions to translate.h header.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h | 71 +++++++++++++++++++++++++++++++++++++++++
 target/mips/translate.c | 70 ----------------------------------------
 2 files changed, 71 insertions(+), 70 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index a30fbf21ff9..a9eab69249f 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -52,6 +52,77 @@ typedef struct DisasContext {
 /* MIPS major opcodes */
 #define MASK_OP_MAJOR(op)   (op & (0x3F << 26))
 
+#define OPC_CP1 (0x11 << 26)
+
+/* Coprocessor 1 (rs field) */
+#define MASK_CP1(op)                (MASK_OP_MAJOR(op) | (op & (0x1F << 21)))
+
+/* Values for the fmt field in FP instructions */
+enum {
+    /* 0 - 15 are reserved */
+    FMT_S = 16,          /* single fp */
+    FMT_D = 17,          /* double fp */
+    FMT_E = 18,          /* extended fp */
+    FMT_Q = 19,          /* quad fp */
+    FMT_W = 20,          /* 32-bit fixed */
+    FMT_L = 21,          /* 64-bit fixed */
+    FMT_PS = 22,         /* paired single fp */
+    /* 23 - 31 are reserved */
+};
+
+enum {
+    OPC_MFC1     = (0x00 << 21) | OPC_CP1,
+    OPC_DMFC1    = (0x01 << 21) | OPC_CP1,
+    OPC_CFC1     = (0x02 << 21) | OPC_CP1,
+    OPC_MFHC1    = (0x03 << 21) | OPC_CP1,
+    OPC_MTC1     = (0x04 << 21) | OPC_CP1,
+    OPC_DMTC1    = (0x05 << 21) | OPC_CP1,
+    OPC_CTC1     = (0x06 << 21) | OPC_CP1,
+    OPC_MTHC1    = (0x07 << 21) | OPC_CP1,
+    OPC_BC1      = (0x08 << 21) | OPC_CP1, /* bc */
+    OPC_BC1ANY2  = (0x09 << 21) | OPC_CP1,
+    OPC_BC1ANY4  = (0x0A << 21) | OPC_CP1,
+    OPC_BZ_V     = (0x0B << 21) | OPC_CP1,
+    OPC_BNZ_V    = (0x0F << 21) | OPC_CP1,
+    OPC_S_FMT    = (FMT_S << 21) | OPC_CP1,
+    OPC_D_FMT    = (FMT_D << 21) | OPC_CP1,
+    OPC_E_FMT    = (FMT_E << 21) | OPC_CP1,
+    OPC_Q_FMT    = (FMT_Q << 21) | OPC_CP1,
+    OPC_W_FMT    = (FMT_W << 21) | OPC_CP1,
+    OPC_L_FMT    = (FMT_L << 21) | OPC_CP1,
+    OPC_PS_FMT   = (FMT_PS << 21) | OPC_CP1,
+    OPC_BC1EQZ   = (0x09 << 21) | OPC_CP1,
+    OPC_BC1NEZ   = (0x0D << 21) | OPC_CP1,
+    OPC_BZ_B     = (0x18 << 21) | OPC_CP1,
+    OPC_BZ_H     = (0x19 << 21) | OPC_CP1,
+    OPC_BZ_W     = (0x1A << 21) | OPC_CP1,
+    OPC_BZ_D     = (0x1B << 21) | OPC_CP1,
+    OPC_BNZ_B    = (0x1C << 21) | OPC_CP1,
+    OPC_BNZ_H    = (0x1D << 21) | OPC_CP1,
+    OPC_BNZ_W    = (0x1E << 21) | OPC_CP1,
+    OPC_BNZ_D    = (0x1F << 21) | OPC_CP1,
+};
+
+#define MASK_CP1_FUNC(op)           (MASK_CP1(op) | (op & 0x3F))
+#define MASK_BC1(op)                (MASK_CP1(op) | (op & (0x3 << 16)))
+
+enum {
+    OPC_BC1F     = (0x00 << 16) | OPC_BC1,
+    OPC_BC1T     = (0x01 << 16) | OPC_BC1,
+    OPC_BC1FL    = (0x02 << 16) | OPC_BC1,
+    OPC_BC1TL    = (0x03 << 16) | OPC_BC1,
+};
+
+enum {
+    OPC_BC1FANY2     = (0x00 << 16) | OPC_BC1ANY2,
+    OPC_BC1TANY2     = (0x01 << 16) | OPC_BC1ANY2,
+};
+
+enum {
+    OPC_BC1FANY4     = (0x00 << 16) | OPC_BC1ANY4,
+    OPC_BC1TANY4     = (0x01 << 16) | OPC_BC1ANY4,
+};
+
 void generate_exception_err(DisasContext *ctx, int excp, int err);
 void generate_exception_end(DisasContext *ctx, int excp);
 void gen_reserved_instruction(DisasContext *ctx);
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 08ed542f4d4..cc876019bf7 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -43,7 +43,6 @@ enum {
     OPC_SPECIAL  = (0x00 << 26),
     OPC_REGIMM   = (0x01 << 26),
     OPC_CP0      = (0x10 << 26),
-    OPC_CP1      = (0x11 << 26),
     OPC_CP2      = (0x12 << 26),
     OPC_CP3      = (0x13 << 26),
     OPC_SPECIAL2 = (0x1C << 26),
@@ -996,75 +995,6 @@ enum {
     OPC_WAIT     = 0x20 | OPC_C0,
 };
 
-/* Coprocessor 1 (rs field) */
-#define MASK_CP1(op)                (MASK_OP_MAJOR(op) | (op & (0x1F << 21)))
-
-/* Values for the fmt field in FP instructions */
-enum {
-    /* 0 - 15 are reserved */
-    FMT_S = 16,          /* single fp */
-    FMT_D = 17,          /* double fp */
-    FMT_E = 18,          /* extended fp */
-    FMT_Q = 19,          /* quad fp */
-    FMT_W = 20,          /* 32-bit fixed */
-    FMT_L = 21,          /* 64-bit fixed */
-    FMT_PS = 22,         /* paired single fp */
-    /* 23 - 31 are reserved */
-};
-
-enum {
-    OPC_MFC1     = (0x00 << 21) | OPC_CP1,
-    OPC_DMFC1    = (0x01 << 21) | OPC_CP1,
-    OPC_CFC1     = (0x02 << 21) | OPC_CP1,
-    OPC_MFHC1    = (0x03 << 21) | OPC_CP1,
-    OPC_MTC1     = (0x04 << 21) | OPC_CP1,
-    OPC_DMTC1    = (0x05 << 21) | OPC_CP1,
-    OPC_CTC1     = (0x06 << 21) | OPC_CP1,
-    OPC_MTHC1    = (0x07 << 21) | OPC_CP1,
-    OPC_BC1      = (0x08 << 21) | OPC_CP1, /* bc */
-    OPC_BC1ANY2  = (0x09 << 21) | OPC_CP1,
-    OPC_BC1ANY4  = (0x0A << 21) | OPC_CP1,
-    OPC_BZ_V     = (0x0B << 21) | OPC_CP1,
-    OPC_BNZ_V    = (0x0F << 21) | OPC_CP1,
-    OPC_S_FMT    = (FMT_S << 21) | OPC_CP1,
-    OPC_D_FMT    = (FMT_D << 21) | OPC_CP1,
-    OPC_E_FMT    = (FMT_E << 21) | OPC_CP1,
-    OPC_Q_FMT    = (FMT_Q << 21) | OPC_CP1,
-    OPC_W_FMT    = (FMT_W << 21) | OPC_CP1,
-    OPC_L_FMT    = (FMT_L << 21) | OPC_CP1,
-    OPC_PS_FMT   = (FMT_PS << 21) | OPC_CP1,
-    OPC_BC1EQZ   = (0x09 << 21) | OPC_CP1,
-    OPC_BC1NEZ   = (0x0D << 21) | OPC_CP1,
-    OPC_BZ_B     = (0x18 << 21) | OPC_CP1,
-    OPC_BZ_H     = (0x19 << 21) | OPC_CP1,
-    OPC_BZ_W     = (0x1A << 21) | OPC_CP1,
-    OPC_BZ_D     = (0x1B << 21) | OPC_CP1,
-    OPC_BNZ_B    = (0x1C << 21) | OPC_CP1,
-    OPC_BNZ_H    = (0x1D << 21) | OPC_CP1,
-    OPC_BNZ_W    = (0x1E << 21) | OPC_CP1,
-    OPC_BNZ_D    = (0x1F << 21) | OPC_CP1,
-};
-
-#define MASK_CP1_FUNC(op)           (MASK_CP1(op) | (op & 0x3F))
-#define MASK_BC1(op)                (MASK_CP1(op) | (op & (0x3 << 16)))
-
-enum {
-    OPC_BC1F     = (0x00 << 16) | OPC_BC1,
-    OPC_BC1T     = (0x01 << 16) | OPC_BC1,
-    OPC_BC1FL    = (0x02 << 16) | OPC_BC1,
-    OPC_BC1TL    = (0x03 << 16) | OPC_BC1,
-};
-
-enum {
-    OPC_BC1FANY2     = (0x00 << 16) | OPC_BC1ANY2,
-    OPC_BC1TANY2     = (0x01 << 16) | OPC_BC1ANY2,
-};
-
-enum {
-    OPC_BC1FANY4     = (0x00 << 16) | OPC_BC1ANY4,
-    OPC_BC1TANY4     = (0x01 << 16) | OPC_BC1ANY4,
-};
-
 #define MASK_CP2(op)                (MASK_OP_MAJOR(op) | (op & (0x1F << 21)))
 
 enum {
-- 
2.26.2

