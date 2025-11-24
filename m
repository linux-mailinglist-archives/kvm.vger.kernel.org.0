Return-Path: <kvm+bounces-64399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 35EEEC815BF
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 16:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 19A6E4E52C9
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 15:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A4DC313E10;
	Mon, 24 Nov 2025 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b="uwCk2x8S";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="WelDxBau"
X-Original-To: kvm@vger.kernel.org
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF712253E4;
	Mon, 24 Nov 2025 15:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.146
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763998368; cv=none; b=PwEXUcA79w4QlLG/+HBcEa7BWDzHU3fQ6mvnmQ52r3Jc49ChUs0MKsPtI/1NqdE0ujIKwguAIbLyhrOXyMYTYjG1H2RHPAsJoegWI6Q3duCXFNV3DV2cxvd6zcys3coBG0q4shjiouhaHspPRdTqJciEqSfFQuXVyUhzVJH1FMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763998368; c=relaxed/simple;
	bh=LjEdglusX9a75QuaP5fC5aqY91qop2WUI4lF3h8c94M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mxs65UXi/UG0oc9187edgTll5F5i1eHhZABeb7BHcBCyoKGzqWO4RgOnn31/CHdtor+Lt2F8l22NLvb7unIo8BitVcs17jOF/mYkz6GD6PNlClX5+oOGwn3MI1V33KmSPS/iKr8RfhGE3+yoRelh+rxnhT5DZf2EeeUQ45xR9nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org; spf=pass smtp.mailfrom=shazbot.org; dkim=pass (2048-bit key) header.d=shazbot.org header.i=@shazbot.org header.b=uwCk2x8S; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=WelDxBau; arc=none smtp.client-ip=103.168.172.146
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=shazbot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shazbot.org
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id BC51EEC0765;
	Mon, 24 Nov 2025 10:32:43 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 24 Nov 2025 10:32:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1763998363;
	 x=1764084763; bh=zFerguA/X2Vl8bSpXAyjVZcz9of64vyZ+JmMnDVFhaw=; b=
	uwCk2x8S2IDB8yTcxy2rSYFnp+kImLJSphMUWPvcveHj9gVIPhpENwKv15RtalFw
	xWXl/kdTGNlTaGTiON2NTzMJuWVngajEVQW+vyAW/MHDroQcVU5xSBt01ok+nUyd
	+Wf8GO1GF9xguSoO7I6MUYbzpj6cB0x+Y0A3G+9EppPeGHwm8spLXVRZFZs+g4+9
	bR/3GwvWXuaY3kMM9usQc85ES6QJpa9IuiZVr2NBoeOa6b6hfn8AstxcWoHQXPIM
	xE3IHC/xAybwnZLvnUaTDjgp+cIPOy9aHI6LuJLx3/hXaZ2GQlOmkI4QG7WeSmqR
	CIMjFlcBaw68AMAFkdp7Kg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763998363; x=
	1764084763; bh=zFerguA/X2Vl8bSpXAyjVZcz9of64vyZ+JmMnDVFhaw=; b=W
	elDxBauWFRiv1yl/0DexRy+8byd43ho//wiuqjNsSMKM1ZSAzol0Hn73YXIykrAC
	oU4MA4o5Qs1HpaVEWxBRp12S8MkBfci17IQfGBpXIjl8Am5WOelM4DMsAKfJrqT/
	3bibBj8H94OJW+d9z5Ga+hQ9ARv8Lmtn/WzzBg3VzJP/nGqM39A4SVNxCqBG1pNz
	hNngv7JFLIc7AG9PjVPnuvvvReYiIdAYyv0klFKlBCkJomlkc8T/MXuJXYy55G/s
	trR7lnHizUSmLyOEmdFuCaOq+4clEClmg/544lvWObczf3dzJXNlqJcpvAPQhITy
	PCzJP0uXI1ok3xw8uyztA==
X-ME-Sender: <xms:mnokacd0pwpEvX6r8R7j5CKdFR0hgqO8_0rkecY8ZdO1hhDB7w033w>
    <xme:mnokaWbVcwRi6tJOuoPnYUXFl2kWyj78KZ-SRCyxXbQbaVxfcnt1y6Glfk1v9pp8C
    L5SvFYeSj0mGj672ahr5s9IC37bBaYakJWA2YYM6ZxPKsVFJ4InIw>
X-ME-Received: <xmr:mnokaU2SXCSfCMbbH6peXqmK70Tl79mDKMXiWdp4WoLvmh9Ept31_zzc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeekleejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpeffhffvvefukfgjfhggtgfgsehtjeertd
    dttddvnecuhfhrohhmpeetlhgvgicuhghilhhlihgrmhhsohhnuceorghlvgigsehshhgr
    iigsohhtrdhorhhgqeenucggtffrrghtthgvrhhnpeehvddtueevjeduffejfeduhfeufe
    ejvdetgffftdeiieduhfejjefhhfefueevudenucffohhmrghinhepkhgvrhhnvghlrdho
    rhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hlvgigsehshhgriigsohhtrdhorhhgpdhnsggprhgtphhtthhopedvhedpmhhouggvpehs
    mhhtphhouhhtpdhrtghpthhtoheprghnkhhithgrsehnvhhiughirgdrtghomhdprhgtph
    htthhopehjghhgseiiihgvphgvrdgtrgdprhgtphhtthhopeihihhshhgrihhhsehnvhhi
    ughirgdrtghomhdprhgtphhtthhopehskhholhhothhhuhhmthhhohesnhhvihguihgrrd
    gtohhmpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpdhrtghp
    thhtoheprghnihhkvghtrgesnhhvihguihgrrdgtohhmpdhrtghpthhtohepvhhsvghthh
    hisehnvhhiughirgdrtghomhdprhgtphhtthhopehmohgthhhssehnvhhiughirgdrtgho
    mhdprhgtphhtthhopeihuhhngihirghnghdrlhhisegrmhgurdgtohhm
X-ME-Proxy: <xmx:m3okafqeyJsOQjN68_nJFIuzJ4d8oVds2jfWDM41vImuWP8Z_8t2CA>
    <xmx:m3okaVx7WkZSGou8DZhU1AxJ8BQlhHX7Ky9rqn0E4cqjCneenXFWvA>
    <xmx:m3okaYB6deiTilWitfRtK96HVPnWwEXSs3--RiPR-bSiH6s0nqKPaw>
    <xmx:m3okacPDcAc-bNruBpuAZXJzF2lnFsvAaPeI390Z4ZLeem7NCkHyAQ>
    <xmx:m3okaej6uJ0u4JBcG0WYGdUXj2kBg6Vs7MrFyjf_vW10s04D9fk6ednr>
Feedback-ID: i03f14258:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Nov 2025 10:32:41 -0500 (EST)
Date: Mon, 24 Nov 2025 08:32:37 -0700
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
Subject: Re: [PATCH v5 3/7] vfio/nvgrace-gpu: Add support for huge pfnmap
Message-ID: <20251124083237.26c92d2b.alex@shazbot.org>
In-Reply-To: <20251124115926.119027-4-ankita@nvidia.com>
References: <20251124115926.119027-1-ankita@nvidia.com>
	<20251124115926.119027-4-ankita@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 24 Nov 2025 11:59:22 +0000
<ankita@nvidia.com> wrote:

> From: Ankit Agrawal <ankita@nvidia.com>
> 
> NVIDIA's Grace based systems have large device memory. The device
> memory is mapped as VM_PFNMAP in the VMM VMA. The nvgrace-gpu
> module could make use of the huge PFNMAP support added in mm [1].
> 
> To achieve this, nvgrace-gpu module is updated to implement huge_fault ops.
> The implementation establishes mapping according to the order request.
> Note that if the PFN or the VMA address is unaligned to the order, the
> mapping fallbacks to the PTE level.
> 
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
> 
> cc: Alex Williamson <alex@shazbot.org>
> cc: Jason Gunthorpe <jgg@ziepe.ca>
> cc: Vikram Sethi <vsethi@nvidia.com>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>  drivers/vfio/pci/nvgrace-gpu/main.c | 43 +++++++++++++++++++++++------
>  1 file changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index f74f3d8e1ebe..c84c01954c9e 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -130,32 +130,58 @@ static void nvgrace_gpu_close_device(struct vfio_device *core_vdev)
>  	vfio_pci_core_close_device(core_vdev);
>  }
>  
> -static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> +static vm_fault_t nvgrace_gpu_vfio_pci_huge_fault(struct vm_fault *vmf,
> +						  unsigned int order)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
>  	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
>  	vm_fault_t ret = VM_FAULT_SIGBUS;
>  	struct mem_region *memregion;
> -	unsigned long pgoff, pfn;
> +	unsigned long pgoff, pfn, addr;
>  
>  	memregion = nvgrace_gpu_memregion(index, nvdev);
>  	if (!memregion)
>  		return ret;
>  
> -	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> +	addr = vmf->address & ~((PAGE_SIZE << order) - 1);
> +	pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;
>  	pfn = PHYS_PFN(memregion->memphys) + pgoff;
>  
> +	if (order && (addr < vma->vm_start ||
> +		      addr + (PAGE_SIZE << order) > vma->vm_end ||
> +		      pfn & ((1 << order) - 1)))
> +		return VM_FAULT_FALLBACK;
> +
>  	scoped_guard(rwsem_read, &nvdev->core_device.memory_lock)
> -		ret = vmf_insert_pfn(vmf->vma, vmf->address, pfn);
> +		ret = vfio_pci_vmf_insert_pfn(vmf, pfn, order);
>  
>  	return ret;
>  }


It may be worth considering replicating the dev_dbg from
vfio_pci_mmap_huge_fault(), it's been very useful in validating that
we're getting the huge PFNMAPs we expect.  Thanks,

Alex

>  
> +static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> +{
> +	return nvgrace_gpu_vfio_pci_huge_fault(vmf, 0);
> +}
> +
>  static const struct vm_operations_struct nvgrace_gpu_vfio_pci_mmap_ops = {
>  	.fault = nvgrace_gpu_vfio_pci_fault,
> +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> +	.huge_fault = nvgrace_gpu_vfio_pci_huge_fault,
> +#endif
>  };
>  
> +static size_t nvgrace_gpu_aligned_devmem_size(size_t memlength)
> +{
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +	return ALIGN(memlength, PMD_SIZE);
> +#endif
> +#ifdef CONFIG_ARCH_SUPPORTS_PUD_PFNMAP
> +	return ALIGN(memlength, PUD_SIZE);
> +#endif
> +	return memlength;
> +}
> +
>  static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  			    struct vm_area_struct *vma)
>  {
> @@ -185,10 +211,10 @@ static int nvgrace_gpu_mmap(struct vfio_device *core_vdev,
>  		return -EOVERFLOW;
>  
>  	/*
> -	 * Check that the mapping request does not go beyond available device
> -	 * memory size
> +	 * Check that the mapping request does not go beyond the exposed
> +	 * device memory size.
>  	 */
> -	if (end > memregion->memlength)
> +	if (end > nvgrace_gpu_aligned_devmem_size(memregion->memlength))
>  		return -EINVAL;
>  
>  	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> @@ -258,7 +284,8 @@ nvgrace_gpu_ioctl_get_region_info(struct vfio_device *core_vdev,
>  
>  	sparse->nr_areas = 1;
>  	sparse->areas[0].offset = 0;
> -	sparse->areas[0].size = memregion->memlength;
> +	sparse->areas[0].size =
> +		nvgrace_gpu_aligned_devmem_size(memregion->memlength);
>  	sparse->header.id = VFIO_REGION_INFO_CAP_SPARSE_MMAP;
>  	sparse->header.version = 1;
>  


