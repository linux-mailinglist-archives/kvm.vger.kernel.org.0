Return-Path: <kvm+bounces-57035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4086B4A00D
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 05:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 802573B2453
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 03:29:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B91B42701D8;
	Tue,  9 Sep 2025 03:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="guM7+cZo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D76E225409;
	Tue,  9 Sep 2025 03:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757388571; cv=none; b=byv9X+PFAvuUhvdc6sJwZoyPi4rW0lZ+8Ps3hDYuEMPml4EQyb6/94sMRG2U9Nswvq7VTxbJlxsrDxEQ7q1kHi6kUxY7ByH9XEi3Wmp6lOMOMtjDVIf+1xAtspOvw6YOZ+p69Pij6va00T1GIzThNqTWFUTgTPpZbytXYHVyFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757388571; c=relaxed/simple;
	bh=EXc69p8u4m6ezjT07mujfn6hxIfP1y4LXG5E32jdTWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HDK8A5nTX2U7MrwaDFhwDDHDsV5u+pdq2BeF0lVFpdFi47cedW7E/lF+Y18pgsUvJ7O/NQulxsK6KontIgJjAeM3XhZl0ws3S8zwL/ysaTmEa214TzsvTBh0Ejv+GP53fvz9s+foehIkpPvVCT/CedJug3yV9YroE4j9+ykZ4C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=guM7+cZo; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757388570; x=1788924570;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EXc69p8u4m6ezjT07mujfn6hxIfP1y4LXG5E32jdTWc=;
  b=guM7+cZo27n2d5CprMxHF1n8Z0ZI8/PvrirldaIiBMuW59oprx1H7Uor
   KP7xTxx6nVPM8uKWldgJIZEcK8n8w+lyChZlH8G0ysPSBdSMJhaZ1ZJDY
   r0Bm+hC/sg4BqQ1QhPOGiLtUqweTU8zYjPTliiakEfriaujG2oc6avGmq
   zmxf7HMYiONIoFfp7y2rnwcc8G/oc0GR07QI01EfOkcKG9lkq1WEWT3gt
   vRTPdQJOr92YGXx1HBWfxrQHY2FvL+63cbnJblI4qLwzal/IDuhTche8/
   kC2jThvABt7l4P8YJE21X8TIoaMhp3zHf3YBc/KW/xaw/JNodGm246dRX
   A==;
X-CSE-ConnectionGUID: oxbinHtMT36GCXIIEaPxDg==
X-CSE-MsgGUID: eGpg2KgORZ29YC0g7fnp5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59587981"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59587981"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 20:29:30 -0700
X-CSE-ConnectionGUID: LEi06bYoRn6OW4GcGWPZYQ==
X-CSE-MsgGUID: plO9xQT9QrSPYN2TnxJMyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,250,1751266800"; 
   d="scan'208";a="172845223"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2025 20:29:28 -0700
Message-ID: <2257f7a6-e4f5-4b90-bb18-cb0af756323f@linux.intel.com>
Date: Tue, 9 Sep 2025 11:29:25 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] KVM: TDX: Do not retry locally when the retry is
 caused by invalid memslot
To: Yan Zhao <yan.y.zhao@intel.com>, seanjc@google.com
Cc: pbonzini@redhat.com, reinette.chatre@intel.com,
 rick.p.edgecombe@intel.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250822070305.26427-1-yan.y.zhao@intel.com>
 <20250822070523.26495-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250822070523.26495-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/22/2025 3:05 PM, Yan Zhao wrote:
> From: Sean Christopherson <seanjc@google.com>
>
> Avoid local retries within the TDX EPT violation handler if a retry is
> triggered by faulting in an invalid memslot, indicating that the memslot is
> undergoing a removal process.
>
> This prevents the slot removal process from being blocked while waiting for
> the VMExit handler to release the SRCU lock.
>
> Opportunistically, export symbol kvm_vcpu_gfn_to_memslot() to allow for
> per-vCPU acceleration of gfn_to_memslot translation.
>
> [Yan: Wrote patch log, comment, fixed a minor error, function export]
>
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Closes: https://lore.kernel.org/all/20250519023737.30360-1-yan.y.zhao@intel.com
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 11 +++++++++++
>   virt/kvm/kvm_main.c    |  1 +
>   2 files changed, 12 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 6784aaaced87..de2c4bb36069 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1992,6 +1992,11 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   	 * blocked by TDs, false positives are inevitable i.e., KVM may re-enter
>   	 * the guest even if the IRQ/NMI can't be delivered.
>   	 *
> +	 * Breaking out of the local retries if a retry is caused by faulting
> +	 * in an invalid memslot (indicating the slot is under removal), so that
> +	 * the slot removal will not be blocked due to waiting for releasing
> +	 * SRCU lock in the VMExit handler.
> +	 *
>   	 * Note: even without breaking out of local retries, zero-step
>   	 * mitigation may still occur due to
>   	 * - invoking of TDH.VP.ENTER after KVM_EXIT_MEMORY_FAULT,
> @@ -2002,6 +2007,8 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   	 * handle retries locally in their EPT violation handlers.
>   	 */
>   	while (1) {
> +		struct kvm_memory_slot *slot;
> +
>   		ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual);
>   
>   		if (ret != RET_PF_RETRY || !local_retry)
> @@ -2015,6 +2022,10 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
>   			break;
>   		}
>   
> +		slot = kvm_vcpu_gfn_to_memslot(vcpu, gpa_to_gfn(gpa));
> +		if (slot && slot->flags & KVM_MEMSLOT_INVALID)

The slot couldn't be NULL here, right?
So the checking for slot is to avoid de-referencing a NULL pointer in case of
bug?

> +			break;
> +
>   		cond_resched();
>   	}
>   	return ret;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 6c07dd423458..f769d1dccc21 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2661,6 +2661,7 @@ struct kvm_memory_slot *kvm_vcpu_gfn_to_memslot(struct kvm_vcpu *vcpu, gfn_t gfn
>   
>   	return NULL;
>   }
> +EXPORT_SYMBOL_GPL(kvm_vcpu_gfn_to_memslot);
>   
>   bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn)
>   {


