Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70392DB6E0
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgLOW7m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:59:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbgLOW7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:34 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADE9C061793
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:52 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id b9so5110085ejy.0
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kJqpgT5cCXxYnWxKZzDjzqN8ClALR+aWkwE4xRgW0a0=;
        b=gTO8VbKJ+idG2rHsFWBqs6EjX1k4dH114g1aphDFM3hLMNDb/c/bqfhzs1q4fu1A6U
         QSUJQQ6CFv/N4acZmCNDJAwZ+Wl2IXvvTU5/Sgws6RvECY3y8X3EUFjrHZGVSOPGuvzh
         CdTcqTuGtjy1lhsBqiaWfj23F0E1jCQHjQQcuO+3VVgS0GZ/6MhHuNFSXZVNlCxcgOqQ
         MRF22jmEa6JnjddJrcDSW00rYOY1mUjoN4Dp8sHLiKNQ+V8GviQ1i0Kcfbjvwo3SAjpX
         sYp2tadnX+jkOmRCQuBlF9syseKhN8B52YsnTgHdvY1mVbq+6g3JYJ9LzkwzdMjY+GiK
         6yCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=kJqpgT5cCXxYnWxKZzDjzqN8ClALR+aWkwE4xRgW0a0=;
        b=KIqtudPZYAjASURMztWBGbcTRFuIm9jQ5aF5QpwotozUpxWKVAVi9UhtO77ouWTSWs
         143+6quJBTKE7DeTgCacTv/HkSJ1zwwswB76/pftQ2iGetmvgoraVtodlpNLd8m1rHuK
         V0ADUplOaflG4kGQpD+xBEruZyYTh4D25x4MkWAp08m4z3JiCDVgh4FYKX4Ll30u3SbM
         soeBkZC2PmLqtqSGOalz0EPVwy0wjznCIkVlnqxKf91Ojky12eeuB5FzXdK/WN9fn8NS
         1WqK9SgZwtggGaGbJXE8ePYuy3qnlisl861FjHJLHdVTZTx1JJJkmFxKGPCxqzc8GzQs
         q3cQ==
X-Gm-Message-State: AOAM532oUHiixHiDfbArgjcaMIp8AdmWKoTZQGr/c+hmp/kT/dotNIqp
        tFiKimYwSiy0WYFFZsYxy/U=
X-Google-Smtp-Source: ABdhPJw6mJBdcLNfKfj0SBcmVGdXRaRrc1mUEGLeCBa59IbS65+5glqmmr1YxvxsTtTDqdGRw3btTQ==
X-Received: by 2002:a17:906:3a84:: with SMTP id y4mr28571019ejd.425.1608073131484;
        Tue, 15 Dec 2020 14:58:51 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id bo20sm19594936edb.1.2020.12.15.14.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:50 -0800 (PST)
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
Subject: [PATCH v2 09/24] target/mips: Alias MSA vector registers on FPU scalar registers
Date:   Tue, 15 Dec 2020 23:57:42 +0100
Message-Id: <20201215225757.764263-10-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commits 863f264d10f ("add msa_reset(), global msa register") and
cb269f273fd ("fix multiple TCG registers covering same data")
removed the FPU scalar registers and replaced them by aliases to
the MSA vector registers.

It is not very clear to have FPU registers displayed with MSA
register names, even if MSA ASE is not present.

Instead of aliasing FPU registers to the MSA ones (even when MSA
is absent), we now alias the MSA ones to the FPU ones (only when
MSA is present).

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/translate.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index 02ea184f9a3..9b5b551b616 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31560,16 +31560,20 @@ void mips_tcg_init(void)
                                         offsetof(CPUMIPSState,
                                                  active_tc.gpr[i]),
                                         regnames[i]);
-
     for (i = 0; i < 32; i++) {
         int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
-        msa_wr_d[i * 2] =
-                tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2]);
+
+        fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, fregnames[i]);
+    }
+    /* MSA */
+    for (i = 0; i < 32; i++) {
+        int off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[0]);
+
         /*
-         * The scalar floating-point unit (FPU) registers are mapped on
-         * the MSA vector registers.
+         * The MSA vector registers are mapped on the
+         * scalar floating-point unit (FPU) registers.
          */
-        fpu_f64[i] = msa_wr_d[i * 2];
+        msa_wr_d[i * 2] = fpu_f64[i];
         off = offsetof(CPUMIPSState, active_fpu.fpr[i].wr.d[1]);
         msa_wr_d[i * 2 + 1] =
                 tcg_global_mem_new_i64(cpu_env, off, msaregnames[i * 2 + 1]);
-- 
2.26.2

