Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB772EE88B
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbhAGW0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbhAGW0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:24 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39607C0612FE
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:25:43 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id q75so6840987wme.2
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QRsQWA6DviCLjfaBDg1WbGaXrnSa2ioMMoOlaaR//h8=;
        b=o0OBpaG8YioPmnh4pCi8uEIllIPToQK4Y/ZurcH7/jBgzM0iX59PpRROfAX9KSm9Qv
         y1M/po13UpDx0ukSBaTIFxHYx4VHSUOnpOezCQWu3EYtKGgUVDXSvNIKYeSmL+QOqnJ3
         H3LDJGFF/dNekLL+AvkIY3R91mTDJTumFY9rCML71mGVTSCTUkRJh+qP8r3Y1PO7DNwe
         +vVhhyT1Goj5s5FDV6ldmMGa/D7ylClNjaujOItzpFp/UtcLBZrmMSInI5/Tm27RIoiW
         qOJaAURMH/V8wGZ1oYMX4RaTnB5af38vnwNyLA0iYwxXzmtjAbdKRecF63ma5xT19Ny3
         7LQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QRsQWA6DviCLjfaBDg1WbGaXrnSa2ioMMoOlaaR//h8=;
        b=egibVMEhpvreCHK6BSZqRpMRtwiygywvvYvZ+AaaOLbWisdGaoV6BDPuKkQwpc1yHV
         PfES7H4ZWZpPTottmyw7N77o2As11fKFBsGGhAlboF+Cg5CoBJjgT+sjRbnft3r1b3IW
         8ckkuX8dA+o1OCNGAEdispse4K1gUZZuEraq2Swbc1U+5aGha5KAXlr4xNTOcUF/fXrq
         l1wsZsthc2Yu7MJEqHJZHDUw4xjOU1sYBDpIQpjU/Bw/8Mamd49OwYgEKb7kTPbMvfJG
         6c2JxK05TcsSR63iEEEiFWJdQDwaFn1rukzktPoqHb+fbS9esWXsZFe/92qQCl9Z3KKf
         bdGw==
X-Gm-Message-State: AOAM532D5ONQ8/0P+b0h/sdcNSNw9zHeVetesm020XdnI6OF0ca6X6sk
        e6W1s9Yai1Ytl8tfA/+jGrA=
X-Google-Smtp-Source: ABdhPJzGmA4+ysp4m5XSrF57IUOYG8Bi+WA1SU7PAOx6p4FBWbHHquxLpd7/0eknqJS8F6BCz/U/mA==
X-Received: by 2002:a1c:65d4:: with SMTP id z203mr509895wmb.65.1610058342032;
        Thu, 07 Jan 2021 14:25:42 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id z15sm10584113wrv.67.2021.01.07.14.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:25:41 -0800 (PST)
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
Subject: [PULL 32/66] target/mips: Declare generic FPU functions in 'translate.h'
Date:   Thu,  7 Jan 2021 23:22:19 +0100
Message-Id: <20210107222253.20382-33-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some FPU translation functions / registers can be used by
ISA / ASE / extensions out of the big translate.c file.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201214183739.500368-15-f4bug@amsat.org>
---
 target/mips/translate.h |  7 +++++++
 target/mips/translate.c | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 5f744c63374..4c30a328e4b 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -60,12 +60,19 @@ void check_insn(DisasContext *ctx, uint64_t flags);
 #ifdef TARGET_MIPS64
 void check_mips_64(DisasContext *ctx);
 #endif
+void check_cp1_enabled(DisasContext *ctx);
 
 void gen_base_offset_addr(DisasContext *ctx, TCGv addr, int base, int offset);
 void gen_load_gpr(TCGv t, int reg);
 void gen_store_gpr(TCGv t, int reg);
 
+void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg);
+void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg);
+int get_fp_bit(int cc);
+
 extern TCGv cpu_gpr[32], cpu_PC;
+extern TCGv_i32 fpu_fcr0, fpu_fcr31;
+extern TCGv_i64 fpu_f64[32];
 extern TCGv bcond;
 
 #define LOG_DISAS(...)                                                        \
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 7c20ed33df7..610fba61de4 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -2492,8 +2492,8 @@ static TCGv cpu_dspctrl, btarget;
 TCGv bcond;
 static TCGv cpu_lladdr, cpu_llval;
 static TCGv_i32 hflags;
-static TCGv_i32 fpu_fcr0, fpu_fcr31;
-static TCGv_i64 fpu_f64[32];
+TCGv_i32 fpu_fcr0, fpu_fcr31;
+TCGv_i64 fpu_f64[32];
 static TCGv_i64 msa_wr_d[64];
 
 #if defined(TARGET_MIPS64)
@@ -2809,7 +2809,7 @@ static void gen_store_fpr32h(DisasContext *ctx, TCGv_i32 t, int reg)
     }
 }
 
-static void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
+void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
 {
     if (ctx->hflags & MIPS_HFLAG_F64) {
         tcg_gen_mov_i64(t, fpu_f64[reg]);
@@ -2818,7 +2818,7 @@ static void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
     }
 }
 
-static void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
+void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
 {
     if (ctx->hflags & MIPS_HFLAG_F64) {
         tcg_gen_mov_i64(fpu_f64[reg], t);
@@ -2832,7 +2832,7 @@ static void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
     }
 }
 
-static inline int get_fp_bit(int cc)
+int get_fp_bit(int cc)
 {
     if (cc) {
         return 24 + cc;
@@ -2907,7 +2907,7 @@ static inline void check_cp0_enabled(DisasContext *ctx)
     }
 }
 
-static inline void check_cp1_enabled(DisasContext *ctx)
+void check_cp1_enabled(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_FPU))) {
         generate_exception_err(ctx, EXCP_CpU, 1);
-- 
2.26.2

