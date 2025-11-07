Return-Path: <kvm+bounces-62272-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id E5930C3E99A
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 07:15:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 61D214E825E
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 06:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87D62D979F;
	Fri,  7 Nov 2025 06:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wvMjfD9U"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441321CFE0;
	Fri,  7 Nov 2025 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762496124; cv=none; b=h9Q8N3QqD28J+BPrB2TgGQb75D5/Gd36IESxAaB39RpPfg81iioZtq4atP7ohOYDQ8ffo82bYy2phSpD2uju2pxFNERaasNO0DAXfdtrUqqAHGziLvx8gXoVC2sBktuSKtOUXZP5uiaijNDM3zfbxV0zbuD40XUTNImiZhWlODw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762496124; c=relaxed/simple;
	bh=2J2J0xQOtW/dkCB4k8qYvgQOW4YmyC7HIhrAhUrKn30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SkLRNsiE8ikrb8ajYpS9n4TWcSVbXTCyZ3KVdYck7nBQUOI9US3AIKC0ywz7ZD7vJOmCEzSVtVeoRHK/cc6jtCGkxIt4HTfpzh0NYy/e0FLppw/UfxeMgewdBwE++gs1pc8xCu7SOo2wg7zMos6njPIEr8RvqiA0YGRU2FBKVD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wvMjfD9U; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=0pvYkku9B0Yn9Tva4Hva9YRPLFO4fPY61E/RWmTzPOE=; b=wvMjfD9UaT3srkTJPow+61yh3N
	OkqKLwST4F525xsesZaRDbQI9izo2FfdhHtCjqZ3ddTVdax7Lbdgnf3nwx9GqRsSsOg9py4xU5yxh
	bPCADIElPjneqxaGddELsdxhLXoiqP4M/8r7MreKn0SZbf+EhyjNv7u7QgJqPc2ZScsbeGgSGitqe
	Kp+se6E94iE6eytcZ6nxR+//81zWQ00AfcMbb5fV4pm5JvbLV6094pdLiv6j8n2ddM00wptAT43yq
	DfNQo+F2OVUd3YbNTBAvqviVZrXwl/dKKcX3sKfwlN3RPj1b1LBIVRhqzil1G0Ezlc9ba4An/rhpu
	5dyhj6jQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHFka-0000000Givm-3DWD;
	Fri, 07 Nov 2025 06:15:08 +0000
Message-ID: <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
Date: Thu, 6 Nov 2025 22:15:07 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
To: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>
Cc: Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/6/25 6:16 AM, Leon Romanovsky wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Reflect latest changes in p2p implementation to support DMABUF lifecycle.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
>  1 file changed, 72 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> index d0b241628cf1..69adea45f73e 100644
> --- a/Documentation/driver-api/pci/p2pdma.rst
> +++ b/Documentation/driver-api/pci/p2pdma.rst
> @@ -9,22 +9,47 @@ between two devices on the bus. This type of transaction is henceforth
>  called Peer-to-Peer (or P2P). However, there are a number of issues that
>  make P2P transactions tricky to do in a perfectly safe way.
>  
> -One of the biggest issues is that PCI doesn't require forwarding
> -transactions between hierarchy domains, and in PCIe, each Root Port
> -defines a separate hierarchy domain. To make things worse, there is no
> -simple way to determine if a given Root Complex supports this or not.
> -(See PCIe r4.0, sec 1.3.1). Therefore, as of this writing, the kernel
> -only supports doing P2P when the endpoints involved are all behind the
> -same PCI bridge, as such devices are all in the same PCI hierarchy
> -domain, and the spec guarantees that all transactions within the
> -hierarchy will be routable, but it does not require routing
> -between hierarchies.
> -
> -The second issue is that to make use of existing interfaces in Linux,
> -memory that is used for P2P transactions needs to be backed by struct
> -pages. However, PCI BARs are not typically cache coherent so there are
> -a few corner case gotchas with these pages so developers need to
> -be careful about what they do with them.
> +For PCIe the routing of TLPs is well defined up until they reach a host bridge

Define what TLP means?
                                   well-defined

> +or root port. If the path includes PCIe switches then based on the ACS settings
> +the transaction can route entirely within the PCIe hierarchy and never reach the
> +root port. The kernel will evaluate the PCIe topology and always permit P2P
> +in these well defined cases.

            well-defined

> +
> +However, if the P2P transaction reaches the host bridge then it might have to
> +hairpin back out the same root port, be routed inside the CPU SOC to another
> +PCIe root port, or routed internally to the SOC.
> +
> +As this is not well defined or well supported in real HW the kernel defaults to

                  well-defined or well-supported

> +blocking such routing. There is an allow list to allow detecting known-good HW,
> +in which case P2P between any two PCIe devices will be permitted.
> +
> +Since P2P inherently is doing transactions between two devices it requires two
> +drivers to be co-operating inside the kernel. The providing driver has to convey
> +its MMIO to the consuming driver. To meet the driver model lifecycle rules the
> +MMIO must have all DMA mapping removed, all CPU accesses prevented, all page
> +table mappings undone before the providing driver completes remove().
> +
> +This requires the providing and consuming driver to actively work together to
> +guarantee that the consuming driver has stopped using the MMIO during a removal
> +cycle. This is done by either a synchronous invalidation shutdown or waiting
> +for all usage refcounts to reach zero.
> +
> +At the lowest level the P2P subsystem offers a naked struct p2p_provider that
> +delegates lifecycle management to the providing driver. It is expected that
> +drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
> +to provide an invalidation shutdown. These MMIO pages have no struct page, and
> +if used with mmap() must create special PTEs. As such there are very few
> +kernel uAPIs that can accept pointers to them, in particular they cannot be used

                                            them;

> +with read()/write(), including O_DIRECT.
> +
> +Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
> +pgmap of MEMORY_DEVICE_PCI_P2PDMA to create struct pages. The lifecycle of
> +pgmap ensures that when the pgmap is destroyed all other drivers have stopped
> +using the MMIO. This option works with O_DIRECT flows, in some cases, if the
> +underlying subsystem supports handling MEMORY_DEVICE_PCI_P2PDMA through
> +FOLL_PCI_P2PDMA. The use of FOLL_LONGTERM is prevented. As this relies on pgmap
> +it also relies on architecture support along with alignment and minimum size
> +limitations.
>  
>  
>  Driver Writer's Guide
> @@ -114,14 +139,38 @@ allocating scatter-gather lists with P2P memory.
>  Struct Page Caveats
>  -------------------
>  
> -Driver writers should be very careful about not passing these special
> -struct pages to code that isn't prepared for it. At this time, the kernel
> -interfaces do not have any checks for ensuring this. This obviously
> -precludes passing these pages to userspace.
> +While the MEMORY_DEVICE_PCI_P2PDMA pages can be installed in VMAs,
> +pin_user_pages() and related will not return them unless FOLL_PCI_P2PDMA is set.
>  
> -P2P memory is also technically IO memory but should never have any side
> -effects behind it. Thus, the order of loads and stores should not be important
> -and ioreadX(), iowriteX() and friends should not be necessary.
> +The MEMORY_DEVICE_PCI_P2PDMA pages require care to support in the kernel. The
> +KVA is still MMIO and must still be accessed through the normal
> +readX()/writeX()/etc helpers. Direct CPU access (e.g. memcpy) is forbidden, just
> +like any other MMIO mapping. While this will actually work on some
> +architectures, others will experience corruption or just crash in the kernel.
> +Supporting FOLL_PCI_P2PDMA in a subsystem requires scrubbing it to ensure no CPU
> +access happens.
> +
> +
> +Usage With DMABUF
> +=================
> +
> +DMABUF provides an alternative to the above struct page based

                                                      page-based

> +client/provider/orchestrator system. In this mode the exporting driver will wrap
> +some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
> +
> +Userspace can then pass the FD to an importing driver which will ask the
> +exporting driver to map it.
> +
> +In this case the initiator and target pci_devices are known and the P2P subsystem
> +is used to determine the mapping type. The phys_addr_t based DMA API is used to

                                              phys_addr_t-based

> +establish the dma_addr_t.
> +
> +Lifecycle is controlled by DMABUF move_notify(), when the exporting driver wants

                                     move_notify(). When

> +to remove() it must deliver an invalidation shutdown to all DMABUF importing
> +drivers through move_notify() and synchronously DMA unmap all the MMIO.
> +
> +No importing driver can continue to have a DMA map to the MMIO after the
> +exporting driver has destroyed its p2p_provider.
>  
>  
>  P2P DMA Support Library
> 

-- 
~Randy


