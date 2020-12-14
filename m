Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0972D9F59
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 19:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408831AbgLNSkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 13:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405812AbgLNSjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 13:39:35 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92993C0617A6
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:54 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w5so13720285wrm.11
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 10:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4dvt8U31xdW0cLzHQK5e0FLr4aqxGweAhaJ4Nz2TOOo=;
        b=hi2tvYJlNB2vVj/lqp0JJjXfK3CvJ7mehCA1FtaoWdKDufzQvsDfSCVf3jyk8G49Cz
         tBmTbzbVW4TDuX1TeQNHmUecO955GzCKrjWUEL0F8iecc8tCZoTd9wga/fbi6FPB+80S
         wWBUTrf5ELxXImCwrAxTyHtCp4efMMyhES2VLGdoU/OvKx62LMXwZz15LVQe9a/MxLIu
         FK0t/mhdM0Q1eyABr50xUvdk2iaQOFUsl6lzMRsPeCx5JKd7Fwwyniob6p7mlrdSsWGb
         chLoIZT5Z0aOeqrVELzRwWtjNET5NEJtsMA370qsJuxxhJLbhS2J7hMqXZ3c6rJeWmHK
         0UBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=4dvt8U31xdW0cLzHQK5e0FLr4aqxGweAhaJ4Nz2TOOo=;
        b=XpkVSVjgXw8ijT2aNgdwz8n1psXjIbEcjYa7EdF/gNUjZ7+p3in1xfOewE56/cyhL7
         qAsmeHWEsYdX2LjoHvHTkHgYN4MSNZ22nTOlGaGampqw/mfoh5iLi0OexmHSscNYN8cs
         jsIqGvOeuF0dJiF5VvJMG74g+fCbYn3jerOWsGg4soFaY2fzd+mNdb5JxUyfP3GVIZch
         mlVjg8xbQuNss0UZG1ueyiwJs0bMHTRlBv+8gWI4tqwsV0IpGx18B8zo3lticiGhIZnN
         7jpKYCSpjLOK9OjTk1R0wQVy1+8QrvF1kSG7BHa+makffnpJ6tFoqjBFsJLAf0n/5c4Y
         r/rQ==
X-Gm-Message-State: AOAM533NXqZzCeS+VtP+Valn7G2znPsI2meVKVbj3S6hiNq6dfXgo8Ul
        z9o/pL2Ge1rqeqlGagFFmhQ=
X-Google-Smtp-Source: ABdhPJxUp2BskZWfBzm4IefQycmoihlnmFcsBXXeNIHnDPr0rau5I3Eek3v+shwfWtIwbQYSopXo1Q==
X-Received: by 2002:adf:f7d2:: with SMTP id a18mr8729982wrq.47.1607971133399;
        Mon, 14 Dec 2020 10:38:53 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id a14sm24486383wrn.3.2020.12.14.10.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 10:38:52 -0800 (PST)
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
Subject: [PATCH v2 14/16] target/mips: Declare generic FPU functions in 'translate.h'
Date:   Mon, 14 Dec 2020 19:37:37 +0100
Message-Id: <20201214183739.500368-15-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214183739.500368-1-f4bug@amsat.org>
References: <20201214183739.500368-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some FPU translation functions / registers can be used by
ISA / ASE / extensions out of the big translate.c file.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.h |  7 +++++++
 target/mips/translate.c | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 989d6c43207..a30fbf21ff9 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -59,12 +59,19 @@ void check_insn(DisasContext *ctx, uint64_t flags);
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
index 318642cbcfe..08ed542f4d4 100644
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

