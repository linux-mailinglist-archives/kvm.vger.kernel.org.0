Return-Path: <kvm+bounces-39995-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF9EA4D75D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 10:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE99B1730F9
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 09:05:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0951620296E;
	Tue,  4 Mar 2025 08:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YbmHcSoK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C79201276;
	Tue,  4 Mar 2025 08:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741078703; cv=none; b=HRGFq4uw4F2vmmjPbjF8MdDwmWofn1hQjFtYtpylAccu0xAVaMbo+fjHwXklcjg4TvkYtF2OiUuOCQHreEGz1+55Wks17YuqV/cHTzrovQoC7snoXY80RnR0FU+rPNjjYiLhKAdY0Avbga1FM7ZMbtbuOxl3yU9kZxBMDSaFQ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741078703; c=relaxed/simple;
	bh=+Rvj17kOTh2FpRb4oCsHlapbTzPh8IIrAuc3/0o8fKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmUOgAojSzGMGTDEQ1263y+dLYmcPrlBkBBx8SHpzBjFNVetVMic/BygjJpRFGXm30g3hJaU7GP1AHTSHjwLx3o+5dJnM5/8kC7wirwE8o4sCALd9ApMPl1GF9UolIm1u4Tb9NIXF16C088V5DZjVHWs95WD2tuAvXY1jkL6I0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YbmHcSoK; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741078702; x=1772614702;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Rvj17kOTh2FpRb4oCsHlapbTzPh8IIrAuc3/0o8fKg=;
  b=YbmHcSoKdp/rfH0WAIL0Labdkka7KDr/lOcQKE8oW9UOcuILaLbGmTmL
   d7aysFmDKqy0O7g6oneotzKGQe/CwbD+4tF261YnU2a383SsyJCiPbgAb
   GcB/mGINN7n/DLu0NZ5XFQLp5pQIkMU7ldYP15P2rA7saO0knDbLTQZxl
   N9tBObHUcWjGuvsQQdVVY8dCAHViV/jmcDVFZxOKvjb73nisD9u+3RSOq
   ywdvL1vyyuV1Moa5gFiL9VBYd/CKkrOHayp4XOp0OgZ3C0sDqZi1rV+48
   9x99dC8mqvyY3w8OixfjEN+96YzvDshew3cLA24vyiWPbiGsqlAohJhGz
   w==;
X-CSE-ConnectionGUID: YyGqKRGSQt+gmwJWGyoWig==
X-CSE-MsgGUID: IIEk1DKrSXuIGY9fdJ4LYg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="64431869"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="64431869"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2025 00:58:21 -0800
X-CSE-ConnectionGUID: 1J0hsscSTSeWEYVfBaqiXA==
X-CSE-MsgGUID: UBDgDT8dQcCDM7nFzpESSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118323372"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa006.jf.intel.com with ESMTP; 04 Mar 2025 00:58:18 -0800
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id C5A6518F; Tue, 04 Mar 2025 10:58:16 +0200 (EET)
Date: Tue, 4 Mar 2025 10:58:16 +0200
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org, 
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu, seanjc@google.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, willy@infradead.org, 
	akpm@linux-foundation.org, xiaoyao.li@intel.com, yilun.xu@intel.com, 
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, vannapurve@google.com, 
	ackerleytng@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, 
	quic_pheragu@quicinc.com, catalin.marinas@arm.com, james.morse@arm.com, 
	yuzenghui@huawei.com, oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, 
	qperret@google.com, keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, 
	hch@infradead.org, jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, 
	fvdl@google.com, hughd@google.com, jthoughton@google.com, peterx@redhat.com
Subject: Re: [PATCH v5 3/9] KVM: guest_memfd: Allow host to map guest_memfd()
 pages
Message-ID: <dedrbmbqyvmsjywilcjvu4lt5a3vess3l4p6ygum62gfpmnyce@cgtpjwf4krfw>
References: <20250303171013.3548775-1-tabba@google.com>
 <20250303171013.3548775-4-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303171013.3548775-4-tabba@google.com>

On Mon, Mar 03, 2025 at 05:10:07PM +0000, Fuad Tabba wrote:
> Add support for mmap() and fault() for guest_memfd backed memory
> in the host for VMs that support in-place conversion between
> shared and private. To that end, this patch adds the ability to
> check whether the VM type supports in-place conversion, and only
> allows mapping its memory if that's the case.
> 
> Also add the KVM capability KVM_CAP_GMEM_SHARED_MEM, which
> indicates that the VM supports shared memory in guest_memfd, or
> that the host can create VMs that support shared memory.
> Supporting shared memory implies that memory can be mapped when
> shared with the host.
> 
> This is controlled by the KVM_GMEM_SHARED_MEM configuration
> option.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  include/linux/kvm_host.h |  11 ++++
>  include/uapi/linux/kvm.h |   1 +
>  virt/kvm/guest_memfd.c   | 105 +++++++++++++++++++++++++++++++++++++++
>  virt/kvm/kvm_main.c      |   4 ++
>  4 files changed, 121 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7788e3625f6d..2d025b8ee20e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -728,6 +728,17 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
>  }
>  #endif
>  
> +/*
> + * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
> + * private memory is enabled and it supports in-place shared/private conversion.
> + */
> +#if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)

Hm. Do we expect any caller for !CONFIG_KVM_PRIVATE_MEM?

> +static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
> +{
> +	return false;
> +}
> +#endif
> +
>  #ifndef kvm_arch_has_readonly_mem
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
>  {

... 

> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index b2aa6bf24d3a..4291956b51ae 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -312,7 +312,112 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
>  	return gfn - slot->base_gfn + slot->gmem.pgoff;
>  }
>  
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> +static bool kvm_gmem_offset_is_shared(struct file *file, pgoff_t index)
> +{
> +	struct kvm_gmem *gmem = file->private_data;
> +
> +	/* For now, VMs that support shared memory share all their memory. */
> +	return kvm_arch_gmem_supports_shared_mem(gmem->kvm);
> +}
> +
> +static vm_fault_t kvm_gmem_fault(struct vm_fault *vmf)
> +{
> +	struct inode *inode = file_inode(vmf->vma->vm_file);
> +	struct folio *folio;
> +	vm_fault_t ret = VM_FAULT_LOCKED;
> +
> +	filemap_invalidate_lock_shared(inode->i_mapping);
> +
> +	folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> +	if (IS_ERR(folio)) {
> +		switch (PTR_ERR(folio)) {
> +		case -EAGAIN:
> +			ret = VM_FAULT_RETRY;
> +			break;
> +		case -ENOMEM:
> +			ret = VM_FAULT_OOM;
> +			break;
> +		default:
> +			ret = VM_FAULT_SIGBUS;
> +			break;
> +		}
> +		goto out_filemap;
> +	}
> +
> +	if (folio_test_hwpoison(folio)) {
> +		ret = VM_FAULT_HWPOISON;
> +		goto out_folio;
> +	}
> +
> +	/* Must be called with folio lock held, i.e., after kvm_gmem_get_folio() */

If this is a requirement, it would be cleaner to rename the function and
pass down the folio and check the lock state inside.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

