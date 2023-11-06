Return-Path: <kvm+bounces-695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 682DD7E1F65
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:06:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1DE9128148F
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6E118AEF;
	Mon,  6 Nov 2023 11:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EtDRzNDf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4610A18636
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:06:43 +0000 (UTC)
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431A698
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 03:06:41 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2c5087d19a6so58551371fa.0
        for <kvm@vger.kernel.org>; Mon, 06 Nov 2023 03:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699268799; x=1699873599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zvMSXcHtnsGDEEiq2Ygmmilt86JHxbxrpSYP17lWc2k=;
        b=EtDRzNDfVvqoH0pBylwAc790aFTUqTYALM68PtJI3zZ3g50p7m9toevhla4Zqnah0L
         ZB5LjhXZap0mCeDO2fJcgb6b4Z2Rf6ZMzgnSzz4FJoBrIyp3EuJIuhLINkn0sRV6/5YF
         tyOxHji6hjHOf4Oqrv6deUTyzwxKE81pbCfIkk/htQmh1HEbu3aoQVuB1w+MYpl0qIyf
         pp2SfWwqckFn8NrKOm2bjw7wDiLIZqxGFMnMLcy9L5MonJhVKzTbxE/PDOAmSyH/y44M
         R1YvQHcdNxb5FWFayOZZhm+79WYxlBZmHnjw15nQjwsllMaipw97X5pmIf4C1w+SYmjp
         dmfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699268799; x=1699873599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zvMSXcHtnsGDEEiq2Ygmmilt86JHxbxrpSYP17lWc2k=;
        b=C6/k2F0WYd/jgBB6JDqPlLCuWigraXyKkV0ejoDpy7UwzT6sFIjLNlhosXDEuEHd+P
         TGPcCA5N8zswvCYODyxzW3XAvQilWH0LDxn45PFDkHpGI2fqtV0LxP7gmU3cyBro9zXR
         6bRqqNXXU2jC/qZgYn8w/QBKbL49u1L0jRc9kvPShpmQeFiQjBqQMhBHtJF6hWVBZTDD
         2XY8yUQlCv28N+mWeD6gossbvP8RvfFjey1jW5LXtLgwwfOoeOoyNKdg2i2Y1mJyhQXZ
         DQQqStrpImLI7Q2liHgz7qjIOp7mw0k+cGUloFFLv8dBViKco6LJLr7RWhKDG4JooZxS
         vKLw==
X-Gm-Message-State: AOJu0YzFb+XJkaPh8RUEogAVoJ9EKlGjVF4teTl3xNeyAtmF1mmAL6AR
	qDCdbWuKRE5K4XBAQamP1rjQFA==
X-Google-Smtp-Source: AGHT+IFk6N3D8WZ9WThiL89QlbWI0KZq0GY/jC5dBPn7GsRDiYKFS2TWfXN5PF6/U9Fqhbvy1HoMPQ==
X-Received: by 2002:a05:651c:210e:b0:2b6:df71:cff1 with SMTP id a14-20020a05651c210e00b002b6df71cff1mr28309158ljq.52.1699268799607;
        Mon, 06 Nov 2023 03:06:39 -0800 (PST)
Received: from m1x-phil.lan (176-131-220-199.abo.bbox.fr. [176.131.220.199])
        by smtp.gmail.com with ESMTPSA id g20-20020a05600c4ed400b003fee8793911sm12017300wmq.44.2023.11.06.03.06.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Nov 2023 03:06:39 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	qemu-s390x@nongnu.org,
	qemu-block@nongnu.org,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PULL 26/60] target/i386/hvf: Rename 'CPUState *cpu' variable as 'cs'
Date: Mon,  6 Nov 2023 12:02:58 +0100
Message-ID: <20231106110336.358-27-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231106110336.358-1-philmd@linaro.org>
References: <20231106110336.358-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Follow the naming used by other files in target/i386/.

No functional changes.

Suggested-by: Zhao Liu <zhao1.liu@intel.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Message-Id: <20231020111136.44401-3-philmd@linaro.org>
---
 target/i386/hvf/x86_emu.c | 92 +++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/target/i386/hvf/x86_emu.c b/target/i386/hvf/x86_emu.c
index cd7ef30126..5b82e84778 100644
--- a/target/i386/hvf/x86_emu.c
+++ b/target/i386/hvf/x86_emu.c
@@ -45,7 +45,7 @@
 #include "vmcs.h"
 #include "vmx.h"
 
-void hvf_handle_io(CPUState *cpu, uint16_t port, void *data,
+void hvf_handle_io(CPUState *cs, uint16_t port, void *data,
                    int direction, int size, uint32_t count);
 
 #define EXEC_2OP_FLAGS_CMD(env, decode, cmd, FLAGS_FUNC, save_res) \
@@ -666,13 +666,13 @@ static void exec_lods(CPUX86State *env, struct x86_decode *decode)
 void simulate_rdmsr(CPUX86State *env)
 {
     X86CPU *x86_cpu = env_archcpu(env);
-    CPUState *cpu = env_cpu(env);
+    CPUState *cs = env_cpu(env);
     uint32_t msr = ECX(env);
     uint64_t val = 0;
 
     switch (msr) {
     case MSR_IA32_TSC:
-        val = rdtscp() + rvmcs(cpu->accel->fd, VMCS_TSC_OFFSET);
+        val = rdtscp() + rvmcs(cs->accel->fd, VMCS_TSC_OFFSET);
         break;
     case MSR_IA32_APICBASE:
         val = cpu_get_apic_base(x86_cpu->apic_state);
@@ -681,16 +681,16 @@ void simulate_rdmsr(CPUX86State *env)
         val = x86_cpu->ucode_rev;
         break;
     case MSR_EFER:
-        val = rvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER);
+        val = rvmcs(cs->accel->fd, VMCS_GUEST_IA32_EFER);
         break;
     case MSR_FSBASE:
-        val = rvmcs(cpu->accel->fd, VMCS_GUEST_FS_BASE);
+        val = rvmcs(cs->accel->fd, VMCS_GUEST_FS_BASE);
         break;
     case MSR_GSBASE:
-        val = rvmcs(cpu->accel->fd, VMCS_GUEST_GS_BASE);
+        val = rvmcs(cs->accel->fd, VMCS_GUEST_GS_BASE);
         break;
     case MSR_KERNELGSBASE:
-        val = rvmcs(cpu->accel->fd, VMCS_HOST_FS_BASE);
+        val = rvmcs(cs->accel->fd, VMCS_HOST_FS_BASE);
         break;
     case MSR_STAR:
         abort();
@@ -745,8 +745,8 @@ void simulate_rdmsr(CPUX86State *env)
         val = env->mtrr_deftype;
         break;
     case MSR_CORE_THREAD_COUNT:
-        val = cpu->nr_threads * cpu->nr_cores;  /* thread count, bits 15..0 */
-        val |= ((uint32_t)cpu->nr_cores << 16); /* core count, bits 31..16 */
+        val = cs->nr_threads * cs->nr_cores;  /* thread count, bits 15..0 */
+        val |= ((uint32_t)cs->nr_cores << 16); /* core count, bits 31..16 */
         break;
     default:
         /* fprintf(stderr, "%s: unknown msr 0x%x\n", __func__, msr); */
@@ -767,7 +767,7 @@ static void exec_rdmsr(CPUX86State *env, struct x86_decode *decode)
 void simulate_wrmsr(CPUX86State *env)
 {
     X86CPU *x86_cpu = env_archcpu(env);
-    CPUState *cpu = env_cpu(env);
+    CPUState *cs = env_cpu(env);
     uint32_t msr = ECX(env);
     uint64_t data = ((uint64_t)EDX(env) << 32) | EAX(env);
 
@@ -778,13 +778,13 @@ void simulate_wrmsr(CPUX86State *env)
         cpu_set_apic_base(x86_cpu->apic_state, data);
         break;
     case MSR_FSBASE:
-        wvmcs(cpu->accel->fd, VMCS_GUEST_FS_BASE, data);
+        wvmcs(cs->accel->fd, VMCS_GUEST_FS_BASE, data);
         break;
     case MSR_GSBASE:
-        wvmcs(cpu->accel->fd, VMCS_GUEST_GS_BASE, data);
+        wvmcs(cs->accel->fd, VMCS_GUEST_GS_BASE, data);
         break;
     case MSR_KERNELGSBASE:
-        wvmcs(cpu->accel->fd, VMCS_HOST_FS_BASE, data);
+        wvmcs(cs->accel->fd, VMCS_HOST_FS_BASE, data);
         break;
     case MSR_STAR:
         abort();
@@ -796,10 +796,10 @@ void simulate_wrmsr(CPUX86State *env)
         abort();
         break;
     case MSR_EFER:
-        /*printf("new efer %llx\n", EFER(cpu));*/
-        wvmcs(cpu->accel->fd, VMCS_GUEST_IA32_EFER, data);
+        /*printf("new efer %llx\n", EFER(cs));*/
+        wvmcs(cs->accel->fd, VMCS_GUEST_IA32_EFER, data);
         if (data & MSR_EFER_NXE) {
-            hv_vcpu_invalidate_tlb(cpu->accel->fd);
+            hv_vcpu_invalidate_tlb(cs->accel->fd);
         }
         break;
     case MSR_MTRRphysBase(0):
@@ -848,9 +848,9 @@ void simulate_wrmsr(CPUX86State *env)
 
     /* Related to support known hypervisor interface */
     /* if (g_hypervisor_iface)
-         g_hypervisor_iface->wrmsr_handler(cpu, msr, data);
+         g_hypervisor_iface->wrmsr_handler(cs, msr, data);
 
-    printf("write msr %llx\n", RCX(cpu));*/
+    printf("write msr %llx\n", RCX(cs));*/
 }
 
 static void exec_wrmsr(CPUX86State *env, struct x86_decode *decode)
@@ -1417,56 +1417,56 @@ static void init_cmd_handler()
     }
 }
 
-void load_regs(CPUState *cpu)
+void load_regs(CPUState *cs)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
+    X86CPU *x86_cpu = X86_CPU(cs);
     CPUX86State *env = &x86_cpu->env;
 
     int i = 0;
-    RRX(env, R_EAX) = rreg(cpu->accel->fd, HV_X86_RAX);
-    RRX(env, R_EBX) = rreg(cpu->accel->fd, HV_X86_RBX);
-    RRX(env, R_ECX) = rreg(cpu->accel->fd, HV_X86_RCX);
-    RRX(env, R_EDX) = rreg(cpu->accel->fd, HV_X86_RDX);
-    RRX(env, R_ESI) = rreg(cpu->accel->fd, HV_X86_RSI);
-    RRX(env, R_EDI) = rreg(cpu->accel->fd, HV_X86_RDI);
-    RRX(env, R_ESP) = rreg(cpu->accel->fd, HV_X86_RSP);
-    RRX(env, R_EBP) = rreg(cpu->accel->fd, HV_X86_RBP);
+    RRX(env, R_EAX) = rreg(cs->accel->fd, HV_X86_RAX);
+    RRX(env, R_EBX) = rreg(cs->accel->fd, HV_X86_RBX);
+    RRX(env, R_ECX) = rreg(cs->accel->fd, HV_X86_RCX);
+    RRX(env, R_EDX) = rreg(cs->accel->fd, HV_X86_RDX);
+    RRX(env, R_ESI) = rreg(cs->accel->fd, HV_X86_RSI);
+    RRX(env, R_EDI) = rreg(cs->accel->fd, HV_X86_RDI);
+    RRX(env, R_ESP) = rreg(cs->accel->fd, HV_X86_RSP);
+    RRX(env, R_EBP) = rreg(cs->accel->fd, HV_X86_RBP);
     for (i = 8; i < 16; i++) {
-        RRX(env, i) = rreg(cpu->accel->fd, HV_X86_RAX + i);
+        RRX(env, i) = rreg(cs->accel->fd, HV_X86_RAX + i);
     }
 
-    env->eflags = rreg(cpu->accel->fd, HV_X86_RFLAGS);
+    env->eflags = rreg(cs->accel->fd, HV_X86_RFLAGS);
     rflags_to_lflags(env);
-    env->eip = rreg(cpu->accel->fd, HV_X86_RIP);
+    env->eip = rreg(cs->accel->fd, HV_X86_RIP);
 }
 
-void store_regs(CPUState *cpu)
+void store_regs(CPUState *cs)
 {
-    X86CPU *x86_cpu = X86_CPU(cpu);
+    X86CPU *x86_cpu = X86_CPU(cs);
     CPUX86State *env = &x86_cpu->env;
 
     int i = 0;
-    wreg(cpu->accel->fd, HV_X86_RAX, RAX(env));
-    wreg(cpu->accel->fd, HV_X86_RBX, RBX(env));
-    wreg(cpu->accel->fd, HV_X86_RCX, RCX(env));
-    wreg(cpu->accel->fd, HV_X86_RDX, RDX(env));
-    wreg(cpu->accel->fd, HV_X86_RSI, RSI(env));
-    wreg(cpu->accel->fd, HV_X86_RDI, RDI(env));
-    wreg(cpu->accel->fd, HV_X86_RBP, RBP(env));
-    wreg(cpu->accel->fd, HV_X86_RSP, RSP(env));
+    wreg(cs->accel->fd, HV_X86_RAX, RAX(env));
+    wreg(cs->accel->fd, HV_X86_RBX, RBX(env));
+    wreg(cs->accel->fd, HV_X86_RCX, RCX(env));
+    wreg(cs->accel->fd, HV_X86_RDX, RDX(env));
+    wreg(cs->accel->fd, HV_X86_RSI, RSI(env));
+    wreg(cs->accel->fd, HV_X86_RDI, RDI(env));
+    wreg(cs->accel->fd, HV_X86_RBP, RBP(env));
+    wreg(cs->accel->fd, HV_X86_RSP, RSP(env));
     for (i = 8; i < 16; i++) {
-        wreg(cpu->accel->fd, HV_X86_RAX + i, RRX(env, i));
+        wreg(cs->accel->fd, HV_X86_RAX + i, RRX(env, i));
     }
 
     lflags_to_rflags(env);
-    wreg(cpu->accel->fd, HV_X86_RFLAGS, env->eflags);
-    macvm_set_rip(cpu, env->eip);
+    wreg(cs->accel->fd, HV_X86_RFLAGS, env->eflags);
+    macvm_set_rip(cs, env->eip);
 }
 
 bool exec_instruction(CPUX86State *env, struct x86_decode *ins)
 {
-    /*if (hvf_vcpu_id(cpu))
-    printf("%d, %llx: exec_instruction %s\n", hvf_vcpu_id(cpu),  env->eip,
+    /*if (hvf_vcpu_id(cs))
+    printf("%d, %llx: exec_instruction %s\n", hvf_vcpu_id(cs),  env->eip,
           decode_cmd_to_string(ins->cmd));*/
 
     if (!_cmd_handler[ins->cmd].handler) {
-- 
2.41.0


