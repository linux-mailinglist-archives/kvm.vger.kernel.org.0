Return-Path: <kvm+bounces-57919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 60D2EB812D6
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 19:31:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4EF81C05ED9
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 17:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063D62FC875;
	Wed, 17 Sep 2025 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="NIUKOpyX"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1C1533D6;
	Wed, 17 Sep 2025 17:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758130281; cv=none; b=jCYcTdoRnfCzfVH3ucxJ+n6jYIgyBTJSFp8mHlKJigGsN9YvvZ7A1s8b/4O5tQcHsh2aT62OG46egLto5jW6I2EZlEbLxCriwfdUKeCRIYpz4r8h7V+P8GaMhHTtydb3wRwDSPDCbmK5ZCTrRyXb0s5diEWgIVn1JHRb1Yve9sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758130281; c=relaxed/simple;
	bh=O/BoVsg3dFQqJJiPyV0KD/FrOE4b9haumLKJNAFUYVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ogg6ss/AV/jwBfmawXxB/astlxdxLXDNfLfEu6ntLDPwDPpwKHu/T4WeBN7QXmeMidP2u0bp62x0tq5Os7/UP9/ugrQDNOCc3HQEJ3bmocuFxir7gRdMvXL3tEuhKZwuJt0LoJvNppCgJ5CRHsx8aOyLCHBOyeDCt7Vd9nbLdqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=NIUKOpyX; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [0.0.0.0] ([134.134.139.75])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 58HHUarm2428029
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 17 Sep 2025 10:30:37 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 58HHUarm2428029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1758130239;
	bh=nGr7w88ouYlRzd9FYKvTf6O4gCs8sXXy40bKMufJTU0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NIUKOpyXetlWfcS5MaJVH7FMhEgy0os19VGvtca8x7nSHttYy01UIOy5exxthJIAn
	 XPUHPcKgSPdm5AcCIfWmYKMQsTeNmAbzaaGv7sj2efcyjKWUMMD4X8+R+fOI6TSkhu
	 fP1qwvGuY7fPaI1RCfhsWVQkkUI2aRfkIwNlGRUA9I3x/BWz/5B6J6bCB6zirik7XH
	 NDBJzGwBLRr+KBqGMG9K/Au7sR7uMAle6VkWpDbvM+Vh8iH3qTCjgiEnB019h4aouB
	 5o0Ey5X2MOtA9nTBUcu2g/5IeLCD3jzDa+RxNPrHGPdS1Tuucd9j4wOjO8kVk6XrW5
	 77LyZhzIgy+gw==
Message-ID: <f533d3a4-183e-4b3d-9b3a-95defb1876e0@zytor.com>
Date: Wed, 17 Sep 2025 10:30:31 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/5] x86/boot, KVM: Move VMXON/VMXOFF handling from
 KVM to CPU lifecycle
To: Sean Christopherson <seanjc@google.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, rafael@kernel.org, pavel@kernel.org,
        brgerst@gmail.com, david.kaplan@amd.com, peterz@infradead.org,
        andrew.cooper3@citrix.com, kprateek.nayak@amd.com, chao.gao@intel.com,
        rick.p.edgecombe@intel.com, dan.j.williams@intel.com,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20250909182828.1542362-1-xin@zytor.com>
 <aMLakCwFW1YEWFG4@google.com>
 <0387b08a-a8b0-4632-abfc-6b8189ded6b4@linux.intel.com>
 <aMmkZlWl4TiS2qm8@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aMmkZlWl4TiS2qm8@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/2025 10:54 AM, Sean Christopherson wrote:
> On Thu, Sep 11, 2025, Arjan van de Ven wrote:
>> Hi,
>>> I also want to keep the code as a module, both to avoid doing VMXON unconditionally,
>>
>> can you expand on what the problem is with having VMXON unconditionally enabled?
> 
> Unlike say EFER.SVME, VMXON fundamentally changes CPU behavior.  E.g. blocks INIT,
> activates VMCS caches (which aren't cleared by VMXOFF on pre-SPR CPUs, and AFAIK
> Intel hasn't even publicly committed to that behavior for SPR+), restricts allowed
> CR0 and CR4 values, raises questions about ucode patch updates, triggers unique
> flows in SMI/RSM, prevents Intel PT from tracing on certain CPUs, and probably a
> few other things I'm forgetting.


Regarding Intel PT, if VMXON/VMXOFF are moved to CPU startup/shutdown, as
Intel PT is initialized during arch_initcall() stage, entering and leaving
VMX operation no longer happen while Intel PT is _active_, thus
intel_pt_handle_vmx() no longer needs to "handles" VMX state transitions.

Thus, the function's purpose is simplified to signaling Intel pt not to
write to IA32_RTIT_CTL during VMX operation if the processor supports Intel
PT but disallows its use in VMX operation, indicated by IA32_VMX_MISC[14]
being cleared.  Otherwise, it does nothing and leaves pt_ctx.vmx_on as 0.

If the following patch is correct, it's more of a simplification then :)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index e8cf29d2b10c..8325a824700a 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -225,17 +225,6 @@ static int __init pt_pmu_hw_init(void)
  		break;
  	}

-	if (boot_cpu_has(X86_FEATURE_VMX)) {
-		/*
-		 * Intel SDM, 36.5 "Tracing post-VMXON" says that
-		 * "IA32_VMX_MISC[bit 14]" being 1 means PT can trace
-		 * post-VMXON.
-		 */
-		rdmsrq(MSR_IA32_VMX_MISC, reg);
-		if (reg & BIT(14))
-			pt_pmu.vmx = true;
-	}
-
  	for (i = 0; i < PT_CPUID_LEAVES; i++) {
  		cpuid_count(20, i,
  			    &pt_pmu.caps[CPUID_EAX + i*PT_CPUID_REGS_NUM],
@@ -1556,41 +1545,39 @@ void intel_pt_interrupt(void)
  	}
  }

-void intel_pt_handle_vmx(int on)
+/*
+ * VMXON is done in the CPU startup phase, thus pt is initialized later.
+ *
+ * Signal pt to not write IA32_RTIT_CTL while in VMX operation if the
+ * processor supports Intel PT but does not allow it to be used in VMX
+ * operation, i.e. IA32_VMX_MISC[bit 14] is cleared.
+ *
+ * Note: If IA32_VMX_MISC[bit 14] is set, vmx_on in pt_ctx remains 0.
+ */
+void intel_pt_set_vmx(int on)
  {
  	struct pt *pt = this_cpu_ptr(&pt_ctx);
-	struct perf_event *event;
-	unsigned long flags;
+	int cpu = raw_smp_processor_id();
+
+	if (!cpu && cpu_feature_enabled(X86_FEATURE_VMX)) {
+		u64 misc;
+
+		/*
+		 * Intel SDM, 36.5 "Tracing post-VMXON" says that
+		 * "IA32_VMX_MISC[bit 14]" being 1 means PT can trace
+		 * post-VMXON.
+		 */
+		rdmsrq(MSR_IA32_VMX_MISC, misc);
+		if (misc & BIT(14))
+			pt_pmu.vmx = true;
+	}

  	/* PT plays nice with VMX, do nothing */
  	if (pt_pmu.vmx)
  		return;

-	/*
-	 * VMXON will clear RTIT_CTL.TraceEn; we need to make
-	 * sure to not try to set it while VMX is on. Disable
-	 * interrupts to avoid racing with pmu callbacks;
-	 * concurrent PMI should be handled fine.
-	 */
-	local_irq_save(flags);
  	WRITE_ONCE(pt->vmx_on, on);
-
-	/*
-	 * If an AUX transaction is in progress, it will contain
-	 * gap(s), so flag it PARTIAL to inform the user.
-	 */
-	event = pt->handle.event;
-	if (event)
-		perf_aux_output_flag(&pt->handle,
-		                     PERF_AUX_FLAG_PARTIAL);
-
-	/* Turn PTs back on */
-	if (!on && event)
-		wrmsrq(MSR_IA32_RTIT_CTL, event->hw.aux_config);
-
-	local_irq_restore(flags);
  }
-EXPORT_SYMBOL_GPL(intel_pt_handle_vmx);

  /*
   * PMU callbacks
diff --git a/arch/x86/include/asm/perf_event.h 
b/arch/x86/include/asm/perf_event.h
index 70d1d94aca7e..9140796e6268 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -659,12 +659,9 @@ static inline void x86_perf_get_lbr(struct x86_pmu_lbr 
*lbr)
  #endif

  #ifdef CONFIG_CPU_SUP_INTEL
- extern void intel_pt_handle_vmx(int on);
+extern void intel_pt_set_vmx(int on);
  #else
-static inline void intel_pt_handle_vmx(int on)
-{
-
-}
+static inline void intel_pt_set_vmx(int on) { }
  #endif

  #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_AMD)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 03b28fa2e91e..9dad23c86152 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2009,7 +2009,7 @@ void cpu_enable_virtualization(void)
  	rdmsrq(MSR_IA32_VMX_BASIC, basic_msr);
  	this_cpu_ptr(&vmxon_vmcs)->hdr.revision_id = 
vmx_basic_vmcs_revision_id(basic_msr);

-	intel_pt_handle_vmx(1);
+	intel_pt_set_vmx(1);

  	cr4_set_bits(X86_CR4_VMXE);

@@ -2023,7 +2023,7 @@ void cpu_enable_virtualization(void)
  fault:
  	pr_err("VMXON faulted on CPU%d\n", cpu);
  	cr4_clear_bits(X86_CR4_VMXE);
-	intel_pt_handle_vmx(0);
+	intel_pt_set_vmx(0);
  }

  /*
@@ -2055,7 +2055,7 @@ void cpu_disable_virtualization(void)

  exit:
  	cr4_clear_bits(X86_CR4_VMXE);
-	intel_pt_handle_vmx(0);
+	intel_pt_set_vmx(0);
  	return;

  fault:

