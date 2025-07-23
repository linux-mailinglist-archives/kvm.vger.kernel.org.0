Return-Path: <kvm+bounces-53191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7309FB0ED53
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 10:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 804D53BB076
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD27027FD64;
	Wed, 23 Jul 2025 08:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hXV16EC6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D251C248F4D;
	Wed, 23 Jul 2025 08:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753259636; cv=none; b=KR/cF+8U7PxwuPr0wtIDQIwvkmMzXWm5qpbakxLurqbMIqF4qD06xhKM8VMod/njD+HU7xH+4kX0eGJynpI/bBUfcKMvszORDResp2Y0H2hU3WgqjMkWEetDt/mrmvH3zV99M2RdI8izOdrxJY1jbhr+kHXyBspbNArL9d1cXG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753259636; c=relaxed/simple;
	bh=8Dj52SAogJGQh3xmjRNC4R33WTgHXzlpdB0NAScPbI4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVs7n5veqmGz1jlrd18+HsD+5VANqbOf93T4CDw7CIc+vwnhR06Jyir+9HkPlWVUUe66YvmPhUbIPgoAsnL+RT+uCz8Z0sBpJMfsikg9yqIGKlyjurQajGqDR8IuceWPjMfsI1aG3PzOyQXDLLGuljNpTV7WseXwdoVQhGYpvdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hXV16EC6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB3BC4CEE7;
	Wed, 23 Jul 2025 08:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753259636;
	bh=8Dj52SAogJGQh3xmjRNC4R33WTgHXzlpdB0NAScPbI4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hXV16EC6m4qnERBrLnOWVlGSbOmsgOxEJhqSzFXLIfpZOppkIJfcTRfnON2d3YZy3
	 8+3PLRZG+tIv+vlRbfywyYBpOLG5PdqpqL+69smnb1t4lv563WrWTy4kdvNCgXAeZa
	 v/NhagD8XtwD0y8cCcF/esFWJvhJu/S04B18Sg69Wm4CFjiVo4IxM6mlDUSAVOZEqn
	 Ii/1iRjp6pNlXVdNQdp+qszobiL9UP4iaZdDML+RP2i+H9mFRypJXA+3ljDx+XwUyh
	 1s3bitqk69soQA1Tc/uJSK8LDhZSG1115YchQ+BW68eQ4SYZxIGjr5Xrc1nf30Ah10
	 EWhXZmS/QYvZg==
Received: from 82-132-236-66.dab.02.net ([82.132.236.66] helo=lobster-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ueUvB-000bwg-Jh;
	Wed, 23 Jul 2025 09:33:54 +0100
Date: Wed, 23 Jul 2025 09:33:44 +0100
Message-ID: <87ldoftifr.wl-maz@kernel.org>
From: Marc Zyngier <maz@kernel.org>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-mm@kvack.org,
	kvmarm@lists.linux.dev,
	pbonzini@redhat.com,
	chenhuacai@kernel.org,
	mpe@ellerman.id.au,
	anup@brainfault.org,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	seanjc@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	xiaoyao.li@intel.com,
	yilun.xu@intel.com,
	chao.p.peng@linux.intel.com,
	jarkko@kernel.org,
	amoorthy@google.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	mic@digikod.net,
	vbabka@suse.cz,
	vannapurve@google.com,
	ackerleytng@google.com,
	mail@maciej.szmigiero.name,
	david@redhat.com,
	michael.roth@amd.com,
	wei.w.wang@intel.com,
	liam.merwick@oracle.com,
	isaku.yamahata@gmail.com,
	kirill.shutemov@linux.intel.com,
	suzuki.poulose@arm.com,
	steven.price@arm.com,
	quic_eberman@quicinc.com,
	quic_mnalajal@quicinc.com,
	quic_tsoni@quicinc.com,
	quic_svaddagi@quicinc.com,
	quic_cvanscha@quicinc.com,
	quic_pderrin@quicinc.com,
	quic_pheragu@quicinc.com,
	catalin.marinas@arm.com,
	james.morse@arm.com,
	yuzenghui@huawei.com,
	oliver.upton@linux.dev,
	will@kernel.org,
	qperret@google.com,
	keirf@google.com,
	roypat@amazon.co.uk,
	shuah@kernel.org,
	hch@infradead.org,
	jgg@nvidia.com,
	rientjes@google.com,
	jhubbard@nvidia.com,
	fvdl@google.com,
	hughd@google.com,
	jthoughton@google.com,
	peterx@redhat.com,
	pankaj.gupta@amd.com,
	ira.weiny@intel.com
Subject: Re: [PATCH v15 18/21] KVM: arm64: Enable host mapping of shared guest_memfd memory
In-Reply-To: <20250717162731.446579-19-tabba@google.com>
References: <20250717162731.446579-1-tabba@google.com>
	<20250717162731.446579-19-tabba@google.com>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) SEMI-EPG/1.14.7 (Harue)
 FLIM-LB/1.14.9 (=?UTF-8?B?R29qxY0=?=) APEL-LB/10.8 EasyPG/1.0.0 Emacs/30.1
 (aarch64-unknown-linux-gnu) MULE/6.0 (HANACHIRUSATO)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-SA-Exim-Connect-IP: 82.132.236.66
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Thu, 17 Jul 2025 17:27:28 +0100,
Fuad Tabba <tabba@google.com> wrote:
> 
> Enable host userspace mmap support for guest_memfd-backed memory on
> arm64. This change provides arm64 with the capability to map guest
> memory at the host directly from guest_memfd:
> 
> * Define kvm_arch_supports_gmem_mmap() for arm64: The
>   kvm_arch_supports_gmem_mmap() macro is defined for arm64 to be true if
>   CONFIG_KVM_GMEM_SUPPORTS_MMAP is enabled. For existing arm64 KVM VM
>   types that support guest_memfd, this enables them to use guest_memfd
>   with host userspace mappings. This provides a consistent behavior as
>   there are currently no arm64 CoCo VMs that rely on guest_memfd solely
>   for private, non-mappable memory. Future arm64 VM types can override
>   or restrict this behavior via the kvm_arch_supports_gmem_mmap() hook
>   if needed.
> 
> * Select CONFIG_KVM_GMEM_SUPPORTS_MMAP in arm64 Kconfig.
> 
> * Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Checks are
>   added to ensure that if guest_memfd is enabled on arm64,
>   KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
>   guest_memfd-backed memory slots on arm64 are currently only supported
>   if they are intended for shared memory use cases (i.e.,
>   kvm_memslot_is_gmem_only() is true). This design reflects the current
>   arm64 KVM ecosystem where guest_memfd is primarily being introduced
>   for VMs that support shared memory.
> 
> Reviewed-by: James Houghton <jthoughton@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 4 ++++
>  arch/arm64/kvm/Kconfig            | 2 ++
>  arch/arm64/kvm/mmu.c              | 7 +++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3e41a880b062..63f7827cfa1b 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1674,5 +1674,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
>  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
>  void check_feature_map(void);
>  
> +#ifdef CONFIG_KVM_GMEM
> +#define kvm_arch_supports_gmem(kvm) true
> +#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
> +#endif

nit: these two lines should be trivially 'true', and the #ifdef-ery
removed, since both KVM_GMEM and KVM_GMEM_SUPPORTS_MMAP are always
selected, no ifs, no buts.

>  
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 713248f240e0..323b46b7c82f 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,8 @@ menuconfig KVM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
> +	select KVM_GMEM
> +	select KVM_GMEM_SUPPORTS_MMAP
>  	help
>  	  Support hosting virtualized guest machines.
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8c82df80a835..85559b8a0845 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2276,6 +2276,13 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
>  		return -EFAULT;
>  
> +	/*
> +	 * Only support guest_memfd backed memslots with mappable memory, since
> +	 * there aren't any CoCo VMs that support only private memory on arm64.
> +	 */
> +	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> +		return -EINVAL;
> +
>  	hva = new->userspace_addr;
>  	reg_end = hva + (new->npages << PAGE_SHIFT);
>  

Otherwise,

Reviewed-by: Marc Zyngier <maz@kernel.org>

	M.

-- 
Jazz isn't dead. It just smells funny.

