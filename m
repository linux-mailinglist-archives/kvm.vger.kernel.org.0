Return-Path: <kvm+bounces-33837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 109929F29CB
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 07:03:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9BE716691F
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 06:03:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AEC91C8FD7;
	Mon, 16 Dec 2024 06:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RqlKUML+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB11192B70;
	Mon, 16 Dec 2024 06:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734329013; cv=none; b=h5qAopoEIIoqNa6xrjhRVs/YMbbWgvntWhzaB4ccM3nu5mgVCyUEAo3rDPhkcX6sHRgGOD6SR5bBOSOV1k7YxDT0AiQHt1j0wnpH+F6Sst52Tb7jP85nMGfJt6SKuncWCX0OqzLgNICO75OYlMhP4Ny/JZhKppOSaQR/vpPlOl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734329013; c=relaxed/simple;
	bh=Kp3xyFWz/0v88Gf9lCCF/jg6HhyIQ70bMmDlTQNGy34=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FbmB5M6rsgC6RnTrOaOk1fmjl1Mku95n0y6bCpR4c1WpwUtECof44Z+ChbNGHfLUz9G7RsfXYzKJwwiUneW0eR5LdifX+VgwN+o9lQiG9WUIZqoKRJZAMsdloF29nbbpz4HqCM978jcx/yatK7XSlwNTyxoqv/H+6uLyG3VlFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RqlKUML+; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734329012; x=1765865012;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Kp3xyFWz/0v88Gf9lCCF/jg6HhyIQ70bMmDlTQNGy34=;
  b=RqlKUML+lsxOFE3ed/LJo23RQ7NMJmjOB0VRt7guU3hl4m7rkSqaSUem
   uaof1AljOVFvWZfOKGkg3fVoIahB09xvPUAsmhNnMtTyW1NRp8MKg/rs2
   0shIGzqxe3/X3+AubeNJJzFtLRB/kE02JrK3S0V5/Y2qniNC2nRnG63B4
   ZPsmOXW6s9Ksv3RMjx1nyvMaAKYy7a/0jkQIb++jCczvysf1MsZppv80v
   80XlYrfrQIxPN8ZI44ulo0SdLZOKygXVYCGk8uhPl1/TDiWekpur8MOb0
   aKFPzSm+3HpUKKHGNpRXwE++wVTQdIREGUMwz4mx+wAfB1UDEX65Z+LCu
   Q==;
X-CSE-ConnectionGUID: 1ESOfbjXR7WLBmKnV3KmJg==
X-CSE-MsgGUID: KMc6HI3CQOq9tZukTycg7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11287"; a="34025178"
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="34025178"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 22:03:30 -0800
X-CSE-ConnectionGUID: pzG4dA16RuKsXXmsY274tA==
X-CSE-MsgGUID: /0V0jTxaShS1V4JayPgpGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="96951397"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 22:03:26 -0800
Message-ID: <edc7f1f3-e498-44cc-aa3c-994d3f290e01@intel.com>
Date: Mon, 16 Dec 2024 14:03:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-5-binbin.wu@linux.intel.com>
 <d3adecc6-b2b9-42ba-8c0f-bd66407e61f0@intel.com>
 <692aacc1-809f-449d-8f67-8e8e7ede8c8d@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <692aacc1-809f-449d-8f67-8e8e7ede8c8d@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/16/2024 9:08 AM, Binbin Wu wrote:
> 
> 
> 
> On 12/13/2024 5:32 PM, Xiaoyao Li wrote:
>> On 12/1/2024 11:53 AM, Binbin Wu wrote:
>>
> [...]
>>> +
>>> +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct vcpu_tdx * tdx = to_tdx(vcpu);
>>> +    u64 gpa = tdvmcall_a0_read(vcpu);
>>
>> We can use kvm_r12_read() directly, which is more intuitive. And we 
>> can drop the MACRO for a0/a1/a2/a3 accessors in patch 022.
> I am neutral about it.
> 

a0, a1, a2, a3, are the name convention for KVM's hypercall. It makes 
sense when serving as the parameters to  __kvm_emulate_hypercall().

However, now __kvm_emulate_hypercall() is made to a MACRO and we don't 
need the temp variable like a0 = kvm_xx_read().

For TDVMCALL leafs other than normal KVM hypercalls, they are all TDX 
specific and defined in TDX GHCI spec, a0/a1/a2/a3 makes no sense for them.

> 
>>
>>> +    u64 size = tdvmcall_a1_read(vcpu);
>>> +    u64 ret;
>>> +
>>> +    /*
>>> +     * Converting TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE requires
>>> +     * userspace to enable KVM_CAP_EXIT_HYPERCALL with 
>>> KVM_HC_MAP_GPA_RANGE
>>> +     * bit set.  If not, the error code is not defined in GHCI for 
>>> TDX, use
>>> +     * TDVMCALL_STATUS_INVALID_OPERAND for this case.
>>> +     */
>>> +    if (!user_exit_on_hypercall(vcpu->kvm, KVM_HC_MAP_GPA_RANGE)) {
>>> +        ret = TDVMCALL_STATUS_INVALID_OPERAND;
>>> +        goto error;
>>> +    }
>>> +
>>> +    if (gpa + size <= gpa || !kvm_vcpu_is_legal_gpa(vcpu, gpa) ||
>>> +        !kvm_vcpu_is_legal_gpa(vcpu, gpa + size -1) ||
>>> +        (vt_is_tdx_private_gpa(vcpu->kvm, gpa) !=
>>> +         vt_is_tdx_private_gpa(vcpu->kvm, gpa + size -1))) {
>>> +        ret = TDVMCALL_STATUS_INVALID_OPERAND;
>>> +        goto error;
>>> +    }
>>> +
>>> +    if (!PAGE_ALIGNED(gpa) || !PAGE_ALIGNED(size)) {
>>> +        ret = TDVMCALL_STATUS_ALIGN_ERROR;
>>> +        goto error;
>>> +    }
>>> +
>>> +    tdx->map_gpa_end = gpa + size;
>>> +    tdx->map_gpa_next = gpa;
>>> +
>>> +    __tdx_map_gpa(tdx);
>>> +    /* Forward request to userspace. */
>>> +    return 0;
>>
>> Maybe let __tdx_map_gpa() return a int to decide whether it needs to 
>> return to userspace and
>>
>>     return __tdx_map_gpa(tdx);
>>
>> ?
> 
> To save one line of code and the comment?

No. Just I found most of the cases that need to exit to usespace, comes 
with "return 0" after setting up the run->exit_reason and run->(fields).

> Because MapGPA always goes to userspace, I don't want to make a function 
> return
> a int that is a fixed value.
> And if the multiple comments bother you, I think the comments can be 
> removed.
> 
>>
>>
>>> +
>>> +error:
>>> +    tdvmcall_set_return_code(vcpu, ret);
>>> +    kvm_r11_write(vcpu, gpa);
>>> +    return 1;
>>> +}
>>> +
>>>   static int handle_tdvmcall(struct kvm_vcpu *vcpu)
>>>   {
>>>       if (tdvmcall_exit_type(vcpu))
>>>           return tdx_emulate_vmcall(vcpu);
>>>         switch (tdvmcall_leaf(vcpu)) {
>>> +    case TDVMCALL_MAP_GPA:
>>> +        return tdx_map_gpa(vcpu);
>>>       default:
>>>           break;
>>>       }
>>> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
>>> index 1abc94b046a0..bfae70887695 100644
>>> --- a/arch/x86/kvm/vmx/tdx.h
>>> +++ b/arch/x86/kvm/vmx/tdx.h
>>> @@ -71,6 +71,9 @@ struct vcpu_tdx {
>>>         enum tdx_prepare_switch_state prep_switch_state;
>>>       u64 msr_host_kernel_gs_base;
>>> +
>>> +    u64 map_gpa_next;
>>> +    u64 map_gpa_end;
>>>   };
>>>     void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 
>>> field, u64 err);
>>
> 


