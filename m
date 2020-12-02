Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 243902CC5C3
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387917AbgLBSph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387681AbgLBSpg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91BAC061A47
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:44:40 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f23so5930984ejt.8
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EfZKBB7TEk79ikaLZVaA0qdMSWTD8SEXSh/4GRS42BA=;
        b=P95A6tbhEC27Gb2iNPVIYBHFIIvucWz+VR+a4ybKvU3EiTnVdOdYajv6KzVoLOw1vi
         A5V1AmZVeBhnxduxA8gceXaEvcuEIXVge8O1e4n1GovoLkYDGjTiuil+mktQHpL9YvAA
         /BUVrienxo7FMO0jf4z1LVzfH49eNkNd8CTbt+APgo340yoKP77xI0/WAXuY39ujR0W+
         inWBo6IXm1A3Qwr5oxXmVJeFB/481K9L+0E5jiJ/j1DVjBfJFy7uLyjpVfKD+fmVNXJg
         q26FGfDnStuNY7oJYTSdkNTZ1f9UxxxdYRtnCK+Mitu15gS/DMkF21uwmDPDYy4xFL4a
         G+Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=EfZKBB7TEk79ikaLZVaA0qdMSWTD8SEXSh/4GRS42BA=;
        b=L4qn1lqfk4TKkp2I3oq6Cuc3CPglzruFVxxzrJAha9TbjK8KUyuYWCqz5LP8AeIh6b
         bNNpUmUIq0X6mRqwCvR2Od5vYf+TPQMbXH4dVAuACHqEsR3hxil5fNRd+LFcTwKyyZC/
         WQ4GpmXtpmijJ6HuQljpjwlv/bVVowECjw5KdC+4XaUVqWOhV3Xc0tQkBnrOg4ASeVzW
         MypcuersLRwJDBo5d+Dn6kHzrC42/MxZ3wwNUv0uPeZ2FcsoTHFUO8id3hYdtRw7ScER
         gikc13SSIS7Z5dhHgmTdVNJ7wPdasYN8MLsm72FAkugMZllw6adkayT44tBbI6Peo8qd
         pUsQ==
X-Gm-Message-State: AOAM531qDmBPZAkN2edVqOchuNiS9FFW9TR/WUWGuJfexYclipgXUtX1
        0AGm33cDb58H/a4srWft/HE=
X-Google-Smtp-Source: ABdhPJy49hwDReaOMfO3lnaEZQ3M3+pPQZ3B7DhL9efpAUnk5pW2RtqwkM/bDuoXEOF/WQE/LJCZXA==
X-Received: by 2002:a17:906:2a19:: with SMTP id j25mr1082013eje.506.1606934679580;
        Wed, 02 Dec 2020 10:44:39 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id j20sm426900ejy.124.2020.12.02.10.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:44:38 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhc@lemote.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH 4/9] target/mips: Simplify MSA TCG logic
Date:   Wed,  2 Dec 2020 19:44:10 +0100
Message-Id: <20201202184415.1434484-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
References: <20201202184415.1434484-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only decode MSA opcodes if MSA is present (implemented).

Now than check_msa_access() will only be called if MSA is
present, the only way to have MIPS_HFLAG_MSA unset is if
MSA is disabled (bit CP0C5_MSAEn cleared, see previous
commit). Therefore we can remove the 'reserved instruction'
exception.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 803ffefba2c..a05c25e50b8 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28697,13 +28697,8 @@ static inline int check_msa_access(DisasContext *ctx)
     }
 
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_MSA))) {
-        if (ctx->insn_flags & ASE_MSA) {
-            generate_exception_end(ctx, EXCP_MSADIS);
-            return 0;
-        } else {
-            generate_exception_end(ctx, EXCP_RI);
-            return 0;
-        }
+        generate_exception_end(ctx, EXCP_MSADIS);
+        return 0;
     }
     return 1;
 }
@@ -30547,7 +30542,7 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
 static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
-    check_insn(ctx, ASE_MSA);
+
     check_msa_access(ctx);
 
     switch (MASK_MSA_MINOR(opcode)) {
@@ -31194,9 +31189,10 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
         case OPC_BNZ_H:
         case OPC_BNZ_W:
         case OPC_BNZ_D:
-            check_insn(ctx, ASE_MSA);
-            gen_msa_branch(env, ctx, op1);
-            break;
+            if (ase_msa_available(env)) {
+                gen_msa_branch(env, ctx, op1);
+                break;
+            }
         default:
             MIPS_INVAL("cp1");
             generate_exception_end(ctx, EXCP_RI);
@@ -31385,7 +31381,9 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
 #endif
         } else {
             /* MDMX: Not implemented. */
-            gen_msa(env, ctx);
+            if (ase_msa_available(env)) {
+                gen_msa(env, ctx);
+            }
         }
         break;
     case OPC_PCREL:
-- 
2.26.2

