Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8D72EE892
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbhAGW1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbhAGW1J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:27:09 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F19A4C0612F9
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:26:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w5so7089020wrm.11
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sIZITomoctnrg7h438bGjGhxwrMRbJgeE72R2oM+qvs=;
        b=sSmpj4/wRqPA48lkOUtGrBDg+BaiS9WsRfX+STUuCl2/YlykDLj5gnH3I/shWnTzix
         O+IVGc7o1psx8VZcj+BmaNUWKTpQ37PDA/sK/uCgrlTud9mFxD4lw0P+uGl5SEToNvDH
         kEHJrUFldXp6vtuElqG9tXLYZLYMRF/o2nGs+fnN+pakzTlgUVRJivOoBBGSqDEAc1D0
         Vc3dCeu5Q/YStRUM/Aj45fYGaLyQ8DZk0iAsaoO6c55KwH5nMvT9QabStCu821OBnTE9
         nrxz/W29WSeKWns7KvIuTMri1j1Uy6f1a8lgjovyLA9gh5J+qKX7ozF9EsKeBEsTV6m1
         CZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=sIZITomoctnrg7h438bGjGhxwrMRbJgeE72R2oM+qvs=;
        b=GRKDQIn3BAnmXux1XNkdhwTI4Yg3QjstC7/9zLdwy33w0tC5/Stg1k+yYhJQT4oea4
         +8Qi/yyNcspe8m5foaSm6Fbwi9fs4vDuUq7fiPtrkhDOK52rNUQ+nHenhTnaT5NDtqGI
         PJHo7SjsGQPFu2lNu4ov0Uh3n2i2MCLld7UVWrjXYt0lGh4LQebfWuKCj9BGlz0CKEwg
         qF4j+2IjTurlbTKr37r1cedo6777reI3R/KdLPs4HbtLOrOKYyS55Rw1Qg2I6vQoZT7I
         RELUas2XZYDr0ofRmTal5sYWU0owQPISJq2n40eYaLyjEdPN4uEthA0LAkCDF4Xqn8OA
         scgA==
X-Gm-Message-State: AOAM533LVDnZ/8lcMZv2UM0y3QQgWXyTQHKaTKYYt1y+dGTgBoVk7Mbc
        EBKSNT7BavVyo40gMcU6iyg=
X-Google-Smtp-Source: ABdhPJyyA9DkDecms4e6imKW1wY4KetEc5pLg7CYsciqR3ze1CMjyrI87mZDUwtj/Zw1OWmM6byPBg==
X-Received: by 2002:adf:c387:: with SMTP id p7mr668077wrf.95.1610058387817;
        Thu, 07 Jan 2021 14:26:27 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id l5sm10517666wrv.44.2021.01.07.14.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:26:27 -0800 (PST)
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
Subject: [PULL 41/66] target/mips: Remove now unused ASE_MSA definition
Date:   Thu,  7 Jan 2021 23:22:28 +0100
Message-Id: <20210107222253.20382-42-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't use ASE_MSA anymore (replaced by ase_msa_available()
checking MSAP bit from CP0_Config3). Remove it.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-Id: <20201208003702.4088927-6-f4bug@amsat.org>
---
 target/mips/mips-defs.h    | 1 -
 target/mips/cpu-defs.c.inc | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 97866019a72..6b8e6800115 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -34,7 +34,6 @@
 #define ASE_MT            0x0000000040000000ULL
 #define ASE_SMARTMIPS     0x0000000080000000ULL
 #define ASE_MICROMIPS     0x0000000100000000ULL
-#define ASE_MSA           0x0000000200000000ULL
 /*
  *   bits 40-51: vendor-specific base instruction sets
  */
diff --git a/target/mips/cpu-defs.c.inc b/target/mips/cpu-defs.c.inc
index fe0f47aadf8..3d44b394773 100644
--- a/target/mips/cpu-defs.c.inc
+++ b/target/mips/cpu-defs.c.inc
@@ -410,7 +410,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 32,
         .PABITS = 40,
-        .insn_flags = CPU_MIPS32R5 | ASE_MSA,
+        .insn_flags = CPU_MIPS32R5,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -723,7 +723,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -763,7 +763,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -889,7 +889,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_LOONGSON3A | ASE_MSA,
+        .insn_flags = CPU_LOONGSON3A,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
-- 
2.26.2

