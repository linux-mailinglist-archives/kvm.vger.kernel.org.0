Return-Path: <kvm+bounces-64564-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C0BFC872A3
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 21:53:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2ECE24E2C29
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 20:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895CE2E22A3;
	Tue, 25 Nov 2025 20:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="GsFLdyR0";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JclA67F1"
X-Original-To: kvm@vger.kernel.org
Received: from flow-b3-smtp.messagingengine.com (flow-b3-smtp.messagingengine.com [202.12.124.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517E82629D;
	Tue, 25 Nov 2025 20:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764103980; cv=none; b=Osajm5yB48ObPqqU0bHw0U5FAPxD5D/mnDLvH+l/xLNHCTwzqyDtuYtEnNdbHmoD1R3plOuVTipvxcz6RmpquyMeNoIdxAbkp9bu5xY2sCJ74+mggtIegfqBTwt48cjx830aqwwiJCkhV+JsByg4YF7tYaaRTzxTTIqzfKdQOcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764103980; c=relaxed/simple;
	bh=8IKE6SSTxQqpU9qQGqOjLnXK9tbkj55XV2dPDdpB35k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=onhpVZqJpOP1AuKu4LTa1fk8CuQaFUbZ9wC2Lx1IiTMznyXuV4PMoEsIPVfOffpgMpMcaXJ9stdk+fDIA0+3/7B5lclAizlkGZGooPSSaXRQNb2BczXubsYxDlILKWQDEX+VFAfd81t4fPooYOzqCpW9llfSXpD/pl4eqoGAY/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=GsFLdyR0; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JclA67F1; arc=none smtp.client-ip=202.12.124.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.stl.internal (Postfix) with ESMTP id B5FFC13000E7;
	Tue, 25 Nov 2025 15:52:55 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 25 Nov 2025 15:52:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764103975;
	 x=1764111175; bh=GbjNBYV6afh08yAggHVzX0VbMxJYkjGe1dH//Duydtc=; b=
	GsFLdyR0QQnfjXuTkn9yq9MQCHTM9LvL0Gi1vDpRxbmzclcujpjHaYnFlLt72/Xc
	uHo63r2pDjpfzP880TI6mOC2Kf5Sza2NPZFN7hv4FjoCzVZt0LDmC0y2muTJcos2
	FIclg/2hnwPxgL7AG4MgFU67UnhslmKC3CTXpG7gdAQm0Ox+5jIPabNTUz6pAahQ
	ZU1Ap1T8aKTi9w8BiH5ltkAXECevPHEW0pj7SWNFubpEMiryfF5V0A1YMVcQ920v
	tc30jrTWuRsRPeSHgOcHB9X5+mbH7WALwwl3OTl/VEIeoNLj31nPxMS+SxrZ5yiK
	3tQkCkqapTqFqRWqsqSsZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764103975; x=
	1764111175; bh=GbjNBYV6afh08yAggHVzX0VbMxJYkjGe1dH//Duydtc=; b=J
	clA67F1m+oeZIKx+pom4dIDw77+ND0fEUimtBp5zRQEis/+1DyCUj5BiZ/cTburm
	mtt7y1Q9fyS/vvAn3r7AqbtK9Wjh3ciZCdky1sPHr4rGJm4GPFLbdgJHfCyy28xw
	KDhArDr7HS85aRNnwcN6sfb4nL2NnuMBv6z5vhzuFZ2X1/dt8ZqJ/HhEO4/RINcz
	7JloIPNvmy8l3NleI71FKLksHBhx0Ew5yEOM4tr1PqZaVcD4IjUHMKQYLoyCaQnE
	2JZ1lkiuYhbmk/BYTUC7QzZ+3p2uWKYi97RkuivgL8GNg0JV9fFOmo4FjxbZtmFF
	VoAe7HfRoTtwNEdxBuR+Q==
X-ME-Sender: <xms:JhcmaR00paTIAAr82asV-wUPdswrFbkt06TXpqK7wap81bMJWcwmdg>
    <xme:JhcmaTFPwSnuvwvImO-ITDR-GGKoGpciKRLYiEbbDpNT2LINxJY15rZt0nCcPkWft
    oBI0JXN_pbpPh-z9D3KqGauSbqRIwtAPRy0SrkFYZQjaizHSR0f>
X-ME-Received: <xmr:JhcmaYgQacLjzk2MqkkS2_kYokcC3dlW_d_GLs_JDbMUoQswcZip19sY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgedvgeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhprghmfghrlhculdeftddtmdenucfjughrpeffhf
    fvvefukfgjfhggtgfgsehtjeertddttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgr
    mhhsohhnuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ehvddtueevjeduffejfeduhfeufeejvdetgffftdeiieduhfejjefhhfefueevudenucff
    ohhmrghinhepkhgvrhhnvghlrdhorhhgnecuufhprghmfghrlhephhhtthhpshemsddslh
    horhgvrdhkvghrnhgvlhdrohhrghdsrghllhdstdegieejkeduiedtjeehheefjeeirdef
    leeguddvkeejqdefqdhpvghtvghrgiesnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomheprghlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgt
    phhtthhopedvhedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghnkhhithgrse
    hnvhhiughirgdrtghomhdprhgtphhtthhopehjghhgseiiihgvphgvrdgtrgdprhgtphht
    thhopeihihhshhgrihhhsehnvhhiughirgdrtghomhdprhgtphhtthhopehskhholhhoth
    hhuhhmthhhohesnhhvihguihgrrdgtohhmpdhrtghpthhtohepkhgvvhhinhdrthhirghn
    sehinhhtvghlrdgtohhmpdhrtghpthhtoheprghnihhkvghtrgesnhhvihguihgrrdgtoh
    hmpdhrtghpthhtohepvhhsvghthhhisehnvhhiughirgdrtghomhdprhgtphhtthhopehm
    ohgthhhssehnvhhiughirgdrtghomhdprhgtphhtthhopeihuhhngihirghnghdrlhhise
    grmhgurdgtohhm
X-ME-Proxy: <xmx:JxcmacdLP1g4SUY4RIlfI3aEqIZmJFhz6Sza4a7M4jrDwwrOomjPJQ>
    <xmx:JxcmaewzbS7_F8qW86SibW2WS3E_E9mX12okB9Aaqsz3chiq-oUBxQ>
    <xmx:JxcmaWZSV7_sMnex-Jk9S-cgw4vDw4G5TvAK-bMEYKXUFP5RsGEQlw>
    <xmx:JxcmacIFiH5IF50A4p_lPKVD0YBIshpMYSgAgHNti5f2TFCOT7vsRw>
    <xmx:JxcmacFohCEUkwM99s3xwmmMbwM7OxD81uLkAdXO0wyNYNF2-qTM3CZ1>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Nov 2025 15:52:53 -0500 (EST)
Date: Tue, 25 Nov 2025 13:52:23 -0700
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
Subject: Re: [PATCH v6 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Message-ID: <20251125135223.4d932b5b.alex@shazbot.org>
In-Reply-To: <20251125173013.39511-3-ankita@nvidia.com>
References: <20251125173013.39511-1-ankita@nvidia.com>
	<20251125173013.39511-3-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 25 Nov 2025 17:30:09 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's Grace based systems have large device memory. The device
> memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
> module could make use of the huge PFNMAP support added in mm [1].
> 
> To make use of the huge pfnmap support, fault/huge_fault ops
> based mapping mechanism needs to be implemented. Currently nvgrace-gpu
> module relies on remap_pfn_range to do the mapping during VM bootup.
> Replace it to instead rely on fault and use vfio_pci_vmf_insert_pfn
> to setup the mapping.
> 
> Moreover to enable huge pfnmap, nvgrace-gpu module is updated by
> adding huge_fault ops implementation. The implementation establishes
> mapping according to the order request. Note that if the PFN or the
> VMA address is unaligned to the order, the mapping fallbacks to
> the PTE level.
> 
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
> 
> cc: Shameer Kolothum <skolothumtho@nvidia.com>
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> cc: Vikram Sethi <vsethi@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 84 +++++++++++++++++++++--------
>  1 file changed, 62 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e346392b72f6..8a982310b188 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,62 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> +static unsigned long addr_to_pgoff(struct vm_area_struct *vma,
> +				   unsigned long addr)
> +{
> +	u64 pgoff = vma->vm_pgoff &
> +		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +
> +	return ((addr - vma->vm_start) >> PAGE_SHIFT) + pgoff;
> +}
> +
> +static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
> +						  unsigned int order)
> +{
> +	struct vm_area_struct *vma = vmf->vma;
> +	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
> +	struct vfio_pci_core_device *vdev = &nvdev->core_device;
> +	unsigned int index =
> +		vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
> +	struct mem_region *memregion;
> +	unsigned long pfn, addr;
> +
> +	memregion = nvgrace_gpu_memregion(index, nvdev);
> +	if (!memregion)
> +		return ret;
> +
> +	addr = vmf->address & ~((PAGE_SIZE << order) - 1);
> +	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
> +
> +	if (order && (addr < vma->vm_start ||
> +		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> +		      pfn & ((1 << order) - 1)))
> +		return VM_FAULT_FALLBACK;

The dev_dbg misses this fallback this way.  Thanks,

Alex

> +
> +	scoped_guard(rwsem_read, &vdev->memory_lock)
> +		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
> +
> +	dev_dbg_ratelimited(&vdev->pdev->dev,
> +			    "%s order = %d pfn 0x%lx: 0x%x\n",
> +			    __func__, order, pfn,
> +			    (unsigned int)ret);
> +
> +	return ret;
> +}
> +
> +static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> +{
> +	return nvgrace_gpu_vfio_pci_huge_fault(vmf, 0);
> +}
> +
> +static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
> +	.fault = nvgrace_gpu_vfio_pci_fault,
> +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> +	.huge_fault = nvgrace_gpu_vfio_pci_huge_fault,
> +#endif
> +};
> +
>  static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  			    struct vm_area_struct *vma)
>  {
> @@ -137,10 +193,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  		container_of(core_vdev, struct nvgrace_gpu_pci_core_device,
>  			     core_device.vdev);
>  	struct mem_region *memregion;
> -	unsigned long start_pfn;
>  	u64 req_len, pgoff, end;
>  	unsigned int index;
> -	int ret = 0;
>  
>  	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>  
> @@ -157,17 +211,18 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  		((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
>  
>  	if (check_sub_overflow(vma->vm_end, vma->vm_start, &req_len) ||
> -	    check_add_overflow(PHYS_PFN(memregion->memphys), pgoff, &start_pfn) ||
>  	    check_add_overflow(PFN_PHYS(pgoff), req_len, &end))
>  		return -EOVERFLOW;
>  
>  	/*
> -	 * Check that the mapping request does not go beyond available device
> -	 * memory size
> +	 * Check that the mapping request does not go beyond the exposed
> +	 * device memory size.
>  	 */
>  	if (end > memregion->memlength)
>  		return -EINVAL;
>  
> +	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +
>  	/*
>  	 * The carved out region of the device memory needs the NORMAL_NC
>  	 * property. Communicate as such to the hypervisor.
> @@ -184,23 +239,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  		vma->vm_page_prot = pgprot_writecombine(vma->vm_page_prot);
>  	}
>  
> -	/*
> -	 * Perform a PFN map to the memory and back the device BAR by the
> -	 * GPU memory.
> -	 *
> -	 * The available GPU memory size may not be power-of-2 aligned. The
> -	 * remainder is only backed by vfio_device_ops read/write handlers.
> -	 *
> -	 * During device reset, the GPU is safely disconnected to the CPU
> -	 * and access to the BAR will be immediately returned preventing
> -	 * machine check.
> -	 */
> -	ret = remap_pfn_range(vma, vma->vm_start, start_pfn,
> -			      req_len, vma->vm_page_prot);
> -	if (ret)
> -		return ret;
> -
> -	vma->vm_pgoff = start_pfn;
> +	vma->vm_ops = &nvgrace_gpu_vfio_pci_mmap_ops;
> +	vma->vm_private_data = nvdev;
>  
>  	return 0;
>  }


