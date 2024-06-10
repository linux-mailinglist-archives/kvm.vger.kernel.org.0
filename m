Return-Path: <kvm+bounces-19238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1704902582
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 17:25:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58BD91F22FDA
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CC2C13FD84;
	Mon, 10 Jun 2024 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sw2F+lfM"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03891140364
	for <kvm@vger.kernel.org>; Mon, 10 Jun 2024 15:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718032767; cv=none; b=pahA3Ox61pwZmp26WCCjQuz8hcu4pQS8MGc9Jtkdit2tycIR0UoGfhxYgdbzKgfJ+s53x9O7LcNUSHsP8Kx1wq7mN2ctj7Q7lr7bdlBscOKGQgPd0chFbPevtD28v8mN2FC6iL7Zx5sIOKkUVzqO448ZAJJW0I5GhC7GA81rcZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718032767; c=relaxed/simple;
	bh=+urT2uxejbnWTGWDhjERLm4pJwmoHG+HNqLAz7qV5P4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mG9ZP3CX451MD2l90YM80KoUcxC6VJ020Th7KxBGJAQrvQi84x1q84gMYWlg+sK440uoSJpVDPEkWHGQB+dXO6k3tctwlcuIyQ8OMhod6FRUcipf7tWZKnl1AFgA5SyBBDtqKVKSVmH0jpwEdrWYhLbRfamheQlxS9Lj1mY59gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sw2F+lfM; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: oak.zeng@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718032762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KKiu4qnDEEkxgkcxXe30X1MKX2KLMdPF1td6NPZnAM8=;
	b=sw2F+lfMZ3l8HawNA7kIWr3pK0lq7HnmPavMpWgUr7rU+1zbON9Ti/U85ptK/5XBbcEv87
	2BodlutKmiORSPlAcNIHof0xq71ZHIZgGYywZy2ISSYXzwGQnEez1TFWDIydAKJWuRKGOx
	OIYVeRO8ue/E5ZniP4Jy+Ay+5ChRqPo=
X-Envelope-To: jgg@ziepe.ca
X-Envelope-To: leon@kernel.org
X-Envelope-To: hch@lst.de
X-Envelope-To: robin.murphy@arm.com
X-Envelope-To: m.szyprowski@samsung.com
X-Envelope-To: joro@8bytes.org
X-Envelope-To: will@kernel.org
X-Envelope-To: chaitanyak@nvidia.com
X-Envelope-To: matthew.brost@intel.com
X-Envelope-To: thomas.hellstrom@intel.com
X-Envelope-To: corbet@lwn.net
X-Envelope-To: axboe@kernel.dk
X-Envelope-To: kbusch@kernel.org
X-Envelope-To: sagi@grimberg.me
X-Envelope-To: yishaih@nvidia.com
X-Envelope-To: shameerali.kolothum.thodi@huawei.com
X-Envelope-To: kevin.tian@intel.com
X-Envelope-To: alex.williamson@redhat.com
X-Envelope-To: jglisse@redhat.com
X-Envelope-To: akpm@linux-foundation.org
X-Envelope-To: linux-doc@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
X-Envelope-To: linux-block@vger.kernel.org
X-Envelope-To: linux-rdma@vger.kernel.org
X-Envelope-To: iommu@lists.linux.dev
X-Envelope-To: linux-nvme@lists.infradead.org
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: bvanassche@acm.org
X-Envelope-To: damien.lemoal@opensource.wdc.com
X-Envelope-To: amir73il@gmail.com
X-Envelope-To: josef@toxicpanda.com
X-Envelope-To: martin.petersen@oracle.com
X-Envelope-To: daniel@iogearbox.net
X-Envelope-To: dan.j.williams@intel.com
X-Envelope-To: jack@suse.com
X-Envelope-To: leonro@nvidia.com
X-Envelope-To: krishnaiah.bommu@intel.com
X-Envelope-To: himal.prasad.ghimiray@intel.com
Message-ID: <e04c1b4a-2677-4db5-bcd0-15e5a3616fa3@linux.dev>
Date: Mon, 10 Jun 2024 17:19:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to two steps
To: "Zeng, Oak" <oak.zeng@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: "leon@kernel.org" <leon@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Robin Murphy <robin.murphy@arm.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Chaitanya Kulkarni <chaitanyak@nvidia.com>,
 "Brost, Matthew" <matthew.brost@intel.com>,
 "Hellstrom, Thomas" <thomas.hellstrom@intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
 Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
 "Tian, Kevin" <kevin.tian@intel.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
 "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 Bart Van Assche <bvanassche@acm.org>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Amir Goldstein <amir73il@gmail.com>,
 "josef@toxicpanda.com" <josef@toxicpanda.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "Williams, Dan J" <dan.j.williams@intel.com>, "jack@suse.com"
 <jack@suse.com>, Leon Romanovsky <leonro@nvidia.com>,
 "Bommu, Krishnaiah" <krishnaiah.bommu@intel.com>,
 "Ghimiray, Himal Prasad" <himal.prasad.ghimiray@intel.com>
References: <cover.1709635535.git.leon@kernel.org>
 <SA1PR11MB6991CB2B1398948F4241E51992182@SA1PR11MB6991.namprd11.prod.outlook.com>
 <20240503164239.GB901876@ziepe.ca>
 <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <PH7PR11MB70047236290DC1CFF9150B8592C62@PH7PR11MB7004.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 10.06.24 17:12, Zeng, Oak wrote:
> Hi Jason, Leon,
>
> I come back to this thread to ask a question. Per the discussion in another thread, I have integrated the new dma-mapping API (the first 6 patches of this series) to DRM subsystem. The new API seems fit pretty good to our purpose, better than scatter-gather dma-mapping. So we want to continue work with you to adopt this new API.
>
> Did you test the new API in RDMA subsystem? Or this RFC series was just some untested codes sending out to get people's design feedback? Do you have refined version for us to try? I ask because we are seeing some issues but not sure whether it is caused by the new API. We are debugging but it would be good to also ask at the same time.

Hi, Zeng

I have tested this patch series. And a patch about NVMe will cause some 
call trace. But if you revert this patch about NVMe, the whole patches 
can work well. You can develop your patches based on this patch series.

It seems that "some agreements can not be reached" about NVMe. So NVMe 
patch can not work well. I do not delve into this NVMe patch.

Zhu Yanjun

>
> Cc Himal/Krishna who are also working/testing the new API.
>
> Thanks,
> Oak
>
>> -----Original Message-----
>> From: Jason Gunthorpe <jgg@ziepe.ca>
>> Sent: Friday, May 3, 2024 12:43 PM
>> To: Zeng, Oak <oak.zeng@intel.com>
>> Cc: leon@kernel.org; Christoph Hellwig <hch@lst.de>; Robin Murphy
>> <robin.murphy@arm.com>; Marek Szyprowski
>> <m.szyprowski@samsung.com>; Joerg Roedel <joro@8bytes.org>; Will
>> Deacon <will@kernel.org>; Chaitanya Kulkarni <chaitanyak@nvidia.com>;
>> Brost, Matthew <matthew.brost@intel.com>; Hellstrom, Thomas
>> <thomas.hellstrom@intel.com>; Jonathan Corbet <corbet@lwn.net>; Jens
>> Axboe <axboe@kernel.dk>; Keith Busch <kbusch@kernel.org>; Sagi
>> Grimberg <sagi@grimberg.me>; Yishai Hadas <yishaih@nvidia.com>;
>> Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>; Tian, Kevin
>> <kevin.tian@intel.com>; Alex Williamson <alex.williamson@redhat.com>;
>> Jérôme Glisse <jglisse@redhat.com>; Andrew Morton <akpm@linux-
>> foundation.org>; linux-doc@vger.kernel.org; linux-kernel@vger.kernel.org;
>> linux-block@vger.kernel.org; linux-rdma@vger.kernel.org;
>> iommu@lists.linux.dev; linux-nvme@lists.infradead.org;
>> kvm@vger.kernel.org; linux-mm@kvack.org; Bart Van Assche
>> <bvanassche@acm.org>; Damien Le Moal
>> <damien.lemoal@opensource.wdc.com>; Amir Goldstein
>> <amir73il@gmail.com>; josef@toxicpanda.com; Martin K. Petersen
>> <martin.petersen@oracle.com>; daniel@iogearbox.net; Williams, Dan J
>> <dan.j.williams@intel.com>; jack@suse.com; Leon Romanovsky
>> <leonro@nvidia.com>; Zhu Yanjun <zyjzyj2000@gmail.com>
>> Subject: Re: [RFC RESEND 00/16] Split IOMMU DMA mapping operation to
>> two steps
>>
>> On Thu, May 02, 2024 at 11:32:55PM +0000, Zeng, Oak wrote:
>>
>>>> Instead of teaching DMA to know these specific datatypes, let's separate
>>>> existing DMA mapping routine to two steps and give an option to
>> advanced
>>>> callers (subsystems) perform all calculations internally in advance and
>>>> map pages later when it is needed.
>>> I looked into how this scheme can be applied to DRM subsystem and GPU
>> drivers.
>>> I figured RDMA can apply this scheme because RDMA can calculate the
>>> iova size. Per my limited knowledge of rdma, user can register a
>>> memory region (the reg_user_mr vfunc) and memory region's sized is
>>> used to pre-allocate iova space. And in the RDMA use case, it seems
>>> the user registered region can be very big, e.g., 512MiB or even GiB
>> In RDMA the iova would be linked to the SVA granual we discussed
>> previously.
>>
>>> In GPU driver, we have a few use cases where we need dma-mapping. Just
>> name two:
>>> 1) userptr: it is user malloc'ed/mmap'ed memory and registers to gpu
>>> (in Intel's driver it is through a vm_bind api, similar to mmap). A
>>> userptr can be of any random size, depending on user malloc
>>> size. Today we use dma-map-sg for this use case. The down side of
>>> our approach is, during userptr invalidation, even if user only
>>> munmap partially of an userptr, we invalidate the whole userptr from
>>> gpu page table, because there is no way for us to partially
>>> dma-unmap the whole sg list. I think we can try your new API in this
>>> case. The main benefit of the new approach is the partial munmap
>>> case.
>> Yes, this is one of the main things it will improve.
>>
>>> We will have to pre-allocate iova for each userptr, and we have many
>>> userptrs of random size... So we might be not as efficient as RDMA
>>> case where I assume user register a few big memory regions.
>> You are already doing this. dma_map_sg() does exactly the same IOVA
>> allocation under the covers.
>>
>>> 2) system allocator: it is malloc'ed/mmap'ed memory be used for GPU
>>> program directly, without any other extra driver API call. We call
>>> this use case system allocator.
>>> For system allocator, driver have no knowledge of which virtual
>>> address range is valid in advance. So when GPU access a
>>> malloc'ed/mmap'ed address, we have a page fault. We then look up a
>>> CPU vma which contains the fault address. I guess we can use the CPU
>>> vma size to allocate the iova space of the same size?
>> No. You'd follow what we discussed in the other thread.
>>
>> If you do a full SVA then you'd split your MM space into granuals and
>> when a fault hits a granual you'd allocate the IOVA for the whole
>> granual. RDMA ODP is using a 512M granual currently.
>>
>> If you are doing sub ranges then you'd probably allocate the IOVA for
>> the well defined sub range (assuming the typical use case isn't huge)
>>
>>> But there will be a true difficulty to apply your scheme to this use
>>> case. It is related to the STICKY flag. As I understand it, the
>>> sticky flag is designed for driver to mark "this page/pfn has been
>>> populated, no need to re-populate again", roughly...Unlike userptr
>>> and RDMA use cases where the backing store of a buffer is always in
>>> system memory, in the system allocator use case, the backing store
>>> can be changing b/t system memory and GPU's device private
>>> memory. Even worse, we have to assume the data migration b/t system
>>> and GPU is dynamic. When data is migrated to GPU, we don't need
>>> dma-map. And when migration happens to a pfn with STICKY flag, we
>>> still need to repopulate this pfn. So you can see, it is not easy to
>>> apply this scheme to this use case. At least I can't see an obvious
>>> way.
>> You are already doing this today, you are keeping the sg list around
>> until you unmap it.
>>
>> Instead of keeping the sg list you'd keep a much smaller datastructure
>> per-granual. The sticky bit is simply a convient way for ODP to manage
>> the smaller data structure, you don't have to use it.
>>
>> But you do need to keep track of what pages in the granual have been
>> DMA mapped - sg list was doing this before. This could be a simple
>> bitmap array matching the granual size.
>>
>> Looking (far) forward we may be able to have a "replace" API that
>> allows installing a new page unconditionally regardless of what is
>> already there.
>>
>> Jason

-- 
Best Regards,
Yanjun.Zhu


