Return-Path: <kvm+bounces-62347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 097C3C415DC
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 19:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7C0ED34FE13
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 18:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEABF34028B;
	Fri,  7 Nov 2025 18:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H59v75Ni"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5D333CEA8;
	Fri,  7 Nov 2025 18:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762541923; cv=none; b=oOrWT/WtaSGTmZWpMsAyWJkW+Wa83PzmeCi0FhRoZrsAnZ7eQ8DtE+CEd9DSTwVpFbcT/ovwy35otzl/Tn+9p4yR8oQ/tDmk1ZQDLpOfHjoUqgMPkY8tUjU7ESeDSYQIrFzEvgQEZGvfe65mux3XEK7puJ9GZ8bUYkJku0ZpDzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762541923; c=relaxed/simple;
	bh=bOUbnZvb2TbWof6JwYRWtCUjJZ+np312O1qVpM42BAw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H9TCIRg3b9h++Fo3Wzci5wvQZ3FtVyvuMpuW/ggrpBTWtIenztLxNNy4teBNCWKDaidLLOkSBzMCxWeKLpqGEODj2YIwSkXCTbjTbYSXbivQqp793Tn6Jrd+k42inzb3MVRR5iq/O+gWDCCDIrEMOasmE+MJv/30HTJZias6qjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=H59v75Ni; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=PjiF0FDj1ggdA8+srznADWIujFetT2w1WcC08yNm+xE=; b=H59v75NiiIx555adWgSui938BX
	Yc3i1CYEaGF7O6kQ1NqaqRVT/Zz7Cswv0/fmOzsuOsqzoIRagasqeUrHrhrdChqEbZeXwaG25NO+S
	5wwiT1Bk++lMCO2rTIpSkO6LuvNwiSk1/lj7Setie4/hO5vXucwRTkyP4yelMuEJS4S3/t3xpANoZ
	fMWvRG+69LUGWzme6PVDco0ZFCeM7vfUpGeksDZI3z5FpBYHlU5+MqvBB/XCUz0tSEk1fDzrRkUZ2
	YHwjo2XWY68XJ4S/UyDHNpcYYoIRz6GCK8IoBHNkuYm6Mq2NkrCY2ePjJ4l6ltSL9O9XJUZxKJPhW
	/Noao/Cg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vHRfI-00000000bYE-3FZm;
	Fri, 07 Nov 2025 18:58:28 +0000
Message-ID: <0c265a9b-fdc5-40d7-845f-30910f1ac6ea@infradead.org>
Date: Fri, 7 Nov 2025 10:58:27 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
To: Leon Romanovsky <leon@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe
 <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton <akpm@linux-foundation.org>,
 Jonathan Corbet <corbet@lwn.net>, Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>,
 Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.com>
 <20251106-dmabuf-vfio-v7-5-2503bf390699@nvidia.com>
 <135df7eb-9291-428b-9c86-d58c2e19e052@infradead.org>
 <20251107160120.GD15456@unreal>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251107160120.GD15456@unreal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

	

On 11/7/25 8:01 AM, Leon Romanovsky wrote:
> On Thu, Nov 06, 2025 at 10:15:07PM -0800, Randy Dunlap wrote:
>>
>>
>> On 11/6/25 6:16 AM, Leon Romanovsky wrote:
>>> From: Jason Gunthorpe <jgg@nvidia.com>
>>>
>>> Reflect latest changes in p2p implementation to support DMABUF lifecycle.
>>>
>>> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>>>  Documentation/driver-api/pci/p2pdma.rst | 95 +++++++++++++++++++++++++--------
>>>  1 file changed, 72 insertions(+), 23 deletions(-)
>>>
>>> diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
>>> index d0b241628cf1..69adea45f73e 100644
>>> --- a/Documentation/driver-api/pci/p2pdma.rst
>>> +++ b/Documentation/driver-api/pci/p2pdma.rst
>>> @@ -9,22 +9,47 @@ between two devices on the bus. This type of transaction is henceforth
>>>  called Peer-to-Peer (or P2P). However, there are a number of issues that
>>>  make P2P transactions tricky to do in a perfectly safe way.
>>>  
>>> -One of the biggest issues is that PCI doesn't require forwarding
>>> -transactions between hierarchy domains, and in PCIe, each Root Port
>>> -defines a separate hierarchy domain. To make things worse, there is no
>>> -simple way to determine if a given Root Complex supports this or not.
>>> -(See PCIe r4.0, sec 1.3.1). Therefore, as of this writing, the kernel
>>> -only supports doing P2P when the endpoints involved are all behind the
>>> -same PCI bridge, as such devices are all in the same PCI hierarchy
>>> -domain, and the spec guarantees that all transactions within the
>>> -hierarchy will be routable, but it does not require routing
>>> -between hierarchies.
>>> -
>>> -The second issue is that to make use of existing interfaces in Linux,
>>> -memory that is used for P2P transactions needs to be backed by struct
>>> -pages. However, PCI BARs are not typically cache coherent so there are
>>> -a few corner case gotchas with these pages so developers need to
>>> -be careful about what they do with them.
>>> +For PCIe the routing of TLPs is well defined up until they reach a host bridge
>>
>> Define what TLP means?
> 
> In PCIe "world", TLP is very well-known and well-defined acronym, which
> means Transaction Layer Packet.

It's your choice (or Bjorn's). I'm just reviewing...

>>                                    well-defined
> 
> Thanks
> 
> diff --git a/Documentation/driver-api/pci/p2pdma.rst b/Documentation/driver-api/pci/p2pdma.rst
> index 69adea45f73e..7530296a5dea 100644
> --- a/Documentation/driver-api/pci/p2pdma.rst
> +++ b/Documentation/driver-api/pci/p2pdma.rst
> @@ -9,17 +9,17 @@ between two devices on the bus. This type of transaction is henceforth
>  called Peer-to-Peer (or P2P). However, there are a number of issues that
>  make P2P transactions tricky to do in a perfectly safe way.
> 
> -For PCIe the routing of TLPs is well defined up until they reach a host bridge
> -or root port. If the path includes PCIe switches then based on the ACS settings
> -the transaction can route entirely within the PCIe hierarchy and never reach the
> -root port. The kernel will evaluate the PCIe topology and always permit P2P
> -in these well defined cases.
> +For PCIe the routing of Transaction Layer Packets (TLPs) is well-defined up
> +until they reach a host bridge or root port. If the path includes PCIe switches
> +then based on the ACS settings the transaction can route entirely within
> +the PCIe hierarchy and never reach the root port. The kernel will evaluate
> +the PCIe topology and always permit P2P in these well-defined cases.
> 
>  However, if the P2P transaction reaches the host bridge then it might have to
>  hairpin back out the same root port, be routed inside the CPU SOC to another
>  PCIe root port, or routed internally to the SOC.
> 
> -As this is not well defined or well supported in real HW the kernel defaults to
> +As this is not well-defined or well supported in real HW the kernel defaults to
Nit:                              well-supported

The rest of it looks good. Thanks.

>  blocking such routing. There is an allow list to allow detecting known-good HW,
>  in which case P2P between any two PCIe devices will be permitted.
> 
> @@ -39,7 +39,7 @@ delegates lifecycle management to the providing driver. It is expected that
>  drivers using this option will wrap their MMIO memory in DMABUF and use DMABUF
>  to provide an invalidation shutdown. These MMIO pages have no struct page, and
>  if used with mmap() must create special PTEs. As such there are very few
> -kernel uAPIs that can accept pointers to them, in particular they cannot be used
> +kernel uAPIs that can accept pointers to them; in particular they cannot be used
>  with read()/write(), including O_DIRECT.
> 
>  Building on this, the subsystem offers a layer to wrap the MMIO in a ZONE_DEVICE
> @@ -154,7 +154,7 @@ access happens.
>  Usage With DMABUF
>  =================
> 
> -DMABUF provides an alternative to the above struct page based
> +DMABUF provides an alternative to the above struct page-based
>  client/provider/orchestrator system. In this mode the exporting driver will wrap
>  some of its MMIO in a DMABUF and give the DMABUF FD to userspace.
> 
> @@ -162,10 +162,10 @@ Userspace can then pass the FD to an importing driver which will ask the
>  exporting driver to map it.
> 
>  In this case the initiator and target pci_devices are known and the P2P subsystem
> -is used to determine the mapping type. The phys_addr_t based DMA API is used to
> +is used to determine the mapping type. The phys_addr_t-based DMA API is used to
>  establish the dma_addr_t.
> 
> -Lifecycle is controlled by DMABUF move_notify(), when the exporting driver wants
> +Lifecycle is controlled by DMABUF move_notify(). When the exporting driver wants
>  to remove() it must deliver an invalidation shutdown to all DMABUF importing
>  drivers through move_notify() and synchronously DMA unmap all the MMIO.
> 

-- 
~Randy


