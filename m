Return-Path: <kvm+bounces-55797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE8EDB37499
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 23:59:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE5451B26FF1
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 22:00:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9110629BD90;
	Tue, 26 Aug 2025 21:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="dvzhD3j/"
X-Original-To: kvm@vger.kernel.org
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28C01DFF0;
	Tue, 26 Aug 2025 21:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756245583; cv=none; b=hG90Z+Nz2iPWRYTl+rWoXAyTT01njQkZs+QrMXgbA88+FmcQ9L8raT70RpeLwXc6ivV2YLIcP2e3RsqUd377P26W7Ibzrvj120YNMpT7bzkFVtEX0Y6h0kSjdKp63cK4/XrvLd79jukOTXFQYlJNJ5Rc1FrLdmkeP7COqptz834=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756245583; c=relaxed/simple;
	bh=rF7py0I4BQaA96IrHqgiK8rvwdsG8stamTkJqbzpqXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NsTwyCpWnN5ZZsrnt6UL69bbnHIlscX3at287JwTXp5vqO7HxIo2ViIMguT7hs2Jx8BFgUsyCIkXJxGvlDn+82JkQVijMuqWgeMzRzzaegKf8+5/wE6sgKfzp3i5DbKV5Rs2GXEjrVcY2aJY3EFoCdFuAKEwUXUPU0X+SxXp+TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=dvzhD3j/; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Received: from [192.168.7.202] ([71.202.166.45])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 57QLx2qS1287801
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Tue, 26 Aug 2025 14:59:02 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 57QLx2qS1287801
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025082201; t=1756245544;
	bh=JhEF9PyJIiz8iDeAX7hqrwvGmHOpLTMxdPH/sUFCfaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dvzhD3j/eO28ZaxQT/SDRzI5/92/hnb+BKoxiEkCVziAGO6BuUE50h13oBz/8NRBb
	 zVRn94TsGBcc8oV08CxqMd8aP89j92txgn8U4NRm9JN4+emHj8CtevRy4F/aNdYzjN
	 5ty+V61NSzqppfTjVSvkKP9SgVnnc9+381KtKs4F97F2n9VYCryJ93SpUwIXZXQrc7
	 74TsSBt/KukYH/KVU1F43qnhAxbFKtrlpHMLkmjzAXYM2hTMNRCTDQsYOfErm+sCoh
	 +C3bOuzuJ9hQdsZ0jrxQ+vPzozbBCkvNiua+6WSUA7iw8DyfDQZ9AAhA6xm07Quqa4
	 o7Kl6SZJSSfTQ==
Message-ID: <c45a7c91-e393-4f71-8b22-aef6486aaa9e@zytor.com>
Date: Tue, 26 Aug 2025 14:59:01 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/20] KVM: VMX: Set FRED MSR intercepts
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        luto@kernel.org, peterz@infradead.org, andrew.cooper3@citrix.com,
        chao.gao@intel.com, hch@infradead.org
References: <20250821223630.984383-1-xin@zytor.com>
 <20250821223630.984383-7-xin@zytor.com>
 <2dd8c323-7654-4a28-86f1-d743b70d10b1@zytor.com>
 <aK340-6yIE_qujUm@google.com>
Content-Language: en-US
From: Xin Li <xin@zytor.com>
Autocrypt: addr=xin@zytor.com; keydata=
 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
 l75w1xInsg==
In-Reply-To: <aK340-6yIE_qujUm@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


>> Hi Sean,
>>
>> I'd like to bring up an issue concerning MSR_IA32_PL0_SSP.
>>
>> The FRED spec claims:
>>
>> The FRED SSP MSRs are supported by any processor that enumerates
>> CPUID.(EAX=7,ECX=1):EAX.FRED[bit 17] as 1. If such a processor does not
>> support CET, FRED transitions will not use the MSRs (because shadow stacks
>> are not enabled), but the MSRs would still be accessible using MSR-access
>> instructions (e.g., RDMSR, WRMSR).
>>
>> It means KVM needs to handle MSR_IA32_PL0_SSP even when FRED is supported
>> but CET is not.  And this can be broken down into two subtasks:
>>
>> 1) Allow such a guest to access MSR_IA32_PL0_SSP w/o triggering #GP.  And
>> this behavior is already implemented in patch 8 of this series.
>>
>> 2) Save and restore MSR_IA32_PL0_SSP in both KVM and Qemu for such a guest.
> 
> What novel work needs to be done in KVM?  For QEMU, I assume it's just adding an
> "or FRED" somewhere.  For KVM, I'm missing what additional work would be required
> that wouldn't be naturally covered by patch 8 (assuming patch 8 is bug-free).

Extra patches:

1) A patch to save/restore guest MSR_IA32_PL0_SSP (i.e., FRED SSP0), as
what we have done for RSP0, following is the patch on top of the patch 
saving/restoring RSP0:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 449a5e02c7de..0bf684342a71 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1294,8 +1294,13 @@ void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)

  	wrmsrq(MSR_KERNEL_GS_BASE, vmx->msr_guest_kernel_gs_base);

-	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)) {
  		wrmsrns(MSR_IA32_FRED_RSP0, vmx->msr_guest_fred_rsp0);
+
+		/* XSAVES/XRSTORS do not cover SSP MSRs */
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+			wrmsrns(MSR_IA32_FRED_SSP0, vmx->msr_guest_fred_ssp0);
+	}
  #else
  	savesegment(fs, fs_sel);
  	savesegment(gs, gs_sel);
@@ -1349,6 +1354,10 @@ static void vmx_prepare_switch_to_host(struct 
vcpu_vmx *vmx)
  		 * CPU exits to userspace (RSP0 is a per-task value).
  		 */
  		fred_sync_rsp0(vmx->msr_guest_fred_rsp0);
+
+		/* XSAVES/XRSTORS do not cover SSP MSRs */
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK))
+			vmx->msr_guest_fred_ssp0 = read_msr(MSR_IA32_FRED_SSP0);
  	}
  #endif
  	load_fixmap_gdt(raw_smp_processor_id());
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 733fa2ef4bea..12c1cf827cb7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -228,6 +228,7 @@ struct vcpu_vmx {
  #ifdef CONFIG_X86_64
  	u64		      msr_guest_kernel_gs_base;
  	u64		      msr_guest_fred_rsp0;
+	u64		      msr_guest_fred_ssp0;
  #endif

  	u64		      spec_ctrl;

And We might want to zero host MSR_IA32_PL0_SSP when switching to host.


2) Add vmx_read_guest_fred_ssp0()/vmx_write_guest_fred_ssp0(), and use
them to read/write MSR_IA32_PL0_SSP in patch 8:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 99106750b1e3..cbdc67682d27 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1400,9 +1408,23 @@ static void vmx_write_guest_fred_rsp0(struct 
vcpu_vmx *vmx, u64 data)
  	vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_RSP0, data,
  				 &vmx->msr_guest_fred_rsp0);
  }
+
+static u64 vmx_read_guest_fred_ssp0(struct vcpu_vmx *vmx)
+{
+	return vmx_read_guest_host_msr(vmx, MSR_IA32_FRED_SSP0,
+				       &vmx->msr_guest_fred_ssp0);
+}
+
+static void vmx_write_guest_fred_ssp0(struct vcpu_vmx *vmx, u64 data)
+{
+	vmx_write_guest_host_msr(vmx, MSR_IA32_FRED_SSP0, data,
+				 &vmx->msr_guest_fred_ssp0);
+}
  #endif

  static void grow_ple_window(struct kvm_vcpu *vcpu)
@@ -2189,6 +2211,18 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct 
msr_data *msr_info)
  	case MSR_IA32_DEBUGCTLMSR:
  		msr_info->data = vmx_guest_debugctl_read();
  		break;
+	case MSR_IA32_PL0_SSP:
+		/*
+		 * If kvm_cpu_cap_has(X86_FEATURE_SHSTK) but
+		 * !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK), XSAVES/XRSTORS
+		 * cover SSP MSRs.
+		 */
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)) {
+			msr_info->data = vmx_read_guest_fred_ssp0(vmx);
+			break;
+		}
+		fallthrough;
  	default:
  	find_uret_msr:
  		msr = vmx_find_uret_msr(vmx, msr_info->index);
@@ -2540,7 +2574,18 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct 
msr_data *msr_info)
  		}
  		ret = kvm_set_msr_common(vcpu, msr_info);
  		break;
-
+	case MSR_IA32_PL0_SSP:
+		/*
+		 * If kvm_cpu_cap_has(X86_FEATURE_SHSTK) but
+		 * !guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK), XSAVES/XRSTORS
+		 * cover SSP MSRs.
+		 */
+		if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+		    guest_cpu_cap_has(vcpu, X86_FEATURE_FRED)) {
+			vmx_write_guest_fred_ssp0(vmx, data);
+			break;
+		}
+		fallthrough;
  	default:
  	find_uret_msr:
  		msr = vmx_find_uret_msr(vmx, msr_index);


3) Another change I was discussing with Chao:
https://lore.kernel.org/lkml/2ed04dff-e778-46c6-bd5f-51295763af06@zytor.com/

> 
>> I have the patches for 2) but they are not included in this series, because
>>
>> 1) how much do we care the value in MSR_IA32_PL0_SSP in such a guest?
>>
>> Yes, Chao told me that you are the one saying that MSRs can be used as
>> clobber registers and KVM should preserve the value.  Does MSR_IA32_PL0_SSP
>> in such a guest count?
> 
> If the architecture says that MSR_IA32_PL0_SSP exists and is accessible, then
> KVM needs to honor that.
> 
>> 2) Saving/restoring MSR_IA32_PL0_SSP adds complexity, though it's seldom
>> used.  Is it worth it?
> 
> Honoring the architecture is generally not optional.  There are extreme cases
> where KVM violates that rule and takes (often undocumented) erratum, e.g. APIC
> base relocation would require an absurd amount of complexity for no real world
> benefit.  But I would be very surprised if the complexity in KVM or QEMU to support
> this scenario is at all meaningful, let alone enough to justify diverging from
> the architectural spec.

Let me post v7 which includes all the required changes.

Thanks!
     Xin


