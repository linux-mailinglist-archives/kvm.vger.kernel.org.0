Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9CC2EE88D
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbhAGW0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727913AbhAGW0j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:39 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CC9C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:23 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id n16so5683858wmc.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VfYlsVfQrXnabjTXXkFkj4bzS4FCzoFbCGst2ujqd0Q=;
        b=pW1Zb8pev9GO4TUM9GY6gZDLX4t4GaeD4uraukSwhqJJkoUA4i4lRS5n497MFqD4eF
         VHvCngigU9DZrCP5g6LmBL736BkvhGwf9Fe4Bqx3yDpfwGcX6u3e8MtfZRLqrYdXCem7
         vZ4fkI0op3/4/p0tKvuH+IVaYT56LZOTWJbVC0aZ8Zas6hX3qwvLmjMpt93Xoaaus6ii
         yoWxFhcczE4vkgUQIaVqdRPE3SWP4JvkY1XuICN6279OG4Vy2f4cLe6vmaQTBbkFQ+Tk
         JBiKA0DPw3QG/OndqLZPXRTkfZOmGbdpZ0WTBkSFC1Us1qG7f6eTSFbJoAqwi065YXD2
         okfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=VfYlsVfQrXnabjTXXkFkj4bzS4FCzoFbCGst2ujqd0Q=;
        b=s8cinYPc8EobNKmD5YGLv/qzHa6eEureosgpaAIKRSlL74sVWG8bxw9kRZOIVVjoYy
         J0PwH/Ko61aoN7KGeXlN70Sannd3xgzANW3SFqJr7bBq1kX++y95TNgZlKED4JWejRog
         yv7d16WKluz6poUtFeYARyyNGomRRkHv/Pjo3qsIRcsEciksBDH/glwBuHiOHaqV33Q4
         12PNn2THRrzKpaAnz2ze20M+WW5h7J3898WOOR2NmM9QHb/Tza0nW2pbGMmllMQ9HTj5
         L7ufwiBNItskVU6oKZK34rWyFrSgeFmgXj68W7qtVhar2fElPftw471Auuat8ZqZDweV
         9ofw==
X-Gm-Message-State: AOAM530/i0+WA5I8/2xQ5Lg1WvwJkqdpgqSrgKjjjJs8iT46DUHaqcjM
        /qwpLs6Zwa/T5u6/1Faf1QA=
X-Google-Smtp-Source: ABdhPJyuyk/uuo1jE+1Ma9y+rdP3wcRZcepOSreGLlzAjvYUHlv2HHczclLyJP+4aKOK9Wz7lwVN/w==
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr503813wml.160.1610058382799;
        Thu, 07 Jan 2021 14:26:22 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id z6sm10681403wrw.58.2021.01.07.14.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:22 -0800 (PST)
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
Subject: [PULL 40/66] target/mips: Simplify MSA TCG logic
Date:   Thu,  7 Jan 2021 23:22:27 +0100
Message-Id: <20210107222253.20382-41-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-5-f4bug@amsat.org>
---
 target/mips/translate.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index c01db5f9d39..e3cea5899f3 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28568,13 +28568,8 @@ static inline int check_msa_access(DisasContext *ctx)
     }
 
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_MSA))) {
-        if (ctx->insn_flags & ASE_MSA) {
-            generate_exception_end(ctx, EXCP_MSADIS);
-            return 0;
-        } else {
-            gen_reserved_instruction(ctx);
-            return 0;
-        }
+        generate_exception_end(ctx, EXCP_MSADIS);
+        return 0;
     }
     return 1;
 }
@@ -30418,7 +30413,7 @@ static void gen_msa_vec(CPUMIPSState *env, DisasContext *ctx)
 static void gen_msa(CPUMIPSState *env, DisasContext *ctx)
 {
     uint32_t opcode = ctx->opcode;
-    check_insn(ctx, ASE_MSA);
+
     check_msa_access(ctx);
 
     switch (MASK_MSA_MINOR(opcode)) {
@@ -31048,9 +31043,11 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
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
+            /* fall through */
         default:
             MIPS_INVAL("cp1");
             gen_reserved_instruction(ctx);
@@ -31239,7 +31236,9 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
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

