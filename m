Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41F3B2EE869
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:25:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbhAGWYd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728249AbhAGWYd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:33 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2EAC0612FD
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:33 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 190so6374786wmz.0
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Ch2a+v0V9pkwP2v4j689PWjNoR3rWExCE6zEXoddgE=;
        b=F57d2OKfrrp3wKUvNPdjKLIL1JjNbvqvSnUIGGYAFlnUEwYJnSrIJsmBM3RopRak9i
         ls8Hc9/z/VQpZL94Dgnuyez4a+4GmKVJ62vwUqMEXw1LqLFfAnKx55tyLiO+x6i6DKlE
         I0v9utPtcgZ8vGF/WVznVUUdeCoFsO1n67keu/29bZzyZxHHiX4COkED1sqeGQ5J+Rue
         fnz389ZQnM28/Y/Kexe39hHI8ybzDH8A3IrPf4WghREr8/W7OGaCfc7hgc7dOzvInRDF
         UsU6w7c3BBPtLA+fqNYIJKRDRbKhtE8ErP0MIJocmoo9Meg5sLsXnXF1VF4Uqu2Kg36R
         zsnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=3Ch2a+v0V9pkwP2v4j689PWjNoR3rWExCE6zEXoddgE=;
        b=mfkAsZsrX6eF5RdZZ8U3Q281H709IvTutc5hk1oVBxl4TJFyGuO14LA3rjKt8VGB7p
         vF7L9prFR7y/MQtNrKpXhivnG49TEEYWTxhHaEPtoytGVxi26GPTgnoOcUXjAzNXI4ZN
         tShtuvwL9LnstZAUS/g9COMAHu/Nd4YhkttLswLXRq33Wfp+AIHFhH17FSW0sKW9UFqf
         5YP96rIb1ihVoBfiApbLFlMm1bTvrbKEe/KuyJuh9S3boWUSENc+Bwa92Pw8AwWiHGAb
         VYex/vEw3rlMTV0odHfUsXWYNEA9WkSwdcYVW+q7/KXeXW038i1oLWsmCRq8NdxxNiPK
         uBsg==
X-Gm-Message-State: AOAM530UsnXx1nRCaNF3nlbLrnZxs3EVPSm/D9k+em5u9WHmsRJfcH2z
        HogKEZeNc55x5avTOjX3bEE=
X-Google-Smtp-Source: ABdhPJzdXdIKcSBucUT3pYndkmoS5x60aKLlSZfLFhp/WfE/w7yrlfWqPpWEEiHMXDU748QZYuCVww==
X-Received: by 2002:a1c:9692:: with SMTP id y140mr528197wmd.128.1610058212530;
        Thu, 07 Jan 2021 14:23:32 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id h3sm9671549wmm.4.2021.01.07.14.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:31 -0800 (PST)
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
Subject: [PULL 07/66] target/mips/mips-defs: Introduce CPU_MIPS64 and cpu_type_is_64bit()
Date:   Thu,  7 Jan 2021 23:21:54 +0100
Message-Id: <20210107222253.20382-8-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

MIPS 64-bit ISA is introduced with MIPS3.

Introduce the CPU_MIPS64 definition aliased to the MIPS3 ISA,
and the cpu_type_is_64bit() method to check if a CPU supports
this ISA (thus is 64-bit).

Suggested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20210104221154.3127610-5-f4bug@amsat.org>
---
 target/mips/cpu.h       | 5 +++++
 target/mips/mips-defs.h | 4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 0c2d397e4a9..9c45744c5c1 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1305,6 +1305,11 @@ static inline bool ase_mt_available(CPUMIPSState *env)
     return env->CP0_Config3 & (1 << CP0C3_MT);
 }
 
+static inline bool cpu_type_is_64bit(const char *cpu_type)
+{
+    return cpu_type_supports_isa(cpu_type, CPU_MIPS64);
+}
+
 void cpu_set_exception_base(int vp_index, target_ulong address);
 
 /* addr.c */
diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 1630ae20d59..89a9a4dda31 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -13,7 +13,7 @@
  */
 #define ISA_MIPS1         0x0000000000000001ULL
 #define ISA_MIPS2         0x0000000000000002ULL
-#define ISA_MIPS3         0x0000000000000004ULL
+#define ISA_MIPS3         0x0000000000000004ULL /* 64-bit */
 #define ISA_MIPS4         0x0000000000000008ULL
 #define ISA_MIPS5         0x0000000000000010ULL
 #define ISA_MIPS32        0x0000000000000020ULL
@@ -71,6 +71,8 @@
 #define CPU_LOONGSON2E  (CPU_MIPS3 | INSN_LOONGSON2E)
 #define CPU_LOONGSON2F  (CPU_MIPS3 | INSN_LOONGSON2F | ASE_LMMI)
 
+#define CPU_MIPS64      (ISA_MIPS3)
+
 /* MIPS Technologies "Release 1" */
 #define CPU_MIPS32R1    (CPU_MIPS2 | ISA_MIPS32)
 #define CPU_MIPS64R1    (CPU_MIPS5 | CPU_MIPS32R1 | ISA_MIPS64)
-- 
2.26.2

