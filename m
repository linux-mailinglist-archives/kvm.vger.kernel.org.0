Return-Path: <kvm+bounces-65487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 56C18CACA09
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:17:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0C1D63067D20
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF73D2E7F29;
	Mon,  8 Dec 2025 09:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QrhGnBPf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2672DC765;
	Mon,  8 Dec 2025 09:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765185314; cv=none; b=bq/nWS4jUrufTSW/zS8LNQi9zfz+0TnTMEZ1L+bQQfkvlyle7rNrCmn7FoweDt34AycTZ8y8z4Wq0RR7X3JWNVRC2U8sGYT3MPGe9m6mI5RZGmYjtoA55TThGPlFbCyqvGZk2qMYqQp8V82vk88evZ9GYQOzYqPraGI0yoL2MDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765185314; c=relaxed/simple;
	bh=Op2nVfSeshtd/97y1F620bAyJ5slemNLwyBYIxH82c8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OX9Ukli6dCEym/rOwiynQK/inee+9d+XH71JPAFNeDOCRHippSqTr9WOfy2RFHbNo7hoLsRYmTjX6jyHfy8BdBzmJ3Oye0Evgt3LC8YmPPadsYSj1KQGDWyz2Q+8JypSuaOYZjajM3BRe5z3WqlKm7CWLRxDG1kGYGbZYPsvCXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QrhGnBPf; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765185311; x=1796721311;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Op2nVfSeshtd/97y1F620bAyJ5slemNLwyBYIxH82c8=;
  b=QrhGnBPfG9KQgS3kIU+kwvMouIZ0LG9BY0XdCwOd2nj4U046KS3TpK+Y
   P3bRZrD8xEseRiLyvQNDR4u57GkybSrBR1Tc3or69x8SV8NBaFtdaR8FL
   ubwpj4MQOd28HJdq70hCLiQ+MVFBO8LCrmLtKco7HS7PuGzg+nkCCszrk
   iebq8niuiV9/8w3h27jSSqKtNJCGNuX1mlcVvY7X/rBvIxIc3cx06tJGq
   YDfN5FdDeoZoyEGBz1E+/d8N8ExrJ6DAOzc7n0Dt1+yhHGDYuliHccn1d
   40BppSKMtDkJzLpAxqqcmYGRimLvEPUjWh6WlVdnA6RAudaZhPYUg+Ms2
   g==;
X-CSE-ConnectionGUID: 2/AQD4yHQ+udJRuXwAFLYg==
X-CSE-MsgGUID: n+jle+ATSAmvKPYxE0nlhw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="66124376"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="66124376"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:15:10 -0800
X-CSE-ConnectionGUID: 4H/pcwrXQVSjY8FUXqPV6w==
X-CSE-MsgGUID: j7p+D3AjRFu5Wm3XzOa1YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="195945489"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:14:59 -0800
Message-ID: <0237b3eb-87f5-4758-b704-9f8d525f1f15@linux.intel.com>
Date: Mon, 8 Dec 2025 17:14:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 35/44] KVM: VMX: Drop intermediate "guest" field from
 msr_autostore
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
 Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
 Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, loongarch@lists.linux.dev,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 Mingwei Zhang <mizhang@google.com>, Xudong Hao <xudong.hao@intel.com>,
 Sandipan Das <sandipan.das@amd.com>,
 Xiong Zhang <xiong.y.zhang@linux.intel.com>,
 Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
References: <20251206001720.468579-1-seanjc@google.com>
 <20251206001720.468579-36-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-36-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> Drop the intermediate "guest" field from vcpu_vmx.msr_autostore as the
> value saved on VM-Exit isn't guaranteed to be the guest's value, it's
> purely whatever is in hardware at the time of VM-Exit.  E.g. KVM's only
> use of the store list at the momemnt is to snapshot TSC at VM-Exit, and
> the value saved is always the raw TSC even if TSC-offseting and/or
> TSC-scaling is enabled for the guest.
>
> And unlike msr_autoload, there is no need differentiate between "on-entry"
> and "on-exit".
>
> No functional change intended.
>
> Cc: Jim Mattson <jmattson@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 10 +++++-----
>  arch/x86/kvm/vmx/vmx.c    |  2 +-
>  arch/x86/kvm/vmx/vmx.h    |  4 +---
>  3 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 729cc1f05ac8..486789dac515 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1076,11 +1076,11 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
>  	 * VM-exit in L0, use the more accurate value.
>  	 */
>  	if (msr_index == MSR_IA32_TSC) {
> -		int i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore.guest,
> +		int i = vmx_find_loadstore_msr_slot(&vmx->msr_autostore,
>  						    MSR_IA32_TSC);
>  
>  		if (i >= 0) {
> -			u64 val = vmx->msr_autostore.guest.val[i].value;
> +			u64 val = vmx->msr_autostore.val[i].value;
>  
>  			*data = kvm_read_l1_tsc(vcpu, val);
>  			return true;
> @@ -1167,7 +1167,7 @@ static void prepare_vmx_msr_autostore_list(struct kvm_vcpu *vcpu,
>  					   u32 msr_index)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -	struct vmx_msrs *autostore = &vmx->msr_autostore.guest;
> +	struct vmx_msrs *autostore = &vmx->msr_autostore;
>  	bool in_vmcs12_store_list;
>  	int msr_autostore_slot;
>  	bool in_autostore_list;
> @@ -2366,7 +2366,7 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
>  	 * addresses are constant (for vmcs02), the counts can change based
>  	 * on L2's behavior, e.g. switching to/from long mode.
>  	 */
> -	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.guest.val));
> +	vmcs_write64(VM_EXIT_MSR_STORE_ADDR, __pa(vmx->msr_autostore.val));
>  	vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.host.val));
>  	vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, __pa(vmx->msr_autoload.guest.val));
>  
> @@ -2704,7 +2704,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  	 */
>  	prepare_vmx_msr_autostore_list(&vmx->vcpu, MSR_IA32_TSC);
>  
> -	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.guest.nr);
> +	vmcs_write32(VM_EXIT_MSR_STORE_COUNT, vmx->msr_autostore.nr);
>  	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
>  	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 62ba2a2b9e98..23c92c41fd83 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6567,7 +6567,7 @@ void dump_vmcs(struct kvm_vcpu *vcpu)
>  	if (vmcs_read32(VM_ENTRY_MSR_LOAD_COUNT) > 0)
>  		vmx_dump_msrs("guest autoload", &vmx->msr_autoload.guest);
>  	if (vmcs_read32(VM_EXIT_MSR_STORE_COUNT) > 0)
> -		vmx_dump_msrs("guest autostore", &vmx->msr_autostore.guest);
> +		vmx_dump_msrs("autostore", &vmx->msr_autostore);
>  
>  	if (vmentry_ctl & VM_ENTRY_LOAD_CET_STATE)
>  		pr_err("S_CET = 0x%016lx, SSP = 0x%016lx, SSP TABLE = 0x%016lx\n",
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index d7a96c84371f..4ce653d729ca 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -245,9 +245,7 @@ struct vcpu_vmx {
>  		struct vmx_msrs host;
>  	} msr_autoload;
>  
> -	struct msr_autostore {
> -		struct vmx_msrs guest;
> -	} msr_autostore;
> +	struct vmx_msrs msr_autostore;
>  
>  	struct {
>  		int vm86_active;

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



