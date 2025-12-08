Return-Path: <kvm+bounces-65495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54737CACB23
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:40:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A501C30B453E
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:36:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98BD32B9A9;
	Mon,  8 Dec 2025 09:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXs/X33q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF892C029D;
	Mon,  8 Dec 2025 09:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186612; cv=none; b=BwcaJJU0CX6HfL+G18VT+VwfsyZvQ9u0maZqNXIkLRzuU1WjOytzgm8y0/yv6Uv/ARm3WDcmBe8VUIhK/j/adNiVElTaEXXKc2o+hXCfrvCebtctXRqnV/RohHrNpOg0Hid1xCfJ4C/AGCBt0AA6dQ7lrGmlSdxqWNaWn2Qbbqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186612; c=relaxed/simple;
	bh=10zHr1SKSV4NU1wJMxeh9bCQVTkfIemMgU27+u6iC/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fTOHfDPgikRC0GVnInElSTjDJ3G3CYGOPxLt5rQevzEI7ldyhyK19PIsIxGEU9CpRCurX4vdxSZZfZIFV2O/uOx7GW9bi1VIlkEcf0Rv740+JcFqv83OaNgJoyj/N8/p+UcgayJdNi7CeTiuDyNk+qHWwH+C03xBrQhzQ68+QPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXs/X33q; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186611; x=1796722611;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=10zHr1SKSV4NU1wJMxeh9bCQVTkfIemMgU27+u6iC/0=;
  b=jXs/X33qi0NTnSdzF8FtYrT8Odo7RgCIXzki7wxe/wJEefkA66o4F3ku
   e8ahDzd97sF54cDrmvoAC+hRxIarJbyKe+zL/AQIEUWKLibjG8Te/OzCF
   xI1QD20agu1FrGyrvcA12QGJBKTL9WzpY0deykkFeHS3av/jwmUhdjMdq
   IZB7GHm+wO3IoZb0Ha9Etq+OScfIlh1DTcdzWF55dgRdFrJBugCa1b8Lp
   gHbyyQ1CytFEbd/fYvBNDu0jsQnkreYmELqxKc7pXLME7AKBNHcdWlWSE
   uYME7ANRi1RUOpFeLvofbe+MchBuS8JROcRqsP5ZN8EdaquM7GbJNXjFn
   g==;
X-CSE-ConnectionGUID: chbx4DplQOGDl2BZSeoOXg==
X-CSE-MsgGUID: fblhaEy9ROSC481qP5Lh6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67288450"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67288450"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:36:49 -0800
X-CSE-ConnectionGUID: bsfJ0l67RQmzvo/wRHYFCA==
X-CSE-MsgGUID: d+3gSK50QVqn044E2530nA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="196157499"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:36:40 -0800
Message-ID: <78fb04ca-59a2-493a-a82b-d59aaf6b557a@linux.intel.com>
Date: Mon, 8 Dec 2025 17:36:38 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 41/44] KVM: VMX: Compartmentalize adding MSRs to host
 vs. guest auto-load list
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
 <20251206001720.468579-42-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-42-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> Undo the bundling of the "host" and "guest" MSR auto-load list logic so
> that the code can be deduplicated by factoring out the logic to a separate
> helper.  Now that "list full" situations are treated as fatal to the VM,
> there is no need to pre-check both lists.
>
> For all intents and purposes, this reverts the add_atomic_switch_msr()
> changes made by commit 3190709335dd ("x86/KVM/VMX: Separate the VMX
> AUTOLOAD guest/host number accounting").
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++-----------
>  1 file changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index be2a2580e8f1..018e01daab68 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1096,9 +1096,9 @@ static __always_inline void add_atomic_switch_msr_special(struct vcpu_vmx *vmx,
>  static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  				  u64 guest_val, u64 host_val)
>  {
> -	int i, j = 0;
>  	struct msr_autoload *m = &vmx->msr_autoload;
>  	struct kvm *kvm = vmx->vcpu.kvm;
> +	int i;
>  
>  	switch (msr) {
>  	case MSR_EFER:
> @@ -1133,25 +1133,26 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  	}
>  
>  	i = vmx_find_loadstore_msr_slot(&m->guest, msr);
> -	j = vmx_find_loadstore_msr_slot(&m->host, msr);
> -
> -	if (KVM_BUG_ON(i < 0 && m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm) ||
> -	    KVM_BUG_ON(j < 0 &&  m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> -		return;
> -
>  	if (i < 0) {
> +		if (KVM_BUG_ON(m->guest.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> +			return;
> +
>  		i = m->guest.nr++;
>  		m->guest.val[i].index = msr;
>  		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
>  	}
>  	m->guest.val[i].value = guest_val;
>  
> -	if (j < 0) {
> -		j = m->host.nr++;
> -		m->host.val[j].index = msr;
> +	i = vmx_find_loadstore_msr_slot(&m->host, msr);
> +	if (i < 0) {
> +		if (KVM_BUG_ON(m->host.nr == MAX_NR_LOADSTORE_MSRS, kvm))
> +			return;
> +
> +		i = m->host.nr++;
> +		m->host.val[i].index = msr;
>  		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
>  	}
> -	m->host.val[j].value = host_val;
> +	m->host.val[i].value = host_val;
>  }
>  
>  static bool update_transition_efer(struct vcpu_vmx *vmx)

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



