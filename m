Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 858AA2D906D
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405302AbgLMUV4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404225AbgLMUV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:56 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41CAC06179C
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:14 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id v14so11954045wml.1
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BwBCSJKUs74AgI90rgGgJ5DnyTy76Cwmh6AmTQxT6D8=;
        b=mrwpFWGC/8qrenEQFhf/VblmOHmQoA6rejjcRRVDeYwpRb49BQO8vN8IeucQNyvrtF
         f8YuxMsC/iKs1KnLM42AK032qwQW6l08i6+WiyZDZK6g6QWF4NM+9+VGOd3vLxmT/7Qi
         ccFby7l/TiVjCbtXYXFPy+2pgJoFqeSrI59iqIwfv3HsS6nVHPMaVXFf5lZVFu7AX39r
         jWGdRsJxAltvakb4Mt5uDaC8KH3wT0ikuaV+GraTYk0xm8X5YbCOlXXnM2oGq16xiT8y
         vnVMGbcFrCJe28hJIbBHmyESd2jtuTxLLL7rxUCjjEMqKleKO1LzwlpHA9T4SRG4Yxtb
         dHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=BwBCSJKUs74AgI90rgGgJ5DnyTy76Cwmh6AmTQxT6D8=;
        b=me9fCVPayM4sUep1H6yF1saiNFnonXsJgxcinMHEgmd70StXy5pdRZ3aRG3FtYmD/q
         kjrD11TS1BB96hi4/rGr3AYKPWzT9ji8wolDAbduZ6LhW4cbSase3A8vUVz5QgBNZ1xD
         Gcp9VNqV7KL1C9OOyCJvwDfuKf/r6axNs3VUhOfPSWrvh8kybmoGlKAldJftKbbp0lpo
         Ml0F2SBZgkhG28/Y/BDYCbeh4Rhp2ut+G5u/UsO28Nrx6X5NM1hKiv6f86YHSeVB7X2W
         SDMmbNCgVxsvMSnqVZg4voJWRoUB6XL+vl6zP8pOBgVZaQDwYaaHhochfzeekD29uFiO
         Twmg==
X-Gm-Message-State: AOAM533hGoFq45iFzNczA/H3jwS4yUj2TK3t31w+0KGRDxZAjI4reeyI
        NpSEEOr5YGHFPVCibHScPoQ=
X-Google-Smtp-Source: ABdhPJyjCdeXDlFSxrZSqJn/AgC7v3c15fguzRGYdbHseBQtSeIjGz1sP0ZJiYfQIPcPfGi/6wFVDw==
X-Received: by 2002:a1c:2288:: with SMTP id i130mr24700600wmi.78.1607890873572;
        Sun, 13 Dec 2020 12:21:13 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h184sm28789455wmh.23.2020.12.13.12.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:21:12 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        kvm@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Paul Burton <paulburton@kernel.org>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 17/26] target/mips: Introduce ase_mt_available() helper
Date:   Sun, 13 Dec 2020 21:19:37 +0100
Message-Id: <20201213201946.236123-18-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of accessing CP0_Config3 directly and checking
the 'Multi-Threading Present' bit, introduce an helper
to simplify code review.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201204222622.2743175-3-f4bug@amsat.org>
---
 target/mips/cpu.h        | 7 +++++++
 hw/mips/cps.c            | 3 +--
 target/mips/cp0_helper.c | 2 +-
 target/mips/cpu.c        | 2 +-
 target/mips/helper.c     | 2 +-
 target/mips/translate.c  | 2 +-
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 5d3b2a01c01..3ac21d0e9c0 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1289,6 +1289,13 @@ int cpu_mips_signal_handler(int host_signum, void *pinfo, void *puc);
 bool cpu_type_supports_cps_smp(const char *cpu_type);
 bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask);
 bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa);
+
+/* Check presence of multi-threading ASE implementation */
+static inline bool ase_mt_available(CPUMIPSState *env)
+{
+    return env->CP0_Config3 & (1 << CP0C3_MT);
+}
+
 void cpu_set_exception_base(int vp_index, target_ulong address);
 
 /* addr.c */
diff --git a/hw/mips/cps.c b/hw/mips/cps.c
index 962b1b0b87c..7a0d289efaf 100644
--- a/hw/mips/cps.c
+++ b/hw/mips/cps.c
@@ -58,8 +58,7 @@ static void main_cpu_reset(void *opaque)
 
 static bool cpu_mips_itu_supported(CPUMIPSState *env)
 {
-    bool is_mt = (env->CP0_Config5 & (1 << CP0C5_VP)) ||
-                 (env->CP0_Config3 & (1 << CP0C3_MT));
+    bool is_mt = (env->CP0_Config5 & (1 << CP0C5_VP)) || ase_mt_available(env);
 
     return is_mt && !kvm_enabled();
 }
diff --git a/target/mips/cp0_helper.c b/target/mips/cp0_helper.c
index cb899fe3d73..36a92857bfb 100644
--- a/target/mips/cp0_helper.c
+++ b/target/mips/cp0_helper.c
@@ -1164,7 +1164,7 @@ void helper_mtc0_entryhi(CPUMIPSState *env, target_ulong arg1)
     old = env->CP0_EntryHi;
     val = (arg1 & mask) | (old & ~mask);
     env->CP0_EntryHi = val;
-    if (env->CP0_Config3 & (1 << CP0C3_MT)) {
+    if (ase_mt_available(env)) {
         sync_c0_entryhi(env, env->current_tc);
     }
     /* If the ASID changes, flush qemu's TLB.  */
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 687e2680dd1..9d7edc1ca21 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -74,7 +74,7 @@ static bool mips_cpu_has_work(CPUState *cs)
     }
 
     /* MIPS-MT has the ability to halt the CPU.  */
-    if (env->CP0_Config3 & (1 << CP0C3_MT)) {
+    if (ase_mt_available(env)) {
         /*
          * The QEMU model will issue an _WAKE request whenever the CPUs
          * should be woken up.
diff --git a/target/mips/helper.c b/target/mips/helper.c
index 59de58fcbc9..0c657865793 100644
--- a/target/mips/helper.c
+++ b/target/mips/helper.c
@@ -419,7 +419,7 @@ void cpu_mips_store_status(CPUMIPSState *env, target_ulong val)
         tlb_flush(env_cpu(env));
     }
 #endif
-    if (env->CP0_Config3 & (1 << CP0C3_MT)) {
+    if (ase_mt_available(env)) {
         sync_c0_status(env, env, env->current_tc);
     } else {
         compute_hflags(env);
diff --git a/target/mips/translate.c b/target/mips/translate.c
index f218997f049..ccc82abce04 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31917,7 +31917,7 @@ void cpu_state_reset(CPUMIPSState *env)
 
     cpu_mips_store_count(env, 1);
 
-    if (env->CP0_Config3 & (1 << CP0C3_MT)) {
+    if (ase_mt_available(env)) {
         int i;
 
         /* Only TC0 on VPE 0 starts as active.  */
-- 
2.26.2

