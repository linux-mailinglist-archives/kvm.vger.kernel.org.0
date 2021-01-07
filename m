Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D152EE877
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 23:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbhAGWZG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 17:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727624AbhAGWZF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 17:25:05 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76EE1C0612F6
        for <kvm@vger.kernel.org>; Thu,  7 Jan 2021 14:24:25 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id y17so7093834wrr.10
        for <kvm@vger.kernel.org>; Thu, 07 Jan 2021 14:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8VbnptZXgmw1r+fJKrz2Q7we2TDNwx1PgIcbr0B8enM=;
        b=vWEk798tkKQE/nbkyfZecpulRxQ1g9CZ1hflnEYJuTb9GxDtygEnCMLNsN3EucxS2q
         oCEDMtjH1rC4YAOr68TSV4itLsAji+Zc0MW+QwSHyoc1r8m8pIR0+iDNfbBuinMLuthC
         L/r1EuqQ6xuDF49Nuuu1rTL7wok0P2G4gufFVtMI9qfyzC0EwcPlxSHwO9T8R7Zo/Sut
         cw76yjxwPvXiKsRK5YZTKgI7pJ985o8lz80TN6O9zRYqGOV/eNvoW/etUkf+tEHIS/c4
         l6tSZCk8bHtICw89nlSz3aVHHkv47SbEwIgcp/zdk6MOcOqLNaECMyN6WrLBLb2IhGDD
         d52Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=8VbnptZXgmw1r+fJKrz2Q7we2TDNwx1PgIcbr0B8enM=;
        b=C2S3fj8uZcp4PsTBdVDxK5zppdHo/2tHm1nrSdjKCKNk1NAjcKL0h5NHByMfpCdh8p
         AsJGJp+pRLwxV3g/uZYCPcUjNWVspEKUhNZzFJP51efscZMMXFIPB1OaXnN/PPJbqIVH
         82UjTyLE5FKSqj+FVf46RAM3stKKHaHZIeKlOhBgRDFspD2IlIBwopC1XmXnHgYtTHmF
         OZGIVlJ9CFHmWfPVWDPbpFyy9znuxQbbgWxAr7cHPpxEUE3YjiYAKiZNtt+YbvzzYUP7
         /0QHj5W3sxB2TXltvO6ixBKeGEekfC9Oa/IOWaaGyZTtXH6jR5+UYGT1s48Ghlsqf+od
         6qfQ==
X-Gm-Message-State: AOAM531Pactl9tK/j/e7Lauh4YDx9aOnJQFjHzQ2mju8bFr7HWRmxmgH
        rxk5mCxFH9Bni7uJE0BtBuA=
X-Google-Smtp-Source: ABdhPJwgPM2/a71z5sYYShgXCbd3btGleobgBn7VBL17CWaY0SuEJ2YpO/wDeSbt636lq2M1sKJG8g==
X-Received: by 2002:a5d:6a88:: with SMTP id s8mr706468wru.118.1610058264312;
        Thu, 07 Jan 2021 14:24:24 -0800 (PST)
Received: from x1w.redhat.com (241.red-88-10-103.dynamicip.rima-tde.net. [88.10.103.241])
        by smtp.gmail.com with ESMTPSA id r82sm9930125wma.18.2021.01.07.14.24.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:24:23 -0800 (PST)
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
Subject: [PULL 17/66] target/mips/mips-defs: Rename ISA_MIPS32R5 as ISA_MIPS_R5
Date:   Thu,  7 Jan 2021 23:22:04 +0100
Message-Id: <20210107222253.20382-18-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107222253.20382-1-f4bug@amsat.org>
References: <20210107222253.20382-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The MIPS ISA release 5 is common to 32/64-bit CPUs.

To avoid holes in the insn_flags type, update the
definition with the next available bit.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Message-Id: <20210104221154.3127610-15-f4bug@amsat.org>
---
 target/mips/mips-defs.h | 4 ++--
 target/mips/translate.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/target/mips/mips-defs.h b/target/mips/mips-defs.h
index 12ff2b3280c..181f3715472 100644
--- a/target/mips/mips-defs.h
+++ b/target/mips/mips-defs.h
@@ -19,7 +19,7 @@
 #define ISA_MIPS_R1       0x0000000000000020ULL
 #define ISA_MIPS_R2       0x0000000000000040ULL
 #define ISA_MIPS_R3       0x0000000000000080ULL
-#define ISA_MIPS32R5      0x0000000000000800ULL
+#define ISA_MIPS_R5       0x0000000000000100ULL
 #define ISA_MIPS32R6      0x0000000000002000ULL
 #define ISA_NANOMIPS32    0x0000000000008000ULL
 /*
@@ -81,7 +81,7 @@
 #define CPU_MIPS64R3    (CPU_MIPS64R2 | CPU_MIPS32R3)
 
 /* MIPS Technologies "Release 5" */
-#define CPU_MIPS32R5    (CPU_MIPS32R3 | ISA_MIPS32R5)
+#define CPU_MIPS32R5    (CPU_MIPS32R3 | ISA_MIPS_R5)
 #define CPU_MIPS64R5    (CPU_MIPS64R3 | CPU_MIPS32R5)
 
 /* MIPS Technologies "Release 6" */
diff --git a/target/mips/translate.c b/target/mips/translate.c
index 9c71d306ee5..83fd6c473a5 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -10993,7 +10993,7 @@ static void gen_cp0(CPUMIPSState *env, DisasContext *ctx, uint32_t opc,
             if (ctx->opcode & (1 << bit_shift)) {
                 /* OPC_ERETNC */
                 opn = "eretnc";
-                check_insn(ctx, ISA_MIPS32R5);
+                check_insn(ctx, ISA_MIPS_R5);
                 gen_helper_eretnc(cpu_env);
             } else {
                 /* OPC_ERET */
-- 
2.26.2

