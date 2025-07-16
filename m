Return-Path: <kvm+bounces-52570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D72BB06D5D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:41:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FA454A05CC
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 05:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CB8E2E6D2E;
	Wed, 16 Jul 2025 05:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eSaF8QKC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D728848CFC;
	Wed, 16 Jul 2025 05:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752644447; cv=none; b=gQcLI50AUTmaxVTuOV1K66yW6Pxn129sISzsB438I8dlPZAerUgnPfhdQsoVcAXKYDAcaalvaUAEePGtFB2gMRnI8bK+irwfLOcy/yYK3ewRADbKTajijnGGNUeFlKucErTa26Y7JwOqyc83c1Puacvxeppdnwmk8nGZvEvUPXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752644447; c=relaxed/simple;
	bh=6iNgYxoqxx120NDW9X1toiGHqvZp6/FTcvKcQv2ACAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eVPyg6TaLPVH5Konxq5ySj2O5Hc3p79/pChq97D9wlr1zn1cFuHQiTiiIZhOU7EQcl/XsP/pqypAVFj63nRRhFxMFU17mNFvlXcyKIQVETHvd6dsM5IKwxdxc9+EBSKPjeD/IGqOqxWRWpP/8N0ZMCOHBWuQiha3OgWsaQ50rdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eSaF8QKC; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752644444; x=1784180444;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6iNgYxoqxx120NDW9X1toiGHqvZp6/FTcvKcQv2ACAo=;
  b=eSaF8QKCczFrzEUuXk0aXXFxNfQ6LJ18+jYBHCC0Guzriy78AKPDQVcd
   F2Qx2JB35NwqlCQ4r0m44JFCURZwC3EPlaqs2z/eqpt7KWfqvcm93VkYF
   vWjt4BZL1cNCQNcNaVmPC0MGkN5z0dbTWbP/lZczpsMd5Q7zcgS3rFDWy
   2h2qHUfygnvfIX/Jj8R1k5djhVkXRvX/89l46Mxex4QNSrV5uMPxEMqyU
   4+x/M3SllrxPOZtT7FW5lhAH12KpRi88BjaeSSf+wf8Q9XkuJdM5LV9Ko
   WSS1LZqi/mWamQQHs6Ju6Q9/YQC2JarhJKoqtIT9heM4rboUrD5w+SmSl
   Q==;
X-CSE-ConnectionGUID: 1QOTKKc2Q5abNAzbGGcHPw==
X-CSE-MsgGUID: qgVCUzLdTwOmaINtOa897g==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="66325483"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="66325483"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:40:43 -0700
X-CSE-ConnectionGUID: Oos/aMvwSTGdgishWHK1Pg==
X-CSE-MsgGUID: E5t7ldu8TNOtPDSeoiR4uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="157215046"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 22:40:23 -0700
Message-ID: <e1470c54-fe2b-4fdf-9b4b-ce9ef0d04a1b@intel.com>
Date: Wed, 16 Jul 2025 13:40:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 08/21] KVM: guest_memfd: Allow host to map guest_memfd
 pages
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
 anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
 brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
 yilun.xu@intel.com, chao.p.peng@linux.intel.com, jarkko@kernel.org,
 amoorthy@google.com, dmatlack@google.com, isaku.yamahata@intel.com,
 mic@digikod.net, vbabka@suse.cz, vannapurve@google.com,
 ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com,
 michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com,
 isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com,
 suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com,
 quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com,
 quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com,
 quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com,
 james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev,
 maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com,
 roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com,
 rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com,
 jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com,
 ira.weiny@intel.com
References: <20250715093350.2584932-1-tabba@google.com>
 <20250715093350.2584932-9-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250715093350.2584932-9-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/2025 5:33 PM, Fuad Tabba wrote:
> Introduce the core infrastructure to enable host userspace to mmap()
> guest_memfd-backed memory. This is needed for several evolving KVM use
> cases:
> 
> * Non-CoCo VM backing: Allows VMMs like Firecracker to run guests
>    entirely backed by guest_memfd, even for non-CoCo VMs [1]. This
>    provides a unified memory management model and simplifies guest memory
>    handling.
> 
> * Direct map removal for enhanced security: This is an important step
>    for direct map removal of guest memory [2]. By allowing host userspace
>    to fault in guest_memfd pages directly, we can avoid maintaining host
>    kernel direct maps of guest memory. This provides additional hardening
>    against Spectre-like transient execution attacks by removing a
>    potential attack surface within the kernel.
> 
> * Future guest_memfd features: This also lays the groundwork for future
>    enhancements to guest_memfd, such as supporting huge pages and
>    enabling in-place sharing of guest memory with the host for CoCo
>    platforms that permit it [3].
> 
> Therefore, enable the basic mmap and fault handling logic within
> guest_memfd. However, this functionality is not yet exposed to userspace
> and remains inactive until two conditions are met in subsequent patches:
> 
> * Kconfig Gate (CONFIG_KVM_GMEM_SUPPORTS_MMAP): A new Kconfig option,
>    KVM_GMEM_SUPPORTS_MMAP, is introduced later in this series. 

Well, KVM_GMEM_SUPPORTS_MMAP is actually introduced by *this* patch, not 
other patches later.

> This
>    option gates the compilation and availability of this mmap
>    functionality at a system level. 

Well, at least from this patch, it doesn't gate the compilation.

> While the code changes in this patch
>    might seem small, the Kconfig option is introduced to explicitly
>    signal the intent to enable this new capability and to provide a clear
>    compile-time switch for it. It also helps ensure that the necessary
>    architecture-specific glue (like kvm_arch_supports_gmem_mmap) is
>    properly defined.
> 
> * Per-instance opt-in (GUEST_MEMFD_FLAG_MMAP): On a per-instance basis,
>    this functionality is enabled by the guest_memfd flag
>    GUEST_MEMFD_FLAG_MMAP, which will be set in the KVM_CREATE_GUEST_MEMFD
>    ioctl. This flag is crucial because when host userspace maps
>    guest_memfd pages, KVM must *not* manage the these memory regions in
>    the same way it does for traditional KVM memory slots. The presence of
>    GUEST_MEMFD_FLAG_MMAP on a guest_memfd instance allows mmap() and
>    faulting of guest_memfd memory to host userspace. Additionally, it
>    informs KVM to always consume guest faults to this memory from
>    guest_memfd, regardless of whether it is a shared or a private fault.
>    This opt-in mechanism ensures compatibility and prevents conflicts
>    with existing KVM memory management. This is a per-guest_memfd flag
>    rather than a per-memslot or per-VM capability because the ability to
>    mmap directly applies to the specific guest_memfd object, regardless
>    of how it might be used within various memory slots or VMs.
> 
> [1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
> [2] https://lore.kernel.org/linux-mm/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
> [3] https://lore.kernel.org/all/c1c9591d-218a-495c-957b-ba356c8f8e09@redhat.com/T/#u
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shivank Garg <shivankg@amd.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>   include/linux/kvm_host.h | 13 +++++++
>   include/uapi/linux/kvm.h |  1 +
>   virt/kvm/Kconfig         |  4 +++
>   virt/kvm/guest_memfd.c   | 73 ++++++++++++++++++++++++++++++++++++++++
>   4 files changed, 91 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 1ec71648824c..9ac21985f3b5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -740,6 +740,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>   }
>   #endif
>   
> +/*
> + * Returns true if this VM supports mmap() in guest_memfd.
> + *
> + * Arch code must define kvm_arch_supports_gmem_mmap if support for guest_memfd
> + * is enabled.

It describes the similar requirement as kvm_arch_has_private_mem and 
kvm_arch_supports_gmem, but it doesn't have the check of

	&& !IS_ENABLED(CONFIG_KVM_GMEM)

So it's straightforward for people to wonder why.

I would suggest just adding the check of !IS_ENABLED(CONFIG_KVM_GMEM) 
like what for kvm_arch_has_private_mem and kvm_arch_supports_gmem. So it 
will get compilation error if any ARCH enables CONFIG_KVM_GMEM without 
defining kvm_arch_supports_gmem_mmap.


> + */
> +#if !defined(kvm_arch_supports_gmem_mmap)
> +static inline bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +

