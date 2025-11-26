Return-Path: <kvm+bounces-64673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F281FC8A9D7
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:25:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60D923AF39B
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 15:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1190E332EB4;
	Wed, 26 Nov 2025 15:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="O9h09XAo";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="yTyfSUAt"
X-Original-To: kvm@vger.kernel.org
Received: from flow-a6-smtp.messagingengine.com (flow-a6-smtp.messagingengine.com [103.168.172.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617813321BD;
	Wed, 26 Nov 2025 15:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764170654; cv=none; b=uDjke4os7EF4mWbJ0mtw95QvbJYMe9tKbcR8zqgCU5CgNC1106ZA5081vMkU9sBiT5WATG1x8nQ8Z7OEASx1ifFg96YgrdbVSSJNVWT/5ngbXMe/ysEFiHLkv6tip6IA5eLKWoakdaRFdN/TwwSrwYtlu+WfHK1nozntD20khgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764170654; c=relaxed/simple;
	bh=T3NRnzZK2fgfGjdRSC+sB5MA90DSR1VOI3xMkkEBs1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R/YKqRsxcqkd6hReCtm/+DljOjPKIPJwy5rz6b4Gd7lL75QKBNpfZbQ5b8KeeUlCU0B5p8rwJkmdwRkCr6A9VA69l5DSTLzCeuXY21jM4jo1JMxxLk0gSYaArO4XETruWvJcVQbGTJMx2juZ/RDv3WWKfiCApZ4pjIRrYUUWIQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=O9h09XAo; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=yTyfSUAt; arc=none smtp.client-ip=103.168.172.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailflow.phl.internal (Postfix) with ESMTP id 3F82613806F0;
	Wed, 26 Nov 2025 10:24:10 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 26 Nov 2025 10:24:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1764170650;
	 x=1764177850; bh=7K3z/8aHP1tAWRzpvSRQ00tWAJwrtVMcutbnPrk8Q0U=; b=
	O9h09XAoSEQ0PBrFJ3QApT+9QhNc2WEFl71mIT51FeRu5N41o6DyOP8WXpjmp/6+
	XvxckgJSW+3XpEOMaAgfvrUuPg9H3uwYGzPlgpvDj30TCMtAP5CrV8CglemK7xK4
	CSAd86+yXXViOHAQ9dtRq22+SSV+EbhvwvsVE18vAQTiP+/zGgYB5MhKQeHN+oPb
	jcxcTRAC1gNgAXdAIH0f3OcrxbBoNnVV9rlyx6G+pGHGLFi7Zhuhv+jlwRb+kMta
	GKlhE4tpIq17FG2TIcwZ5sKmrpvetVpVFbG7cLK2weh8/yP2XBPU0NtNty2ATtOE
	Opjjpbk7pYU3qCWeqKAmqA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1764170650; x=
	1764177850; bh=7K3z/8aHP1tAWRzpvSRQ00tWAJwrtVMcutbnPrk8Q0U=; b=y
	TyfSUAtaUKcBOeIY+5k2rs2iNikoTW21V5GFQ62IGejYw2S87KZJub879HoQUzE9
	lsqAVeC8DaoLIUIMB3i0IMqX1HpIKhpD4OMZHVTARdvgjJvurywtZhWD5/hLfKDD
	+/sLLa5FlWnVvqDEvBI8kTo9HtbFohKAsOtfpx6rPmhmYqMXwH2sPuVKq/iTeA57
	uAeKxPoUzxMqsdApNZpB/V98y4Nv/k+6PfiuCNTGhxp3jhN+n8TsUNcDeBMT3skR
	nQD/GVOOkqq+x3V4FWlKiPE1I3CcCxl9oa3qMjMC0hPh2QZcrslRvVp+FzQ2TaFe
	89pABHfwKKbyNaSH/FU8Q==
X-ME-Sender: <xms:mRsnaesC4e1Ex_YF2hP-n_wHR7Aa7KRzPA96geDZJU8yd9oqBIX5Ow>
    <xme:mRsnaedw7V0ljL6jImwZFL0B-b_RMoTyRkA8LsVQOo8zdWQVUpJEbtlJtdBAqGQOX
    h_wnYmds6G2-7BdXKDbMnluz-y1SrK-vIJga5zxxbKoPkGXSeKe7g>
X-ME-Received: <xmr:mRsnaQbvRIfJr2Rsw1WoUN-9jcFPsaAuUgCbncFenmsmW6zJjR0GUm_i>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeegieelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:mRsnaW076hPMj638_WKnXV4ukTOOo71ATcpl1E9emK-r5cy4zY5AnQ>
    <xmx:mRsnaZphjIq0UAGsySYuWdYm1k_cwuw2YPsgJkmUxjLFCqIOtvMeFQ>
    <xmx:mRsnaXwZEPxu--xx1k5pPSJYnUDbP4OiPn4LGEMeTsch2f0upC17Ag>
    <xmx:mRsnaSCOWvhWyGd5QwdOLUq5AaNq-ztFoVGEZM_9d4DObbVjfq_6Rg>
    <xmx:mhsnab8-JQxVmkRJq5xoFHl72EUonAeAP6rWoZamk_1sviyUOGJRyP3f>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Nov 2025 10:24:08 -0500 (EST)
Date: Wed, 26 Nov 2025 08:22:40 -0700
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
Subject: Re: [PATCH v7 2/6] vfio/nvgrace-gpu: Add support for huge pfnmap
Message-ID: <20251126082240.59ffa6bd.alex@shazbot.org>
In-Reply-To: <20251126052627.43335-3-ankita@nvidia.com>
References: <20251126052627.43335-1-ankita@nvidia.com>
	<20251126052627.43335-3-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 26 Nov 2025 05:26:23 +0000
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
> Cc: Shameer Kolothum <skolothumtho@nvidia.com>
> Cc: Alex Williamson <alex@shazbot.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Vikram Sethi <vsethi@nvidia.com>
> Reviewed-by: Zhi Wang <zhiw@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 85 +++++++++++++++++++++--------
>  1 file changed, 63 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e346392b72f6..ac9551b9e4b6 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,6 +130,63 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
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
> +	addr = ALIGN_DOWN(vmf->address, PAGE_SIZE << order);
> +	pfn = PHYS_PFN(memregion->memphys) + addr_to_pgoff(vma, addr);
> +
> +	if (unmappable_for_order(vma, addr, pfn, order)) {
> +		ret = VM_FAULT_FALLBACK;
> +		goto out;
> +	}
> +
> +	scoped_guard(rwsem_read, &vdev->memory_lock)
> +		ret = vfio_pci_vmf_insert_pfn(vdev, vmf, pfn, order);
> +
> +out:

Adopt same code flow as suggested in 1/, return SIGBUS directly for
!memregion, initialize ret to FALLBACK.  Thanks,

Alex

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
> @@ -137,10 +194,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
> @@ -157,17 +212,18 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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
> @@ -184,23 +240,8 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
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


