Return-Path: <kvm+bounces-65490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C068CACBAD
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:46:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E17E03101F81
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D5C8315D29;
	Mon,  8 Dec 2025 09:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nXofIik1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33B59314A7C;
	Mon,  8 Dec 2025 09:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186206; cv=none; b=rlPK2ksqCFTxWLZfaWrj3XCxegM5VhSW++qqyPPjmxmyqmfuR/tlHScP/4TdDBeou2HVMP3EZ7IWCcL8tTZ61HvUGH6CJIc5JRgX6c9wlq2wnzllo75Z8Ad9W72tKobLy3uXpjMMwqjqlX0KL6G146zdvCIV+1MDz0CEEl42UHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186206; c=relaxed/simple;
	bh=JcvwqgFLZTsix0sYAKimzPeJUH3wC8yywdSyJTN0AOA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QuhU++FWIGCoMGcjBuFmIqCkwTeqY8pHGewog0hmAk/H/PpiwTpxUbdG/s75JeK1gQcMq6apKB+YkD82kgqY51R1rMGKqu0fvKjeqvS0SNM9ILRLK64dgssC/vJzrZl8AY/qVfkBEWjhzQnb1S0mXqNEuI6JhTAJWprY1ztiFSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nXofIik1; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186205; x=1796722205;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JcvwqgFLZTsix0sYAKimzPeJUH3wC8yywdSyJTN0AOA=;
  b=nXofIik18CH0JQSzkCZXBhsdsW6oayriLxNss4v2cHQ2prAOIIt/QQB4
   zpi2zaUEejwjuSPLwMjF8nuA8R7nq+XU9DRpwrJCmoDLFPaICSMJVzgyn
   C6+cPy0uLjsJ3ozTF10vCLzfa/I6v8HuHtQwAeOU39IzDWTtHZmZ3uRVs
   nAtXPnGvzucTC+O6tSR81ZzpFoI47cKbJ3mR4Qi81tkDZjkaUxoM3Vw9v
   vlL1k3g8hv/zTATX7bizX3KpGyC+b+LxOtU+9cAjQ5KISHUiOTZSg+PZK
   3QdYjBO5f5qGii8JcoDJYcJVbze9ajrIRTtIwyMTFPrafABBtmUnKXmSE
   g==;
X-CSE-ConnectionGUID: 2Gjt5I4OT3+UTodRv70D8Q==
X-CSE-MsgGUID: nwFU4kQ/RiCppBgiUVC1UQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="70979398"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="70979398"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:30:04 -0800
X-CSE-ConnectionGUID: hxoRms/XQeW3zbu9VYpNCQ==
X-CSE-MsgGUID: qMxDtETuSwGp66ogCtei0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200067632"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:29:56 -0800
Message-ID: <2440b9bf-a2a1-4f66-94b2-71f47d62f3db@linux.intel.com>
Date: Mon, 8 Dec 2025 17:29:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 37/44] KVM: VMX: Dedup code for removing MSR from
 VMCS's auto-load list
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
 <20251206001720.468579-38-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-38-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> Add a helper to remove an MSR from an auto-{load,store} list to dedup the
> msr_autoload code, and in anticipation of adding similar functionality for
> msr_autostore.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 52bcb817cc15..a51f66d1b201 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1040,9 +1040,22 @@ static int vmx_find_loadstore_msr_slot(struct vmx_msrs *m, u32 msr)
>  	return -ENOENT;
>  }
>  
> +static void vmx_remove_auto_msr(struct vmx_msrs *m, u32 msr,
> +				unsigned long vmcs_count_field)
> +{
> +	int i;
> +
> +	i = vmx_find_loadstore_msr_slot(m, msr);
> +	if (i < 0)
> +		return;
> +
> +	--m->nr;
> +	m->val[i] = m->val[m->nr];

Sometimes the order of MSR writing does matter, e.g., PERF_GLOBAL_CTRL MSR
should be written at last after all PMU MSR writing. So directly moving the
last MSR entry into cleared one could break the MSR writing sequence and
may cause issue in theory.

I know this won't really cause issue since currently vPMU won't use the MSR
auto-load feature to save any PMU MSR, but it's still unsafe for future uses. 

I'm not sure if it's worthy to do the strict MSR entry shift right now.
Perhaps we could add a message to warn users at least.

Thanks.


> +	vmcs_write32(vmcs_count_field, m->nr);
> +}
> +
>  static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
>  {
> -	int i;
>  	struct msr_autoload *m = &vmx->msr_autoload;
>  
>  	switch (msr) {
> @@ -1063,21 +1076,9 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
>  		}
>  		break;
>  	}
> -	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> -	if (i < 0)
> -		goto skip_guest;
> -	--m->guest.nr;
> -	m->guest.val[i] = m->guest.val[m->guest.nr];
> -	vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
>  
> -skip_guest:
> -	i = vmx_find_loadstore_msr_slot(&m->host, msr);
> -	if (i < 0)
> -		return;
> -
> -	--m->host.nr;
> -	m->host.val[i] = m->host.val[m->host.nr];
> -	vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
> +	vmx_remove_auto_msr(&m->guest, msr, VM_ENTRY_MSR_LOAD_COUNT);
> +	vmx_remove_auto_msr(&m->host, msr, VM_EXIT_MSR_LOAD_COUNT);
>  }
>  
>  static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,

