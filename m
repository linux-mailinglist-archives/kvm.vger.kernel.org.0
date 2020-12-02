Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155CD2CC5C5
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 19:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389681AbgLBSpj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 13:45:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387932AbgLBSpi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 13:45:38 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED7EC061A48
        for <kvm@vger.kernel.org>; Wed,  2 Dec 2020 10:44:46 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id f23so5987209ejk.2
        for <kvm@vger.kernel.org>; Wed, 02 Dec 2020 10:44:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vLfle+Khrb+jNknl9qLNu4/IaRmhOoPiQ1bCWscTpa8=;
        b=k6LA4FjKbLo1e0EZcAw8OjDx6WJRuZ5isiJf2gQbNT7J7zzMdv0z55vmdw8Q453dXO
         09RT0/fwoLyjryvAieQaTswBEoRM4BNXid0l0uoXhQkvZMikjylHyqYWgFG+Ikd+Iivt
         kQDn7uSfPOKwyK96uoNxyjC6K7zfgA9HRwbrYHanRhpsoFx2OXl4JyHdu7pmOz2Zqc9U
         rveBrE3r+RK+pZwMkUirkq9bj0hubckUDcbo88yRk9FnlMV1XOGVT+8KjivlxjaB4ZA6
         2yu1Agbhe0LYXfcWHa0JmCga7AUWcDETq/bh2MXTOTq89D0nnAhR4V50nFbyr2y7Klvo
         qUJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=vLfle+Khrb+jNknl9qLNu4/IaRmhOoPiQ1bCWscTpa8=;
        b=JmupMP4qf3Vv8CaYnZoeJH7BEy+j+IKZtuG+wSP0vBEnsl/Nrb5nlyA7dcrbdlAFGo
         Gg6s57FrZRmaRCuM4oJOG4KDKEghvNXSIY629U661sMqmRoOm4GhSZhppuQiRzmjm9L9
         sZESQTnatRKP1ChL2JF5xOQJqmvo0+aJD143mYLutfqwwtlXAnGz2iaDwaGm3C6bo4x/
         wZnLOyyp+gHi4pRnbwzVF+1iUjTfy4g1rGdNaU2L1v95FB5EYKAzT/9Xh5L4W9daKtwC
         VCjvdwXdUH3IhU2uJVCbvw9dgznzRW8x/iAuHWwMPyVKMcn6yfCFFGRbYtcpGJqUpKdw
         B4vA==
X-Gm-Message-State: AOAM533Vrn0B4Kpl1ve51eMPXFoar9zDO2jQ6Ac2cvBJgZaxmFsqRcPE
        mJ7nY2TWJ52Y0xmwgoIgUJU=
X-Google-Smtp-Source: ABdhPJxANmBj/O2gJNTPFlCEZrpLeO/u99wBmHVQ9W8gHFrDNamvLDWP6Os/K+Pwap/GKdend2V7pQ==
X-Received: by 2002:a17:907:214d:: with SMTP id rk13mr1105171ejb.501.1606934685030;
        Wed, 02 Dec 2020 10:44:45 -0800 (PST)
Received: from x1w.redhat.com (111.red-88-21-205.staticip.rima-tde.net. [88.21.205.111])
        by smtp.gmail.com with ESMTPSA id z2sm506002edr.47.2020.12.02.10.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 10:44:44 -0800 (PST)
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
Subject: [PATCH 5/9] target/mips: Remove now unused ASE_MSA definition
Date:   Wed,  2 Dec 2020 19:44:11 +0100
Message-Id: <20201202184415.1434484-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201202184415.1434484-1-f4bug@amsat.org>
References: <20201202184415.1434484-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't use ASE_MSA anymore (replaced by ase_msa_available()
checking MSAP bit from CP0_Config3). Remove it.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/mips-defs.h          | 1 -
 target/mips/translate_init.c.inc | 8 ++++----
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
diff --git a/target/mips/translate_init.c.inc b/target/mips/translate_init.c.inc
index 3b069190ed8..2170f8ace6f 100644
--- a/target/mips/translate_init.c.inc
+++ b/target/mips/translate_init.c.inc
@@ -408,7 +408,7 @@ const mips_def_t mips_defs[] =
         .CP1_fcr31_rw_bitmask = 0xFF83FFFF,
         .SEGBITS = 32,
         .PABITS = 40,
-        .insn_flags = CPU_MIPS32R5 | ASE_MSA,
+        .insn_flags = CPU_MIPS32R5,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -719,7 +719,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -759,7 +759,7 @@ const mips_def_t mips_defs[] =
         .MSAIR = 0x03 << MSAIR_ProcID,
         .SEGBITS = 48,
         .PABITS = 48,
-        .insn_flags = CPU_MIPS64R6 | ASE_MSA,
+        .insn_flags = CPU_MIPS64R6,
         .mmu_type = MMU_TYPE_R4000,
     },
     {
@@ -885,7 +885,7 @@ const mips_def_t mips_defs[] =
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

