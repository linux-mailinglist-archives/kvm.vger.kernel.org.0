Return-Path: <kvm+bounces-30459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4D6C9BAE88
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 09:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1518A1C2147E
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 08:50:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08C01AB6CC;
	Mon,  4 Nov 2024 08:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mTvW/bXY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F86E1494B1;
	Mon,  4 Nov 2024 08:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730710206; cv=none; b=OsjOevcrGHLvDeKGvqj3gsgwMBqB9LUBy17XB4p/6Ld7dNXXPeKmaZ7yLkN9GBtreCGp0AxrIxqwUjP7dn6+XlIFW/nJy8hIlWrHLKV3vaX6tqR+J+mX90wd0AULvNzLLUrYwvVfdAFeFd5fStrWZE4ZGLaiHYtB/9gFUkCS7KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730710206; c=relaxed/simple;
	bh=5o4cDQtU8wPPXLF0ckxsf8HLWysGFSinbqKa6qqgBoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R/odKmXmlxDFfBSqUR9edqrZfvtTeFh3fwcfAtHdeywVHix0luSvDaC6v9bdLb95nDZ3P2se3sg2Fs174Ikx3cYbs9RMH2OZoMPCIXfo3Zpgg1CvN1/m7Yx9JXPU25sU8yYIqcbLIiGx2eg3IaozjcxoZK8B8x4914EEW1vIpow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mTvW/bXY; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730710204; x=1762246204;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5o4cDQtU8wPPXLF0ckxsf8HLWysGFSinbqKa6qqgBoc=;
  b=mTvW/bXYlavZ0mrCzfy5gJmlPg7hkN5qjPrYuuIvZJMnQ7AIMA1xsXoM
   uEIC/0OQAWXJFTK8IgOeOW/1lahYu/mTaepTxt9PCSuqTyZqwdm0p6K5Z
   oifosgMWYbtZBwrX3mBOSbmYElrcWCw8UwSGMYj8ok7SW0H0nfElLvOxA
   0hj0xDlLuV4oUJDZ2Rj0fHld0AkbTlCGV3AT9Uj3s4gK8vMYga+jI7qoG
   6b5TBYubWbO1NUvUyHwv51Opnc/RUK+xQULJAnJtPNU2eznLcnDcIMoAx
   wJd0qqBaywKXbwTtIv1/7cVwbPxTuwuiMxgr+JGurFdKhdMfJS552tXCI
   g==;
X-CSE-ConnectionGUID: gY9UTFOITsKX+S0/nTFmgQ==
X-CSE-MsgGUID: /l5dCslKSpmomd6bMgEEBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52957360"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52957360"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:50:01 -0800
X-CSE-ConnectionGUID: HPnvxhSkRHq83KnY8LJc4Q==
X-CSE-MsgGUID: qXQqZ0N7RHWSBd3Dg9zOow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,256,1725346800"; 
   d="scan'208";a="106938291"
Received: from unknown (HELO [10.238.12.149]) ([10.238.12.149])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 00:49:55 -0800
Message-ID: <f95cd8c6-af5c-4d8f-99a8-16d0ec56d9a4@linux.intel.com>
Date: Mon, 4 Nov 2024 16:49:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
To: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 Isaku Yamahata <isaku.yamahata@intel.com>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
 <20240826022255.361406-2-binbin.wu@linux.intel.com>
 <ZyKbxTWBZUdqRvca@google.com>
 <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
 <ZyLWMGcgj76YizSw@google.com>
 <1cace497215b025ed8b5f7815bdeb23382ecad32.camel@intel.com>
 <ZyUEMLoy6U3L4E8v@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <ZyUEMLoy6U3L4E8v@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit




On 11/2/2024 12:39 AM, Sean Christopherson wrote:
> On Fri, Nov 01, 2024, Kai Huang wrote:
>> On Thu, 2024-10-31 at 07:54 -0700, Sean Christopherson wrote:
>>> On Thu, Oct 31, 2024, Kai Huang wrote:
>>> -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
>>> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
>>> -		/* MAP_GPA tosses the request to the user space. */
>>> -		return 0;
>>> +	r = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, &ret);
>>> +	if (r <= r)
>>> +		return r;
>> ... should be:
>>
>> 	if (r <= 0)
>> 		return r;
>>
>> ?
>>
>> Another option might be we move "set hypercall return value" code inside
>> __kvm_emulate_hypercall().  So IIUC the reason to split
>> __kvm_emulate_hypercall() out is for TDX, and while non-TDX uses RAX to carry
>> the hypercall return value, TDX uses R10.
>>
>> We can additionally pass a "kvm_hypercall_set_ret_func" function pointer to
>> __kvm_emulate_hypercall(), and invoke it inside.  Then we can change
>> __kvm_emulate_hypercall() to return:
>>      < 0 error,
>>      ==0 return to userspace,
>>      > 0 go back to guest.
> Hmm, and the caller can still handle kvm_skip_emulated_instruction(), because the
> return value is KVM's normal pattern.
>
> I like it!
>
> But, there's no need to pass a function pointer, KVM can write (and read) arbitrary
> GPRs, it's just avoided in most cases so that the sanity checks and available/dirty
> updates are elided.  For this code though, it's easy enough to keep kvm_rxx_read()
> for getting values, and eating the overhead of a single GPR write is a perfectly
> fine tradeoff for eliminating the return multiplexing.
>
> Lightly tested.  Assuming this works for TDX and passes testing, I'll post a
> mini-series next week.
>
> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Fri, 1 Nov 2024 09:04:00 -0700
> Subject: [PATCH] KVM: x86: Refactor __kvm_emulate_hypercall() to accept reg
>   names, not values
>
> Rework __kvm_emulate_hypercall() to take the names of input and output
> (guest return value) registers, as opposed to taking the input values and
> returning the output value.  As part of the refactor, change the actual
> return value from __kvm_emulate_hypercall() to be KVM's de facto standard
> of '0' == exit to userspace, '1' == resume guest, and -errno == failure.
>
> Using the return value for KVM's control flow eliminates the multiplexed
> return value, where '0' for KVM_HC_MAP_GPA_RANGE (and only that hypercall)
> means "exit to userspace".
>
> Use the direct GPR accessors to read values to avoid the pointless marking
> of the registers as available, but use kvm_register_write_raw() for the
> guest return value so that the innermost helper doesn't need to multiplex
> its return value.  Using the generic kvm_register_write_raw() adds very
> minimal overhead, so as a one-off in a relatively slow path it's well
> worth the code simplification.
>
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 15 +++++++++----
>   arch/x86/kvm/x86.c              | 40 +++++++++++++--------------------
>   2 files changed, 27 insertions(+), 28 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6d9f763a7bb9..9e66fde1c4e4 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2179,10 +2179,17 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
>   	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl);
> +int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			      unsigned long a0, unsigned long a1,
> +			      unsigned long a2, unsigned long a3,
> +			      int op_64_bit, int cpl, int ret_reg);
> +
> +#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, ret)	\
> +	____kvm_emulate_hypercall(vcpu,						\
> +				  kvm_##nr##_read(vcpu), kvm_##a0##_read(vcpu),	\
> +				  kvm_##a1##_read(vcpu), kvm_##a2##_read(vcpu),	\
> +				  kvm_##a3##_read(vcpu), op_64_bit, cpl, VCPU_REGS_##ret)
> +
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
>   
>   int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e09daa3b157c..425a301911a6 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9998,10 +9998,10 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   
> -unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> -				      unsigned long a0, unsigned long a1,
> -				      unsigned long a2, unsigned long a3,
> -				      int op_64_bit, int cpl)
> +int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
> +			      unsigned long a0, unsigned long a1,
> +			      unsigned long a2, unsigned long a3,
> +			      int op_64_bit, int cpl, int ret_reg)
>   {
>   	unsigned long ret;
>   
> @@ -10086,15 +10086,18 @@ unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
>   
>   out:
>   	++vcpu->stat.hypercalls;
> -	return ret;
> +
> +	if (!op_64_bit)
> +		ret = (u32)ret;
> +
> +	kvm_register_write_raw(vcpu, ret_reg, ret);
> +	return 1;
>   }
> -EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
> +EXPORT_SYMBOL_GPL(____kvm_emulate_hypercall);
>   
>   int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   {
> -	unsigned long nr, a0, a1, a2, a3, ret;
> -	int op_64_bit;
> -	int cpl;
> +	int r;
>   
>   	if (kvm_xen_hypercall_enabled(vcpu->kvm))
>   		return kvm_xen_hypercall(vcpu);
> @@ -10102,23 +10105,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>   	if (kvm_hv_hypercall_enabled(vcpu))
>   		return kvm_hv_hypercall(vcpu);
>   
> -	nr = kvm_rax_read(vcpu);
> -	a0 = kvm_rbx_read(vcpu);
> -	a1 = kvm_rcx_read(vcpu);
> -	a2 = kvm_rdx_read(vcpu);
> -	a3 = kvm_rsi_read(vcpu);
> -	op_64_bit = is_64_bit_hypercall(vcpu);
> -	cpl = kvm_x86_call(get_cpl)(vcpu);
> -
> -	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl);
> -	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
> -		/* MAP_GPA tosses the request to the user space. */
> +	r = __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
> +				    is_64_bit_hypercall(vcpu),
> +				    kvm_x86_call(get_cpl)(vcpu), RAX);
Now, the register for return code of the hypercall can be specified.
But in  ____kvm_emulate_hypercall(), the complete_userspace_io callback
is hardcoded to complete_hypercall_exit(), which always set return code
to RAX.

We can allow the caller to pass in the cui callback, or assign different
version according to the input 'ret_reg'.  So that different callers can use
different cui callbacks.  E.g., TDX needs to set return code to R10 in cui
callback.

How about:

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index dba78f22ab27..0fba98685f42 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2226,13 +2226,15 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
  int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
                               unsigned long a0, unsigned long a1,
                               unsigned long a2, unsigned long a3,
-                             int op_64_bit, int cpl, int ret_reg);
+                             int op_64_bit, int cpl, int ret_reg,
+                             int (*cui)(struct kvm_vcpu *vcpu));

-#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, ret)        \
+#define __kvm_emulate_hypercall(_vcpu, nr, a0, a1, a2, a3, op_64_bit, cpl, ret, cui)   \
____kvm_emulate_hypercall(vcpu, \
                                   kvm_##nr##_read(vcpu), kvm_##a0##_read(vcpu), \
                                   kvm_##a1##_read(vcpu), kvm_##a2##_read(vcpu), \
-                                 kvm_##a3##_read(vcpu), op_64_bit, cpl, VCPU_REGS_##ret)
+                                 kvm_##a3##_read(vcpu), op_64_bit, cpl, VCPU_REGS_##ret, \
+                                 cui)

  int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e0a518aec4a..b68690c4a4c0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10019,7 +10019,8 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
  int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
                               unsigned long a0, unsigned long a1,
                               unsigned long a2, unsigned long a3,
-                             int op_64_bit, int cpl, int ret_reg)
+                             int op_64_bit, int cpl, int ret_reg,
+                             int (*cui)(struct kvm_vcpu *vcpu))
  {
         unsigned long ret;

@@ -10093,7 +10094,7 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
                         vcpu->run->hypercall.flags |= KVM_EXIT_HYPERCALL_LONG_MODE;

                 WARN_ON_ONCE(vcpu->run->hypercall.flags & KVM_EXIT_HYPERCALL_MBZ);
-               vcpu->arch.complete_userspace_io = complete_hypercall_exit;
+               vcpu->arch.complete_userspace_io = cui;
                 /* stat is incremented on completion. */
                 return 0;
         }
@@ -10125,7 +10126,7 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)

         r = __kvm_emulate_hypercall(vcpu, rax, rbx, rcx, rdx, rsi,
                                     is_64_bit_hypercall(vcpu),
-                                   kvm_x86_call(get_cpl)(vcpu), RAX);
+                                   kvm_x86_call(get_cpl)(vcpu), RAX, complete_hypercall_exit);
         if (r <= 0)
                 return 0;


> +	if (r <= 0)
>   		return 0;
>   
> -	if (!op_64_bit)
> -		ret = (u32)ret;
> -	kvm_rax_write(vcpu, ret);
> -
>   	return kvm_skip_emulated_instruction(vcpu);
>   }
>   EXPORT_SYMBOL_GPL(kvm_emulate_hypercall);
>
> base-commit: 911785b796e325dec83b32050f294e278a306211


