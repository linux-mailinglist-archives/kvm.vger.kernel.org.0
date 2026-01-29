Return-Path: <kvm+bounces-69500-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHYnN0LMemmu+gEAu9opvQ
	(envelope-from <kvm+bounces-69500-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 03:56:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A8866AB466
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 03:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 12911301DADB
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2582F3570D0;
	Thu, 29 Jan 2026 02:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7tw3YQR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE46264602;
	Thu, 29 Jan 2026 02:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769655347; cv=none; b=PhD7anh/aitN3jjoa1ocI9q6EUBCrrWqiGIK1zteGcjAjULujgSeg7YAXeh+3fDfAQGK2UZHA7bwz99Igtg5o6pQdmyns+QSQ8EuQ+lNN6Dys2CMva4UbKU4CSHuksXTMI6VjH/n48/Xm4Ua+TQqM+L3EF3JxERqDSp3gQNMCNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769655347; c=relaxed/simple;
	bh=BJjXZCZnv3j5oTHj+A7V+Py7z+aKrAN5yPJ56CHDN1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ePmPvhUYV34q2h53uxi0PKrT8p0Ux69qG3RNaEntpZx6pGJqd4yGS1Ycpwi4S5n3wulBqMiCYUFxQFgz/MegQ5UmUkujAc/yRQ9WR3TdhpD8MT6JsPMCKz1y96e6rHmYpHCq8xkw7wysgJ0znfzEoJWn/nms+gHVhu6rYbfoLp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7tw3YQR; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769655341; x=1801191341;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=BJjXZCZnv3j5oTHj+A7V+Py7z+aKrAN5yPJ56CHDN1o=;
  b=l7tw3YQRI7JOANBMa0podUIqwn+wXbr0IAF4Hi9mbemkUdqF3QCP3vj8
   IcgBjh7yXgSn940d7D1hrsBFzylF671zwJjVnd4R4A6rnDq4IqOovu9qy
   NeqeMQc2z3RGRzI4Eev/WpDxLC4qcjqb+++MJf8oZISxjFvQ291Tkwk/y
   s6s0O5c8u0zTaXepgASdLDs5tFuid13dsqa1qgbMkPsXUxvRvDyAki/13
   VnMNmJB7ivYSCAEgg7u6x0XLp1KOXbHHXAI4azcS1lFyyeaEUOOx/mFPl
   IgcDfDgL8uMV2H5Iowo38MQIW8mp5gTZJSTGji+sJ1IxQ0gu42xDp62aQ
   w==;
X-CSE-ConnectionGUID: ZT08Ao4+Q3++y7jPetKozw==
X-CSE-MsgGUID: theqoMljSOKB5F+5px/JPg==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="82252489"
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="82252489"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 18:55:34 -0800
X-CSE-ConnectionGUID: ROyvVfRPTuCbV6vhOcRPvA==
X-CSE-MsgGUID: 1GQLGSycTWCqMkJmSo8bxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,260,1763452800"; 
   d="scan'208";a="208460589"
Received: from unknown (HELO [10.238.3.203]) ([10.238.3.203])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 18:55:31 -0800
Message-ID: <0eff82fe-e3e9-43bb-907f-3279163489f0@intel.com>
Date: Thu, 29 Jan 2026 10:55:28 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] KVM: x86: Explicitly configure supported XSS from
 {svm,vmx}_set_cpu_caps()
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
References: <20260128014310.3255561-1-seanjc@google.com>
 <20260128014310.3255561-2-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20260128014310.3255561-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[xiaoyao.li@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-69500-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: A8866AB466
X-Rspamd-Action: no action

On 1/28/2026 9:43 AM, Sean Christopherson wrote:
> Explicitly configure KVM's supported XSS as part of each vendor's setup
> flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
> to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
> VMX is enabled, i.e. when nested=1.  The late clearing results in
> nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
> when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
> ultimately leading to a mismatched VMCS config due to the reference config
> having the CET bits set, but every CPU's "local" config having the bits
> cleared.
> 
> Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
> kvm_x86_vendor_init(), before calling into vendor code, and not referenced
> between ops->hardware_setup() and their current/old location.

I'm thinking whether to move the initialization of supported_xss from 
kvm_x86_vendor_init() to kvm_setup_xss_caps(). Anyway it can be a 
separate patch, if we agree to make the change.

For this fixing patch,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
> Cc: stable@vger.kernel.org
> Cc: Mathias Krause <minipli@grsecurity.net>
> Cc: John Allen <john.allen@amd.com>
> Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Cc: Chao Gao <chao.gao@intel.com>
> Cc: Binbin Wu <binbin.wu@linux.intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/svm/svm.c |  2 ++
>   arch/x86/kvm/vmx/vmx.c |  2 ++
>   arch/x86/kvm/x86.c     | 30 +++++++++++++++++-------------
>   arch/x86/kvm/x86.h     |  2 ++
>   4 files changed, 23 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7803d2781144..c00a696dacfc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5387,6 +5387,8 @@ static __init void svm_set_cpu_caps(void)
>   	 */
>   	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
>   	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
> +
> +	kvm_setup_xss_caps();
>   }
>   
>   static __init int svm_hardware_setup(void)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 27acafd03381..9f85c3829890 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8230,6 +8230,8 @@ static __init void vmx_set_cpu_caps(void)
>   		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
>   		kvm_cpu_cap_clear(X86_FEATURE_IBT);
>   	}
> +
> +	kvm_setup_xss_caps();
>   }
>   
>   static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 8acfdfc583a1..cac1d6a67b49 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9965,6 +9965,23 @@ static struct notifier_block pvclock_gtod_notifier = {
>   };
>   #endif
>   
> +void kvm_setup_xss_caps(void)
> +{
> +	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> +		kvm_caps.supported_xss = 0;
> +
> +	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> +	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +
> +	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
> +		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> +		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> +		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> +	}
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
> +
>   static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
>   {
>   	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
> @@ -10138,19 +10155,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   	if (!tdp_enabled)
>   		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
>   
> -	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> -		kvm_caps.supported_xss = 0;
> -
> -	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
> -	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
> -		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> -
> -	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
> -		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
> -		kvm_cpu_cap_clear(X86_FEATURE_IBT);
> -		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
> -	}
> -
>   	if (kvm_caps.has_tsc_control) {
>   		/*
>   		 * Make sure the user can only configure tsc_khz values that
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 70e81f008030..94d4f07aaaa0 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -483,6 +483,8 @@ extern struct kvm_host_values kvm_host;
>   extern bool enable_pmu;
>   extern bool enable_mediated_pmu;
>   
> +void kvm_setup_xss_caps(void);
> +
>   /*
>    * Get a filtered version of KVM's supported XCR0 that strips out dynamic
>    * features for which the current process doesn't (yet) have permission to use.


