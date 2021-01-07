Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2BD2EE890
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728523AbhAGW0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727870AbhAGW0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:26:54 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC564C0612FB
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:38 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id t16so7146631wra.3
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DQ4NcLmRVy40lLGUZw2vzkfPGYpNttR3tCsf5kFmz/8=;
        b=IyXKkfNL7hGiSkGT4c/E2YerUGtsWqVoPs7ntAQbAB/la7lRak6q3Xy4FdAmnnrlyX
         yTLKIw/ZKXBLE6g+JaVbm/fO+I0iACnENjMN9YUC+Y3cBss37hOpBZa4Ffp12znPv8zc
         B/goa6jsw9so7QJyZ7ldnRr7sDCI8qoHLgOgxJHYwNXrEInL27gR8NIW49bVyAxTpe5W
         nfWygBarjnRIuk0B0pvRAWoGXx1VSuasC/Z3NxNQ1VHhtSM1bRupoB/FMuCAMjvoqBIt
         bEXnEMQBFJoOC7qQ1T1dZhyJYmAaI1DXZJofh5F3ILUaeHVNBgN94LTe766acm0SBE1A
         rkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DQ4NcLmRVy40lLGUZw2vzkfPGYpNttR3tCsf5kFmz/8=;
        b=ZMdjsmdyCs5qOJDRbfkeMoTaAW3SmDnIF6Y2qyrWePbJYzd6S8pxgbopqFL+UDPDvz
         9VPFtfatkfw5ASz4g5MVz+gxFWQbHjYYFMcPML3G0AnVS5FWUkNNeB9PHKi9nry9rmKk
         f1kuXFiayLANNWTGYCfwZACVNb6uoBqZomJ59SD6O57TQtsJKM/T+IdiBqa+styya1W0
         N02rV7G8CAZnrTF6b+1ZJoH4ugt+5r+GrQ8F6Q43S+Xtk1kGeTlM3tvTzc+cjx4cFh3C
         5qvzmMzJVR0Vd34aWqJDgyb4TyGliNKqQVmOSIxgqxEZ2RyOLDXi9J67m8eOqx+AZADG
         8ZBg==
X-Gm-Message-State: AOAM530PH8rS5ngGcjeU6DaIEsreySZEJQ1By+R1o090Uh3/3aS6Iwmh
        9xXz7Tr0+0h41V/T52me6f4=
X-Google-Smtp-Source: ABdhPJzthOoRVhYBVewfdJ5SzxIvoMQCudwx3jqR+BRb0cS7J1Aphov0/3GbpoYqe8QCK8ssEDuSNA==
X-Received: by 2002:a5d:4704:: with SMTP id y4mr670512wrq.358.1610058397783;
        Thu, 07 Jan 2021 14:26:37 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c20sm9452590wmb.38.2021.01.07.14.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:37 -0800 (PST)
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
Subject: [PULL 43/66] target/mips: Extract msa_translate_init() from mips_tcg_init()
Date:   Thu,  7 Jan 2021 23:22:30 +0100
Message-Id: <20210107222253.20382-44-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The msa_wr_d[] registers are only initialized/used by MSA.

They are declared static. We want to move them to the new
'msa_translate.c' unit in few commits, without having to
declare them global (with extern).

Extract first the logic initialization of the MSA registers
from the generic initialization. We will later move this
function along with the MSA registers to the new C unit.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-8-f4bug@amsat.org>
---
 target/mips/translate.h |  3 +++
 target/mips/translate.c | 33 +++++++++++++++++++--------------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/target/mips/translate.h b/target/mips/translate.h
index 402bc5e8846..b9cd315c7f4 100644
--- a/target/mips/translate.h
+++ b/target/mips/translate.h
@@ -162,4 +162,7 @@ extern TCGv bcond;
         }                                                                     \
     } while (0)
 
+/* MSA */
+void msa_translate_init(void);
+
 #endif
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 30354fee828..bb9420b9f7f 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31551,6 +31551,24 @@ void mips_cpu_dump_state(CPUState *cs, FILE *f, int flags)
     }
 }
 
+void msa_translate_init(void)
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
@@ -31566,20 +31584,7 @@ void mips_tcg_init(void)
 
         fpu_f64[i] = tcg_global_mem_new_i64(cpu_env, off, fregnames[i]);
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

