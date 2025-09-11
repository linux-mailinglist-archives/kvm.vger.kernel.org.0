Return-Path: <kvm+bounces-57282-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F1EDB52983
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 09:02:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56BA51C23702
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 07:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49A4B265632;
	Thu, 11 Sep 2025 07:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AAvuE2VD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0827E329F0F;
	Thu, 11 Sep 2025 07:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757574146; cv=none; b=Lw/T6juE5F2HwiLVuPUzTMj1aqscFMWNWyUlP4ma2sT95aURY9wQQff0KeIqh1+05xpdOhHlZta1sncR+0HLxevnVeplawjFyYh+ZLMPvfQJxXpeJWMJo17LSb7no4iC7oxu7f2rXbRmNP6eE+x+7QCwA7Pt4f5e0dyJ3cO/pDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757574146; c=relaxed/simple;
	bh=TtDGs5cCuBB/0vsasgCRdQvt55EHjiBp1kQwXGLwQow=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FEjyVFn5SRE5U1FaQgNiHWKuCRfECQt6RBDCyVj5ILALjvSsLkaM2HZq9SO1yzDhV33YyfJzHfO3H7SuHKuEXoJRqJRs/K3QTmnx8vvMeEZpyhlzL+Lxdnlcf9xQchEnaSXG+T6QHMdohww9Dp3aH3IwucW9jORH3zdPXfRiUVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AAvuE2VD; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757574145; x=1789110145;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TtDGs5cCuBB/0vsasgCRdQvt55EHjiBp1kQwXGLwQow=;
  b=AAvuE2VDtDuTPufjrNUlB1cTjmV6vx8YpofvwJ6GWcRxVYpEGcfnqwkd
   iGp4xZ3x0mLM0T7SaeTswV69FgfJ4Y2bvySmY1T6va2K8xKazsbEQnu0E
   ipLBjWYtuQIii+DMwWlFpCXwQJmynBkgzX6gx8Un5AkEQvpO1zy6QYI34
   5k0gdxxy2RGSJ0Ka6ds+adv2iay5BH76w1ic5pdC5uz1Z2EeWOEKk+bli
   O9g4UezI+NAuUvNrWHTzl/NZ9cUNSz9N3S8Txv6a1DC3KtChNhlfWz/5Z
   hf+Nbbfm9DNPpgKLiOYfOVyhhmgjR3uk6wQANxqiNGldCv+Lh8vUiJ/vX
   Q==;
X-CSE-ConnectionGUID: ezK8Mu0dQiSWJl4gmVXnUA==
X-CSE-MsgGUID: 0g7GE/j0QRixqdLw+5dhqw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59844086"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59844086"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 00:02:24 -0700
X-CSE-ConnectionGUID: +uG7AjgWRzSKDV9DIsJjWw==
X-CSE-MsgGUID: P+d9dd6/RUmd3TObSrB46A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,256,1751266800"; 
   d="scan'208";a="204381029"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2025 00:02:19 -0700
Message-ID: <27d1afdc-350c-45a0-a4f9-1d9688314256@linux.intel.com>
Date: Thu, 11 Sep 2025 15:02:16 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 04/22] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
To: Chao Gao <chao.gao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 john.allen@amd.com, mingo@kernel.org, mingo@redhat.com,
 minipli@grsecurity.net, mlevitsk@redhat.com, namhyung@kernel.org,
 pbonzini@redhat.com, prsampat@amd.com, rick.p.edgecombe@intel.com,
 seanjc@google.com, shuah@kernel.org, tglx@linutronix.de,
 weijiang.yang@intel.com, x86@kernel.org, xin@zytor.com, xiaoyao.li@intel.com
References: <20250909093953.202028-1-chao.gao@intel.com>
 <20250909093953.202028-5-chao.gao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250909093953.202028-5-chao.gao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/2025 5:39 PM, Chao Gao wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
> due to XSS MSR modification.
> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
> before allocate sufficient xsave buffer.

Nit:
allocate -> allocating.

Otherwise,
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

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
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
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
> index 6c167117018c..bbae3bf405c7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4020,6 +4020,8 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   		 */
>   		if (data & ~vcpu->arch.guest_supported_xss)
>   			return 1;
> +		if (vcpu->arch.ia32_xss == data)
> +			break;
>   		vcpu->arch.ia32_xss = data;
>   		vcpu->arch.cpuid_dynamic_bits_dirty = true;
>   		break;


