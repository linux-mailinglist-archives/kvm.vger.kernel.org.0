Return-Path: <kvm+bounces-65496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E2862CACBBF
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:47:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 239ED30CB02B
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:42:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B8A31196C;
	Mon,  8 Dec 2025 09:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BD/i3oLl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B54931078B;
	Mon,  8 Dec 2025 09:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186650; cv=none; b=nPH8CwV+MPMdQyZbZsVeH9Ufpf4TaK8Qgx8zMsuPU4+jizvWNTtKvLkacbFa/GmD1FFT9ZplUKmSO4mDqk1WCHGqakIM7YuDHOLJ68utk1L/0Vn3B+M4jRWbAIbdaRdk/V6+y9sHP6K0zPGM50z42tN60zkEe7zyfDrc95qBVD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186650; c=relaxed/simple;
	bh=d0HhougkGXq9v34Z+ad6ty1DqDsicraVXYq04vcosCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mtz7h7fpt8913o3wygY5nVGLczh8FTKJzXFSF6+fPHHUZCp9pNkiWM+TiSeEGaw/vluhRaMcpeq1PsyJUEiXi6+XFpU0dhq6JcPlvCH5s5tPRopyEEH9QvCd1e+UztrtvAU6QFoqAH/QH5QmkMt2yS1gzfvFMN3kFsePILyzNZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BD/i3oLl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186649; x=1796722649;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=d0HhougkGXq9v34Z+ad6ty1DqDsicraVXYq04vcosCM=;
  b=BD/i3oLlQ2UzR3IlB+Jx/pgvUfxf/2cyB+0yBbBBiWcRU0YbEjQn2Oej
   4NbMgk5dM1ZkVpBkPtj2uydStYWL8H72EOprSUXgn83/dl9ivN4/eDl9w
   PVogiejYhQcw3rOp/sdKoU7aovPI+ReXqYZrVQ6KjDKxfPSAAkqOC8em4
   73xLPLlh0Ml8+5nqZYv479hT8K/osygMudP4Ds/T/SzOYhKKGHYQOTJGV
   l+k1bNVCIlQNhWRBIJQLeRP71jjdV7rnvkQn33m57tuUR++/utO6N2A9C
   PDuKL9bf5WJDkSLcXemYb1k7DP55waHyo1gaAwyY4KQaXyrinIEIOSRGV
   A==;
X-CSE-ConnectionGUID: b7FawbJeSgC9qBZibT39oA==
X-CSE-MsgGUID: Qb8rZkutQMaHhrPV0ofyxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67020891"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67020891"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:37:28 -0800
X-CSE-ConnectionGUID: JlmL8gc6QXy0jo0j61cLRA==
X-CSE-MsgGUID: oX3fz7C0SwOU1S4iJ0yDOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="195793053"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:37:21 -0800
Message-ID: <3025d575-4fba-41ff-b9dc-fab4eaf87dcc@linux.intel.com>
Date: Mon, 8 Dec 2025 17:37:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 42/44] KVM: VMX: Dedup code for adding MSR to VMCS's
 auto list
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
 <20251206001720.468579-43-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-43-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> Add a helper to add an MSR to a VMCS's "auto" list to deduplicate the code
> in add_atomic_switch_msr(), and so that the functionality can be used in
> the future for managing the MSR auto-store list.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 41 +++++++++++++++++++----------------------
>  1 file changed, 19 insertions(+), 22 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 018e01daab68..3f64d4b1b19c 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1093,12 +1093,28 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  	vm_exit_controls_setbit(vmx, exit);
>  }
>  
> +static void vmx_add_auto_msr(struct vmx_msrs *m, u32 msr, u64 value,
> +			     unsigned long vmcs_count_field, struct kvm *kvm)
> +{
> +	int i;
> +
> +	i = vmx_find_loadstore_msr_slot(m, msr);
> +	if (i < 0) {
> +		if (KVM_BUG_ON(m->nr == MAX_NR_LOADSTORE_MSRS, kvm))
> +			return;
> +
> +		i = m->nr++;
> +		m->val[i].index = msr;
> +		vmcs_write32(vmcs_count_field, m->nr);
> +	}
> +	m->val[i].value = value;
> +}
> +
>  static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  				  u64 guest_val, u64 host_val)
>  {
>  	struct msr_autoload *m = &vmx->msr_autoload;
>  	struct kvm *kvm = vmx->vcpu.kvm;
> -	int i;
>  
>  	switch (msr) {
>  	case MSR_EFER:
> @@ -1132,27 +1148,8 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  		wrmsrq(MSR_IA32_PEBS_ENABLE, 0);
>  	}
>  
> -	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> -	if (i < 0) {
> -		if (KVM_BUG_ON(m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> -			return;
> -
> -		i = m->guest.nr++;
> -		m->guest.val[i].index = msr;
> -		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
> -	}
> -	m->guest.val[i].value = guest_val;
> -
> -	i = vmx_find_loadstore_msr_slot(&m->host, msr);
> -	if (i < 0) {
> -		if (KVM_BUG_ON(m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> -			return;
> -
> -		i = m->host.nr++;
> -		m->host.val[i].index = msr;
> -		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> -	}
> -	m->host.val[i].value = host_val;
> +	vmx_add_auto_msr(&m->guest, msr, guest_val, VM_ENTRY_MSR_LOAD_COUNT, kvm);
> +	vmx_add_auto_msr(&m->guest, msr, host_val, VM_EXIT_MSR_LOAD_COUNT, kvm);
>  }
>  
>  static bool update_transition_efer(struct vcpu_vmx *vmx)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



