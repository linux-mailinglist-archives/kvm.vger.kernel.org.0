Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D922D1EAA
	for <lists+kvm@lfdr.de>; Tue,  8 Dec 2020 00:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgLGX5F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 18:57:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgLGX5E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 18:57:04 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B097C0611C5
        for <kvm@vger.kernel.org>; Mon,  7 Dec 2020 15:56:14 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id r5so15652666eda.12
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 15:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=53Dvdfm15q5hV8eSzEAIt0mbwAz3z1SRdWqDZyLTyCw=;
        b=JQtb7jU1a90twhjLZt5ZZPdmmu3yFQAsj03UgFwgNoKfcSvOqVfLlYdj0enOECfflG
         BDbJNcKqudpTMrSmyJNG+V44zFpGWEO7fyGddISSyODBHm5XIYz56SegjjO0FOrNxjdC
         K/Xd5JRUkstUsDejeesioCujzpRI1BGTTdWaUa2EjrybyWSwFycr9byiJbr1JXLBOZrW
         uUgR1W1l4y09OGBYpUshdR28JlFw/UyCCPXfTdVjC362Mbx+HBL3RIwCTH3Fwsv1aXr/
         SNSJMiuP2TiGsbTEW0cIP+HoPIiCjQvPSvTR2T3hd09vk66u2GD3V6RTs7jBzkm6eS13
         Adpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=53Dvdfm15q5hV8eSzEAIt0mbwAz3z1SRdWqDZyLTyCw=;
        b=NHQqTh2MLDjsPciAR35Xa+4eqtkwnxu1J1cjBaZvVAbhK1RkWpkjsEAG0Ckqt6a1WU
         VsLbL1phiibfCdqURB+7v5P2hx0vHP1atLWv4xTYyIlTsVO6i6xZyFMa9iqJpo5Vcnnp
         T0R10xp1HBY2aNlyAvDEO4+H+WpeDwDlmWrJt8t1QrMrCOYlg+xL6m71xdvlhLDdlS9s
         GowVInp2NPiJj3CEHNCvGLipf1/d2nafFoOK5vApi5Sspj3sKUPt0cKiLYknkpXmbfSG
         B5c8pKnXGQVjJ/nRgbS589p9MpFGl+l+n48e8+afmNmtuT5d2QN07QhVlpUFD/kacWpf
         9TJA==
X-Gm-Message-State: AOAM530d3kX7tQN5VIlab8p1UCrim5k0xG/sKKFL/XyYssFeExUZ6y9+
        QG40IzX+bSnKrEqoCPc1rEU=
X-Google-Smtp-Source: ABdhPJxplgzajb9bgrDV5yDYPoUk6SaPXNXC86rbVLE639k9Z9BJtJk9kcrIAdYSt72Rwo3bHpuR0g==
X-Received: by 2002:aa7:c403:: with SMTP id j3mr22079182edq.217.1607385373179;
        Mon, 07 Dec 2020 15:56:13 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id f11sm13875704ejd.40.2020.12.07.15.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 15:56:12 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Richard Henderson <richard.henderson@linaro.org>,
        Huacai Chen <chenhuacai@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH 6/7] target/mips: Declare generic FPU functions in 'fpu_translate.h'
Date:   Tue,  8 Dec 2020 00:55:38 +0100
Message-Id: <20201207235539.4070364-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207235539.4070364-1-f4bug@amsat.org>
References: <20201207235539.4070364-1-f4bug@amsat.org>
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
 target/mips/fpu_translate.h | 25 +++++++++++++++++++++++++
 target/mips/translate.c     | 14 ++++++++------
 2 files changed, 33 insertions(+), 6 deletions(-)
 create mode 100644 target/mips/fpu_translate.h

diff --git a/target/mips/fpu_translate.h b/target/mips/fpu_translate.h
new file mode 100644
index 00000000000..430e0b77537
--- /dev/null
+++ b/target/mips/fpu_translate.h
@@ -0,0 +1,25 @@
+/*
+ * FPU-related MIPS translation routines.
+ *
+ *  Copyright (C) 2004-2005  Jocelyn Mayer
+ *  Copyright (c) 2006 Marius Groeger (FPU operations)
+ *
+ * SPDX-License-Identifier: LGPL-2.1-or-later
+ */
+#ifndef TARGET_MIPS_FPU_TRANSLATE_H
+#define TARGET_MIPS_FPU_TRANSLATE_H
+
+#include "exec/translator.h"
+#include "translate.h"
+
+extern TCGv_i32 fpu_fcr0, fpu_fcr31;
+extern TCGv_i64 fpu_f64[32];
+
+void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg);
+void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg);
+
+int get_fp_bit(int cc);
+
+void check_cp1_enabled(DisasContext *ctx);
+
+#endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 6614512a828..bc54eb58c70 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -40,7 +40,9 @@
 #include "exec/log.h"
 #include "qemu/qemu-print.h"
 #include "fpu_helper.h"
+
 #include "translate.h"
+#include "fpu_translate.h"
 
 enum {
     /* indirect opcode tables */
@@ -2496,8 +2498,8 @@ static TCGv cpu_dspctrl, btarget;
 TCGv bcond;
 static TCGv cpu_lladdr, cpu_llval;
 static TCGv_i32 hflags;
-static TCGv_i32 fpu_fcr0, fpu_fcr31;
-static TCGv_i64 fpu_f64[32];
+TCGv_i32 fpu_fcr0, fpu_fcr31;
+TCGv_i64 fpu_f64[32];
 static TCGv_i64 msa_wr_d[64];
 
 #if defined(TARGET_MIPS64)
@@ -2813,7 +2815,7 @@ static void gen_store_fpr32h(DisasContext *ctx, TCGv_i32 t, int reg)
     }
 }
 
-static void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
+void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
 {
     if (ctx->hflags & MIPS_HFLAG_F64) {
         tcg_gen_mov_i64(t, fpu_f64[reg]);
@@ -2822,7 +2824,7 @@ static void gen_load_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
     }
 }
 
-static void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
+void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
 {
     if (ctx->hflags & MIPS_HFLAG_F64) {
         tcg_gen_mov_i64(fpu_f64[reg], t);
@@ -2836,7 +2838,7 @@ static void gen_store_fpr64(DisasContext *ctx, TCGv_i64 t, int reg)
     }
 }
 
-static inline int get_fp_bit(int cc)
+int get_fp_bit(int cc)
 {
     if (cc) {
         return 24 + cc;
@@ -2911,7 +2913,7 @@ static inline void check_cp0_enabled(DisasContext *ctx)
     }
 }
 
-static inline void check_cp1_enabled(DisasContext *ctx)
+void check_cp1_enabled(DisasContext *ctx)
 {
     if (unlikely(!(ctx->hflags & MIPS_HFLAG_FPU))) {
         generate_exception_err(ctx, EXCP_CpU, 1);
-- 
2.26.2

