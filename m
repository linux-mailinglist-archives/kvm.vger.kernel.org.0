Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88E52DB6DF
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 00:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730421AbgLOW7t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:59:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730279AbgLOW7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:34 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF9EC0613D3
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:47 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p22so22778732edu.11
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8J3sFo3k2S1YmV6te7FAq6YGGAxZZACq8K+krD2ja+Y=;
        b=BmPmPgRoFcjepulKHlWeXFD97VHMYjpE19Xg5pW/CHYTCfOlgE+pSMvoT1OaoTVV//
         NQWJK4MoVz31Bj9vjGtYHyuB0MmvCjW29ft1wkKP3nrRpsc/9JVt1oAtG10pgePgMAub
         KVarmzNxbVMREmVttuG1Wn67oV/2TIJvQBdJ6bfS7goY+RO/PM4jkIvXGYEDd/zZSrjQ
         /U2Dv/9Z7GR1TxNVgqEzU1zFcpiWZ3PS1XtYbQ66/b9Xg8aOln1scJeVUTjTUEm65OIH
         rr2QXjRqedtRATJQKsGCFEenWCTs4LhUrXuFQZ9TsDVovRNbYEzGaWsme0LEvY9Dy2Xx
         dVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=8J3sFo3k2S1YmV6te7FAq6YGGAxZZACq8K+krD2ja+Y=;
        b=DAF0jwvKQaLsQXmA6rfACjCtMak3enLM8kyuWmLyZS3QJzaNdhDRQUTeHJs20QthnD
         wXXdWlcKm1WTu3Voxi0w+S/QU3H2VHyfdwu1N/ZaJOFgaNJS5c5BPMAcFiYrQHZA4u3Y
         c2o2pzfnZhbtPSxXJjhqXlqYWgZVjEhLVgnNXhdYd/auuK+1plmDu2xCPxLFCLUhbEzM
         8lCpaCpAS/wvY/eD4n77dTOU/dye2JlcDcoju8WczmrMzBi0DM6y5s8uQt0RFKyFSd/k
         HW51J0fcgSVsWbYuKXlU4Q1/lfX3gt43QaYLUPPe/UcluJht2bXPf7MxiAHmPBC4teUJ
         WmDQ==
X-Gm-Message-State: AOAM533qvI6qnFfPYkXbnjLWnNDnWOW9AF1ZQ3KDUl7gchhGZ3/0Xb7u
        EvRo7OoYPNAvvx6E1p4WKrY=
X-Google-Smtp-Source: ABdhPJxs1anFL48anFvNij5UZqX93iuISG9w1P3EGLDcSda41Z4Do1u27B3fRtD06FML0cUwb7VYQQ==
X-Received: by 2002:a05:6402:c4:: with SMTP id i4mr16884467edu.152.1608073125852;
        Tue, 15 Dec 2020 14:58:45 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id e11sm19258366edj.44.2020.12.15.14.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:45 -0800 (PST)
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
Subject: [PATCH v2 08/24] target/mips: Remove now unused ASE_MSA definition
Date:   Tue, 15 Dec 2020 23:57:41 +0100
Message-Id: <20201215225757.764263-9-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
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
---
 target/mips/mips-defs.h    | 1 -
 target/mips/cpu-defs.c.inc | 8 ++++----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index ed6a7a9e545..805034b8956 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -45,7 +45,6 @@
 #define ASE_MT            0x0000000040000000ULL
 #define ASE_SMARTMIPS     0x0000000080000000ULL
 #define ASE_MICROMIPS     0x0000000100000000ULL
-#define ASE_MSA           0x0000000200000000ULL
 /*
  *   bits 40-51: vendor-specific base instruction sets
  */
diff --git a/target/mips/cpu-defs.c.inc b/target/mips/cpu-defs.c.inc
index bf12e91f715..325b24b8e2c 100644
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
@@ -721,7 +721,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -761,7 +761,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -887,7 +887,7 @@ const mips_def_t mips_defs[] =
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

