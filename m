Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B722EE8A7
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbhAGW2c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728739AbhAGW2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:28:32 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A4CC0612FA
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:27:51 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 3so6823649wmg.4
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YBRHf7wGs+dAQiqYFO87nWhgnylXmMhIKDrVpD+hV3A=;
        b=TfT4Z7pCtA5i/83DuHy+/X+0UCcP0xTOxo+I1mwEVwU+M20l6yIhDRkCEtsgku1mxg
         OTOHuJ1CSA2oI5iR4UItCm9Zq98N5ObcfAq/NeHOYHG1iOPXOhuR7aZONkGGyD/CWJCx
         lx/G28pauWvxempWaqg+vHX4fU7vMVobraeTcTA64+Fq+SYhp5da6zTmspmNxODUKM/h
         RCiuhDKko1A8a91re0MyhOerfAAILo67RVVXiKlLuRAJMGHfDk9EADcdIOAIhItLWj8v
         fTbieEJaxsTqcBHjhHiy33o+dIC1vo2Gk/hWylF01ybzxMyb16EvMw8lN/2NC59kiA0Z
         hriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=YBRHf7wGs+dAQiqYFO87nWhgnylXmMhIKDrVpD+hV3A=;
        b=P83l/xPMjz4DmBsOJ/tVYCigLQkfCgyUPb9xtn956hVBrGpW/mrmMFJ46oJnRUerYC
         zMFW6FlgGvvK13m4EztQyzwfi3Qh2ljjqtIW++ABObjf5TYeNjYaLW1cdwmNbnaflYfz
         HmId8kJGXoIZj+fWYyv80XJCTV50PjWL5XzFG2lggDrmdeC47FCWh2ew0zOK4Z+trspK
         qC4Zf3wZK3q6UGvtiLBEvtCvpeBKzXzXmLbiL1UYan+Ug0f8xQedK4cvCEREv0NimhpX
         MU2+IK+O1MWrj+9hlckVXrdHWhz1UIjqdsBc3un7PIAhSi7riiivgH1jZ4hXk844L10D
         AO4A==
X-Gm-Message-State: AOAM5337YaDw3JdUcPMQJYLRzJegk0krUBMZ61BHCUR559yAtxjoZBqw
        AQa75bMJzev2FImLYxHHVeA=
X-Google-Smtp-Source: ABdhPJy7oJ7BB8Xzb76xkAfOU8XnrPlDmrZ+GsFRHxXmMlUkKT7gC+Vy/DlK/QSONpgwK84Dr/EfGg==
X-Received: by 2002:a1c:4c0a:: with SMTP id z10mr495077wmf.95.1610058470286;
        Thu, 07 Jan 2021 14:27:50 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id q15sm9908485wrw.75.2021.01.07.14.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:27:49 -0800 (PST)
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
Subject: [PULL 57/66] target/mips: Remove now unreachable LSA/DLSA opcodes code
Date:   Thu,  7 Jan 2021 23:22:44 +0100
Message-Id: <20210107222253.20382-58-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we switched to decodetree-generated processing,
we can remove this now unreachable code.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201208203704.243704-6-f4bug@amsat.org>
---
 target/mips/translate.c | 29 +++++------------------------
 1 file changed, 5 insertions(+), 24 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index cd34b06faae..f4481afb8de 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -280,9 +280,6 @@ enum {
     R6_OPC_DCLZ     = 0x12 | OPC_SPECIAL,
     R6_OPC_DCLO     = 0x13 | OPC_SPECIAL,
     R6_OPC_SDBBP    = 0x0e | OPC_SPECIAL,
-
-    OPC_LSA  = 0x05 | OPC_SPECIAL,
-    OPC_DLSA = 0x15 | OPC_SPECIAL,
 };
 
 /* Multiplication variants of the vr54xx. */
@@ -24319,9 +24316,6 @@ static void decode_opc_special_r6(CPUMIPSState *env, DisasContext *ctx)
 
     op1 = MASK_SPECIAL(ctx->opcode);
     switch (op1) {
-    case OPC_LSA:
-        gen_LSA(ctx, rd, rt, rs, extract32(ctx->opcode, 6, 2));
-        break;
     case OPC_MULT:
     case OPC_MULTU:
     case OPC_DIV:
@@ -24372,10 +24366,6 @@ static void decode_opc_special_r6(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
 #if defined(TARGET_MIPS64)
-    case OPC_DLSA:
-        check_mips_64(ctx);
-        gen_DLSA(ctx, rd, rt, rs, extract32(ctx->opcode, 6, 2));
-        break;
     case R6_OPC_DCLO:
     case R6_OPC_DCLZ:
         if (rt == 0 && sa == 1) {
@@ -24637,18 +24627,14 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         check_insn(ctx, ISA_MIPS2);
         gen_trap(ctx, op1, rs, rt, -1);
         break;
-    case OPC_LSA: /* OPC_PMON */
-        if ((ctx->insn_flags & ISA_MIPS_R6) || ase_msa_available(env)) {
-            decode_opc_special_r6(env, ctx);
-        } else {
-            /* Pmon entry point, also R4010 selsl */
+    case OPC_PMON:
+        /* Pmon entry point, also R4010 selsl */
 #ifdef MIPS_STRICT_STANDARD
-            MIPS_INVAL("PMON / selsl");
-            gen_reserved_instruction(ctx);
+        MIPS_INVAL("PMON / selsl");
+        gen_reserved_instruction(ctx);
 #else
-            gen_helper_0e0i(pmon, sa);
+        gen_helper_0e0i(pmon, sa);
 #endif
-        }
         break;
     case OPC_SYSCALL:
         generate_exception_end(ctx, EXCP_SYSCALL);
@@ -24739,11 +24725,6 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
             break;
         }
         break;
-    case OPC_DLSA:
-        if ((ctx->insn_flags & ISA_MIPS_R6) || ase_msa_available(env)) {
-            decode_opc_special_r6(env, ctx);
-        }
-        break;
 #endif
     default:
         if (ctx->insn_flags & ISA_MIPS_R6) {
-- 
2.26.2

