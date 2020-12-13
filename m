Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5682D9064
	for <lists+kvm@lfdr.de>; Sun, 13 Dec 2020 21:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393417AbgLMUV0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Dec 2020 15:21:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393142AbgLMUVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Dec 2020 15:21:25 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B135C0613D6
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:45 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c5so10754989wrp.6
        for <kvm@vger.kernel.org>; Sun, 13 Dec 2020 12:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cgaHXNW/5WgtwEvWMUgAxy7itdnx69iC1c/ZHbcmFvM=;
        b=uQYrE+2Qhcmp3WlwFdf+D5+FYcDpG6cFeMPXtrY0OjHRN54VDeyV4PYKH/fjkNOH9Q
         wVzi+zTFbAwfMhEeLrysDanA7Mn6Mn2C4DDp1HvOyjpdDoU4ASjaqqP9Qs24Lel8Cbxv
         mmNDIGN4fufjv6MdWjm7hfFh6ERPFyXQyvz90Cgu/eOfrsQt9OaWmrME9kyFMTOByKQS
         uTO11JZ01gOSC4kbMTGupYqPGQAbUyfxx+LV1WebPC+cKjZXaaxCKRIsmB1BhjpZWiy0
         Wa8m/TJZIggopdrFRJw4oPlIfG3PA3fYFMNZQPEV9CjXXisBjwZFNqI2F3YR4NDw6izZ
         6mGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=cgaHXNW/5WgtwEvWMUgAxy7itdnx69iC1c/ZHbcmFvM=;
        b=czmu0dU7WtG26wgZhuh2TkG+2kE+gN3y4Dg+ko4XxEArBUGkOPpmwBwqhOz7Wqwqjl
         va6Jq1DOb7Pv4m/eWy/9g8QqBrVD0WJ3t0zd/HVaVb7hJCsWlYQ0EbgKITTOPSN6KpMA
         /6+hj21FD3yVP+QB17TJSQiJgBZxCcVHGGKAX/yte1WDaXyi8p5qhjtNlrzXPPQPkvly
         fBmTN1pZ2E0bRLCy03RttFfHutIgH15/oWH5ufUUx7jbjVdpefTjH9huPiDKfPlEh7pM
         SL9guubeBxbAT1ryyNrZT1fSYs0m6sraDD1Fv2w484h0gE5H7Y0OQOZWTC9FNQbunO0l
         fSNg==
X-Gm-Message-State: AOAM5310JzwutlQHBmi5zGOnaHR9foQCXZoEYAU7/KE9Wu7atn7aCCx3
        a0ITJhkvHY4tKNwyyPOYqkU=
X-Google-Smtp-Source: ABdhPJxi1HLf3FD13UfxWm0lJHdi9m9BmBMJoArKmNJDfLLV01NRhcTmbVSlznxIufmZF2k7WGlVfg==
X-Received: by 2002:a5d:56c3:: with SMTP id m3mr8510854wrw.419.1607890843830;
        Sun, 13 Dec 2020 12:20:43 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id h13sm28768884wrm.28.2020.12.13.12.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 12:20:43 -0800 (PST)
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
Subject: [PULL 11/26] target/mips: Rename cpu_supports_FEAT() as cpu_type_supports_FEAT()
Date:   Sun, 13 Dec 2020 21:19:31 +0100
Message-Id: <20201213201946.236123-12-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213201946.236123-1-f4bug@amsat.org>
References: <20201213201946.236123-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As cpu_supports_isa() / cpu_supports_cps_smp() take a 'cpu_type'
name argument, rename them cpu_type_supports_FEAT().

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Message-Id: <20201207215257.4004222-2-f4bug@amsat.org>
---
 target/mips/cpu.h       | 4 ++--
 hw/mips/boston.c        | 4 ++--
 hw/mips/malta.c         | 4 ++--
 target/mips/translate.c | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/target/mips/cpu.h b/target/mips/cpu.h
index 23f8c6f96cd..9c65c87bf99 100644
--- a/target/mips/cpu.h
+++ b/target/mips/cpu.h
@@ -1286,8 +1286,8 @@ int cpu_mips_signal_handler(int host_signum, void *pinfo, void *puc);
 #define MIPS_CPU_TYPE_NAME(model) model MIPS_CPU_TYPE_SUFFIX
 #define CPU_RESOLVING_TYPE TYPE_MIPS_CPU
 
-bool cpu_supports_cps_smp(const char *cpu_type);
-bool cpu_supports_isa(const char *cpu_type, uint64_t isa);
+bool cpu_type_supports_cps_smp(const char *cpu_type);
+bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa);
 void cpu_set_exception_base(int vp_index, target_ulong address);
 
 /* mips_int.c */
diff --git a/hw/mips/boston.c b/hw/mips/boston.c
index 3d40867dc4c..16467ea4752 100644
--- a/hw/mips/boston.c
+++ b/hw/mips/boston.c
@@ -459,12 +459,12 @@ static void boston_mach_init(MachineState *machine)
     s = BOSTON(dev);
     s->mach = machine;
 
-    if (!cpu_supports_cps_smp(machine->cpu_type)) {
+    if (!cpu_type_supports_cps_smp(machine->cpu_type)) {
         error_report("Boston requires CPUs which support CPS");
         exit(1);
     }
 
-    is_64b = cpu_supports_isa(machine->cpu_type, ISA_MIPS64);
+    is_64b = cpu_type_supports_isa(machine->cpu_type, ISA_MIPS64);
 
     object_initialize_child(OBJECT(machine), "cps", &s->cps, TYPE_MIPS_CPS);
     object_property_set_str(OBJECT(&s->cps), "cpu-type", machine->cpu_type,
diff --git a/hw/mips/malta.c b/hw/mips/malta.c
index 5c11eecec11..4651a1055c9 100644
--- a/hw/mips/malta.c
+++ b/hw/mips/malta.c
@@ -1205,7 +1205,7 @@ static void create_cps(MachineState *ms, MaltaState *s,
 static void mips_create_cpu(MachineState *ms, MaltaState *s,
                             qemu_irq *cbus_irq, qemu_irq *i8259_irq)
 {
-    if ((ms->smp.cpus > 1) && cpu_supports_cps_smp(ms->cpu_type)) {
+    if ((ms->smp.cpus > 1) && cpu_type_supports_cps_smp(ms->cpu_type)) {
         create_cps(ms, s, cbus_irq, i8259_irq);
     } else {
         create_cpu_without_cps(ms, s, cbus_irq, i8259_irq);
@@ -1309,7 +1309,7 @@ void mips_malta_init(MachineState *machine)
         loaderparams.initrd_filename = initrd_filename;
         kernel_entry = load_kernel();
 
-        if (!cpu_supports_isa(machine->cpu_type, ISA_NANOMIPS32)) {
+        if (!cpu_type_supports_isa(machine->cpu_type, ISA_NANOMIPS32)) {
             write_bootloader(memory_region_get_ram_ptr(bios),
                              bootloader_run_addr, kernel_entry);
         } else {
diff --git a/target/mips/translate.c b/target/mips/translate.c
index c64a1bc42e1..b8ed16bb779 100644
--- a/target/mips/translate.c
+++ b/target/mips/translate.c
@@ -31770,13 +31770,13 @@ void cpu_mips_realize_env(CPUMIPSState *env)
     mvp_init(env, env->cpu_model);
 }
 
-bool cpu_supports_cps_smp(const char *cpu_type)
+bool cpu_type_supports_cps_smp(const char *cpu_type)
 {
     const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
     return (mcc->cpu_def->CP0_Config3 & (1 << CP0C3_CMGCR)) != 0;
 }
 
-bool cpu_supports_isa(const char *cpu_type, uint64_t isa)
+bool cpu_type_supports_isa(const char *cpu_type, uint64_t isa)
 {
     const MIPSCPUClass *mcc = MIPS_CPU_CLASS(object_class_by_name(cpu_type));
     return (mcc->cpu_def->insn_flags & isa) != 0;
-- 
2.26.2

