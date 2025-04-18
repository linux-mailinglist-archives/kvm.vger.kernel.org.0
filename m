Return-Path: <kvm+bounces-43672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6042FA93C05
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 19:33:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB40B1B67BBE
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 17:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7FE021A459;
	Fri, 18 Apr 2025 17:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NDEoUxAU"
X-Original-To: kvm@vger.kernel.org
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF55218EA8
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744997554; cv=none; b=IQNr7Mwa4TxoHcZ8LYMykNithR5IwZh0td2FVhCu4MqWoXkX31Ee73rK+BzmJTMQtYVaQd4ITzeZpJspACCdBkCEXLLCoqFCkGUZUrPlUd+FHTaTkRNJGNXd5IxmZ8xI/n/MtuAcF/QIIi76iuwNeNRb76wGJNfVrtFQ35oSr5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744997554; c=relaxed/simple;
	bh=4LbL3yDsXjPBiLx2utEjlwFEsm3elP0XO8E8/Q+LTyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=snafqd4TfG4Ov+RSgihnYUlLLMsW4dLQ6cveNh88PUiW7Bb06z4Ta4X99ln5/OkvAW20F7EaK4fC7YBDf9rrB1io63BdtiPVW+RBRSf+iWUYwDNGbzbIWuIznjVqSTlqBKpqsimr3W0fc6ktGiBtP4IkFxpDhU+slDziwMSL/Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NDEoUxAU; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 18 Apr 2025 10:32:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744997539;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sSB6/HaNSjSfYRrCWVWg3Elkc/lNEbOs/GojnMdDT/4=;
	b=NDEoUxAUAOh9TMaNz/w8ZJr0ubWoU72AHqz/Zno4ishFwMqaICnLOM/6yq8bRl9UMGomc4
	2UXzn03AmEyQKggS/9IjUGG6jjqG+Jiid/pgc9/Z6HZYTwpAEeqUVNhvkFjDOfsrx/wyua
	vrLT3W5RzPwQ9qhP4Aea5r5Irp6uPg4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] KVM: arm64, x86: make kvm_arch_has_irq_bypass() inline
Message-ID: <aAKMk34zbvHUtDON@linux.dev>
References: <20250418171609.231588-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250418171609.231588-1-pbonzini@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Apr 18, 2025 at 01:16:09PM -0400, Paolo Bonzini wrote:
> kvm_arch_has_irq_bypass() is a small function and even though it does
> not appear in any *really* hot paths, it's also not entirely rare.
> Make it inline---it also works out nicely in preparation for using it in
> kvm-intel.ko and kvm-amd.ko, since the function is not currently exported.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

LOL, surprised this wasn't the case already.

Acked-by: Oliver Upton <oliver.upton@linux.dev>

> ---
>  arch/arm64/include/asm/kvm_host.h   | 5 +++++
>  arch/arm64/kvm/arm.c                | 5 -----
>  arch/powerpc/include/asm/kvm_host.h | 2 ++
>  arch/x86/include/asm/kvm_host.h     | 6 ++++++
>  arch/x86/kvm/x86.c                  | 5 -----
>  include/linux/kvm_host.h            | 1 -
>  6 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index e98cfe7855a6..08ba91e6fb03 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1588,4 +1588,9 @@ void kvm_set_vm_id_reg(struct kvm *kvm, u32 reg, u64 val);
>  #define kvm_has_s1poe(k)				\
>  	(kvm_has_feat((k), ID_AA64MMFR3_EL1, S1POE, IMP))
>  
> +static inline bool kvm_arch_has_irq_bypass(void)
> +{
> +	return true;
> +}
> +
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 68fec8c95fee..19ca57def629 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -2743,11 +2743,6 @@ bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
>  	return irqchip_in_kernel(kvm);
>  }
>  
> -bool kvm_arch_has_irq_bypass(void)
> -{
> -	return true;
> -}
> -
>  int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>  				      struct irq_bypass_producer *prod)
>  {
> diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
> index 2d139c807577..6f761b77b813 100644
> --- a/arch/powerpc/include/asm/kvm_host.h
> +++ b/arch/powerpc/include/asm/kvm_host.h
> @@ -907,4 +907,6 @@ static inline void kvm_arch_flush_shadow_all(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>  
> +bool kvm_arch_has_irq_bypass(void);
> +
>  #endif /* __POWERPC_KVM_HOST_H__ */
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 3bdae454a959..7bc174a1f1cb 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -35,6 +35,7 @@
>  #include <asm/mtrr.h>
>  #include <asm/msr-index.h>
>  #include <asm/asm.h>
> +#include <asm/irq_remapping.h>
>  #include <asm/kvm_page_track.h>
>  #include <asm/kvm_vcpu_regs.h>
>  #include <asm/reboot.h>
> @@ -2423,4 +2424,9 @@ int memslot_rmap_alloc(struct kvm_memory_slot *slot, unsigned long npages);
>   */
>  #define KVM_EXIT_HYPERCALL_MBZ		GENMASK_ULL(31, 1)
>  
> +static inline bool kvm_arch_has_irq_bypass(void)
> +{
> +	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
> +}
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 3712dde0bf9d..c1fdd527044c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13556,11 +13556,6 @@ bool kvm_arch_has_noncoherent_dma(struct kvm *kvm)
>  }
>  EXPORT_SYMBOL_GPL(kvm_arch_has_noncoherent_dma);
>  
> -bool kvm_arch_has_irq_bypass(void)
> -{
> -	return enable_apicv && irq_remapping_cap(IRQ_POSTING_CAP);
> -}
> -
>  int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
>  				      struct irq_bypass_producer *prod)
>  {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 291d49b9bf05..82f044e4b3f5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -2383,7 +2383,6 @@ struct kvm_vcpu *kvm_get_running_vcpu(void);
>  struct kvm_vcpu * __percpu *kvm_get_running_vcpus(void);
>  
>  #if IS_ENABLED(CONFIG_HAVE_KVM_IRQ_BYPASS)
> -bool kvm_arch_has_irq_bypass(void);
>  int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *,
>  			   struct irq_bypass_producer *);
>  void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *,
> -- 
> 2.43.5
> 
> 

