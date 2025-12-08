Return-Path: <kvm+bounces-65494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9661DCACAF0
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 10:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 518C43073D43
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 09:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C1BF32B997;
	Mon,  8 Dec 2025 09:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PuKCZyqO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2526F32ABF3;
	Mon,  8 Dec 2025 09:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765186526; cv=none; b=pGyzm3282E725/dgcu8EJFndlhc0lwwMx5c1By/L0STyVo/WAnsPsPDls1NHr4jwRKR0yE8f13cthSJFMkdLtn5x9DaaLM0rv6u9gFsaHbhJEfMZVAdeJRXjjr4VP91Gbc+1hBtedvlf7yoXcHtCe1muhUflyoICSNY5z//nG+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765186526; c=relaxed/simple;
	bh=dxwlUYyotMAj1FOCT7HUPg377L9SdqVfiNdsHHzR+yM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b0eD/w9EJb/Ddf9XXsNTUDR9q5q5luQ7B2QiSBPqQ//t2+xOQPsagmVZalVw+lnRjxsDMx/eorBIn3kNzGsFiK4ml+lyhr4eGPgio230QGDk+LglNL0z+vxP0dguNbum66i1LN2xxB00MTAGVUK2tkosJlati3b1I+/3DkJE0CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PuKCZyqO; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765186525; x=1796722525;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dxwlUYyotMAj1FOCT7HUPg377L9SdqVfiNdsHHzR+yM=;
  b=PuKCZyqOjReTjq8jEzdtw98j6Asvg3VBZVzEepHmgcG+kd/UdjB6DMm9
   QeWnVGXvXcBIOPzfRsOIIr8wNxdDJhHMLCzv/twpO9p/1W4dypsT6eo0U
   TR0oFBEqYdtXyuc+jTmKwWBnwrdynpk2rD3Vmroy1iT+OBm13TZoN86v8
   zzmg7PEL/6Fup2Fz+zsCk/KgHdUP+jovSbQjswyp4aTDQDPIdVCGMNHfC
   iJh65ND4f3shKVNknV7HpnZVrkfnLAcxcwZURDxVaCIF7JAF034NO21QR
   obQwZ7KhUom/eRoHQTdVp8OIAh1nKy9rpzqmyTDRkH0sbVzC/ssWWgoaX
   Q==;
X-CSE-ConnectionGUID: sO3ovh3hR92iVWzonwBloA==
X-CSE-MsgGUID: pOOUNsrzTr+8q6MxT1HfNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67288202"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67288202"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:35:24 -0800
X-CSE-ConnectionGUID: GvTBKVl5QN2hGFwHvhUlpA==
X-CSE-MsgGUID: UZpj0zMRTM69UjjLsI6NgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="196157405"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.12]) ([10.124.240.12])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2025 01:35:15 -0800
Message-ID: <c2562f0b-9d73-479d-acaf-27da2fbe0c1e@linux.intel.com>
Date: Mon, 8 Dec 2025 17:35:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 40/44] KVM: VMX: Set MSR index auto-load entry if and
 only if entry is "new"
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
 <20251206001720.468579-41-seanjc@google.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20251206001720.468579-41-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 12/6/2025 8:17 AM, Sean Christopherson wrote:
> When adding an MSR to the auto-load lists, update the MSR index in the
> list entry if and only if a new entry is being inserted, as 'i' can only
> be non-negative if vmx_find_loadstore_msr_slot() found an entry with the
> MSR's index.  Unnecessarily setting the index is benign, but it makes it
> harder to see that updating the value is necessary even when an existing
> entry for the MSR was found.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2c50ebf4ff1b..be2a2580e8f1 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -1141,16 +1141,16 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
>  
>  	if (i < 0) {
>  		i = m->guest.nr++;
> +		m->guest.val[i].index = msr;
>  		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
>  	}
> -	m->guest.val[i].index = msr;
>  	m->guest.val[i].value = guest_val;
>  
>  	if (j < 0) {
>  		j = m->host.nr++;
> +		m->host.val[j].index = msr;
>  		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, m->host.nr);
>  	}
> -	m->host.val[j].index = msr;
>  	m->host.val[j].value = host_val;
>  }
>  

Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>



