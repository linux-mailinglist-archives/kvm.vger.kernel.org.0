Return-Path: <kvm+bounces-64675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 155D5C8A9E3
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:25:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDF113AE2DD
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 428FA333728;
	Wed, 26 Nov 2025 15:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="k3P6E3qW";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MwcixTV8"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28DD332EAD;
	Wed, 26 Nov 2025 15:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170658; cv=none; b=PRIRBijrLufqH6mrr5AAJfjW73NItKVZwzpC8fEvzjt1z1w7mJdA3KNsaR93Ma/b2yDsyd3jit/Frj9ldICtWwotocz0eL0hvBHFB/lDzkU/Irv8tG1rbBtgVKStBUsixKpwakmnZ1kTRMvpskbfhEFL8QMlncnjwjwOYm0P+NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170658; c=relaxed/simple;
	bh=AzhzpAIugeRffXjXI7tbB1YjBWe+OkWiUb9Mm5gxeVw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gwGuXWPxGHlYChNmqYB1ril07otzliUvQKW2k658V0ejt/f/di15f0leRDg2Q9hR32NfWCoBcekC2x/RjKwCYvFXPubmi/bKfEvbsj+6LbJpEIDWWUM9PTeK0UNuOF3ubJ1V4s8VovJDlOmaU3RGj303e4kfjuDJEG9mpfy3bIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=k3P6E3qW; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MwcixTV8; arc=none smtp.client-ip=103.168.172.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id E1D53EC01E5;
	Wed, 26 Nov 2025 10:24:14 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 26 Nov 2025 10:24:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764170654;
	 x=1764257054; bh=Xmwqn12bY3OMRLTnJpQ3xcxGDFxiCK7G7qPUg2ggkNQ=; b=
	k3P6E3qWxE6Eu+Y0vJAZEwZw7sdvQ6azRj7QtC+CbD0OMd79vihW/23vVrIBKPxS
	TuHi+gtuPIQZlVTWllB7chzsstqgHtqXTIBY3VHkN714Uamzuy03bCWGqMRHPSX7
	wX3czTsQjlOG+yd3XKC7UuRCpc3nqwh+o3EQOH08er7e3tVNfa1KtRIYnFRyeuFs
	gPZhgjNuMjPmIVb+O/+QSGKZtX3knxW3Qm98HJhRkSxA/KqZTwhhvI0CdM04wog9
	NQPDfnLuUCvacskU15nIvqZ0erwLmJ6IWn66V6MceJqmWf+2pWEnq2DupnsA3+7T
	8dwh8iBbUNY1dLbzig+4Vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764170654; x=
	1764257054; bh=Xmwqn12bY3OMRLTnJpQ3xcxGDFxiCK7G7qPUg2ggkNQ=; b=M
	wcixTV86GybKiVSX1oJ/88GZ9ed0FJfvvIvegOPbTZh490xEfVUnYJopJ5aSPr06
	E8zELhekUPtVNrOmD3hD7i4+EUn/D2yEAHRxEG0nHNZvg3q2PI/nWJTRBbYEE8MI
	Ny4sHIMdawGt6thTmKvuh0LIKGulSzjRXAN3H0y4nNo1b4Q7TQ8z5BMDDER88q+2
	gwqPX5tQX1k41wq8f9sIOU358hs/EXATGCBxj8x3IT44eROl/JkLq8mAot60ON5x
	+OW7IZ/Z9+6H6YgP75890lcynV+1v1Y4VnIH0AAg5LnbJxd+6Hy44CUFcXntu3Hn
	fld2EFDWzZFC25LA0LMeA==
X-ME-Sender: <xms:nhsnaSnXjwSGVm9gY9d9L2zTsxhgXsni8utzVqLzybMmeQyjyqM-vg>
    <xme:nhsnaU2DNYaH7zl7isRDKSA2MIbwvYFQbpWn4uisaroo9CdfgMTeSBpx8RtnWaQYO
    oq1gSHn_fTfbJK1G6-APYGlwyP7Zb9UUm_2aB8Z8v7DnxnyJzRxeg>
X-ME-Received: <xmr:nhsnaXRohNh0v5mKfcjJTr8V98ce-RkRsBE2DNEF2u9njNS8pezXGpxU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegjedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeetteduleegkeeigedugeeluedvff
    egheeliedvtdefkedtkeekheffhedutefhhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspg
    hrtghpthhtohepvdehpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrnhhkihht
    rgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepjhhgghesiihivghpvgdrtggrpdhrtg
    hpthhtohephihishhhrghihhesnhhvihguihgrrdgtohhmpdhrtghpthhtohepshhkohhl
    ohhthhhumhhthhhosehnvhhiughirgdrtghomhdprhgtphhtthhopehkvghvihhnrdhtih
    grnhesihhnthgvlhdrtghomhdprhgtphhtthhopegrnhhikhgvthgrsehnvhhiughirgdr
    tghomhdprhgtphhtthhopehvshgvthhhihesnhhvihguihgrrdgtohhmpdhrtghpthhtoh
    epmhhotghhshesnhhvihguihgrrdgtohhmpdhrtghpthhtohephihunhigihgrnhhgrdhl
    ihesrghmugdrtghomh
X-ME-Proxy: <xmx:nhsnaUPDcQjWsh06dz-0lNxb9EJCzKcgc51W_p5dS9h8S7ug9uwghA>
    <xmx:nhsnabh7kznK6soCE5YFauXZHQBZmCFyORKx9OxUF50wEedYAFOBeA>
    <xmx:nhsnaUIsNfstWNYnks7j2TungUJBPQ1SHA9AincSZQETughUoIvUXQ>
    <xmx:nhsnaW5wiex6vgqYkeu_0c-Xqz2mj4OXcbX_80BZVNpWWc0RIfiMmw>
    <xmx:nhsnaUhOtKWQNQL0PdDuSGj94QCerUMJ9h2JjJ0iwO0mRlIXpMJxG9EY>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 10:24:12 -0500 (EST)
Date: Wed, 26 Nov 2025 08:22:35 -0700
From: Alex Williamson <alex@shazbot.org>
To: <ankita@nvidia.com>
Cc: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <skolothumtho@nvidia.com>,
 <kevin.tian@intel.com>, <aniketa@nvidia.com>, <vsethi@nvidia.com>,
 <mochs@nvidia.com>, <Yunxiang.Li@amd.com>, <yi.l.liu@intel.com>,
 <zhangdongdong@eswincomputing.com>, <avihaih@nvidia.com>,
 <bhelgaas@google.com>, <peterx@redhat.com>, <pstanner@redhat.com>,
 <apopple@nvidia.com>, <kvm@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
 <targupta@nvidia.com>, <zhiw@nvidia.com>, <danw@nvidia.com>,
 <dnigam@nvidia.com>, <kjaju@nvidia.com>
Subject: Re: [PATCH v7 1/6] vfio: refactor vfio_pci_mmap_huge_fault function
Message-ID: <20251126082235.49edd6d7.alex@shazbot.org>
In-Reply-To: <20251126052627.43335-2-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
	<20251126052627.43335-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Nov 2025 05:26:22 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Refactor vfio_pci_mmap_huge_fault to take out the implementation
> to map the VMA to the PTE/PMD/PUD as a separate function.
> 
> Export the new function to be used by nvgrace-gpu module.
> 
> No functional change is intended.
> 
> Cc: Shameer Kolothum <skolothumtho@nvidia.com>
> Cc: Alex Williamson <alex@shazbot.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 54 +++++++++++++++++---------------
>  include/linux/vfio_pci_core.h    | 16 ++++++++++
>  2 files changed, 45 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7dcf5439dedc..52e3a10d776b 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1640,48 +1640,52 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
>  	return (pci_resource_start(vdev->pdev, index) >> PAGE_SHIFT) + pgoff;
>  }
>  
> -static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
> -					   unsigned int order)
> +vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
> +				   struct vm_fault *vmf,
> +				   unsigned long pfn,
> +				   unsigned int order)
>  {
> -	struct vm_area_struct *vma = vmf->vma;
> -	struct vfio_pci_core_device *vdev = vma->vm_private_data;
> -	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
> -	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
> -	unsigned long pfn = vma_to_pfn(vma) + pgoff;
> -	vm_fault_t ret = VM_FAULT_SIGBUS;
> -
> -	if (order && (addr < vma->vm_start ||
> -		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> -		      pfn & ((1 << order) - 1))) {
> -		ret = VM_FAULT_FALLBACK;
> -		goto out;
> -	}
> -
> -	down_read(&vdev->memory_lock);
> +	lockdep_assert_held_read(&vdev->memory_lock);
>  
>  	if (vdev->pm_runtime_engaged || !__vfio_pci_memory_enabled(vdev))
> -		goto out_unlock;
> +		return VM_FAULT_SIGBUS;
>  
>  	switch (order) {
>  	case 0:
> -		ret = vmf_insert_pfn(vma, vmf->address, pfn);
> -		break;
> +		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	case PMD_ORDER:
> -		ret = vmf_insert_pfn_pmd(vmf, pfn, false);
> -		break;
> +		return vmf_insert_pfn_pmd(vmf, pfn, false);
>  #endif
>  #ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
>  	case PUD_ORDER:
> -		ret = vmf_insert_pfn_pud(vmf, pfn, false);
> +		return vmf_insert_pfn_pud(vmf, pfn, false);
>  		break;
>  #endif
>  	default:
> +		return VM_FAULT_FALLBACK;
> +	}
> +}
> +EXPORT_SYMBOL_GPL(vfio_pci_vmf_insert_pfn);
> +
> +static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
> +					   unsigned int order)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct vfio_pci_core_device *vdev = vma->vm_private_data;
> +	unsigned long addr = vmf->address & ~((PAGE_SIZE << order) - 1);
> +	unsigned long pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
> +	unsigned long pfn = vma_to_pfn(vma) + pgoff;
> +	vm_fault_t ret;
> +
> +	if (unmappable_for_order(vma, addr, pfn, order)) {
>  		ret = VM_FAULT_FALLBACK;
> +		goto out;
>  	}
>  
> -out_unlock:
> -	up_read(&vdev->memory_lock);
> +	scoped_guard(rwsem_read, &vdev->memory_lock)
> +		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
> +
>  out:

We really don't need a goto to jump over this tiny section of code.
With the naming/polarity change below this can just be:

	vm_fault_t ret = VM_FAULT_FALLBACK;

	if (is_aligned_for_order(vma, addr, pfn, order)) {
		scoped_guard(rwsem_read, &vdev->memory_lock)
			ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
	}


>  	dev_dbg_ratelimited(&vdev->pdev->dev,
>  			   "%s(,order = %d) BAR %ld page offset 0x%lx: 0x%x\n",
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index f541044e42a2..1d457216ce4d 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -119,6 +119,9 @@ ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
>  		size_t count, loff_t *ppos);
>  ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
>  		size_t count, loff_t *ppos);
> +vm_fault_t vfio_pci_vmf_insert_pfn(struct vfio_pci_core_device *vdev,
> +				   struct vm_fault *vmf, unsigned long pfn,
> +				   unsigned int order);
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
>  void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
>  int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
> @@ -161,4 +164,17 @@ VFIO_IOREAD_DECLARATION(32)
>  VFIO_IOREAD_DECLARATION(64)
>  #endif
>  
> +static inline bool unmappable_for_order(struct vm_area_struct *vma,
> +					unsigned long addr,
> +					unsigned long pfn,
> +					unsigned int order)
> +{
> +	if (order && (addr < vma->vm_start ||
> +		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> +		      !IS_ALIGNED(pfn, 1 << order)))
> +		return true;
> +
> +	return false;
> +}


Change polarity and rename to is_aligned_for_order()?  No need for
branched return.

	return !(order && (addr < vma->vm_start ||
			   addr + (PAGE_SIZE << order) > vma->vm_end ||
			   !IS_ALIGNED(pfn, 1 << order)));

Describe this change in the commit log.  Thanks,

Alex

