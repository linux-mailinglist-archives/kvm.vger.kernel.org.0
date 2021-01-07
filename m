Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99C52EE864
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbhAGWYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbhAGWYW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:22 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FD1C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:49 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id k10so6359330wmi.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RavFb6dHUeenzrSfS/Q/TJH5UznJIUfWdY3rLcA4ySo=;
        b=mzomH6jdr6EZyEVSkuwt5lbCGtIdXcojInKf28RZ7eaHb8UfBBjDHu5odN17tPu6kt
         yscLmJFXJ02sXHpWGRUK47dKzGq69UfyMdvxn5nvY07q4HOKHXGCfn+oEPOcNJm/krfT
         znaJMbL5k2Ky4BMiExwNBTy8ioJRjxBxnkL6QhQ22b39mYDBvObcK7s8vltc8ZB/b5lm
         Sou5o/G2SzG2fXF+GpU1MVnblpF7G3rArUUJb/oSSXjYME/Hs3sri1jYVLd5/MlZ39uF
         U8eyG8qnzNJeAANdniSIxbFD2ZoHato3uN0kHrdAHraBTARYou6D6QQ4IfqvbHtECvHi
         YQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=RavFb6dHUeenzrSfS/Q/TJH5UznJIUfWdY3rLcA4ySo=;
        b=ssC7ucCJSRowGel7+C2I9Ar/YAsDIcYTeAfn6Ui8+jMjRKlq/0uQn7cA3r1uEj9sFh
         2h9IXpiIfKdsdMiOv/ZC2MkevWNyMvH5F0HoPNvu/ESK0CkFE8WUGQTtInGdO/IcMarY
         8tV+26cHOOEm0m14PYaooZi4Prw6+TDu76pssua5qEMsyf7NvR1JZG13jYcrkcf0KoOR
         T3hV1jwovLclFwkGrUVtT2E6jtNZdYj3L42P7NabASrVrAN4Cm7H2O8uA1amnlqMQp2+
         5qJziN+Ojcw3QCVsjwpZbiIajjkSSczk3fLAsnhh4bgeoeZJw+cfWdoZmnJevSGjDf2u
         L1tw==
X-Gm-Message-State: AOAM531KXlgBU4TayMNuvlo8Rpmfv0BvUFCToRpVrzLGEDxUAeSmhJy5
        GjILFjd0gfLns3ZPQ1ntTVc=
X-Google-Smtp-Source: ABdhPJzUXXuSdtPR6ULt4R79zWpOOuF4QmJ5/Gvwe7kpCeGD2sb3/+U49oGXlw0Hv5NJhAtc0Km/iw==
X-Received: by 2002:a1c:9ac6:: with SMTP id c189mr492866wme.137.1610058228349;
        Thu, 07 Jan 2021 14:23:48 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id e15sm10531456wrx.86.2021.01.07.14.23.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:47 -0800 (PST)
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
Subject: [PULL 10/66] target/mips/mips-defs: Use ISA_MIPS32R2 definition to check Release 2
Date:   Thu,  7 Jan 2021 23:21:57 +0100
Message-Id: <20210107222253.20382-11-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the single ISA_MIPS32R2 definition to check if the Release 2
ISA is supported, whether the CPU support 32/64-bit.

For now we keep '32' in the definition name, we will rename it
as ISA_MIPS_R2 in few commits.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-8-f4bug@amsat.org>
---
 target/mips/mips-defs.h    | 3 +--
 linux-user/mips/cpu_loop.c | 1 -
 target/mips/translate.c    | 4 ++--
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 23ce8b8406f..b36b59c12d3 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -18,7 +18,6 @@
 #define ISA_MIPS5         0x0000000000000010ULL
 #define ISA_MIPS32        0x0000000000000020ULL
 #define ISA_MIPS32R2      0x0000000000000040ULL
-#define ISA_MIPS64R2      0x0000000000000100ULL
 #define ISA_MIPS32R3      0x0000000000000200ULL
 #define ISA_MIPS64R3      0x0000000000000400ULL
 #define ISA_MIPS32R5      0x0000000000000800ULL
@@ -78,7 +77,7 @@
 
 /* MIPS Technologies "Release 2" */
 #define CPU_MIPS32R2    (CPU_MIPS32R1 | ISA_MIPS32R2)
-#define CPU_MIPS64R2    (CPU_MIPS64R1 | CPU_MIPS32R2 | ISA_MIPS64R2)
+#define CPU_MIPS64R2    (CPU_MIPS64R1 | CPU_MIPS32R2)
 
 /* MIPS Technologies "Release 3" */
 #define CPU_MIPS32R3    (CPU_MIPS32R2 | ISA_MIPS32R3)
diff --git a/linux-user/mips/cpu_loop.c b/linux-user/mips/cpu_loop.c
index cfe7ba5c47d..f0831379cc4 100644
--- a/linux-user/mips/cpu_loop.c
+++ b/linux-user/mips/cpu_loop.c
@@ -385,7 +385,6 @@ void target_cpu_copy_regs(CPUArchState *env, struct target_pt_regs *regs)
     prog_req.fre &= interp_req.fre;
 
     bool cpu_has_mips_r2_r6 = env->insn_flags & ISA_MIPS32R2 ||
-                              env->insn_flags & ISA_MIPS64R2 ||
                               env->insn_flags & ISA_MIPS32R6 ||
                               env->insn_flags & ISA_MIPS64R6;
 
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 172027f9d6e..9fc9dedf30d 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -28621,7 +28621,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
     case OPC_DINSM:
     case OPC_DINSU:
     case OPC_DINS:
-        check_insn(ctx, ISA_MIPS64R2);
+        check_insn(ctx, ISA_MIPS32R2);
         check_mips_64(ctx);
         gen_bitops(ctx, op1, rt, rs, sa, rd);
         break;
@@ -28641,7 +28641,7 @@ static void decode_opc_special3(CPUMIPSState *env, DisasContext *ctx)
             decode_opc_special3_r6(env, ctx);
             break;
         default:
-            check_insn(ctx, ISA_MIPS64R2);
+            check_insn(ctx, ISA_MIPS32R2);
             check_mips_64(ctx);
             op2 = MASK_DBSHFL(ctx->opcode);
             gen_bshfl(ctx, op2, rt, rd);
-- 
2.26.2

