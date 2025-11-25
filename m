Return-Path: <kvm+bounces-64566-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02691C872AF
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:53:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5FC8F3B3422
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EE062E6CCC;
	Tue, 25 Nov 2025 20:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="BmwpJ2LT";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="jxhkkSny"
X-Original-To: kvm@vger.kernel.org
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A422E4266;
	Tue, 25 Nov 2025 20:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103985; cv=none; b=rHwbZsHyJRiU68TRBaUMfR5kO9GzSsx6pSxkP9HR3hTG2m0jAhuv334z5uaiIid7intqNWVpebDEqSGaqtQJiawPIMqcgyldu086Gk4Z1acdqkEEy2Px013LZoiLrw5/932m7xbOOzeXCGXz+1JvVfVnMdFv4pgSiyn0X7V4IDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103985; c=relaxed/simple;
	bh=mAEnaBp/QiF9yhx2kcAu/ucfNK/V+FsCtLv4DtJ1G/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DS/qSdI76VwBZ611ccMj0HbDM2sZ1QjrbpuypebYrMd36Hj1of+rM4MQLlbL2YzRax5DRcYc1ktBND47FgFc92+DVvYe870Wgj5/Lvhm2oR3lqazJZYA3D/1lt6DLhZnKN29MS0tSTpqdWCe93c6bNzWCnqExLx1LM2qS4HzriA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=BmwpJ2LT; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=jxhkkSny; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfout.stl.internal (Postfix) with ESMTP id D2EC01D0014A;
	Tue, 25 Nov 2025 15:53:01 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-11.internal (MEProxy); Tue, 25 Nov 2025 15:53:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764103981;
	 x=1764190381; bh=zaNzre1R539onAJiUi+ocHKnpXTu30cdWFnNlClQYWQ=; b=
	BmwpJ2LTzuTD3ddYVkfqchCYrthyxUCpbExJ0VackNZWNmpJmwC3NSXvCNNx2OsA
	FD7Avx8/Lhe4ggdZ11H0JkHNmsaZ8HS43Wd3AimaiVgtxNn9ZS2NHSyx/Q5x+EXx
	lW1GHfI/XdwEh3ntZlsB11W1ZKABIljEv4HM59GxAvQhwcFvTld+aL99wlzbGeDe
	8ewvyMrkLIqIuVasWGOILmivBPuf2jivyT2IrBN12RQ2CovkQoBHB7lgkCG0bWXQ
	jdeZrkr7vCsCKBC8+yS6RpDhrLSymC/Z1NJrqJAVQt/O0kgbOxQtq1y092vqLkU5
	s86szB4rp3JtrGH7C73UEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764103981; x=
	1764190381; bh=zaNzre1R539onAJiUi+ocHKnpXTu30cdWFnNlClQYWQ=; b=j
	xhkkSnycmzj0kOceI37OhMcvDrlbbtrTGJpsbFlJ/eVYz6fzTW7+3M2b+grdmKOg
	MFVS/wDSvKIJJkxEZiPTm82xhlb3MccSPrTiseLDjCW1GS2L5w2erc4/NJIYSkpv
	BXS9qGuy08ZlyGAIpHICe3DChVAxYjZhzWcw8RRXvan/JYlLc27DoGp+jHYAqA2o
	jTZF1rBnRCeF3RvkcsBRnVq4WCOvz9aMkiZcyKQnTYCO9ZHFW9tT8XdbcVCxD0C9
	6lCH1j+VJ90uLnXfo3XhnWRcHSv2ISOHndN668LO56T5LnqAk+reZGjJ79Qb4DLD
	gmcFaxa8Mw9Yr6v6jnKSQ==
X-ME-Sender: <xms:LRcmaUmbKuI4WMSWiopv6WIafMsJDwZXo4pXs9ZlJS8cigbZQxxOmg>
    <xme:LRcmae3Ez3r9W7_NwYJO_1h8UNeW0sthJ5R2sC_EGKg9fiFazFYyY9Mw-ixDIr6Yh
    3qWnOoCOqQnc3FkjNv0ZenF_KX6gUIQ1BwRTf1ZEzzektNsvnMboQ>
X-ME-Received: <xmr:LRcmaZQZqNQiNEaHAj_yuSunGcKEqmnMgSy3fR1YC4BabOdThMqw6GEc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgedvgeejucetufdoteggodetrf
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
X-ME-Proxy: <xmx:LRcmaePtRn6YG0qnzvwsV4SZKKVNy235qs_ySrkRArPjzusNSF7ITQ>
    <xmx:LRcmadhhIvXvox5C4OMtbYCizuMYDknNSKrI9aD4xNMcW7UMyNiYLA>
    <xmx:LRcmaeLnTR90zAViv-UdpmW3j0xxZrjmmOq7ssfI8DcxRXeRPMECaQ>
    <xmx:LRcmaY4TIzs2EvxztrGf5JLKw-0-TORrnfAZOU3975t8XCKYGmINqg>
    <xmx:LRcmaehxzCtKZkdiOQF_ACOhbEL-L3fP7hDIur7jN7vwTwaFiQKqRj7q>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Nov 2025 15:52:59 -0500 (EST)
Date: Tue, 25 Nov 2025 13:52:16 -0700
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
Subject: Re: [PATCH v6 1/6] vfio: export function to map the VMA
Message-ID: <20251125135216.5c18c311.alex@shazbot.org>
In-Reply-To: <20251125173013.39511-2-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-2-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Nov 2025 17:30:08 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> Take out the implementation to map the VMA to the PTE/PMD/PUD
> as a separate function.
> 
> Export the function to be used by nvgrace-gpu module.
> 
> cc: Shameer Kolothum <skolothumtho@nvidia.com>
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> Reviewed-by: Shameer Kolothum <skolothumtho@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 50 ++++++++++++++++++++------------
>  include/linux/vfio_pci_core.h    |  3 ++
>  2 files changed, 34 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 7dcf5439dedc..c445a53ee12e 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1640,31 +1640,21 @@ static unsigned long vma_to_pfn(struct vm_area_struct *vma)
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
> +	vm_fault_t ret;
>  
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
> +		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
>  		break;
>  #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
>  	case PMD_ORDER:
> @@ -1680,7 +1670,29 @@ static vm_fault_t vfio_pci_mmap_huge_fault(struct vm_fault *vmf,
>  		ret = VM_FAULT_FALLBACK;
>  	}
>  
> -out_unlock:
> +	return ret;
> +}

At this point we no longer need @ret, we can return directly in all
cases.

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
> +	vm_fault_t ret = VM_FAULT_SIGBUS;

The only use case of this initialization is now in the new function.

> +
> +	if (order && (addr < vma->vm_start ||
> +		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> +		      pfn & ((1 << order) - 1))) {
> +		ret = VM_FAULT_FALLBACK;
> +		goto out;
> +	}

Should we make a static inline in a vfio header for the above to avoid
the duplicate implementation in the next patch?  Also we might as well
use an else branch rather than goto with the bulk of the code moved
now.  Maybe also just convert to a scoped_guard as well.  Thanks,

Alex

> +
> +	down_read(&vdev->memory_lock);
> +	ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
>  	up_read(&vdev->memory_lock);
>  out:
>  	dev_dbg_ratelimited(&vdev->pdev->dev,
> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index f541044e42a2..6f7c6c0d4278 100644
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


