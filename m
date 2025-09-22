Return-Path: <kvm+bounces-58360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE20CB8F49B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:25:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4FCC3B66C2
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7492F5A19;
	Mon, 22 Sep 2025 07:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b+EXKeQd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04EA7212578;
	Mon, 22 Sep 2025 07:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758525922; cv=none; b=WMgQK5fBlUOYFnto40Yu9lywG5pnaGY5YUdL7qQcL6S3IyjU5aNNzP3rk2HyuSl3aaGWX8XM2USOgdiUCt1q+WTXOwS3X2XU6AxxOijmy19XRPEHkpWVM+Cm3LtjMu5ioELtzUHJYtJwR1bIieCWhsbOHQRz/Q6zbgPV4s/Ce2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758525922; c=relaxed/simple;
	bh=zgYPwSd7h2h/iajm7Yw03doKtbIcXSLqMklWJTw6wK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uv3aKegnwCGKe+tSBefFk1aA78Sr1mho+N5Kfehl3Whzk/NL1RttVkYavRD+mHT2hIZBCvztSsTHrpNylG4LxE0tsvInY25p421h2hXjiL2T3p5hTtkdLafkyQ8r2NN3BqkWo2BehE6+eTTWsIwG4QS6qm/rVn996w6EtSGo5ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b+EXKeQd; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758525921; x=1790061921;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zgYPwSd7h2h/iajm7Yw03doKtbIcXSLqMklWJTw6wK8=;
  b=b+EXKeQdcSbdbRXk3nz/PfzHaQR6lUK6h0ndsi8PfxTcdSjNwsarRMj8
   73CvQRbSgU2Zb+5EfoK8UAqCpGvr0xTNsUxKzf75MdPFflgZfR2/a7jR1
   9ucmUT7fEejVHbi5RqLgS5YYsfpDbgZjCQ2PY8hMYzWaAWcU9nVWDRRMK
   DrPtIsrOG9VXy2Y5UHwcIeK4R6Y7c78KcZNAcsjxQboFA444Vl4RAJuyO
   I4OU8G4YgPXwYccwLc+od5X+RdhwOoi+q4q+/v74nUPZHlFfI1RW9FyOP
   KDzRn8y5DH5oLzN8xtTvPjA+CKbBNhhGfgP6/jtBfQ9Xw2iWK53LRE7ni
   Q==;
X-CSE-ConnectionGUID: E85T+R2CRySpN7EQ3UW+pg==
X-CSE-MsgGUID: L5+dnVgOTJWWmu+it6fL1g==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="59820083"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="59820083"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:25:14 -0700
X-CSE-ConnectionGUID: 7zSHwH9DQzWQEbw0lTqH/w==
X-CSE-MsgGUID: dooSLQzHTjaliOXNr569Kg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="176317319"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:25:08 -0700
Message-ID: <ed332d81-9e22-41e3-95cb-9bebca1b00f6@linux.intel.com>
Date: Mon, 22 Sep 2025 15:25:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 23/51] KVM: x86: Allow setting CR4.CET if IBT or SHSTK
 is supported
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-24-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-24-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> From: Yang Weijiang <weijiang.yang@intel.com>
>
> Drop X86_CR4_CET from CR4_RESERVED_BITS and instead mark CET as reserved
> if and only if IBT *and* SHSTK are unsupported, i.e. allow CR4.CET to be
> set if IBT or SHSTK is supported.  This creates a virtualization hole if
> the CPU supports both IBT and SHSTK, but the kernel or vCPU model only
> supports one of the features.  However, it's entirely legal for a CPU to
> have only one of IBT or SHSTK, i.e. the hole is a flaw in the architecture,
> not in KVM.
>
> More importantly, so long as KVM is careful to initialize and context
> switch both IBT and SHSTK state (when supported in hardware) if either
> feature is exposed to the guest, a misbehaving guest can only harm itself.
> E.g. VMX initializes host CET VMCS fields based solely on hardware
> capabilities.
>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: Mathias Krause <minipli@grsecurity.net>
> Tested-by: John Allen <john.allen@amd.com>
> Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 2 +-
>   arch/x86/kvm/x86.h              | 3 +++
>   2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 554d83ff6135..39231da3a3ff 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -142,7 +142,7 @@
>   			  | X86_CR4_OSXSAVE | X86_CR4_SMEP | X86_CR4_FSGSBASE \
>   			  | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_VMXE \
>   			  | X86_CR4_SMAP | X86_CR4_PKE | X86_CR4_UMIP \
> -			  | X86_CR4_LAM_SUP))
> +			  | X86_CR4_LAM_SUP | X86_CR4_CET))
>   
>   #define CR8_RESERVED_BITS (~(unsigned long)X86_CR8_TPR)
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 65cbd454c4f1..f3dc77f006f9 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -680,6 +680,9 @@ static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
>   		__reserved_bits |= X86_CR4_PCIDE;       \
>   	if (!__cpu_has(__c, X86_FEATURE_LAM))           \
>   		__reserved_bits |= X86_CR4_LAM_SUP;     \
> +	if (!__cpu_has(__c, X86_FEATURE_SHSTK) &&       \
> +	    !__cpu_has(__c, X86_FEATURE_IBT))           \
> +		__reserved_bits |= X86_CR4_CET;         \
>   	__reserved_bits;                                \
>   })
>   


