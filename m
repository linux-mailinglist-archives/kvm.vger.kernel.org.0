Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37492CC5C7
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730945AbgLBSpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727454AbgLBSpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:45 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C254C061A49
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:44:57 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id 7so5990801ejm.0
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=g86VgmSNy4f4zzNJeVPl770oLi4Jhzj+nbmAAlUIF60=;
        b=Oi1mz7FptywDHxL4wFFotazbFkvsdN+8GtFfpfUzmHCiPc/x2VxgbGdYABGUrTFIbU
         5Hmko5FGjblPU29p6aui0qp6lJMZsFt92u1DXkyHFhFVxQNCQyXUaxO1CRI/M8hlioKF
         z8NaUrdaS0ptFNJ96W+aVYOn5EOkM4DBCzMrpZ112PWuQL6BS1jdFvt3UGE+hkXf2mL8
         DveDDsY4P6Yp1kXA0meLFC8kNo2Zm+ZO8yb257XDpNMHd0ieSMxfTKQHdwc43X+FNJmh
         jykwuofme+rQ2v8HYxmRURyGMbJjTCkqpgjCfRkljDq3OmfTpfzmMUSHVSoxmcVDsvH+
         ucGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=g86VgmSNy4f4zzNJeVPl770oLi4Jhzj+nbmAAlUIF60=;
        b=FoxGqa6KJgxGd59orZ/NuVzgrfbR4g6HXPxByvMANRVxeFifLOKR3ieWS79NeUkt9e
         mgvApQrsejJRaK1oWR4tmfpLYQ160fFTyMkES2cs3T5xtzXqVE12wMkNdFci6kKcsuRG
         yZLSHOM8/iA1sl+bp7enKHmQuVeRl90V/9n6KISty/KLLYp57z/SSv6X+ZL35g6NR4Fg
         SGwhWvgkGGkrLioQze5fNjov5niWq1NZ7aAUu9Yw1bG7izc0dYG/Jeh8CKucNWNkIGCD
         YOiSfR+So/+g9a2Mm/RFAVjy0oKvQwlr2dbzvmRjiZEsS2zkbjn+Zh4rNewCnk3NHkUt
         AGNA==
X-Gm-Message-State: AOAM530jlj3IKlFt+DSKwhJqqm6B+/+OZcyvbtcc5AFl+AsNYkc1hEJr
        fH+x8wXI7+hYcwqBLYfYe09Zb+8yL1E=
X-Google-Smtp-Source: ABdhPJwjeCuvpeuBnGWFwyPDgCk9BaHv5eStq6XWq+D3+5rh2254O9WeuxjHg+qB3zX5zSHBorSF5A==
X-Received: by 2002:a17:906:6713:: with SMTP id a19mr1164126ejp.468.1606934695848;
        Wed, 02 Dec 2020 10:44:55 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id d7sm575737edv.17.2020.12.02.10.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:44:55 -0800 (PST)
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
Subject: [PATCH 7/9] target/mips: Extract msa_translate_init() from mips_tcg_init()
Date:   Wed,  2 Dec 2020 19:44:13 +0100
Message-Id: <20201202184415.1434484-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
References: <20201202184415.1434484-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the logic initialization of the MSA registers from
the generic initialization.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 41880f21abd..a5112acc351 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31672,6 +31672,24 @@ void mips_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
+static void msa_translate_init(void)
+{
+    int i;
+
+    for (i = 0; i < 32; i++) {
+        int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
+
+        /*
+         * The MSA vector registers are mapped on the
+         * scalar floating-point unit (FPU) registers.
+         */
+        msa_wr_d[i * 2] = fpu_f64[i];
+        off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1]);
+        msa_wr_d[i * 2 + 1] =
+                tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2 + 1]);
+    }
+}
+
 void mips_tcg_init(void)
 {
     int i;
@@ -31685,22 +31703,9 @@ void mips_tcg_init(void)
     for (i = 0; i < 32; i++) {
         int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
 
-        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2]);
+        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, fregnames[i]);
     }
-    /* MSA */
-    for (i = 0; i < 32; i++) {
-        int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
-
-        /*
-         * The MSA vector registers are mapped on the
-         * scalar floating-point unit (FPU) registers.
-         */
-        msa_wr_d[i * 2] = fpu_f64[i];
-        off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1]);
-        msa_wr_d[i * 2 + 1] =
-                tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2 + 1]);
-    }
-
+    msa_translate_init();
     cpu_PC = tcg_global_mem_new(cpu_env,
                                 offsetof(CPUMIPSState, active_tc.PC), "PC");
     for (i = 0; i < MIPS_DSP_ACC; i++) {
-- 
2.26.2

