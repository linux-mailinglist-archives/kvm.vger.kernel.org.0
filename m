Return-Path: <kvm+bounces-67921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62748D17623
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 09:52:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C384730164CA
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 08:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A715836AB58;
	Tue, 13 Jan 2026 08:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k7NTohOx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B028F3128AE;
	Tue, 13 Jan 2026 08:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768294317; cv=none; b=lPRbAx4MfGxCG/vydKdzEfrex3JD0ph60Jg0nA19gDmCkGL+flbVgvKwRCGNato3St+gHtAIUdpS+w9/gSreaNO1ROF+TwCyKl1AxvN5NlagON0TyW00r1xHEIJt5afVK09nq/5g786e+UThlNRiOE2ep1BZWqC8v0a7ZapeoTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768294317; c=relaxed/simple;
	bh=7KbNTxbFaXizAwZBgHQhlm6YMKRaEBJ+xLXDrhJd+4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tywxObCOeVhWmaVAIpdHwfJwEhQ95KRG8s6Sf0cb59ICecC6U3Z/xE0qFClbBIDvnUXT7v727BMKQdNoXKLzcdyA442Qr7/IY5Vr8tW5C+8FbH7PnLET5dCbeNs1Rwx9pmQktz3wTgw6KeO7HU0BHWL7rH02AZYKxFHkFHosWOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k7NTohOx; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768294316; x=1799830316;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=7KbNTxbFaXizAwZBgHQhlm6YMKRaEBJ+xLXDrhJd+4Y=;
  b=k7NTohOxSZieX027yk3eaPROU47E3cY6ViwulZ2a8HukT6crvRtK8TZd
   j7U6jFlGpkKEQEZD2NtTagp9/mzU9KNF6t+sGKTy2LEFCPS7kyfhppc7j
   bhvzB11B1kpa0a0vl2d63Qfv+CYG2/VIaq/B5HSPf/htUYoQIZhHccbbx
   9pSkL24Q0OGV1ul7KGFWeLATDUi+OeC6yLRlNSRCQJRQ0v7zBZgvc9AKY
   F18h1ePCI7AHgkKVxUMsDnDmvTzOvNmCKyjkqbMpShjfjkmQ6hlorjUsN
   eaB1IGMBOSOzmzHoeCw5FHhf3zmYCkqVjHYs5AZi2/CAjvVnVQUWruefr
   g==;
X-CSE-ConnectionGUID: 9UStSyFgS56uY7cNrySQvg==
X-CSE-MsgGUID: S0cA7RvwSmSZ9tB56RDgEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11669"; a="69734455"
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="69734455"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 00:51:56 -0800
X-CSE-ConnectionGUID: MsfG/7jISmiXa5/F2Lll4Q==
X-CSE-MsgGUID: iSH5hfydSdaFfqKcr7i1pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,222,1763452800"; 
   d="scan'208";a="204412291"
Received: from unknown (HELO [10.238.1.231]) ([10.238.1.231])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2026 00:51:55 -0800
Message-ID: <b9281487-7dcf-4bab-b251-c2e54c9940c8@linux.intel.com>
Date: Tue, 13 Jan 2026 16:51:52 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] KVM: VMX: Move nested_mark_vmcs12_pages_dirty() to
 vmx.c, and rename
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Fred Griffoul <fgriffo@amazon.co.uk>
References: <20251121223444.355422-1-seanjc@google.com>
 <20251121223444.355422-5-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121223444.355422-5-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/22/2025 6:34 AM, Sean Christopherson wrote:
> Move nested_mark_vmcs12_pages_dirty() to vmx.c now that it's only used in
> the VM-Exit path, and add "all" to its name to document that its purpose
> is to mark all (mapped-out-of-band) vmcs12 pages as dirty.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 13 -------------
>  arch/x86/kvm/vmx/vmx.c    | 14 +++++++++++++-
>  2 files changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d0cf99903971..97554eda440c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -3980,19 +3980,6 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
>  	}
>  }
>  
> -
> -void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)

The declaration in the header file is left over.
Since the patch series has been merged in the kvm-x86 next branch, I sent a
patch to remove it.

https://lore.kernel.org/kvm/20260113084748.1714633-1-binbin.wu@linux.intel.com/

> -{
> -	struct vcpu_vmx *vmx = to_vmx(vcpu);
> -
> -	/*
> -	 * Don't need to mark the APIC access page dirty; it is never
> -	 * written to by the CPU during APIC virtualization.
> -	 */
> -	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
> -	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);
> -}
> -
>  static int vmx_complete_nested_posted_interrupt(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 4cbe8c84b636..cc38d08935e8 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6378,6 +6378,18 @@ static void vmx_flush_pml_buffer(struct kvm_vcpu *vcpu)
>  	vmcs_write16(GUEST_PML_INDEX, PML_HEAD_INDEX);
>  }
>  
> +static void nested_vmx_mark_all_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_vmx *vmx = to_vmx(vcpu);
> +
> +	/*
> +	 * Don't need to mark the APIC access page dirty; it is never
> +	 * written to by the CPU during APIC virtualization.
> +	 */
> +	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.virtual_apic_map);
> +	kvm_vcpu_map_mark_dirty(vcpu, &vmx->nested.pi_desc_map);
> +}
> +
>  static void vmx_dump_sel(char *name, uint32_t sel)
>  {
>  	pr_err("%s sel=0x%04x, attr=0x%05x, limit=0x%08x, base=0x%016lx\n",
> @@ -6655,7 +6667,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  		 * Mark them dirty on every exit from L2 to prevent them from
>  		 * getting out of sync with dirty tracking.
>  		 */
> -		nested_mark_vmcs12_pages_dirty(vcpu);
> +		nested_vmx_mark_all_vmcs12_pages_dirty(vcpu);
>  
>  		/*
>  		 * Synthesize a triple fault if L2 state is invalid.  In normal


