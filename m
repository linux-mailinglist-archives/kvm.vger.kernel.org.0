Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BA1C2EE894
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbhAGW1P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbhAGW1O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:14 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F7CC0612FA
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:33 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r3so7143876wrt.2
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SLgFG7YcdrjVHzWVWnO7xpT2n5lITWbqMk/I8sXWfOk=;
        b=d/2kXACMCYQclLA1uft/PbEWTToOKXFyqPw7O1axl2zel4sbNPxpmJ5XC3TjHwoKyb
         CEzzvJI4PAqaea5ghcON4a6gP4M65sPAYy7wEC2imtZENY4uqrK0U6GLXZoPEZmTbNFO
         Np8//S9+Sl80Rp9AsJZ/sD/GMGolPSyN7A8loIZENr/TZNM45KsGZ1hIzHPRSqUOIj1Q
         r8lsYqMDqomOL6eczMsHZ4A5ZPjr6gArW2M+DOv6QJzEmGkAflMzXJ1cDfjaBSf5F5cj
         oC5/V/JYLot/Yg2ZuVl7Hc40x8cq5/jIAU/b4ld7YGv+wvO0wTR70yV/5b+r/zJAPjES
         PgcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=SLgFG7YcdrjVHzWVWnO7xpT2n5lITWbqMk/I8sXWfOk=;
        b=gXy7LG57fxuRo86f74dpv0NDwcYd/lJ4VI2vGNvB3zYOu8jaspl5JVS9VO/Q6BeZt8
         V0YMdkyF6TMe95LPdmQCz97r9dpu5Bd4xRjRnCKSa94vI2/Bbv9ZIZ1j5PIunPF1eEZ5
         hdZYnsm9bgDymnMquuzpLhOm3swgVryeY05kSBQAz7cCYyObs5raLtWQZMI18yVMd2n+
         x75AjAChGgU2l6mpSRLWGgCyENNRZcCQKugbDfOEZHwqSPqZcRHeJw1+ArHpAAod6v+w
         8aWhbqVQrmPHJ1gzbVyi4SwF9ctdlcAFjTrEiwMpgo22sQt3Stc+CH2dEsmgsXD2CmqM
         jTpQ==
X-Gm-Message-State: AOAM532xOGYHE52F1tq6disML0+F26XbrpRGmsosbpSdLw+cDxwTQYwy
        +9L1t3j89fVnqk4wttEWwnU=
X-Google-Smtp-Source: ABdhPJwABwkMalCqlOIOuUNqZu3FWRSiPZD48Pp+/a8H7j6j4kjy5sVuElCjluc7YUiLCJi3AklShw==
X-Received: by 2002:a5d:6944:: with SMTP id r4mr688892wrw.134.1610058392803;
        Thu, 07 Jan 2021 14:26:32 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id o124sm10003482wmb.5.2021.01.07.14.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:32 -0800 (PST)
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
Subject: [PULL 42/66] target/mips: Alias MSA vector registers on FPU scalar registers
Date:   Thu,  7 Jan 2021 23:22:29 +0100
Message-Id: <20210107222253.20382-43-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
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
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-7-f4bug@amsat.org>
---
 target/mips/translate.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/target/mips/translate.c b/target/mips/translate.c
index e3cea5899f3..30354fee828 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31561,16 +31561,20 @@ void mips_tcg_init(void)
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

