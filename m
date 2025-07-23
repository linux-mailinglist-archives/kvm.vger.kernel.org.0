Return-Path: <kvm+bounces-53252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D308B0F4DE
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:05:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 313AE1AA1B6A
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 14:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E4592F4326;
	Wed, 23 Jul 2025 14:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bBofrdTE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9C52F2C6F;
	Wed, 23 Jul 2025 14:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753279454; cv=none; b=uOb3Mj5C/I0ojsU2klAEfy4fmFdN+oww+35KbYB3wo6vzevyeERDfFN0dSpar0nuX3yPGhHOdyyZx/1qko51kRQAlT6qC3Zxwth4ymRMws0zwss80hwnjeHoV/n1Wkzx8wqQ4B7BfnlH6L2SjbVlbKPAr+F0t92uMbbGpx06VHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753279454; c=relaxed/simple;
	bh=lC7D423FBBscRuryASHtu4WfamrsmdENxp22E1bBitw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HPcxZH9Oac4As1EoG5Y5Y3iGYG8YimHOzrjbkL47a6EZ5rPX46AzCDz/rqYvN9K6ePAwSsaQv2HclVjemXMWbaUjOV4NAxhFsjBKKX6AMRxIgXYdEeYoXJKzkMxLmIELAxNiwRLjtvFY63CnT5TIt+syphSZrVaayE0o3eKo92c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bBofrdTE; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753279452; x=1784815452;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lC7D423FBBscRuryASHtu4WfamrsmdENxp22E1bBitw=;
  b=bBofrdTEAMIY7guFeKDjZLSKjB+lLza/ppMcwL/epxpAq14HSIUI0oIM
   fh0tpoJ3s5dzuFsGEXHjk6d7/yUcICdOeyHJNCqguahsAPROgO1BLI7Qn
   N+F3Cj/75cVdAHJbdQFuUA4P1dsegypIKwwJYV9AjvLcAZL155zoDT93h
   Sw8Vl+DysSAHhFXmJRxK5xjnbH3lkUj+GsbcArUjinEpOkQYPNTRfvJ5V
   WBonXaizcaFAYti/6/Kj/lm6dXl7n5QvOhDletwUwCgrxnKPI22T1NS8S
   kQxW9EV7xjxNpxufmToUded0AT2yoKp14QO6AgRZLyyvm3RgI76O5UoMj
   w==;
X-CSE-ConnectionGUID: aJclpD6KTtKMFTzAdc0pvA==
X-CSE-MsgGUID: 1pzUyU9/Qae7FjD8+Gd9xQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55505242"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55505242"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:04:11 -0700
X-CSE-ConnectionGUID: MEc0+Hk+ToyvuSHaf8ZX5A==
X-CSE-MsgGUID: agVwp6nNQBG9waDbKb6Pjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="190480304"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 07:03:57 -0700
Message-ID: <c301ec11-9d24-4cc6-9dc7-46800df4d5a8@intel.com>
Date: Wed, 23 Jul 2025 22:03:54 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 10/22] KVM: guest_memfd: Add plumbing to host to map
 guest_memfd pages
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
References: <20250723104714.1674617-1-tabba@google.com>
 <20250723104714.1674617-11-tabba@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250723104714.1674617-11-tabba@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/2025 6:47 PM, Fuad Tabba wrote:
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
> Enable the basic mmap and fault handling logic within guest_memfd, but
> hold off on allow userspace to actually do mmap() until the architecture
> support is also in place.
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

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/x86.c       | 11 +++++++
>   include/linux/kvm_host.h |  4 +++
>   virt/kvm/guest_memfd.c   | 70 ++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 85 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a1c49bc681c4..e5cd54ba1eaa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13518,6 +13518,16 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
>   }
>   EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
>   
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +/*
> + * KVM doesn't yet support mmap() on guest_memfd for VMs with private memory
> + * (the private vs. shared tracking needs to be moved into guest_memfd).
> + */
> +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +	return !kvm_arch_has_private_mem(kvm);
> +}
> +

I think it's better to move the kvm_arch_supports_gmem_mmap() stuff to 
patch 20. Because we don't know how kvm_arch_supports_gmem_mmap() is 
going to be used unitll that patch.

>   #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
>   int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
>   {
> @@ -13531,6 +13541,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
>   	kvm_x86_call(gmem_invalidate)(start, end);
>   }
>   #endif
> +#endif
>   
>   int kvm_spec_ctrl_test_value(u64 value)
>   {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 4d1c44622056..26bad600f9fa 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -726,6 +726,10 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>   }
>   #endif
>   
> +#ifdef CONFIG_KVM_GUEST_MEMFD
> +bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);
> +#endif
> +
>   #ifndef kvm_arch_has_readonly_mem
>   static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>   {
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index a99e11b8b77f..67e7cd7210ef 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,72 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>   	return gfn - slot->base_gfn + slot->gmem.pgoff;
>   }
>   
> +static bool kvm_gmem_supports_mmap(struct inode *inode)
> +{
> +	return false;
> +}
> +
> +static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >= i_size_read(inode))
> +		return VM_FAULT_SIGBUS;
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		int err = PTR_ERR(folio);
> +
> +		if (err == -EAGAIN)
> +			return VM_FAULT_RETRY;
> +
> +		return vmf_error(err);
> +	}
> +
> +	if (WARN_ON_ONCE(folio_test_large(folio))) {
> +		ret = VM_FAULT_SIGBUS;
> +		goto out_folio;
> +	}
> +
> +	if (!folio_test_uptodate(folio)) {
> +		clear_highpage(folio_page(folio, 0));
> +		kvm_gmem_mark_prepared(folio);
> +	}
> +
> +	vmf->page = folio_file_page(folio, vmf->pgoff);
> +
> +out_folio:
> +	if (ret != VM_FAULT_LOCKED) {
> +		folio_unlock(folio);
> +		folio_put(folio);
> +	}
> +
> +	return ret;
> +}
> +
> +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> +	.fault = kvm_gmem_fault_user_mapping,
> +};
> +
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	if (!kvm_gmem_supports_mmap(file_inode(file)))
> +		return -ENODEV;
> +
> +	if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> +	    (VM_SHARED | VM_MAYSHARE)) {
> +		return -EINVAL;
> +	}
> +
> +	vma->vm_ops = &kvm_gmem_vm_ops;
> +
> +	return 0;
> +}
> +
>   static struct file_operations kvm_gmem_fops = {
> +	.mmap		= kvm_gmem_mmap,
>   	.open		= generic_file_open,
>   	.release	= kvm_gmem_release,
>   	.fallocate	= kvm_gmem_fallocate,
> @@ -391,6 +456,11 @@ static const struct inode_operations kvm_gmem_iops = {
>   	.setattr	= kvm_gmem_setattr,
>   };
>   
> +bool __weak kvm_arch_supports_gmem_mmap(struct kvm *kvm)
> +{
> +	return true;
> +}
> +
>   static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>   {
>   	const char *anon_name = "[kvm-gmem]";


