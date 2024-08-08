Return-Path: <kvm+bounces-23603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B63C194B80B
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 09:41:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CF2C286097
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 07:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3C5D188CD1;
	Thu,  8 Aug 2024 07:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V63Vty4h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F60512E1C7;
	Thu,  8 Aug 2024 07:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723102887; cv=none; b=s2kvMFf45ZNtvKt3BYOlwhDukwIqCx4kYH9EiYKYKIm20DKk5ZFqqW5lHvmfyWORiyRvcDH47APCeIRyCRwlC1JOAuWJFIHLXPjbwv1A4iNihIMCYtGCfUR3Pq3+TwAe992LDmPcYxNTswPzgP3zu1ESpxKr9FDCg+yyqQwSPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723102887; c=relaxed/simple;
	bh=lajLtdSPaYb3RZF6tZ1cHdAvL4k1IFEHMhUa4dUnK/o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gog+LbJR1rBW1ubw0GYBpoiRrODKI8vGEJcOYGhKrwVclL1aYQfBoYLN+ebNWh3UdXixzZFYRLSTMU2M9oaLgEOKy+Pt/DmyI/YB7slA+VhJ5zk3jWeCR2Yl7kD0cZxsXJMfnNSk2xvGGLUeSO1aQHfxz0CnunI/nYxQAZB5uFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V63Vty4h; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723102886; x=1754638886;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lajLtdSPaYb3RZF6tZ1cHdAvL4k1IFEHMhUa4dUnK/o=;
  b=V63Vty4hwd34DI5mEOqcgBepWOHcDxMN3gz91OP783AeEqqb+XMjhMbv
   Y0I99bTgrMQ1dYW9CNVV2NJAvVdtMLLDuZyxxrdwtEZUpWxSR5CQK+Tuf
   lbpTdZYlT6tagUf2/IEEYK1MHE4hUy/s6ckSEATQGEV0AQPxcUqBk2eiO
   X5XRnd4JGavUEtC1xWJPV9+JQrqyz5G2MeIojNoS6uMTxhJxmSSC6irV8
   Xgn/ilfDZS43VnJls31xAD1TMZ9k2gdZGd04ul//LCvhaqPHCqpQI25kx
   tnbWb8Hu5u8VCBf3OkMSUfgv6ZoMmYq3BZt6WFf11DrWKhtFXvhhVxz4y
   w==;
X-CSE-ConnectionGUID: 0w8VEGc1TGOazHtr0bM1Zw==
X-CSE-MsgGUID: Vhgi9eeAT5WekRfeFYuH+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="21380452"
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="21380452"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 00:41:25 -0700
X-CSE-ConnectionGUID: NiEX1bqeSsKhqlfYvJwbgQ==
X-CSE-MsgGUID: 0grGwWvHSaeSoFbut2ZJ/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,272,1716274800"; 
   d="scan'208";a="88043110"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.228.22]) ([10.124.228.22])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2024 00:41:24 -0700
Message-ID: <0a8fea1b-955e-4a34-91ac-79870c3989d8@intel.com>
Date: Thu, 8 Aug 2024 15:41:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] KVM: Move flags check for user memory regions to the
 ioctl() specific API
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240802205003.353672-1-seanjc@google.com>
 <20240802205003.353672-7-seanjc@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240802205003.353672-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/3/2024 4:50 AM, Sean Christopherson wrote:
> Move the check on memory region flags to kvm_vm_ioctl_set_memory_region()
> now that the internal API, kvm_set_internal_memslot(), disallows any and
> all flags.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   virt/kvm/kvm_main.c | 54 ++++++++++++++++++---------------------------
>   1 file changed, 22 insertions(+), 32 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 84fcb20e3e1c..09cc261b080a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1566,34 +1566,6 @@ static void kvm_replace_memslot(struct kvm *kvm,
>   #define KVM_SET_USER_MEMORY_REGION_V1_FLAGS \
>   	(KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY)
>   
> -static int check_memory_region_flags(struct kvm *kvm,
> -				     const struct kvm_userspace_memory_region2 *mem)
> -{
> -	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> -
> -	if (kvm_arch_has_private_mem(kvm))
> -		valid_flags |= KVM_MEM_GUEST_MEMFD;
> -
> -	/* Dirty logging private memory is not currently supported. */
> -	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> -		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> -
> -#ifdef CONFIG_HAVE_KVM_READONLY_MEM
> -	/*
> -	 * GUEST_MEMFD is incompatible with read-only memslots, as writes to
> -	 * read-only memslots have emulated MMIO, not page fault, semantics,
> -	 * and KVM doesn't allow emulated MMIO for private memory.
> -	 */
> -	if (!(mem->flags & KVM_MEM_GUEST_MEMFD))
> -		valid_flags |= KVM_MEM_READONLY;
> -#endif
> -
> -	if (mem->flags & ~valid_flags)
> -		return -EINVAL;
> -
> -	return 0;
> -}

I would vote for keeping it instead of open coding it.

> -
>   static void kvm_swap_active_memslots(struct kvm *kvm, int as_id)
>   {
>   	struct kvm_memslots *slots = kvm_get_inactive_memslots(kvm, as_id);
> @@ -1986,10 +1958,6 @@ static int kvm_set_memory_region(struct kvm *kvm,
>   
>   	lockdep_assert_held(&kvm->slots_lock);
>   
> -	r = check_memory_region_flags(kvm, mem);
> -	if (r)
> -		return r;
> -
>   	as_id = mem->slot >> 16;
>   	id = (u16)mem->slot;
>   
> @@ -2114,6 +2082,28 @@ EXPORT_SYMBOL_GPL(kvm_set_internal_memslot);
>   static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
>   					  struct kvm_userspace_memory_region2 *mem)
>   {
> +	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
> +
> +	if (kvm_arch_has_private_mem(kvm))
> +		valid_flags |= KVM_MEM_GUEST_MEMFD;
> +
> +	/* Dirty logging private memory is not currently supported. */
> +	if (mem->flags & KVM_MEM_GUEST_MEMFD)
> +		valid_flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
> +
> +#ifdef CONFIG_HAVE_KVM_READONLY_MEM
> +	/*
> +	 * GUEST_MEMFD is incompatible with read-only memslots, as writes to
> +	 * read-only memslots have emulated MMIO, not page fault, semantics,
> +	 * and KVM doesn't allow emulated MMIO for private memory.
> +	 */
> +	if (!(mem->flags & KVM_MEM_GUEST_MEMFD))
> +		valid_flags |= KVM_MEM_READONLY;
> +#endif
> +
> +	if (mem->flags & ~valid_flags)
> +		return -EINVAL;
> +
>   	if ((u16)mem->slot >= KVM_USER_MEM_SLOTS)
>   		return -EINVAL;
>   


