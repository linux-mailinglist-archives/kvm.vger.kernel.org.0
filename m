Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A65DC2DB6B9
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728268AbgLOW7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 17:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgLOW7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Dec 2020 17:59:09 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF369C0617A6
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:24 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id b9so5109005ejy.0
        for <kvm@vger.kernel.org>; Tue, 15 Dec 2020 14:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+wY9Wxdfz8Q05SZXY3w48hyJcCL39vkqVQj5St83H/w=;
        b=GcAigDrbQLzOEAbrwidZpxN3admNCJMSaudn0ivWvxhNktukMBj0fo0yonOBBXDtAn
         ELcE2tBAf+8gJHst79f+6XryZ6ptaysj5mpNvo448Dk+FYx5onMDZWnUyshkaFP0aeI7
         fagA0KEYd53PPDYXjfgDypcgJ4I3Jj3vbZnZ+8VXuMDBkwzEancNWdoVvhOmRUjkLJ3K
         O37mugRMTBJVK0eW/ywUQiAnzd1sZOFLkw3wMFD5KJu+bp3gbSmFnunP/vlvyW7l79+7
         5RUcaNB5rhVTMxV6APoUMSuS3UXhBxG7+RwFe5knb1SAsDiCQx+YmqtvyNi+GZPiHOQn
         6Zfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=+wY9Wxdfz8Q05SZXY3w48hyJcCL39vkqVQj5St83H/w=;
        b=AWtb5VzV0mT5F2ur4upg//ULvsWoTh7iVkxQnQiOiggomKfAoYK0KBRNUJUds/GcTM
         e2EBiNDMwCvH9XVHKrkMVTErVpyJrPffjLS4cRyyYiOjAolAD2Bl/lEnyXb18rhpm90/
         hSX0j+ht2OFCa/9j2UOup5LeddrO4OqEmw61zdvloTdFvitzewUXu/TwMbxdzmkumA07
         TzRHME75EXCD+uDNzbvNxIKjOIk9hsu08jvJXGt4722QZBlVqSeNFjecnItOhKr3IfrH
         J3kJ6Avruobgbma+4s0Pb6xKB1VzkVKq3ItitXC0PBYXoEvT7wyZHmnmpDCzuv2TtTpX
         +OLQ==
X-Gm-Message-State: AOAM532Yw33SO8aSt58m6fnQhLgt7xkO6/vbikwCBgcGaxrph9E0cfQW
        D2duT7FrmyljI/nUOvTAdME=
X-Google-Smtp-Source: ABdhPJysJBw/ijI2j8W8zKgKL6O2UflTWr8SqHldf1JMKj1Szq6aQAbJ5n/eI2DBnZIywd1nbmwueA==
X-Received: by 2002:a17:906:8051:: with SMTP id x17mr8771161ejw.430.1608073103571;
        Tue, 15 Dec 2020 14:58:23 -0800 (PST)
Received: from x1w.redhat.com (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id dd12sm19502228edb.6.2020.12.15.14.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 14:58:22 -0800 (PST)
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
Subject: [PATCH v2 04/24] target/mips: Introduce ase_msa_available() helper
Date:   Tue, 15 Dec 2020 23:57:37 +0100
Message-Id: <20201215225757.764263-5-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201215225757.764263-1-f4bug@amsat.org>
References: <20201215225757.764263-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of accessing CP0_Config3 directly and checking
the 'MSA Present' bit, introduce an explicit helper,
making the code easier to read.

Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 target/mips/cpu.h       |  6 ++++++
 target/mips/cpu.c       |  2 +-
 target/mips/kvm.c       | 12 ++++++------
 target/mips/translate.c |  6 ++----
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index c6a556efad5..1d72307c547 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1291,6 +1291,12 @@ bool cpu_supports_isa(const CPUMIPSState *env, uint64_t isa_mask);
 bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa);
 bool isa_rel6_available(const CPUMIPSState *env);
 
+/* Check presence of MSA implementation */
+static inline bool ase_msa_available(CPUMIPSState *env)
+{
+    return env->CP0_Config3 & (1 << CP0C3_MSAP);
+}
+
 /* Check presence of multi-threading ASE implementation */
 static inline bool ase_mt_available(CPUMIPSState *env)
 {
diff --git a/target/mips/cpu.c b/target/mips/cpu.c
index 9f082518076..1b4c13bc972 100644
--- a/target/mips/cpu.c
+++ b/target/mips/cpu.c
@@ -532,7 +532,7 @@ static void mips_cpu_reset(DeviceState *dev)
     }
 
     /* MSA */
-    if (env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (ase_msa_available(env)) {
         msa_reset(env);
     }
 
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index a5b6fe35dbc..84fb10ea35d 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -79,7 +79,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
         }
     }
 
-    if (kvm_mips_msa_cap && env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (kvm_mips_msa_cap && ase_msa_available(env)) {
         ret = kvm_vcpu_enable_cap(cs, KVM_CAP_MIPS_MSA, 0, 0);
         if (ret < 0) {
             /* mark unsupported so it gets disabled on reset */
@@ -105,7 +105,7 @@ void kvm_mips_reset_vcpu(MIPSCPU *cpu)
         warn_report("KVM does not support FPU, disabling");
         env->CP0_Config1 &= ~(1 << CP0C1_FP);
     }
-    if (!kvm_mips_msa_cap && env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (!kvm_mips_msa_cap && ase_msa_available(env)) {
         warn_report("KVM does not support MSA, disabling");
         env->CP0_Config3 &= ~(1 << CP0C3_MSAP);
     }
@@ -618,7 +618,7 @@ static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
          * FPU register state is a subset of MSA vector state, so don't put FPU
          * registers if we're emulating a CPU with MSA.
          */
-        if (!(env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if (!ase_msa_available(env)) {
             /* Floating point registers */
             for (i = 0; i < 32; ++i) {
                 if (env->CP0_Status & (1 << CP0St_FR)) {
@@ -637,7 +637,7 @@ static int kvm_mips_put_fpu_registers(CPUState *cs, int level)
     }
 
     /* Only put MSA state if we're emulating a CPU with MSA */
-    if (env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (ase_msa_available(env)) {
         /* MSA Control Registers */
         if (level == KVM_PUT_FULL_STATE) {
             err = kvm_mips_put_one_reg(cs, KVM_REG_MIPS_MSA_IR,
@@ -698,7 +698,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
          * FPU register state is a subset of MSA vector state, so don't save FPU
          * registers if we're emulating a CPU with MSA.
          */
-        if (!(env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if (!ase_msa_available(env)) {
             /* Floating point registers */
             for (i = 0; i < 32; ++i) {
                 if (env->CP0_Status & (1 << CP0St_FR)) {
@@ -717,7 +717,7 @@ static int kvm_mips_get_fpu_registers(CPUState *cs)
     }
 
     /* Only get MSA state if we're emulating a CPU with MSA */
-    if (env->CP0_Config3 & (1 << CP0C3_MSAP)) {
+    if (ase_msa_available(env)) {
         /* MSA Control Registers */
         err = kvm_mips_get_one_reg(cs, KVM_REG_MIPS_MSA_IR,
                                    &env->msair);
diff --git a/target/mips/translate.c b/target/mips/translate.c
index af543d1f375..fc658b3be33 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -24920,8 +24920,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         gen_trap(ctx, op1, rs, rt, -1);
         break;
     case OPC_LSA: /* OPC_PMON */
-        if ((ctx->insn_flags & ISA_MIPS32R6) ||
-            (env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if ((ctx->insn_flags & ISA_MIPS32R6) || ase_msa_available(env)) {
             decode_opc_special_r6(env, ctx);
         } else {
             /* Pmon entry point, also R4010 selsl */
@@ -25023,8 +25022,7 @@ static void decode_opc_special(CPUMIPSState *env, DisasContext *ctx)
         }
         break;
     case OPC_DLSA:
-        if ((ctx->insn_flags & ISA_MIPS32R6) ||
-            (env->CP0_Config3 & (1 << CP0C3_MSAP))) {
+        if ((ctx->insn_flags & ISA_MIPS32R6) || ase_msa_available(env)) {
             decode_opc_special_r6(env, ctx);
         }
         break;
-- 
2.26.2

