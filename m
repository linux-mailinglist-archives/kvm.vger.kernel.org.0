Return-Path: <kvm+bounces-65491-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id F376BCACDC8
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 11:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B16030202D5
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 10:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8CBA327C03;
	Mon,  8 Dec 2025 09:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQVcpbiv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D913277A9;
	Mon,  8 Dec 2025 09:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186336; cv=none; b=cAagIeiEnuTae/iI/KHVas4VM3RqVuyfvf45hZapCkPP421yD/323KFzkyK5S7uY2pcfu/IQhR435epk5AabN06yZ4FdhDIUySyNZWX0DH9H39VlwB2nefr1xdit5u/cZhE+aojhr3JCw8zSLbEhTJNOVqiZlZxHQWQ+wU8YO3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186336; c=relaxed/simple;
	bh=GYQaZ3LGrXDq/3mzDZllqKTFLOorC/Poy7Wcg2fCybE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t9zCgoU0Mv3lTem8TKGmR7aCJiw5wSIpQurDeL3HdVVVFAmXXGb1gQT5y6eXroHpZNCB2MBGO2YJt3Nqps/VM6rE9JAUNvMcmNNFW0bvjiPiHkZ9jsZVtRxlQORuA40/Bws2AyAg16Qb+Coyy0OB2OEjV7reo3lghXOg3j528ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQVcpbiv; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186334; x=1796722334;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GYQaZ3LGrXDq/3mzDZllqKTFLOorC/Poy7Wcg2fCybE=;
  b=aQVcpbiv0F2NUnkBYXalI3ma2C/QdKczgWXLuLniKs00Dh+fvlqPF0hN
   3QKVhVndQIW+ZZ9V9J1HGbTLPqC96qrimPBqCtEkiQFxrI0KCNKsAnrEe
   2kkcCVBX4vLqqrj9joPGtO+oA/VVFplqeVZWl8qr1itn9W0btsHzOr/kB
   KhiW7X9LQb84Ryaywtx0w6IoQ37Imrc+IJzH95lMbnsZlLiYjwIpUSoHb
   X3QfcP9Xv1xGFohQo1jXhxlKGK2SWlvmcDEvCyqQ/A8jF7oh8bdr0jRLF
   k00PVY8mvE8l99gIUXmmY8FbuwufELvO8ic4re0mfBNbUVz0Be+NdhuSz
   A==;
X-CSE-ConnectionGUID: F49oPPRKSTSCEBQ3PPTqGw==
X-CSE-MsgGUID: 0saCXtSOSfSkLaie/Y98mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="70979530"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="70979530"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:32:13 -0800
X-CSE-ConnectionGUID: ypr0CVsRRuCL80dlOYG7Uw==
X-CSE-MsgGUID: sHpFM58aQWi8jT8QK4x6Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200067937"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:32:04 -0800
Message-ID: <f551c638-a8c8-4aab-9fb7-f04df124ff15@linux.intel.com>
Date: Mon, 8 Dec 2025 17:32:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 38/44] KVM: VMX: Drop unused @entry_only param from
 add_atomic_switch_msr()
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
 <20251206001720.468579-39-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-39-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> Drop the "on VM-Enter only" parameter from add_atomic_switch_msr() as it
> is no longer used, and for all intents and purposes was never used.  The
> functionality was added, under embargo, by commit 989e3992d2ec
> ("x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs"),
> and then ripped out by commit 2f055947ae5e ("x86/kvm: Drop L1TF MSR list
> approach") just a few commits later.
>
>   2f055947ae5e x86/kvm: Drop L1TF MSR list approach
>   72c6d2db64fa x86/litf: Introduce vmx status variable
>   215af5499d9e cpu/hotplug: Online siblings when SMT control is turned on
>   390d975e0c4e x86/KVM/VMX: Use MSR save list for IA32_FLUSH_CMD if required
>   989e3992d2ec x86/KVM/VMX: Extend add_atomic_switch_msr() to allow VMENTER only MSRs
>
> Furthermore, it's extremely unlikely KVM will ever _need_ to load an MSR
> value via the auto-load lists only on VM-Enter.  MSRs writes via the lists
> aren't optimized in any way, and so the only reason to use the lists
> instead of a WRMSR are for cases where the MSR _must_ be load atomically
> with respect to VM-Enter (and/or VM-Exit).  While one could argue that
> command MSRs, e.g. IA32_FLUSH_CMD, "need" to be done exact at VM-Enter, in
> practice doing such flushes within a few instructons of VM-Enter is more
> than sufficient.
>
> Note, the shortlog and changelog for commit 390d975e0c4e ("x86/KVM/VMX: Use
> MSR save list for IA32_FLUSH_CMD if required") are misleading and wrong.
> That commit added MSR_IA32_FLUSH_CMD to the VM-Enter _load_ list, not the
> VM-Enter save list (which doesn't exist, only VM-Exit has a store/save
> list).
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index a51f66d1b201..38491962b2c1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1094,7 +1094,7 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  }
>  
>  static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> -				  u64 guest_val, u64 host_val, bool entry_only)
> +				  u64 guest_val, u64 host_val)
>  {
>  	int i, j = 0;
>  	struct msr_autoload *m = &vmx->msr_autoload;
> @@ -1132,8 +1132,7 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  	}
>  
>  	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> -	if (!entry_only)
> -		j = vmx_find_loadstore_msr_slot(&m->host, msr);
> +	j = vmx_find_loadstore_msr_slot(&m->host, msr);
>  
>  	if ((i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS) ||
>  	    (j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS)) {
> @@ -1148,9 +1147,6 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  	m->guest.val[i].index = msr;
>  	m->guest.val[i].value = guest_val;
>  
> -	if (entry_only)
> -		return;
> -
>  	if (j < 0) {
>  		j = m->host.nr++;
>  		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> @@ -1190,8 +1186,7 @@ static bool update_transition_efer(struct vcpu_vmx *vmx)
>  		if (!(guest_efer & EFER_LMA))
>  			guest_efer &= ~EFER_LME;
>  		if (guest_efer != kvm_host.efer)
> -			add_atomic_switch_msr(vmx, MSR_EFER,
> -					      guest_efer, kvm_host.efer, false);
> +			add_atomic_switch_msr(vmx, MSR_EFER, guest_efer, kvm_host.efer);
>  		else
>  			clear_atomic_switch_msr(vmx, MSR_EFER);
>  		return false;
> @@ -7350,7 +7345,7 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
>  			clear_atomic_switch_msr(vmx, msrs[i].msr);
>  		else
>  			add_atomic_switch_msr(vmx, msrs[i].msr, msrs[i].guest,
> -					msrs[i].host, false);
> +					      msrs[i].host);
>  }
>  
>  static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit)

LGTM.

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



