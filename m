Return-Path: <kvm+bounces-43758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA8DA96138
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 10:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A68E9189C0FA
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 08:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482CC2566CF;
	Tue, 22 Apr 2025 08:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="hcEX0Oma"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714231F0E34;
	Tue, 22 Apr 2025 08:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745310229; cv=none; b=jjSiJLt6RKWUX9CgGl9r22Bjt6IKz8hcZQlbtbj4N/hPzm5T9PRzClkFFDnoq46OxwyIhCH00HyyBgA+2EoXuflUKLw90epnLmW1PfDA2lke/9dezhQhSx6qNk1CBwIHBLvNLN7IsdE94HExb87AiISFxYFwZK6G4tJLbojmWiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745310229; c=relaxed/simple;
	bh=5mnJXQbl6SEJYO4dMb/C/ZhC/prPzA9KgQK92fsGtwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkUdQ0Y9B+b7/gOSi9OvkpJ40/x+l4npl3M/BMfIo7+t7AmSHo/R7A9pgJ6snEiT7WeI4fuau75S+CNXTakUuWvqWJwPlhqi2aFNqQVdKjFOmQMQ3qrIXK9M4jgUr0QzFJKDl54/XzqBp2USvuo161DQqRRJz/yT+ipWWWOD3a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=hcEX0Oma; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from terminus.zytor.com (terminus.zytor.com [IPv6:2607:7c80:54:3:0:0:0:136])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 53M8MG9K1954391
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 22 Apr 2025 01:22:33 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 53M8MG9K1954391
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025042001; t=1745310154;
	bh=hH40dRMC8icMs0Kq/gRLpfnhusccGZZqYtPjziXUIq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcEX0Oma3CVnkwxqS8bKBIm18tqvV7335h9MWMF4E8wAMoT4z1itaFgVa2bu1H7Lv
	 Ga+u823XXqz9EiWUYA9XlCQeHFfgScC5iggnF6WJwS4CQfGeYOy+x+oIvnckcTBzB6
	 8V7NP2nGUmfkFx31xOhz6KwJe5WcJid/C9tfwl98yFuEFykSa3egLEr8WStBfP/6oh
	 K8ADOv9Wdb6X6GRIlWoxPenpyB34mw1V1qvbQ8zIfGnVmMda21cc2+p+ghtOaC0a2V
	 V8nAVloDomWCJYiVBeBOXpRIQBAsncCQrgBQ+uMQZJ1te/DZTdjVSMkiakmJECg5VO
	 psDTTjszTfsAw==
From: "Xin Li (Intel)" <xin@zytor.com>
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-pm@vger.kernel.org,
        linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org,
        linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        netdev@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com,
        peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        irogers@google.com, adrian.hunter@intel.com, kan.liang@linux.intel.com,
        wei.liu@kernel.org, ajay.kaher@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, tony.luck@intel.com,
        pbonzini@redhat.com, vkuznets@redhat.com, seanjc@google.com,
        luto@kernel.org, boris.ostrovsky@oracle.com, kys@microsoft.com,
        haiyangz@microsoft.com, decui@microsoft.com
Subject: [RFC PATCH v2 06/34] x86/msr: Use the alternatives mechanism to read PMC
Date: Tue, 22 Apr 2025 01:21:47 -0700
Message-ID: <20250422082216.1954310-7-xin@zytor.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422082216.1954310-1-xin@zytor.com>
References: <20250422082216.1954310-1-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To eliminate the indirect call overhead introduced by the pv_ops API,
use the alternatives mechanism to read PMC:

    1) When built with !CONFIG_XEN_PV, X86_FEATURE_XENPV becomes a
       disabled feature, preventing the Xen PMC read code from being
       built and ensuring the native code is executed unconditionally.

    2) When built with CONFIG_XEN_PV:

       2.1) If not running on the Xen hypervisor (!X86_FEATURE_XENPV),
            the kernel runtime binary is patched to unconditionally
            jump to the native PMC read code.

       2.2) If running on the Xen hypervisor (X86_FEATURE_XENPV), the
            kernel runtime binary is patched to unconditionally jump
            to the Xen PMC read code.

Consequently, remove the pv_ops PMC read API.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
---
 arch/x86/include/asm/msr.h            | 31 ++++++++++++++++++++-------
 arch/x86/include/asm/paravirt.h       |  5 -----
 arch/x86/include/asm/paravirt_types.h |  2 --
 arch/x86/kernel/paravirt.c            |  1 -
 arch/x86/xen/enlighten_pv.c           |  2 --
 drivers/net/vmxnet3/vmxnet3_drv.c     |  2 +-
 6 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 01dc8e61ef97..33cf506e2fd6 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -8,6 +8,7 @@
 
 #include <asm/asm.h>
 #include <asm/errno.h>
+#include <asm/cpufeature.h>
 #include <asm/cpumask.h>
 #include <uapi/asm/msr.h>
 #include <asm/shared/msr.h>
@@ -73,6 +74,10 @@ static inline void do_trace_read_msr(u32 msr, u64 val, int failed) {}
 static inline void do_trace_rdpmc(u32 msr, u64 val, int failed) {}
 #endif
 
+#ifdef CONFIG_XEN_PV
+extern u64 xen_read_pmc(int counter);
+#endif
+
 /*
  * __rdmsr() and __wrmsr() are the two primitives which are the bare minimum MSR
  * accessors and should not have any tracing or other functionality piggybacking
@@ -170,16 +175,32 @@ native_write_msr_safe(u32 msr, u32 low, u32 high)
 extern int rdmsr_safe_regs(u32 regs[8]);
 extern int wrmsr_safe_regs(u32 regs[8]);
 
-static inline u64 native_read_pmc(int counter)
+static __always_inline u64 native_rdpmcq(int counter)
 {
 	DECLARE_ARGS(val, low, high);
 
-	asm volatile("rdpmc" : EAX_EDX_RET(val, low, high) : "c" (counter));
+	asm_inline volatile("rdpmc" : EAX_EDX_RET(val, low, high) : "c" (counter));
+
 	if (tracepoint_enabled(rdpmc))
 		do_trace_rdpmc(counter, EAX_EDX_VAL(val, low, high), 0);
+
 	return EAX_EDX_VAL(val, low, high);
 }
 
+static __always_inline u64 rdpmcq(int counter)
+{
+#ifdef CONFIG_XEN_PV
+	if (cpu_feature_enabled(X86_FEATURE_XENPV))
+		return xen_read_pmc(counter);
+#endif
+
+	/*
+	 * 1) When built with !CONFIG_XEN_PV.
+	 * 2) When built with CONFIG_XEN_PV but not running on Xen hypervisor.
+	 */
+	return native_rdpmcq(counter);
+}
+
 #ifdef CONFIG_PARAVIRT_XXL
 #include <asm/paravirt.h>
 #else
@@ -233,12 +254,6 @@ static inline int rdmsrq_safe(u32 msr, u64 *p)
 	*p = native_read_msr_safe(msr, &err);
 	return err;
 }
-
-static __always_inline u64 rdpmcq(int counter)
-{
-	return native_read_pmc(counter);
-}
-
 #endif	/* !CONFIG_PARAVIRT_XXL */
 
 /* Instruction opcode for WRMSRNS supported in binutils >= 2.40 */
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index 590824916394..c7689f5f70d6 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -239,11 +239,6 @@ static inline int rdmsrq_safe(unsigned msr, u64 *p)
 	return err;
 }
 
-static __always_inline u64 rdpmcq(int counter)
-{
-	return PVOP_CALL1(u64, cpu.read_pmc, counter);
-}
-
 static inline void paravirt_alloc_ldt(struct desc_struct *ldt, unsigned entries)
 {
 	PVOP_VCALL2(cpu.alloc_ldt, ldt, entries);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 631c306ce1ff..475f508531d6 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -101,8 +101,6 @@ struct pv_cpu_ops {
 	u64 (*read_msr_safe)(unsigned int msr, int *err);
 	int (*write_msr_safe)(unsigned int msr, unsigned low, unsigned high);
 
-	u64 (*read_pmc)(int counter);
-
 	void (*start_context_switch)(struct task_struct *prev);
 	void (*end_context_switch)(struct task_struct *next);
 #endif
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 1ccd05d8999f..28d195ad7514 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -132,7 +132,6 @@ struct paravirt_patch_template pv_ops = {
 	.cpu.write_msr		= native_write_msr,
 	.cpu.read_msr_safe	= native_read_msr_safe,
 	.cpu.write_msr_safe	= native_write_msr_safe,
-	.cpu.read_pmc		= native_read_pmc,
 	.cpu.load_tr_desc	= native_load_tr_desc,
 	.cpu.set_ldt		= native_set_ldt,
 	.cpu.load_gdt		= native_load_gdt,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 846b5737d320..9fbe187aff00 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1236,8 +1236,6 @@ static const typeof(pv_ops) xen_cpu_ops __initconst = {
 		.read_msr_safe = xen_read_msr_safe,
 		.write_msr_safe = xen_write_msr_safe,
 
-		.read_pmc = xen_read_pmc,
-
 		.load_tr_desc = paravirt_nop,
 		.set_ldt = xen_set_ldt,
 		.load_gdt = xen_load_gdt,
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 7edd0b5e0e77..8af3b4d7ef4d 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -151,7 +151,7 @@ static u64
 vmxnet3_get_cycles(int pmc)
 {
 #ifdef CONFIG_X86
-	return native_read_pmc(pmc);
+	return native_rdpmcq(pmc);
 #else
 	return 0;
 #endif
-- 
2.49.0


