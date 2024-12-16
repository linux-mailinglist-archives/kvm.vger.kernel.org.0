Return-Path: <kvm+bounces-33835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 055629F2954
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 05:37:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8A0D188614C
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 04:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0EF1B87ED;
	Mon, 16 Dec 2024 04:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eUKbPwqq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F1DA41;
	Mon, 16 Dec 2024 04:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734323861; cv=none; b=Y/bAFZCT5tsuSqGRzFKkx8/amUs2JvYSaILIle7XyedmKRxHASYXPIDeMKhekdKQrMs2XfE8g1bKi5v1D0b42YJtlCM6Vbcm7J7Gv9zn+V7gXMxYslyCvLO8xxmv2dJ4ce7VS0pdSzI5RMSKiqh5RBgd/5mgbBYAQLoGk05MV6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734323861; c=relaxed/simple;
	bh=/ZLxmtpD7i77LgMQtthygKh9darH2+HxDdhqKF+SxZ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pw7YjdqbqLivNny1m0y+LeXpL0GPhWp+O2/ap8sLqlPQzfNx3+zFI62KcnPAQ/ZCYJktEG/yWeiuGRNwloaOTU05n48Ul8WC4fdl8+z0Nyn1q5Aiomp2nLi+iw3DmnWmr3fIrtZSK7pMFKwqP5p3Tck8b7588snzB3JjI7hVOzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eUKbPwqq; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734323859; x=1765859859;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/ZLxmtpD7i77LgMQtthygKh9darH2+HxDdhqKF+SxZ4=;
  b=eUKbPwqqhzuSMmPnu78bak2eKKaWFa3b6Ol8DdJE3WGrblP1wt09p7tG
   qm5q24Aw/6jnCaKF6Q8Yrt6jGwDMd4ZL5DRS0/ijqNruDp8GpYbM2FD0Q
   IPz3pM3zGI3+DtoKIkRL1f3sL8PsAFhLqx3T00OPh8Ot6PURPszVgoMWg
   vmoJ+9E5hDpsGAavIlF5K54bPexvK8eD858bjf3yIGnUx92p2MF34bK6i
   mTrEWjh02yi2lHaSXJSLbEAiIt0SqWu5u6Ix1jPuQTj0E0PpC5XaiPLvV
   YU0DKngniyoiOdVGQDD+Wf77UxNZUsKQu/xEg22ATKqY4R5Fqe30rGuqX
   A==;
X-CSE-ConnectionGUID: Rd9b3sWeQEiM3EDaIJ9KCw==
X-CSE-MsgGUID: Z6qkA69gTcSgnJiz56lHgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11287"; a="34732467"
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="34732467"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 20:37:39 -0800
X-CSE-ConnectionGUID: hB2F3kOKRVK/ZBxkreQCXA==
X-CSE-MsgGUID: R+AidrljTfqnvygPxOJ+tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,237,1728975600"; 
   d="scan'208";a="101937650"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Dec 2024 20:37:36 -0800
Message-ID: <646990e1-cce6-4040-af40-6d80e0cd954a@intel.com>
Date: Mon, 16 Dec 2024 12:37:32 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] KVM: TDX: Add a place holder to handle TDX VM exit
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-2-binbin.wu@linux.intel.com>
 <28930ac3-f4af-4d93-a766-11a5fedb321e@intel.com>
 <25a042e8-c39a-443c-a2e4-10f515b1f2af@linux.intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <25a042e8-c39a-443c-a2e4-10f515b1f2af@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/16/2024 8:54 AM, Binbin Wu wrote:
> 
> 
> 
> On 12/13/2024 4:57 PM, Xiaoyao Li wrote:
>> On 12/1/2024 11:53 AM, Binbin Wu wrote:
...
>>
>>>   }
>>>     void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int 
>>> pgd_level)
>>> @@ -1135,6 +1215,88 @@ int tdx_sept_remove_private_spte(struct kvm 
>>> *kvm, gfn_t gfn,
>>>       return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
>>>   }
>>>   +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>>> +{
>>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>>> +    u64 vp_enter_ret = tdx->vp_enter_ret;
>>> +    union vmx_exit_reason exit_reason;
>>> +
>>> +    if (fastpath != EXIT_FASTPATH_NONE)
>>> +        return 1;
>>> +
>>> +    /*
>>> +     * Handle TDX SW errors, including TDX_SEAMCALL_UD, 
>>> TDX_SEAMCALL_GP and
>>> +     * TDX_SEAMCALL_VMFAILINVALID.
>>> +     */
>>> +    if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
>>> +        KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
>>> +        goto unhandled_exit;
>>> +    }
>>> +
>>> +    /*
>>> +     * Without off-TD debug enabled, failed_vmentry case must have
>>> +     * TDX_NON_RECOVERABLE set.
>>> +     */
>>
>> This comment is confusing. I'm not sure why it is put here. Below code 
>> does nothing with exit_reason.failed_vmentry.
> 
> Because when failed_vmentry occurs, vp_enter_ret will have
> TDX_NON_RECOVERABLE set, so it will be handled below.

The words somehow is confusing, which to me is implying something like:

	WARN_ON(!debug_td() && exit_reason.failed_vmentry &&
                 !(vp_enter_ret & TDX_NON_RECOVERABLE))

Besides, VMX returns KVM_EXIT_FAIL_ENTRY for vm-entry failure. So the 
question is why TDX cannot do it same way?

>>
>>> +    if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE))) {
>>> +        /* Triple fault is non-recoverable. */
>>> +        if (unlikely(tdx_check_exit_reason(vcpu, 
>>> EXIT_REASON_TRIPLE_FAULT)))
>>> +            return tdx_handle_triple_fault(vcpu);
>>> +
>>> +        kvm_pr_unimpl("TD vp_enter_ret 0x%llx, hkid 0x%x hkid pa 
>>> 0x%llx\n",
>>> +                  vp_enter_ret, to_kvm_tdx(vcpu->kvm)->hkid,
>>> +                  set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
>>
>> It indeed needs clarification for the need of "hkid" and "hkid pa". 
>> Especially the "hkdi pa", which is the result of applying HKID of the 
>> current TD to a physical address 0. I cannot think of any reason why 
>> we need such info.
> Yes, set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid) should be removed.
> I didn't notice it.

don't forget to justify why HKID is useful here. To me, HKID can be 
dropped as well.

> Thanks!
> 
> 
>>
>>> +        goto unhandled_exit;
>>> +    }
>>> +
>>> +    /* From now, the seamcall status should be TDX_SUCCESS. */
>>> +    WARN_ON_ONCE((vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != 
>>> TDX_SUCCESS);
>>
>> Is there any case that TDX_SUCCESS with additional non-zero 
>> information in the lower 32-bits? I thought TDX_SUCCESS is a whole 64- 
>> bit status code.
> TDX status code uses the upper 32-bits.
> 
> When the status code is TDX_SUCCESS and has a valid VMX exit reason, the 
> lower
> 32-bit is the VMX exit reason.
> 
> You can refer to the TDX module ABI spec or 
> interface_function_completion_status.json
> from the intel-tdx-module-1.5-abi-table for details.
> 

I see. (I asked a silly question that I even missed the normal Exit case)


