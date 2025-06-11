Return-Path: <kvm+bounces-48970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7D0AD4C51
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 09:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 09B1518953C0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 07:09:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5077322FACE;
	Wed, 11 Jun 2025 07:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lDkxGNV4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195011494A8;
	Wed, 11 Jun 2025 07:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749625753; cv=none; b=kFhfbj5RY3hfCk+0t/goebfp2xbejgoi8TSKq2S/Dflljj4RYHHwt4v78L5hFsu1BIZi5SC18NTISS2Yp5z05S/jKkkRYhtFOVjNmwHzw66yzD6yJxJ4OBzkhPiVHA3pKgcde/U7dzifUaB0t1ySR+QBsWwIYnfLDWDmqGm2xQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749625753; c=relaxed/simple;
	bh=PSOUw4nND6JTRG7Gcj3JAP7WhQyzD+HANN81r+8hnqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dizfGvtogAkKekW32YyZLxJgsYngZbx4DMxDO0gbjOe+w/qh9zo0/HmrUX3mwmZ8pOFW4e6Lks2OSz5qN6TbJjG9oHjC5HZE2+ZRsaIP1eWneEOumANlrf7RtkbcRtfLK2pBCkYzhgC8twvgHxi7mR+pktZq2CUpZ6rXM2IBIqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lDkxGNV4; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749625751; x=1781161751;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PSOUw4nND6JTRG7Gcj3JAP7WhQyzD+HANN81r+8hnqk=;
  b=lDkxGNV49YBpwGstQZkUPaybP3DmrsA6QcA3zCMh/0iFw09UFLIBnzL0
   vQ/NbUscvzvvQrYtlEKoh9BgHYnAum235J2GH1/b6LkIjqlhfBidbWqop
   gZMNPuJeABwmmtC5gnAzNUFfdxWprIzT+MTBjkBYjrm5w48OSYp+GbYMg
   CyWuACwjFd0AdEmyJz+eH2jkin/xmVAB9nPEHA5Ymbg93uDSPPMOt5TJd
   EIJxPKR66u5vUi0L8D+9HVXl4fTQwndwQYX0TAwhYeANY50fNauTfnoLf
   J8s7Vwp6HBERTfLB6c48brWJtBm05O0YilPvJfFz5Os8Uf9zIP7Uukw2/
   Q==;
X-CSE-ConnectionGUID: fxi/kRf5Qu2oY3LvjOvyDA==
X-CSE-MsgGUID: KLI+Rx8/SqOEAYNRwYuUOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="69188885"
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="69188885"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:09:10 -0700
X-CSE-ConnectionGUID: tFAysObOQ9qC2LkKwJMKhg==
X-CSE-MsgGUID: j9yyoq9ySNi/QpZiMkzvPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,227,1744095600"; 
   d="scan'208";a="150926587"
Received: from unknown (HELO [10.238.0.239]) ([10.238.0.239])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2025 00:09:08 -0700
Message-ID: <27f345bd-2f2b-4e40-8601-d2bd7c12ce5e@linux.intel.com>
Date: Wed, 11 Jun 2025 15:09:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 20/32] KVM: x86: Rename msr_filter_changed() =>
 recalc_msr_intercepts()
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>,
 Dapeng Mi <dapeng1.mi@linux.intel.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 Manali Shukla <Manali.Shukla@amd.com>
References: <20250610225737.156318-1-seanjc@google.com>
 <20250610225737.156318-21-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250610225737.156318-21-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/11/2025 6:57 AM, Sean Christopherson wrote:
> Rename msr_filter_changed() to recalc_msr_intercepts() and drop the
> trampoline wrapper now that both SVM and VMX use a filter-agnostic recalc
> helper to react to the new userspace filter.
>
> No functional change intended.
>
> Reviewed-by: Xin Li (Intel) <xin@zytor.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm-x86-ops.h | 2 +-
>   arch/x86/include/asm/kvm_host.h    | 2 +-
>   arch/x86/kvm/svm/svm.c             | 8 +-------
>   arch/x86/kvm/vmx/main.c            | 6 +++---
>   arch/x86/kvm/vmx/vmx.c             | 7 +------
>   arch/x86/kvm/vmx/x86_ops.h         | 2 +-
>   arch/x86/kvm/x86.c                 | 8 +++++++-
>   7 files changed, 15 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index 8d50e3e0a19b..19a6735d6dd8 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -139,7 +139,7 @@ KVM_X86_OP(check_emulate_instruction)
>   KVM_X86_OP(apic_init_signal_blocked)
>   KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
>   KVM_X86_OP_OPTIONAL(migrate_timers)
> -KVM_X86_OP(msr_filter_changed)
> +KVM_X86_OP(recalc_msr_intercepts)
>   KVM_X86_OP(complete_emulated_msr)
>   KVM_X86_OP(vcpu_deliver_sipi_vector)
>   KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 330cdcbed1a6..89a626e5b80f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1885,7 +1885,7 @@ struct kvm_x86_ops {
>   	int (*enable_l2_tlb_flush)(struct kvm_vcpu *vcpu);
>   
>   	void (*migrate_timers)(struct kvm_vcpu *vcpu);
> -	void (*msr_filter_changed)(struct kvm_vcpu *vcpu);
> +	void (*recalc_msr_intercepts)(struct kvm_vcpu *vcpu);
>   	int (*complete_emulated_msr)(struct kvm_vcpu *vcpu, int err);
>   
>   	void (*vcpu_deliver_sipi_vector)(struct kvm_vcpu *vcpu, u8 vector);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index de3d59c71229..710bc5f965dc 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -896,11 +896,6 @@ static void svm_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   	 */
>   }
>   
> -static void svm_msr_filter_changed(struct kvm_vcpu *vcpu)
> -{
> -	svm_recalc_msr_intercepts(vcpu);
> -}
> -
>   void svm_copy_lbrs(struct vmcb *to_vmcb, struct vmcb *from_vmcb)
>   {
>   	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
> @@ -929,7 +924,6 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
>   	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
> -
>   	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
>   	svm_recalc_lbr_msr_intercepts(vcpu);
>   
> @@ -5227,7 +5221,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
>   
>   	.apic_init_signal_blocked = svm_apic_init_signal_blocked,
>   
> -	.msr_filter_changed = svm_msr_filter_changed,
> +	.recalc_msr_intercepts = svm_recalc_msr_intercepts,
>   	.complete_emulated_msr = svm_complete_emulated_msr,
>   
>   	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index d1e02e567b57..b3c58731a2f5 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -220,7 +220,7 @@ static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>   	return vmx_get_msr(vcpu, msr_info);
>   }
>   
> -static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
> +static void vt_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   {
>   	/*
>   	 * TDX doesn't allow VMM to configure interception of MSR accesses.
> @@ -231,7 +231,7 @@ static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
>   	if (is_td_vcpu(vcpu))
>   		return;
>   
> -	vmx_msr_filter_changed(vcpu);
> +	vmx_recalc_msr_intercepts(vcpu);
>   }
>   
>   static int vt_complete_emulated_msr(struct kvm_vcpu *vcpu, int err)
> @@ -1034,7 +1034,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
>   	.apic_init_signal_blocked = vt_op(apic_init_signal_blocked),
>   	.migrate_timers = vmx_migrate_timers,
>   
> -	.msr_filter_changed = vt_op(msr_filter_changed),
> +	.recalc_msr_intercepts = vt_op(recalc_msr_intercepts),
>   	.complete_emulated_msr = vt_op(complete_emulated_msr),
>   
>   	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index ce7a1c07e402..bdff81f8288d 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4074,7 +4074,7 @@ void pt_update_intercept_for_msr(struct kvm_vcpu *vcpu)
>   	}
>   }
>   
> -static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
> +void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   {
>   	if (!cpu_has_vmx_msr_bitmap())
>   		return;
> @@ -4123,11 +4123,6 @@ static void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu)
>   	 */
>   }
>   
> -void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
> -{
> -	vmx_recalc_msr_intercepts(vcpu);
> -}
> -
>   static int vmx_deliver_nested_posted_interrupt(struct kvm_vcpu *vcpu,
>   						int vector)
>   {
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index b4596f651232..34c6e683e321 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -52,7 +52,7 @@ void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>   			   int trig_mode, int vector);
>   void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu);
>   bool vmx_has_emulated_msr(struct kvm *kvm, u32 index);
> -void vmx_msr_filter_changed(struct kvm_vcpu *vcpu);
> +void vmx_recalc_msr_intercepts(struct kvm_vcpu *vcpu);
>   void vmx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
>   void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
>   int vmx_get_feature_msr(u32 msr, u64 *data);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index dd34a2ec854c..cc9a01b6dbc8 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10926,8 +10926,14 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   			kvm_vcpu_update_apicv(vcpu);
>   		if (kvm_check_request(KVM_REQ_APF_READY, vcpu))
>   			kvm_check_async_pf_completion(vcpu);
> +
> +		/*
> +		 * Recalc MSR intercepts as userspace may want to intercept
> +		 * accesses to MSRs that KVM would otherwise pass through to
> +		 * the guest.
> +		 */
>   		if (kvm_check_request(KVM_REQ_MSR_FILTER_CHANGED, vcpu))
> -			kvm_x86_call(msr_filter_changed)(vcpu);
> +			kvm_x86_call(recalc_msr_intercepts)(vcpu);
>   
>   		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
>   			kvm_x86_call(update_cpu_dirty_logging)(vcpu);


