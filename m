Return-Path: <kvm+bounces-57687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D02B58F16
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 09:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 490961BC380F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5281B2DECDF;
	Tue, 16 Sep 2025 07:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nlxg2PMN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B1619AD48;
	Tue, 16 Sep 2025 07:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758007429; cv=none; b=e4JYpALcmp89cyCH7pLCtPgbWMYnPZh++vPcI5yL5cESBkpcT7DsdoPZzxQGyhAzp6P020WotlVutseHQ1ZxK9abuCDcl+J4uyptn3xdqzjKrvpmrYBqE/Dav1TrAsWMRF5dRQ9vUrnxNMrmTVN10X4haplE+lDbSMhtSfCkRgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758007429; c=relaxed/simple;
	bh=Yf/8hYPN/q0LzDANImUzGnbKSGWsKsddfBmnlqg34+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nuSQLrFaQRBZox04eJYXBPViZAVk2vCmVvvnKTCuUVRW6zTc3YpJkTW5ufd/vuAasqmLfb2S3AdVPX5XaCniYhVxc2tqfOEL4iRGuzuidc4q5QhF73jEDU/el0bJrp8yHSKQy/RB1qU/voJMKnYOUZ1AqMVs/Dl1TAJn2E8oS9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nlxg2PMN; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758007426; x=1789543426;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Yf/8hYPN/q0LzDANImUzGnbKSGWsKsddfBmnlqg34+A=;
  b=nlxg2PMNB1yFkppi4zceGKOaAZubLNmwKCAJRFHuzOw7LaIE4DV1ZoJn
   IuAuTRys6DAH35MsIf1Bb9myq62ZknhG7che25SYf9aUgYag054kbd4xW
   lHg7G03o3sgLm2ELubRYs18FSTFruxZYZQVVzqVv6BQxHS8dFONcRd5UG
   Nev66wIt+1YKQ0Rs7hIPs3OCfmF/Q81EMTnp8tNBebf2yGWZNJ8Q9my3y
   KE0BIP+gfLPfJ6Ys+Ob3d6Sd+zmC1YCFydX7iJ19C72RReV1gIH8l4RNG
   NSDIMMMvJCmsvAFfMtyM0rvSlv1eFbQdxflL4Fw9mZ2xq5PLoH8wsOMl+
   Q==;
X-CSE-ConnectionGUID: d0S8w3R7QM+ZMJ2biOD0Rg==
X-CSE-MsgGUID: OnprL7brRI+YLUiqOwSu7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="70899869"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="70899869"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:23:45 -0700
X-CSE-ConnectionGUID: w09WolwjRpu4HNhfiLngIg==
X-CSE-MsgGUID: 0oXGfAkORmKuTHlUQ0CJMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174678520"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2025 00:23:42 -0700
Message-ID: <41c80c3f-d05e-4cbd-9564-1cc5e0724690@linux.intel.com>
Date: Tue, 16 Sep 2025 15:23:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 07/41] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-8-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250912232319.429659-8-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/13/2025 7:22 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
> due to XSS MSR modification.
> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
> before allocate sufficient xsave buffer.
>
> Note, KVM does not yet support any XSS based features, i.e. supported_xss
> is guaranteed to be zero at this time.
>
> Opportunistically skip CPUID updates if XSS value doesn't change.
>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/cpuid.c | 3 ++-
>   arch/x86/kvm/x86.c   | 2 ++
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 46cf616663e6..b5f87254ced7 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -316,7 +316,8 @@ static void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
>   	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 1);
>   	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>   		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
> +						 vcpu->arch.ia32_xss, true);
>   }
>   
>   static bool kvm_cpuid_has_hyperv(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5a5af40c06a9..519d58b82f7f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3993,6 +3993,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		 */
>   		if (data & ~vcpu->arch.guest_supported_xss)
>   			return 1;
> +		if (vcpu->arch.ia32_xss == data)
> +			break;
>   		vcpu->arch.ia32_xss = data;
>   		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>   		break;


