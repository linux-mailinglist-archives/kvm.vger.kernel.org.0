Return-Path: <kvm+bounces-52172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD12DB01F1A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 16:25:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 722503A4054
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 14:25:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3E52E763A;
	Fri, 11 Jul 2025 14:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="edeIEV48"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7D42E7173;
	Fri, 11 Jul 2025 14:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752243917; cv=none; b=IkMIfOuwQS2tlWi/SwwW/gVTfxD3+3F99ATU5j57U71TjS4VPoqWzRargYDyWTcm4ZXKRe+QWn1sJwuvmWLuIEteNMcclzYD8KUZecHE/jclOmGE99iUU/k4TsfmyGjCcxDVurR5TE57A7n5hLYmgcfryMA54cvLSFN548DIENo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752243917; c=relaxed/simple;
	bh=mT92Yf1qT91lUyIxzQhq7R8nLdUDilbEyTBw9eze26A=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NUnUz006SYhTpNarmnCSJ5LepOMjG1mUlAogQnzPZiBONN3o7KjL8Mny3V+giDT82cPjngmm16t38GLEazYqzrorfrdHhkCtDTSUiay17B6OXJVy8ZOzdPXintyOAAKDskVmGu1Yds50SDrUKTRWlNsCHDZZ4D/WD4/fKd5Jwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=edeIEV48; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E4DC4CEED;
	Fri, 11 Jul 2025 14:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752243917;
	bh=mT92Yf1qT91lUyIxzQhq7R8nLdUDilbEyTBw9eze26A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=edeIEV488UPbnlYE7PWZZWbOmUSjBS8wRFsDqD2aTeIr9m6LdZ1lnxG0DXFJfuWbC
	 RAeA8al1VK+smMmAmWqjBJHhW2SiWIivOLgMN6pc8f+CjbIVb6pT3Vmo/86DsQ61k6
	 HhG59iKQMRWFDYchTY3Ww8GkWetdZfZl0OtMaBxLvgvaYtI+3LlXyzcVcLDsx7dQHO
	 cppRrvXep/BfaFomrHZYAeUE5EKIbZk7lkuSJ0SLUATy9GRT/uMO7nZdbbkMTgJQuI
	 YztNfC/M8HWkcoo3G/HvumY4fM/4fahY2Ian2ggRB0c/t50Ln7XVfVLqXgWvmyyzhZ
	 XvuUi2yw1HLvg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=goblin-girl.misterjones.org)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uaEgc-00Eu7B-9D;
	Fri, 11 Jul 2025 15:25:14 +0100
Date: Fri, 11 Jul 2025 15:25:13 +0100
Message-ID: <868qkuajp2.wl-maz@kernel.org>
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
Subject: Re: [PATCH v13 17/20] KVM: arm64: Enable host mapping of shared guest_memfd memory
In-Reply-To: <20250709105946.4009897-18-tabba@google.com>
References: <20250709105946.4009897-1-tabba@google.com>
	<20250709105946.4009897-18-tabba@google.com>
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
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: tabba@google.com, kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderr
 in@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, will@kernel.org, qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, ira.weiny@intel.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On Wed, 09 Jul 2025 11:59:43 +0100,
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
> * Enforce KVM_MEMSLOT_GMEM_ONLY for guest_memfd on arm64: Compile and
>   runtime checks are added to ensure that if guest_memfd is enabled on
>   arm64, KVM_GMEM_SUPPORTS_MMAP must also be enabled. This means
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
>  arch/arm64/kvm/Kconfig            | 1 +
>  arch/arm64/kvm/mmu.c              | 8 ++++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index d27079968341..bd2af5470c66 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1675,5 +1675,9 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id fgt);
>  void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, u64 *res1);
>  void check_feature_map(void);
>  
> +#ifdef CONFIG_KVM_GMEM
> +#define kvm_arch_supports_gmem(kvm) true
> +#define kvm_arch_supports_gmem_mmap(kvm) IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP)
> +#endif
>  
>  #endif /* __ARM64_KVM_HOST_H__ */
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 713248f240e0..28539479f083 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -37,6 +37,7 @@ menuconfig KVM
>  	select HAVE_KVM_VCPU_RUN_PID_CHANGE
>  	select SCHED_INFO
>  	select GUEST_PERF_EVENTS if PERF_EVENTS
> +	select KVM_GMEM_SUPPORTS_MMAP
>  	help
>  	  Support hosting virtualized guest machines.
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 71f8b53683e7..b92ce4d9b4e0 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -2274,6 +2274,14 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>  	if ((new->base_gfn + new->npages) > (kvm_phys_size(&kvm->arch.mmu) >> PAGE_SHIFT))
>  		return -EFAULT;
>  
> +	/*
> +	 * Only support guest_memfd backed memslots with mappable memory, since
> +	 * there aren't any CoCo VMs that support only private memory on arm64.
> +	 */
> +	BUILD_BUG_ON(IS_ENABLED(CONFIG_KVM_GMEM) && !IS_ENABLED(CONFIG_KVM_GMEM_SUPPORTS_MMAP));
> +	if (kvm_slot_has_gmem(new) && !kvm_memslot_is_gmem_only(new))
> +		return -EINVAL;
> +
>  	hva = new->userspace_addr;
>  	reg_end = hva + (new->npages << PAGE_SHIFT);
>  

Honestly, I don't see the point in making CONFIG_KVM_GMEM a buy in. We
have *no* configurability for KVM/arm64, the only exception being the
PMU support, and that has been a pain at every step of the way.

Either KVM is enabled, and it comes with "batteries included", or it's
not. Either way, we know exactly what we're getting, and it makes
reproducing problems much easier.

Thanks,

	M.

-- 
Without deviation from the norm, progress is not possible.

