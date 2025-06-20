Return-Path: <kvm+bounces-50001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D33FAE10A8
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 03:21:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 646797AD44B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 01:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6113E482F2;
	Fri, 20 Jun 2025 01:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qj0hDI5h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ED535950;
	Fri, 20 Jun 2025 01:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750382466; cv=none; b=Ew2FDWaDxWBxdwyDL1dQfFJRWY3XcWF/FPdi3VUGfapMxobb1cGLgGcazW5orQ2IscE8AUr/nDsuDLgdx+PNUqfrPGyTlC6/osV5gYhJOf89tEjEXGrAGzmpJ5rwtrVZ4SFSyIzeFqRSRWCSqks97Ox3nDNdn5TRNCZhxtToTwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750382466; c=relaxed/simple;
	bh=7zVvybjqSFfS+Z9K61ba+IQ8a9OcQvv3itypzSUbN4o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MvoEx6C7XLL64IXTxwdXQvJNWKv01DbppneT7xLT3xcDpqHoCM7q3eEu/axHmFBDxQpZpXAO/CwboMrXQL9r0txywONiymrjRlYIWvmcj6owxc3DQOsmeiWR3LxKhCnf6VZ1McovwUxnF7m+sQKAADdJBcSgRweP2fUhg7wmNXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qj0hDI5h; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750382464; x=1781918464;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7zVvybjqSFfS+Z9K61ba+IQ8a9OcQvv3itypzSUbN4o=;
  b=Qj0hDI5hEibpyPd5ZhZCY79aruZ0z0AR07daOrPJJDiY4svsCaf6Bqsu
   hzEvK/5IRmLS7oB2HTn+zIGzAnRrRgMSlVQud84x2djKa4kE0oVPBlFjy
   iO5ALlAFo97teTsgZnElSdmkDwNdXtkjA2SEuOC0WH4Z4EDayTFuiV+m3
   T6eCVMGQddW9JXPiFrG6gDrqtH6Gft8mu8+6XMH8Hk72edPo0VpjOFrze
   zOTcuWahxw3FrNoVtdP87TeyX8pzAfWaeIsJybrK5TNTKzevGV6Bcb4sD
   /knwItYgnPMtGT5IDdTWr63bZx/O+vNXoULGpkdrnKpeDaDfmtLaqNdaU
   g==;
X-CSE-ConnectionGUID: YU7Zu6qWTUeqqTWL54/hzw==
X-CSE-MsgGUID: RiKE7o3IS5anr+9mzn/IqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="52605675"
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="52605675"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 18:21:03 -0700
X-CSE-ConnectionGUID: 8erNCieqRBK2kxgCMCZKLQ==
X-CSE-MsgGUID: W84Lfdy6QAOxCXWnNdFBiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,250,1744095600"; 
   d="scan'208";a="150911071"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2025 18:20:58 -0700
Message-ID: <cc443335-442d-4ed0-aa01-a6bf5c27b39c@intel.com>
Date: Fri, 20 Jun 2025 09:20:55 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] KVM: TDX: Exit to userspace for GetTdVmCallInfo
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, seanjc@google.com
Cc: rick.p.edgecombe@intel.com, kai.huang@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 mikko.ylinen@linux.intel.com, kirill.shutemov@intel.com,
 jiewen.yao@intel.com, binbin.wu@linux.intel.com
References: <20250619180159.187358-1-pbonzini@redhat.com>
 <20250619180159.187358-4-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250619180159.187358-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/20/2025 2:01 AM, Paolo Bonzini wrote:
> From: Binbin Wu <binbin.wu@linux.intel.com>
> 
> Exit to userspace for TDG.VP.VMCALL<GetTdVmCallInfo> via KVM_EXIT_TDX,
> to allow userspace to provide information about the support of
> TDVMCALLs when r12 is 1 for the TDVMCALLs beyond the GHCI base API.
> 
> GHCI spec defines the GHCI base TDVMCALLs: <GetTdVmCallInfo>, <MapGPA>,
> <ReportFatalError>, <Instruction.CPUID>, <#VE.RequestMMIO>,
> <Instruction.HLT>, <Instruction.IO>, <Instruction.RDMSR> and
> <Instruction.WRMSR>. They must be supported by VMM to support TDX guests.
> 
> For GetTdVmCallInfo
> - When leaf (r12) to enumerate TDVMCALL functionality is set to 0,
>    successful execution indicates all GHCI base TDVMCALLs listed above are
>    supported.
> 
>    Update the KVM TDX document with the set of the GHCI base APIs.
> 
> - When leaf (r12) to enumerate TDVMCALL functionality is set to 1, it
>    indicates the TDX guest is querying the supported TDVMCALLs beyond
>    the GHCI base TDVMCALLs.
>    Exit to userspace to let userspace set the TDVMCALL sub-function bit(s)
>    accordingly to the leaf outputs.  KVM could set the TDVMCALL bit(s)
>    supported by itself when the TDVMCALLs don't need support from userspace
>    after returning from userspace and before entering guest. Currently, no
>    such TDVMCALLs implemented, KVM just sets the values returned from
>    userspace.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
> [Adjust userspace API. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   Documentation/virt/kvm/api.rst | 15 +++++++++++++-
>   arch/x86/kvm/vmx/tdx.c         | 38 ++++++++++++++++++++++++++++++----
>   include/uapi/linux/kvm.h       |  5 +++++
>   3 files changed, 53 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 3643d853a634..2b1656907356 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7190,6 +7190,11 @@ The valid value for 'flags' is:
>   					u64 gpa;
>   					u64 size;
>   				} get_quote;
> +				struct {
> +					u64 ret;
> +					u64 leaf;
> +					u64 r11, r12, r13, r14;
> +				} get_tdvmcall_info;
>   			};
>   		} tdx;
> 
> @@ -7216,9 +7221,17 @@ queued successfully, the TDX guest can poll the status field in the
>   shared-memory area to check whether the Quote generation is completed or
>   not. When completed, the generated Quote is returned via the same buffer.
>   
> +* ``TDVMCALL_GET_TD_VM_CALL_INFO``: the guest has requested the support
> +status of TDVMCALLs.  The output values for the given leaf should be
> +placed in fields from ``r11`` to ``r14`` of the ``get_tdvmcall_info``
> +field of the union.  This TDVMCALL must succeed, therefore KVM leaves
> +``ret`` equal to ``TDVMCALL_STATUS_SUCCESS`` and ``r11`` to ``r14``
> +equal to zero on entry.
> +
>   KVM may add support for more values in the future that may cause a userspace
>   exit, even without calls to ``KVM_ENABLE_CAP`` or similar.  In this case,
> -it will enter with output fields already valid; in the common case, the
> +it will enter with output fields already valid as mentioned for
> +``TDVMCALL_GET_TD_VM_CALL_INFO`` above; in the common case, the
>   ``unknown.ret`` field of the union will be ``TDVMCALL_STATUS_SUBFUNC_UNSUPPORTED``.
>   Userspace need not do anything if it does not wish to support a TDVMCALL.
>   ::
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 6878a76069f8..5804d1b1ea0e 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1451,18 +1451,49 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int tdx_complete_get_td_vm_call_info(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +
> +	tdvmcall_set_return_code(vcpu, vcpu->run->tdx.get_tdvmcall_info.ret);
> +
> +	/*
> +	 * For now, there is no TDVMCALL beyond GHCI base API supported by KVM
> +	 * directly without the support from userspace, just set the value
> +	 * returned from userspace.
> +	 */
> +	tdx->vp_enter_args.r11 = vcpu->run->tdx.get_tdvmcall_info.r11;
> +	tdx->vp_enter_args.r12 = vcpu->run->tdx.get_tdvmcall_info.r12;
> +	tdx->vp_enter_args.r13 = vcpu->run->tdx.get_tdvmcall_info.r13;
> +	tdx->vp_enter_args.r14 = vcpu->run->tdx.get_tdvmcall_info.r14;
> +
> +	return 1;
> +}
> +
>   static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
>   {
>   	struct vcpu_tdx *tdx = to_tdx(vcpu);
>   
> -	if (tdx->vp_enter_args.r12)
> -		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> -	else {
> +	switch (tdx->vp_enter_args.r12) {
> +	case 1:
> +		vcpu->run->tdx.get_tdvmcall_info.leaf = tdx->vp_enter_args.r12;
> +		vcpu->run->exit_reason = KVM_EXIT_TDX;
> +		vcpu->run->tdx.flags = 0;
> +		vcpu->run->tdx.nr = TDVMCALL_GET_TD_VM_CALL_INFO;
> +		vcpu->run->tdx.get_tdvmcall_info.ret = TDVMCALL_STATUS_SUCCESS;
> +		vcpu->run->tdx.get_tdvmcall_info.r11 = 0;
> +		vcpu->run->tdx.get_tdvmcall_info.r12 = 0;
> +		vcpu->run->tdx.get_tdvmcall_info.r13 = 0;
> +		vcpu->run->tdx.get_tdvmcall_info.r14 = 0;
> +		vcpu->arch.complete_userspace_io = tdx_complete_get_td_vm_call_info;
> +		return 0;
> +	default:
>   		tdx->vp_enter_args.r11 = 0;
> +		tdx->vp_enter_args.r12 = 0;
>   		tdx->vp_enter_args.r13 = 0;
>   		tdx->vp_enter_args.r14 = 0;
> +		return 1;

Though it looks OK to return all-0 for r12 == 0 and undefined case of 
r12 > 1, I prefer returning TDVMCALL_STATUS_INVALID_OPERAND for 
undefined case.

So please make above "case 0:", and make the "default:" return 
TDVMCALL_STATUS_INVALID_OPERAND

>   	}
> -	return 1;
>   }
>   
>   static int tdx_complete_simple(struct kvm_vcpu *vcpu)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 6708bc88ae69..fb3b4cd8d662 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -461,6 +461,11 @@ struct kvm_run {
>   					__u64 gpa;
>   					__u64 size;
>   				} get_quote;
> +				struct {
> +					__u64 ret;
> +					__u64 leaf;
> +					__u64 r11, r12, r13, r14;
> +				} get_tdvmcall_info;
>   			};
>   		} tdx;
>   		/* Fix the size of the union. */


