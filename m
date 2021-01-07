Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0A12EE86C
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728308AbhAGWYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728287AbhAGWYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:38 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729E7C0612F5
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:44 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id g185so6829404wmf.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JF+srhqzVhiG9h5YfjprayJ58NzAW66CVocxdnKYZak=;
        b=MyguUpy9swxrQddCuBBhGkZGqa0U5jWbrSLDTzAIhc1PiGDgyuPql0/kz7s5UThQa8
         M2R4vS9nZK5kp5WHUbO20F7wvtmgvkMuUY3SwBWxWYDbH1sn4QvCqw2SNEn4CbTwbItY
         2E1XodvxynzXBeiHkAeyfMRIeZu9NU/rZWD85UPoQtlX4KWlHSelWB3Top/3qaB2L8WF
         cI00sx4srzSEdcXmd1S/6QJTj0G5rN+xGYsMSP8mS6w/t+GU93ZKt++rH+dY4bB94UoN
         +iMPeUtbk7ESKYeUub/jY5KWAw1ZDlxthUOZZwyzxl152hWs6dBDb49It4mI16d9zD7F
         3NEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=JF+srhqzVhiG9h5YfjprayJ58NzAW66CVocxdnKYZak=;
        b=lIOIa2cLvCf9SFwmm4B69YZb610O3xpOcDDB/pbqC2lzw4YOAsQWEHF888znQc9thi
         ML/UrzmH5YH2ebgaYwtLW/Cj46/a/4pmju7MQ88erpkb0q8WTCKDS1PkFQkVmaVxN1NL
         BMj3t2d2jymfMQS3uV0LTv6gRSX8pcfgy2rR9T7z7cJ5xkg8DMzyHZPzJr2SMHJtuR7q
         oSoUIHjH6ptqtzWBzhcGZumV+ioiIw5a5yWA2ZZx02jvQaHSuoH1NGCKn7/Z2F1Yqv/K
         v0gwWQkcBoJ5CgjKb1yDmHOS/WJSQqPnODgJdWsCJjH7OEufrmEZaPUad6xq4Rwh8FEy
         Q//w==
X-Gm-Message-State: AOAM530boP7MuOv/yIrSQJspbTzbHwdribAK08KJOmea9Ehul+NJwGfY
        ZT9Opfad/dDkgprrw3LgnOc=
X-Google-Smtp-Source: ABdhPJyqDIoi12kS/zEfaBOSjiMRo+zjIF9jiFqHqRZVWv01024Gv+Yl22rTTDgoM4CVyIbrMKG0xA==
X-Received: by 2002:a1c:4904:: with SMTP id w4mr507415wma.140.1610058223270;
        Thu, 07 Jan 2021 14:23:43 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c6sm10834861wrh.7.2021.01.07.14.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:42 -0800 (PST)
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
Subject: [PULL 09/66] target/mips/mips-defs: Use ISA_MIPS32 definition to check Release 1
Date:   Thu,  7 Jan 2021 23:21:56 +0100
Message-Id: <20210107222253.20382-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the single ISA_MIPS32 definition to check if the Release 1
ISA is supported, whether the CPU support 32/64-bit.

For now we keep '32' in the definition name, we will rename it
as ISA_MIPS_R1 in few commits.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-7-f4bug@amsat.org>
---
 target/mips/mips-defs.h |  3 +--
 target/mips/translate.c | 10 +++++-----
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 89a9a4dda31..23ce8b8406f 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -18,7 +18,6 @@
 #define ISA_MIPS5         0x0000000000000010ULL
 #define ISA_MIPS32        0x0000000000000020ULL
 #define ISA_MIPS32R2      0x0000000000000040ULL
-#define ISA_MIPS64        0x0000000000000080ULL
 #define ISA_MIPS64R2      0x0000000000000100ULL
 #define ISA_MIPS32R3      0x0000000000000200ULL
 #define ISA_MIPS64R3      0x0000000000000400ULL
@@ -75,7 +74,7 @@
 
 /* MIPS Technologies "Release 1" */
 #define CPU_MIPS32R1    (CPU_MIPS2 | ISA_MIPS32)
-#define CPU_MIPS64R1    (CPU_MIPS5 | CPU_MIPS32R1 | ISA_MIPS64)
+#define CPU_MIPS64R1    (CPU_MIPS5 | CPU_MIPS32R1)
 
 /* MIPS Technologies "Release 2" */
 #define CPU_MIPS32R2    (CPU_MIPS32R1 | ISA_MIPS32R2)
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 19933b7868c..172027f9d6e 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -8943,7 +8943,7 @@ static void gen_dmfc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     const char *register_name = "invalid";
 
     if (sel != 0) {
-        check_insn(ctx, ISA_MIPS64);
+        check_insn(ctx, ISA_MIPS32);
     }
 
     switch (reg) {
@@ -9669,7 +9669,7 @@ static void gen_dmtc0(DisasContext *ctx, TCGv arg, int reg, int sel)
     const char *register_name = "invalid";
 
     if (sel != 0) {
-        check_insn(ctx, ISA_MIPS64);
+        check_insn(ctx, ISA_MIPS32);
     }
 
     if (tb_cflags(ctx->base.tb) & CF_USE_ICOUNT) {
@@ -14907,12 +14907,12 @@ static int decode_mips16_opc(CPUMIPSState *env, DisasContext *ctx)
                 break;
 #if defined(TARGET_MIPS64)
             case RR_RY_CNVT_ZEW:
-                check_insn(ctx, ISA_MIPS64);
+                check_insn(ctx, ISA_MIPS32);
                 check_mips_64(ctx);
                 tcg_gen_ext32u_tl(cpu_gpr[rx], cpu_gpr[rx]);
                 break;
             case RR_RY_CNVT_SEW:
-                check_insn(ctx, ISA_MIPS64);
+                check_insn(ctx, ISA_MIPS32);
                 check_mips_64(ctx);
                 tcg_gen_ext32s_tl(cpu_gpr[rx], cpu_gpr[rx]);
                 break;
@@ -27612,7 +27612,7 @@ static void decode_opc_special2_legacy(CPUMIPSState *env, DisasContext *ctx)
 #if defined(TARGET_MIPS64)
     case OPC_DCLO:
     case OPC_DCLZ:
-        check_insn(ctx, ISA_MIPS64);
+        check_insn(ctx, ISA_MIPS32);
         check_mips_64(ctx);
         gen_cl(ctx, op1, rd, rs);
         break;
-- 
2.26.2

