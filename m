Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 854392DB6C3
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgLOW73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730188AbgLOW71 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:27 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67C53C061282
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:41 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id j22so12049327eja.13
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BnBuWwu/IR7HzibU0fSLa1btap3ty/kGytf5ZOVzJHw=;
        b=US6pT9hkIUe/3Y7u3abkxfxmo+g63uoofHU7oXDwqFCQZm1V3FKeZ5fDXzLgWMR+tz
         ZUIr8FArsHvKzwdU5ieVduhNmBORH2czavfCNyp2G3DaW1Wx7Y+dAOSt4ViEAcfknR4j
         NEDgCAFVKk+EIAx5IlI16zjC648EjQDBh+vWLjHPVKgPCIwWemlKmBw9hB648PyqxsGN
         VdYu36vVvnu1D9nYrydInoLe21pVmk0ZgN067MnXf6abBT+2DG+WabDXSuxUz78F/nNw
         ztxNkZsRG3MrTs1HcvdY+Er07tfLpecaOC2VF4tD5oP0KgRVvnanghVChVImnzbLu5mN
         nnig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=BnBuWwu/IR7HzibU0fSLa1btap3ty/kGytf5ZOVzJHw=;
        b=i1RiBKqjaGvBToAqZZBnSCxuZR/7UeaCB8NgN7TN8T1kITVJIsGXldENsQ+MgZGmU5
         5HmR0t4Fd/99RQpP4M6mODxlx2S1/JoMqoWP2srMU4mY6K12Sa/hFqCyxgxyzK5vXyNS
         jMFUivNpSV0cqMp4W+a1dE3jDXKaNRgQodRMHeJZFmB87mcCHO8RMQ+rgXic0CQZ0XoQ
         6KvRzhwSsdYx9EDOX06xj2SH12PdWfIFp4xA1gx68Hdw1ZxxuoWocAlm48fq5TEie+N6
         Tvuoa1T+gAkKYfQD1y0cAExjZlgz4IthPsiw7lflgBV85acZl/iwR9qRfqRz/VTLjrfP
         2HSQ==
X-Gm-Message-State: AOAM532UFTmo4Y7odMhx4brLRjBHplbgBZXXI6mf/hJSV9Tbx2wMfZ6c
        yvl8286rOmyuEQ5xgzA+yeM=
X-Google-Smtp-Source: ABdhPJwWEmYN+znrgrxMg2p+03mYpoUKLrA8wM858BfPuk+pAWE4X4Nrr/vTEL+NY0y64W3QwD6D1g==
X-Received: by 2002:a17:906:705:: with SMTP id y5mr14673838ejb.428.1608073120174;
        Tue, 15 Dec 2020 14:58:40 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 35sm19174328ede.0.2020.12.15.14.58.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:39 -0800 (PST)
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
Subject: [PATCH v2 07/24] target/mips: Simplify MSA TCG logic
Date:   Tue, 15 Dec 2020 23:57:40 +0100
Message-Id: <20201215225757.764263-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
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
index fc658b3be33..02ea184f9a3 100644
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
@@ -31048,9 +31043,10 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
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
             gen_reserved_instruction(ctx);
@@ -31239,7 +31235,9 @@ static bool decode_opc_legacy(CPUMIPSState *env, DisasContext *ctx)
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

