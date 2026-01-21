Return-Path: <kvm+bounces-68680-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHobId93cGktYAAAu9opvQ
	(envelope-from <kvm+bounces-68680-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 07:53:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E621552667
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 07:53:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0AC39742A72
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 06:47:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 574563328FC;
	Wed, 21 Jan 2026 06:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nVGzQRda"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA2D311C15;
	Wed, 21 Jan 2026 06:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977908; cv=none; b=CqY6gT5IZuxv7+mZpxcU9rJkO5k8QjGxuEuamFv8tgrpaftWx2werBkB25L0PjXWBgbc7HBEi2fvfJOUZ/0W2UPwAtj8nh2ETfmMUMXB1t2oh7qTD07qbtAFc27plTAehMiFZAh43yww51XMSHQctblC3HUqTHZGP/ZgKI68CRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977908; c=relaxed/simple;
	bh=emFmtGjBh2YKCKjrMYKM35tuLZPSVERmIvEJbX2hJ18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=twNswR3nsx63RBDsdedg4WnEVadiVu575cxhozKwooDb6evA4wQcouelv5MID5JKvxrz+oCHJICyRMs8T7+oXHfxf7CZuWW06+zotAv7LFGNvsloHs9Xpx+XzDVmD/Su/jOR5oDEFF4BlRmTNghmsBDtr+de2nuvh7GflnEhpOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nVGzQRda; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768977906; x=1800513906;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=emFmtGjBh2YKCKjrMYKM35tuLZPSVERmIvEJbX2hJ18=;
  b=nVGzQRda+1CHEK9EekqLyp5OqlibYwFJul60zdLf9jEUSjMgqwaUEiHo
   usu4dvxECuh9UB/QD9Hy5XGESYk/6I0076NxYvjC5OoGnpjB5Mm4ajOnT
   SVxku5EtQoaZ0HJCh5kjHjkBBSHlMWkcI4lg9OGQrEHow5HkpnfuS8oei
   rc6V9kG17piVF3x7mMoR8v5ttwzEmQ60m2WBOSFaF06TGizY/fXNTuE/s
   xVOklr+PVt6YlI4BCTF2kZlkUuR1nV7MGrxIJcHqlxSfOPS6n6h0VSkV/
   EU1Q3ZZ1EvMlFIZU7caf9e0ipcYQV6oPYN/LM4krwKJkOtGUq8qp9Vkrm
   A==;
X-CSE-ConnectionGUID: /m3vWnOlQAim0az8PAaI0w==
X-CSE-MsgGUID: mW+s9bpOTE6o1NiCeBOvFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11677"; a="81644458"
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="81644458"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 22:45:05 -0800
X-CSE-ConnectionGUID: /EJRXMFXR7iCgu3yICXfYw==
X-CSE-MsgGUID: yg/ujrYvSdGYG75C7dU65A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,242,1763452800"; 
   d="scan'208";a="206415896"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 22:45:00 -0800
Message-ID: <8731e234-22b8-4ccf-89ef-63feed09e9c5@linux.intel.com>
Date: Wed, 21 Jan 2026 14:44:58 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 07/22] KVM: VMX: Initialize VMCS FRED fields
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
 corbet@lwn.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, andrew.cooper3@citrix.com, chao.gao@intel.com,
 hch@infradead.org, sohil.mehta@intel.com
References: <20251026201911.505204-1-xin@zytor.com>
 <20251026201911.505204-8-xin@zytor.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251026201911.505204-8-xin@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68680-lists,kvm=lfdr.de];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[binbin.wu@linux.intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,linux.intel.com:mid,intel.com:email,intel.com:dkim]
X-Rspamd-Queue-Id: E621552667
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 10/27/2025 4:18 AM, Xin Li (Intel) wrote:
> From: Xin Li <xin3.li@intel.com>
> 
> Initialize host VMCS FRED fields with host FRED MSRs' value and
> guest VMCS FRED fields to 0.
> 
> FRED CPU state is managed in 9 new FRED MSRs:
>         IA32_FRED_CONFIG,
>         IA32_FRED_STKLVLS,
>         IA32_FRED_RSP0,
>         IA32_FRED_RSP1,
>         IA32_FRED_RSP2,
>         IA32_FRED_RSP3,
>         IA32_FRED_SSP1,
>         IA32_FRED_SSP2,
>         IA32_FRED_SSP3,
> as well as a few existing CPU registers and MSRs:
>         CR4.FRED,
>         IA32_STAR,
>         IA32_KERNEL_GS_BASE,
>         IA32_PL0_SSP (also known as IA32_FRED_SSP0).
> 
> CR4, IA32_KERNEL_GS_BASE and IA32_STAR are already well managed.
> Except IA32_FRED_RSP0 and IA32_FRED_SSP0, all other FRED CPU state
> MSRs have corresponding VMCS fields in both the host-state and
> guest-state areas.  So KVM just needs to initialize them, and with
> proper VM entry/exit FRED controls, a FRED CPU will keep tracking
> host and guest FRED CPU state in VMCS automatically.
> 

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

[...]

> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fcfa99160018..c8b5359123bf 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1459,6 +1459,15 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu)
>  				    (unsigned long)(cpu_entry_stack(cpu) + 1));
>  		}
>  
> +		/* Per-CPU FRED MSRs */
> +		if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> +#ifdef CONFIG_X86_64

Nit:

Is this needed?

FRED is initialized by X86_64_F(), if CONFIG_X86_64 is not enabled, this
path is not reachable.
There should be no compilation issue without #ifdef CONFIG_X86_64 / #endif.

There are several similar patterns in this patch, using  #ifdef CONFIG_X86_64 / 
#endif or not seems not consistent. E.g. __vmx_vcpu_reset() and init_vmcs()
doesn't check the config, but here does.

> +			vmcs_write64(HOST_IA32_FRED_RSP1, __this_cpu_ist_top_va(ESTACK_DB));
> +			vmcs_write64(HOST_IA32_FRED_RSP2, __this_cpu_ist_top_va(ESTACK_NMI));
> +			vmcs_write64(HOST_IA32_FRED_RSP3, __this_cpu_ist_top_va(ESTACK_DF));
> +#endif
> +		}
> +
>  		vmx->loaded_vmcs->cpu = cpu;
>  	}
>  }
> @@ -4330,6 +4339,17 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
>  	 */
>  	vmcs_write16(HOST_DS_SELECTOR, 0);
>  	vmcs_write16(HOST_ES_SELECTOR, 0);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> +		/* FRED CONFIG and STKLVLS are the same on all CPUs */
> +		vmcs_write64(HOST_IA32_FRED_CONFIG, kvm_host.fred_config);
> +		vmcs_write64(HOST_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
> +
> +		/* Linux doesn't support kernel shadow stacks, thus SSPs are 0s */
> +		vmcs_write64(HOST_IA32_FRED_SSP1, 0);
> +		vmcs_write64(HOST_IA32_FRED_SSP2, 0);
> +		vmcs_write64(HOST_IA32_FRED_SSP3, 0);
> +	}
>  #else
>  	vmcs_write16(HOST_DS_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
>  	vmcs_write16(HOST_ES_SELECTOR, __KERNEL_DS);  /* 22.2.4 */
> @@ -4841,6 +4861,17 @@ static void init_vmcs(struct vcpu_vmx *vmx)
>  	}
>  
>  	vmx_setup_uret_msrs(vmx);
> +
> +	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> +		vmcs_write64(GUEST_IA32_FRED_CONFIG, 0);
> +		vmcs_write64(GUEST_IA32_FRED_RSP1, 0);
> +		vmcs_write64(GUEST_IA32_FRED_RSP2, 0);
> +		vmcs_write64(GUEST_IA32_FRED_RSP3, 0);
> +		vmcs_write64(GUEST_IA32_FRED_STKLVLS, 0);
> +		vmcs_write64(GUEST_IA32_FRED_SSP1, 0);
> +		vmcs_write64(GUEST_IA32_FRED_SSP2, 0);
> +		vmcs_write64(GUEST_IA32_FRED_SSP3, 0);
> +	}
>  }
>  
>  static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
> @@ -8717,6 +8748,11 @@ __init int vmx_hardware_setup(void)
>  
>  	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
>  
> +	if (kvm_cpu_cap_has(X86_FEATURE_FRED)) {
> +		rdmsrl(MSR_IA32_FRED_CONFIG, kvm_host.fred_config);
> +		rdmsrl(MSR_IA32_FRED_STKLVLS, kvm_host.fred_stklvls);
> +	}
> +
>  	return r;
>  }
>  
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index f3dc77f006f9..0c1fbf75442b 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -52,6 +52,9 @@ struct kvm_host_values {
>  	u64 xss;
>  	u64 s_cet;
>  	u64 arch_capabilities;
> +
> +	u64 fred_config;
> +	u64 fred_stklvls;
>  };
>  
>  void kvm_spurious_fault(void);


