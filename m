Return-Path: <kvm+bounces-32712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA0A9DB1B1
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 04:08:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7C7D166F0A
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 03:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E4A86252;
	Thu, 28 Nov 2024 03:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YtaTq7L+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4ED6F2F2;
	Thu, 28 Nov 2024 03:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732763295; cv=none; b=aXc2L/uYW6kj6hvdN0kGAWGhVenSoqaQ+eQpitpqcPPAUztXlnITytqHFItakDNULS03frkokBJ0qtIjxsVEdbyokh4oWSF1ZVFhIuL2E1ZYJhgoQLIxy/Eqzr8owI9oSPatPt/6OKJHid0BkdfAvCBj509XBjkvPMVdbehJHCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732763295; c=relaxed/simple;
	bh=HtnlMtuuCAwEnKb60bWqVXiiSx3vAT0XcEhXT9fkaw8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IfHQVvxTVHNYdUWPRFbwwuC73lkVQ7QYn6U01WA6prJewO2Ht6nMEmAWCFk72SJ2idltDlbNniSvTPbvaNjXXTH3ATu8zofi8znzhIggFM/K1D8pUKhczk4yo+QNASH40L6F/AGnR8H3Dw4Ee4N5dKB976HeozyaTczuM50Oclo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YtaTq7L+; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732763294; x=1764299294;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HtnlMtuuCAwEnKb60bWqVXiiSx3vAT0XcEhXT9fkaw8=;
  b=YtaTq7L+xUL7+FfUkqJzMu/JTXe6XH7STpJeXdSZUIbAcjJ7OtQ8chfE
   vuJr0d16JJIeYWKMgjlHVKtHCDMgB99Dj2PjJdt+REQkbDnTH1Qkc9fTF
   /qLcY6JpJvHf2BGl9Wyg1eIK5P5BATHj0YI4lrdI0W+rSQ9HuJS7RaSsV
   t4/HHERLYfRq5HlegU4rZPe8zB380d6kIJZdcCobs3O51JOUOYB86lC52
   j1K9/MEXlaTIBA8ZMAnoSLFETReSj/XblB5LZJgLy3H78j0W2um/xk8GF
   xPPWRXtEvNu6u1GpbN7PjRUTuZdALUFM0on2sbiXvge/OX3fY/vUBlGg0
   Q==;
X-CSE-ConnectionGUID: PFJQd1+pTDqrc6+bPRyPyg==
X-CSE-MsgGUID: iYnZ22nvQsqnawCPcLFCyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11269"; a="32919112"
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="32919112"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:08:14 -0800
X-CSE-ConnectionGUID: F8LzMGRkR+2qILyRS3ityQ==
X-CSE-MsgGUID: TTlfjsq/S3KP8YiLpdLshg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,191,1728975600"; 
   d="scan'208";a="92505947"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2024 19:08:11 -0800
Message-ID: <ce45a9cb-44a4-4a3d-bc81-608a0871ae6d@intel.com>
Date: Thu, 28 Nov 2024 11:08:08 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] KVM: x86: Always complete hypercall via function
 callback
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Tom Lendacky <thomas.lendacky@amd.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
 Kai Huang <kai.huang@intel.com>
References: <20241128004344.4072099-1-seanjc@google.com>
 <20241128004344.4072099-6-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20241128004344.4072099-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/2024 8:43 AM, Sean Christopherson wrote:
> Finish "emulation" of KVM hypercalls by function callback, even when the
> hypercall is handled entirely within KVM, i.e. doesn't require an exit to
> userspace, and refactor __kvm_emulate_hypercall()'s return value to *only*
> communicate whether or not KVM should exit to userspace or resume the
> guest.
> 
> (Ab)Use vcpu->run->hypercall.ret to propagate the return value to the
> callback, purely to avoid having to add a trampoline for every completion
> callback.
> 
> Using the function return value for KVM's control flow eliminates the
> multiplexed return value, where '0' for KVM_HC_MAP_GPA_RANGE (and only
> that hypercall) means "exit to userspace".
> 
> Note, the unnecessary extra indirect call and thus potential retpoline
> will be eliminated in the near future by converting the intermediate layer
> to a macro.
> 
> Suggested-by: Binbin Wu <binbin.wu@linux.intel.com>
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/x86.c | 29 ++++++++++++-----------------
>   arch/x86/kvm/x86.h | 10 ++++++----
>   2 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 11434752b467..39be2a891ab4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9982,10 +9982,11 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl)
> +int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			    unsigned long a0, unsigned long a1,
> +			    unsigned long a2, unsigned long a3,
> +			    int op_64_bit, int cpl,
> +			    int (*complete_hypercall)(struct kvm_vcpu *))
>   {
>   	unsigned long ret;
>   
> @@ -10061,7 +10062,7 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   			vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;
>   
>   		WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
> -		vcpu->arch.complete_userspace_io = complete_hypercall_exit;
> +		vcpu->arch.complete_userspace_io = complete_hypercall;
>   		/* stat is incremented on completion. */
>   		return 0;
>   	}
> @@ -10071,13 +10072,15 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   	}
>   
>   out:
> -	return ret;
> +	vcpu->run->hypercall.ret = ret;
> +	complete_hypercall(vcpu);
> +	return 1;

shouldn't it be

	return complete_hypercall(vcpu);

?

Originally, kvm_emulate_hypercall() returns 
kvm_skip_emulated_instruction(). Now it becomes

	kvm_skip_emulated_instruction();
	return 1;

I don't go deep to see if kvm_skip_emulated_instruction() always return 
1 for this case. But logically,

	return complete_hypercall(vcpu);

looks more reasonable.

>   }
>   EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
>   
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   {
> -	unsigned long nr, a0, a1, a2, a3, ret;
> +	unsigned long nr, a0, a1, a2, a3;
>   	int op_64_bit;
>   	int cpl;
>   
> @@ -10095,16 +10098,8 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   	op_64_bit = is_64_bit_hypercall(vcpu);
>   	cpl = kvm_x86_call(get_cpl)(vcpu);
>   
> -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> -		return 0;
> -
> -	if (!op_64_bit)
> -		ret = (u32)ret;
> -	kvm_rax_write(vcpu, ret);
> -
> -	return kvm_skip_emulated_instruction(vcpu);
> +	return __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl,
> +				       complete_hypercall_exit);
>   }
>   EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>   
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 6db13b696468..28adc8ea04bf 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -617,10 +617,12 @@ static inline bool user_exit_on_hypercall(struct kvm *kvm, unsigned long hc_nr)
>   	return kvm->arch.hypercall_exit_enabled & BIT(hc_nr);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl);
> +int __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			    unsigned long a0, unsigned long a1,
> +			    unsigned long a2, unsigned long a3,
> +			    int op_64_bit, int cpl,
> +			    int (*complete_hypercall)(struct kvm_vcpu *));
> +
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>   
>   #endif


