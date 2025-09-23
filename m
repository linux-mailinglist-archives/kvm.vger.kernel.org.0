Return-Path: <kvm+bounces-58540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC12FB966F0
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 16:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8675C323582
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 14:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B9526A08C;
	Tue, 23 Sep 2025 14:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/IrROhS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA8E263899;
	Tue, 23 Sep 2025 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758638810; cv=none; b=ZBfETMEzjrm0p5f8dJUzEZB0QxBdVFS5vuDGxk5EY4Q+wzIXtkjmyqeLIABu+btJxlCF3ne9ll0MXHQd4/REofrgaq2mUDOhhYKZDaNaBg4pl2NAA3nTLV/tss9t8bGZPiKviekBTM+X05x235zs+E2LkZz96fSSOedpfHQ3piI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758638810; c=relaxed/simple;
	bh=QAyl6N6s6CyTsAmkHEtDQY+dzBkOK1eUdGWVdnftp14=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DrLH4t0UaDULfeIm5A+FHM3mr9u37beeqzvZbGYA8lqH6423cSWyfRxVD+LTw4zYddLv0JcPTqb1bf3mm9CLHCvGDFjHb9T3a5XwO2HC3Rxezaq9kzI9nO+QdvFN7sC+JN1YAtUBaawwQCV5X3OhoeYUydgCWxKt+J3hrVDIhwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/IrROhS; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758638808; x=1790174808;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QAyl6N6s6CyTsAmkHEtDQY+dzBkOK1eUdGWVdnftp14=;
  b=j/IrROhSA2OBXqUdqP/cE3Vu4zBcgrjLQKdFnupEYV7NytiuvtKI6L7U
   yZfohJLNs1wJYHXov06bsynZSOT9qAX5rhJdIcNiKT2Zo2HK/Qe2yK24j
   OT10+zLCllLSVBoscIPjLbcOFeXgDegOJRmgb65yg0GY/Lp2exp/BPlXT
   nF1j/bXUs+k2P+SRoiClqdyHRBMDWV3cbw5TxmMbk9EvPJFPtmDHWF9UZ
   wE1UvN6cjC8DeAQw+Drk51oStJ0ey8hSuu5eX3lpYrLLrgH+KUIWeP+BG
   IOF/MQTup4GmB3L4QWOIm2sESw/ohlXxR5N/Wxwc62lNta+RQPMtakqy6
   Q==;
X-CSE-ConnectionGUID: Hvw+dek0TcyXLZiHdVANwA==
X-CSE-MsgGUID: k86ronLNQkGSp44Omf0cxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60975141"
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="60975141"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:46:47 -0700
X-CSE-ConnectionGUID: HFyaSItMTQCCXEMbcJdBUg==
X-CSE-MsgGUID: I3HGN0HWR1+OUC1hkkRZZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,288,1751266800"; 
   d="scan'208";a="182048471"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.238.14]) ([10.124.238.14])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2025 07:46:44 -0700
Message-ID: <12ebc4cb-f8ba-486f-9205-85d7e5516c52@intel.com>
Date: Tue, 23 Sep 2025 22:46:41 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 23/51] KVM: x86: Allow setting CR4.CET if IBT or SHSTK
 is supported
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Binbin Wu <binbin.wu@linux.intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-24-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

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


