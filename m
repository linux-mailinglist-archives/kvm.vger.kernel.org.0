Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F30C2D1F13
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 01:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgLHAiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 19:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728671AbgLHAiQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 19:38:16 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE7DC061749
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 16:37:27 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id q16so15742526edv.10
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 16:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2EM+VJnj9N5+Eo9D9uZ5ImcarVVv2XQ17VoxaCesAks=;
        b=qcON2vRUzK9jDc9B04+NV+rpqvRemQSaXmhQe7iGcQ/CZdr5KMjVd66uY4QlxdnJqj
         2D6aWArTGBrgnQTsmXA8xiyCH6lUObZxwX1sW05zgQyNwzApuwNHp7x+LvDzRVhej71V
         K0FozBgR6tiHwbSRK1yQA0hWa2nb1EGuTLGu/vbFnn6B9wup0H4uAD2L03qsWGykslC+
         60syOPQWPqJ3Aq8f2sdTgSOlFX/4Ereeu8L3eQ407hX0yXk96MK1Ghxqc9upv80c4x7x
         Tro0Fid6/Y1Wy3ygjnzt9jNtGQcgigQwzpM+5aMMbVKna1YqeORR59HqH4KZIia5P16Z
         GDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=2EM+VJnj9N5+Eo9D9uZ5ImcarVVv2XQ17VoxaCesAks=;
        b=rg2FOGqx+ynuBNOMDjL2giipqRvgKmYi46Ewvg6JZwYewpekwT2ujo3ZGdAwTDZL2s
         cTa3Rm9Wrd+oXRtBuWsiBrMV8wERqkXQKCMssicOvLkIoKfuLZ+FAHIR9J+ZcKoywa9q
         07Hl98Qv9pA806o3CpRxfzaBbaYY2g2op1zWt7IJx/nCrQdsYEv4kyiQzx/ni4lCfdga
         L8TFs78juNq98QDi5KYMIu9CQUUMAb2oSw+fjmtqFZX3TVj5wMfTl/4l168olgAfA758
         U0s+Pxf6OfD8g0la4mAETxa6JOTY0L+fjh/Cnfhdl1U/Y04Y9aFgoOBW/WWW61DujFaR
         vzrg==
X-Gm-Message-State: AOAM532S7JcngknHlzR3XN31x+E9nkR214EqE2nsdJDGLwOfVkI6EgYf
        bZoJJ+UreLm13RbdWeSmKu4=
X-Google-Smtp-Source: ABdhPJzTkLxWJ4xhekHbm421HeMQSVtuxyRdyKD/XgMSP91/4CCBemltSQBKeZJy1HJ8wE9Hn9H7Qg==
X-Received: by 2002:a05:6402:c83:: with SMTP id cm3mr22139357edb.189.1607387846066;
        Mon, 07 Dec 2020 16:37:26 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id b21sm15304035edr.53.2020.12.07.16.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 16:37:25 -0800 (PST)
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
Subject: [PATCH 04/17] target/mips: Simplify MSA TCG logic
Date:   Tue,  8 Dec 2020 01:36:49 +0100
Message-Id: <20201208003702.4088927-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201208003702.4088927-1-f4bug@amsat.org>
References: <20201208003702.4088927-1-f4bug@amsat.org>
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

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index b20cf1b52d9..da0cb98df09 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28576,13 +28576,8 @@ static inline int check_msa_access(DisasContext *ctx)
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
@@ -30426,7 +30421,7 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
 static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
-    check_insn(ctx, ASE_MSA);
+
     check_msa_access(ctx);
 
     switch (MASK_MSA_MINOR(opcode)) {
@@ -31073,9 +31068,10 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
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
@@ -31264,7 +31260,9 @@ static void decode_opc(CPUMIPSState *env, DisasContext *ctx)
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

