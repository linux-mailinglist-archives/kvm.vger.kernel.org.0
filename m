Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93F82EE868
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbhAGWY3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:24:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728206AbhAGWY2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:24:28 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCB3C0612FB
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:23:28 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id y23so6835681wmi.1
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CCcScCerij69CQ6oZxOAaSELOgitQBqHQwR1Q8IbG/E=;
        b=Gh1Hsp51UHuTegHxXpED3GcTcd9CTxlel1n8ImSOclnsGAX/HRzESqbamlHxeNmmHB
         gaEDPEqoOCVUJBCa3QkTdiYiVZUfwysSUvJ+BRur0iiPySyeMh3ZRRhsaLucT0PQhDGx
         5ec4RWI8RUw0dXZhqpHAM69kVjDWwGiCMx8mG6YxtIlbQFN3Sd0ArfN8O1k3AaynPgh/
         Y3Vs+tXzvW4LFM7iGQKBDiBFe2bnADHhdFTjzBpX6D+q4wuk9f8P6t3WGtV97Plgb5s1
         9XnjK927XYUa1zGPHqN0IQiAuD8L48E82yWwwkN3nIZgl9L2wqh/xfqDY7WRTYA5C22N
         dJTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=CCcScCerij69CQ6oZxOAaSELOgitQBqHQwR1Q8IbG/E=;
        b=dKWM6gXNldNDwWac75gTQ+i0rxgGH59zZxjctT6nwyeeeuh87QJ48jRdzqHzbpwDOh
         WQutdQ0FhSiF0VzmO+pwgZqRbrdLa5gOKsKBGPrDTdq+doCd07ANbdgCOk/Jjxm4s/vP
         GiqHTX3NhalxC2mJCEggiV07S+iJxfHJXj9aNYjp3yuARkzd+rNFDlSwY3WUpi1pJACA
         zn0Cs3e8yPQCHHmNGLGECF9zFqfqcwebIjOys3UyAaKu7pyFe0RtPpLIrIZMYJa6f4xK
         MRRjyELKiX4D7sI/G1a65wB9bt2xnvqvS03d+oR19TZZm31+uxFpwy2WZRN3HuTrHJNG
         oCiw==
X-Gm-Message-State: AOAM533pewfRHKRmxvzpnp70cOBYS2ttrxqn4iDQ5nJORWERLzGnC0U8
        wAW6UWOjV1VObUYhSbz+Wms=
X-Google-Smtp-Source: ABdhPJy/gw9y0iLygnNYCRbNVdeUgo3SJN/NH5crn6wIfiA04NxP/S7hfoDf86Rn9ZrhmLpdiaeK+g==
X-Received: by 2002:a7b:cb4f:: with SMTP id v15mr489712wmj.123.1610058207316;
        Thu, 07 Jan 2021 14:23:27 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id c7sm11506623wro.16.2021.01.07.14.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:23:26 -0800 (PST)
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
Subject: [PULL 06/66] target/mips/mips-defs: Rename CPU_MIPSxx Release 1 as CPU_MIPSxxR1
Date:   Thu,  7 Jan 2021 23:21:53 +0100
Message-Id: <20210107222253.20382-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'CPU_MIPS32' and 'CPU_MIPS64' definitions concern CPUs implementing
the "Release 1" ISA. Rename it with the 'R1' suffix, as the other
CPU definitions do.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20210104221154.3127610-4-f4bug@amsat.org>
---
 target/mips/mips-defs.h          |  8 ++++----
 target/mips/translate_init.c.inc | 14 +++++++-------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 48544ba73b4..1630ae20d59 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -72,12 +72,12 @@
 #define CPU_LOONGSON2F  (CPU_MIPS3 | INSN_LOONGSON2F | ASE_LMMI)
 
 /* MIPS Technologies "Release 1" */
-#define CPU_MIPS32      (CPU_MIPS2 | ISA_MIPS32)
-#define CPU_MIPS64      (CPU_MIPS5 | CPU_MIPS32 | ISA_MIPS64)
+#define CPU_MIPS32R1    (CPU_MIPS2 | ISA_MIPS32)
+#define CPU_MIPS64R1    (CPU_MIPS5 | CPU_MIPS32R1 | ISA_MIPS64)
 
 /* MIPS Technologies "Release 2" */
-#define CPU_MIPS32R2    (CPU_MIPS32 | ISA_MIPS32R2)
-#define CPU_MIPS64R2    (CPU_MIPS64 | CPU_MIPS32R2 | ISA_MIPS64R2)
+#define CPU_MIPS32R2    (CPU_MIPS32R1 | ISA_MIPS32R2)
+#define CPU_MIPS64R2    (CPU_MIPS64R1 | CPU_MIPS32R2 | ISA_MIPS64R2)
 
 /* MIPS Technologies "Release 3" */
 #define CPU_MIPS32R3    (CPU_MIPS32R2 | ISA_MIPS32R3)
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index cac3d241831..0ba3cf18ef7 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -72,7 +72,7 @@ const mips_def_t mips_defs[] =
         .CP0_Status_rw_bitmask = 0x1278FF17,
         .SEGBITS = 32,
         .PABITS = 32,
-        .insn_flags = CPU_MIPS32,
+        .insn_flags = CPU_MIPS32R1,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -94,7 +94,7 @@ const mips_def_t mips_defs[] =
         .CP0_Status_rw_bitmask = 0x1258FF17,
         .SEGBITS = 32,
         .PABITS = 32,
-        .insn_flags = CPU_MIPS32 | ASE_MIPS16,
+        .insn_flags = CPU_MIPS32R1 | ASE_MIPS16,
         .mmu_type = MMU_TYPE_FMT,
     },
     {
@@ -114,7 +114,7 @@ const mips_def_t mips_defs[] =
         .CP0_Status_rw_bitmask = 0x1278FF17,
         .SEGBITS = 32,
         .PABITS = 32,
-        .insn_flags = CPU_MIPS32,
+        .insn_flags = CPU_MIPS32R1,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -134,7 +134,7 @@ const mips_def_t mips_defs[] =
         .CP0_Status_rw_bitmask = 0x1258FF17,
         .SEGBITS = 32,
         .PABITS = 32,
-        .insn_flags = CPU_MIPS32 | ASE_MIPS16,
+        .insn_flags = CPU_MIPS32R1 | ASE_MIPS16,
         .mmu_type = MMU_TYPE_FMT,
     },
     {
@@ -552,7 +552,7 @@ const mips_def_t mips_defs[] =
         .CP0_Status_rw_bitmask = 0x12F8FFFF,
         .SEGBITS = 42,
         .PABITS = 36,
-        .insn_flags = CPU_MIPS64,
+        .insn_flags = CPU_MIPS64R1,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -578,7 +578,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 42,
         .PABITS = 36,
-        .insn_flags = CPU_MIPS64,
+        .insn_flags = CPU_MIPS64R1,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -607,7 +607,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 40,
         .PABITS = 36,
-        .insn_flags = CPU_MIPS64 | ASE_MIPS3D,
+        .insn_flags = CPU_MIPS64R1 | ASE_MIPS3D,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
-- 
2.26.2

