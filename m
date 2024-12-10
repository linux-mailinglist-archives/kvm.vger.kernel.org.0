Return-Path: <kvm+bounces-33373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E299EA502
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 03:16:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 39B69168005
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 02:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7826519E992;
	Tue, 10 Dec 2024 02:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fD+hebdC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9925D477;
	Tue, 10 Dec 2024 02:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733796882; cv=none; b=BJl8juwTXqfTJuQi/TwrQoVi7uWtnuBilnu/v6tM8kYa9TLcmVRQVMoGmynRropVgDaWtwHtWZ0PFfxs8pQaPS1SZQUJuyamQENQYcI70UNnBhrIV/PxoHj/cPohm5Zmiw6PjLYJ4okC5EOIjwuwELSuz1ZcjMxcG+3jgaEXocc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733796882; c=relaxed/simple;
	bh=PiXu9l+4qedQacXyzm74QV0ZA9egVrz0r2XH1OaomXw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ORq9b1VIG4fMrF9rDSujDKWmA7ahzTMBOXSsQ9rtCLeDy6rxwJ3aeP18e9zUUmMyD6YBnzEt9YRo86U2FF8F2puGGHltYiUvYdpFfJ6eopVTp5uKlbUB+okBaVQEgLHpnLtIuZvADLWPH2warDMXP4DmRbTRd/6dCHWkEUNqjR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fD+hebdC; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733796880; x=1765332880;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PiXu9l+4qedQacXyzm74QV0ZA9egVrz0r2XH1OaomXw=;
  b=fD+hebdCO6kJPxU1/jQiv7QGAp09MUBs3XSDq0wGSSLGkv0MqbSJWDoR
   tDpruVJopmZzoaxo9TOhtsD5tZov2n1V+mSo2Ngrkboiy+aWtgNFrHWGB
   AXaZIrlDF0MCt+YmRphiYHZ0UTF8v0W+1US4ctk7T8YiSTPJbg3gY7EwE
   2zJ6O0GUODCDr0vi86f/9IynT9XN+DlPx8+DvqBh0BAYUELk+jk6dABNU
   +ze2+ghkdg+iNduZzaj7F5q+gTDKeqKUWyEcmT7cZ8B9Ka5rdg+aJB1sR
   XLDVxxW9N9+sC/sVaSt0TVXr/Y362ABrXJVTkX/TsPOKImdz7Awf7uN9i
   g==;
X-CSE-ConnectionGUID: ZrzVQi0bTM+H3LA9woRiSA==
X-CSE-MsgGUID: ALF/jMblRqiOTwrB/tjoBw==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44799938"
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="44799938"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 18:14:40 -0800
X-CSE-ConnectionGUID: e0vg3zN3SyeLP0hGKUyj6g==
X-CSE-MsgGUID: I3c4QdKERra9XRGFCshY2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,221,1728975600"; 
   d="scan'208";a="95709528"
Received: from unknown (HELO [10.238.9.154]) ([10.238.9.154])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 18:14:37 -0800
Message-ID: <747271b4-2d33-476b-8056-b54ce46441d1@linux.intel.com>
Date: Tue, 10 Dec 2024 10:14:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] KVM: TDX: Add a place holder to handle TDX VM exit
To: Chao Gao <chao.gao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, michael.roth@amd.com, linux-kernel@vger.kernel.org
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
 <20241201035358.2193078-2-binbin.wu@linux.intel.com>
 <Z1bS0sWkPjsaf33b@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <Z1bS0sWkPjsaf33b@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 12/9/2024 7:21 PM, Chao Gao wrote:
> On Sun, Dec 01, 2024 at 11:53:50AM +0800, Binbin Wu wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> Introduce the wiring for handling TDX VM exits by implementing the
>> callbacks .get_exit_info(), and .handle_exit().  Additionally, add
>> error handling during the TDX VM exit flow, and add a place holder
>> to handle various exit reasons.  Add helper functions to retrieve
>> exit information, exit qualifications, and more.
>>
>> Contention Handling: The TDH.VP.ENTER operation may contend with TDH.MEM.*
>> operations for secure EPT or TD EPOCH.  If contention occurs, the return
>> value will have TDX_OPERAND_BUSY set with operand type, prompting the vCPU
>> to attempt re-entry into the guest via the fast path.
>>
>> Error Handling: The following scenarios will return to userspace with
>> KVM_EXIT_INTERNAL_ERROR.
>> - TDX_SW_ERROR: This includes #UD caused by SEAMCALL instruction if the
>>   CPU isn't in VMX operation, #GP caused by SEAMCALL instruction when TDX
>>   isn't enabled by the BIOS, and TDX_SEAMCALL_VMFAILINVALID when SEAM
>>   firmware is not loaded or disabled.
>> - TDX_ERROR: This indicates some check failed in the TDX module, preventing
>>   the vCPU from running.
>> - TDX_NON_RECOVERABLE: Set by the TDX module when the error is
>>   non-recoverable, indicating that the TDX guest is dead or the vCPU is
>>   disabled.  This also covers failed_vmentry case, which must have
>>   TDX_NON_RECOVERABLE set since off-TD debug feature has not been enabled.
>>   An exception is the triple fault, which also sets TDX_NON_RECOVERABLE
>>   but exits to userspace with KVM_EXIT_SHUTDOWN, aligning with the VMX
>>   case.
>> - Any unhandled VM exit reason will also return to userspace with
>>   KVM_EXIT_INTERNAL_ERROR.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
>> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> [..]
>
>> fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>> {
>> 	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> @@ -837,9 +900,26 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>> 	tdx->prep_switch_state = TDX_PREP_SW_STATE_UNRESTORED;
>>
>> 	vcpu->arch.regs_avail &= ~VMX_REGS_LAZY_LOAD_SET;
>> +
>> +	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR))
>> +		return EXIT_FASTPATH_NONE;
>> +
>> +	if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_MCE_DURING_VMENTRY)))
>> +		kvm_machine_check();
> I was wandering if EXIT_REASON_MCE_DURING_VMENTRY should be handled in the
> switch-case in tdx_handle_exit() because I saw there is a dedicated handler
> for VMX. But looks EXIT_REASON_MCE_DURING_VMENTRY is a kind of VMentry
> failure. So, it won't reach that switch-case.
Yes, similar to VMX, for TDX, EXIT_REASON_MCE_DURING_VMENTRY will be captured
by failed_vmentry, which will have TDX_NON_RECOVERABLE set and handled before
the switch-case.


>   And, VMX's handler for
> EXIT_REASON_MCE_DURING_VMENTRY is actually dead code and can be removed.
I think so, for VMX, the exit_reason.failed_vmentry case will return to
userspace, it won't reach the handler for EXIT_REASON_MCE_DURING_VMENTRY.


>
>> +
>> 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>
>> -	return EXIT_FASTPATH_NONE;
>> +	if (unlikely(tdx_has_exit_reason(vcpu) && tdexit_exit_reason(vcpu).failed_vmentry))
>> +		return EXIT_FASTPATH_NONE;
>> +
>> +	return tdx_exit_handlers_fastpath(vcpu);
>> +}
>> +
>> +static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
>> +{
>> +	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
>> +	vcpu->mmio_needed = 0;
>> +	return 0;
>> }
>>
>> void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
>> @@ -1135,6 +1215,88 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>> 	return tdx_sept_drop_private_spte(kvm, gfn, level, pfn);
>> }
>>
>> +int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
>> +{
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +	u64 vp_enter_ret = tdx->vp_enter_ret;
>> +	union vmx_exit_reason exit_reason;
>> +
>> +	if (fastpath != EXIT_FASTPATH_NONE)
>> +		return 1;
>> +
>> +	/*
>> +	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
>> +	 * TDX_SEAMCALL_VMFAILINVALID.
>> +	 */
>> +	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
>> +		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
>> +		goto unhandled_exit;
>> +	}
>> +
>> +	/*
>> +	 * Without off-TD debug enabled, failed_vmentry case must have
>> +	 * TDX_NON_RECOVERABLE set.
>> +	 */
>> +	if (unlikely(vp_enter_ret & (TDX_ERROR | TDX_NON_RECOVERABLE))) {
>> +		/* Triple fault is non-recoverable. */
>> +		if (unlikely(tdx_check_exit_reason(vcpu, EXIT_REASON_TRIPLE_FAULT)))
>> +			return tdx_handle_triple_fault(vcpu);
>> +
>> +		kvm_pr_unimpl("TD vp_enter_ret 0x%llx, hkid 0x%x hkid pa 0x%llx\n",
>> +			      vp_enter_ret, to_kvm_tdx(vcpu->kvm)->hkid,
>> +			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
>> +		goto unhandled_exit;
>> +	}
>> +
>> +	/* From now, the seamcall status should be TDX_SUCCESS. */
>> +	WARN_ON_ONCE((vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) != TDX_SUCCESS);
>> +	exit_reason = tdexit_exit_reason(vcpu);
>> +
>> +	switch (exit_reason.basic) {
>> +	default:
>> +		break;
>> +	}
>> +
>> +unhandled_exit:
>> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
>> +	vcpu->run->internal.ndata = 2;
>> +	vcpu->run->internal.data[0] = vp_enter_ret;
>> +	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
>> +	return 0;
>> +}
>> +
>> +void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
>> +		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
>> +{
>> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>> +	if (tdx_has_exit_reason(vcpu)) {
>> +		/*
>> +		 * Encode some useful info from the the 64 bit return code
>> +		 * into the 32 bit exit 'reason'. If the VMX exit reason is
>> +		 * valid, just set it to those bits.
>> +		 */
>> +		*reason = (u32)tdx->vp_enter_ret;
>> +		*info1 = tdexit_exit_qual(vcpu);
>> +		*info2 = tdexit_ext_exit_qual(vcpu);
>> +	} else {
>> +		/*
>> +		 * When the VMX exit reason in vp_enter_ret is not valid,
>> +		 * overload the VMX_EXIT_REASONS_FAILED_VMENTRY bit (31) to
>> +		 * mean the vmexit code is not valid. Set the other bits to
>> +		 * try to avoid picking a value that may someday be a valid
>> +		 * VMX exit code.
>> +		 */
>> +		*reason = 0xFFFFFFFF;
>> +		*info1 = 0;
>> +		*info2 = 0;
>> +	}
>> +
>> +	*intr_info = tdexit_intr_info(vcpu);
> If there is no valid exit reason, shouldn't intr_info be set to 0?
Yes. Will fix it.
Thanks!

>
>> +	*error_code = 0;
>> +}
>> +


