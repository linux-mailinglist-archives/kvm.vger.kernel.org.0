Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA1041133AA
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 19:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731684AbfLDSSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 13:18:41 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6592 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731300AbfLDSKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 13:10:39 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5de7f6a20001>; Wed, 04 Dec 2019 10:10:42 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 04 Dec 2019 10:10:38 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 04 Dec 2019 10:10:38 -0800
Received: from [10.25.73.41] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 4 Dec
 2019 18:10:29 +0000
Subject: Re: [PATCH v9 Kernel 2/5] vfio iommu: Add ioctl defination to get
 dirty pages bitmap.
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>
CC:     "cjia@nvidia.com" <cjia@nvidia.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Yang, Ziye" <ziye.yang@intel.com>,
        "Liu, Changpeng" <changpeng.liu@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "jonathan.davies@nutanix.com" <jonathan.davies@nutanix.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "aik@ozlabs.ru" <aik@ozlabs.ru>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "felipe@nutanix.com" <felipe@nutanix.com>,
        "Zhengxiao.zx@Alibaba-inc.com" <Zhengxiao.zx@Alibaba-inc.com>,
        "shuangtai.tst@alibaba-inc.com" <shuangtai.tst@alibaba-inc.com>,
        "Ken.Xue@amd.com" <Ken.Xue@amd.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-3-git-send-email-kwankhede@nvidia.com>
 <20191112153020.71406c44@x1.home>
 <324ce4f8-d655-ee37-036c-fc9ef9045bef@nvidia.com>
 <20191113130705.32c6b663@x1.home>
 <7f74a2a1-ba1c-9d4c-dc5e-343ecdd7d6d6@nvidia.com>
 <20191114140625.213e8a99@x1.home> <20191126005739.GA31144@joy-OptiPlex-7040>
 <20191203110412.055c38df@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <cce08ca5-79df-2839-16cd-15723b995c07@nvidia.com>
Date:   Wed, 4 Dec 2019 23:40:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191203110412.055c38df@x1.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1575483042; bh=R3imMCbDCbIFut9x45QFXqZeFNWbCNngI692/3ZuJqU=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=e5mCEYe/FG1QCKBd01tdF2bsyeysG4cCZWk2wwJCeNzXU+aAYlIWht54nsIw9yS+2
         MkmxbaUy6WN4JVK5a0asKqBLYPYCkUTtBsYJHsLsvKi6rhL/gsL2Y+X6tpS6uNncVM
         xzmK/PbOtBjne3IU74WHCi/gMUtTu/H00lB7te8iiszoMTGUVQwEXbLGPcdztWfbyj
         qkDvXOLJeFGFDuxLyIVCQSlakmZ4qGn8J0kAvwcS9pBo6P0wF2Eh+KROKiqFGdOrIf
         0XDGVBdBV5QKqPzolWb0xNZ3k1cfiaDtqj5nBazagrB6YXhZ9gTLU9OkIIVfsW1ejz
         XX4L20WvkREiQ==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/3/2019 11:34 PM, Alex Williamson wrote:
> On Mon, 25 Nov 2019 19:57:39 -0500
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
>> On Fri, Nov 15, 2019 at 05:06:25AM +0800, Alex Williamson wrote:
>>> On Fri, 15 Nov 2019 00:26:07 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>    
>>>> On 11/14/2019 1:37 AM, Alex Williamson wrote:
>>>>> On Thu, 14 Nov 2019 01:07:21 +0530
>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>      
>>>>>> On 11/13/2019 4:00 AM, Alex Williamson wrote:
>>>>>>> On Tue, 12 Nov 2019 22:33:37 +0530
>>>>>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>>>>>         
>>>>>>>> All pages pinned by vendor driver through vfio_pin_pages API should be
>>>>>>>> considered as dirty during migration. IOMMU container maintains a list of
>>>>>>>> all such pinned pages. Added an ioctl defination to get bitmap of such
>>>>>>>
>>>>>>> definition
>>>>>>>         
>>>>>>>> pinned pages for requested IO virtual address range.
>>>>>>>
>>>>>>> Additionally, all mapped pages are considered dirty when physically
>>>>>>> mapped through to an IOMMU, modulo we discussed devices opting in to
>>>>>>> per page pinning to indicate finer granularity with a TBD mechanism to
>>>>>>> figure out if any non-opt-in devices remain.
>>>>>>>         
>>>>>>
>>>>>> You mean, in case of device direct assignment (device pass through)?
>>>>>
>>>>> Yes, or IOMMU backed mdevs.  If vfio_dmas in the container are fully
>>>>> pinned and mapped, then the correct dirty page set is all mapped pages.
>>>>> We discussed using the vpfn list as a mechanism for vendor drivers to
>>>>> reduce their migration footprint, but we also discussed that we would
>>>>> need a way to determine that all participants in the container have
>>>>> explicitly pinned their working pages or else we must consider the
>>>>> entire potential working set as dirty.
>>>>>      
>>>>
>>>> How can vendor driver tell this capability to iommu module? Any suggestions?
>>>
>>> I think it does so by pinning pages.  Is it acceptable that if the
>>> vendor driver pins any pages, then from that point forward we consider
>>> the IOMMU group dirty page scope to be limited to pinned pages?  There
>> we should also be aware of that dirty page scope is pinned pages + unpinned pages,
>> which means ever since a page is pinned, it should be regarded as dirty
>> no matter whether it's unpinned later. only after log_sync is called and
>> dirty info retrieved, its dirty state should be cleared.
> 
> Yes, good point.  We can't just remove a vpfn when a page is unpinned
> or else we'd lose information that the page potentially had been
> dirtied while it was pinned.  Maybe that vpfn needs to move to a dirty
> list and both the currently pinned vpfns and the dirty vpfns are walked
> on a log_sync.  The dirty vpfns list would be cleared after a log_sync.
> The container would need to know that dirty tracking is enabled and
> only manage the dirty vpfns list when necessary.  Thanks,
> 

If page is unpinned, then that page is available in free page pool for 
others to use, then how can we say that unpinned page has valid data?

If suppose, one driver A unpins a page and when driver B of some other 
device gets that page and he pins it, uses it, and then unpins it, then 
how can we say that page has valid data for driver A?

Can you give one example where unpinned page data is considered reliable 
and valid?

Thanks,
Kirti

> Alex
>   
>>> are complications around non-singleton IOMMU groups, but I think we're
>>> already leaning towards that being a non-worthwhile problem to solve.
>>> So if we require that only singleton IOMMU groups can pin pages and we
>>> pass the IOMMU group as a parameter to
>>> vfio_iommu_driver_ops.pin_pages(), then the type1 backend can set a
>>> flag on its local vfio_group struct to indicate dirty page scope is
>>> limited to pinned pages.  We might want to keep a flag on the
>>> vfio_iommu struct to indicate if all of the vfio_groups for each
>>> vfio_domain in the vfio_iommu.domain_list dirty page scope limited to
>>> pinned pages as an optimization to avoid walking lists too often.  Then
>>> we could test if vfio_iommu.domain_list is not empty and this new flag
>>> does not limit the dirty page scope, then everything within each
>>> vfio_dma is considered dirty.
>>>     
>>>>>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>>>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>>>>>>> ---
>>>>>>>>     include/uapi/linux/vfio.h | 23 +++++++++++++++++++++++
>>>>>>>>     1 file changed, 23 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>>>>>> index 35b09427ad9f..6fd3822aa610 100644
>>>>>>>> --- a/include/uapi/linux/vfio.h
>>>>>>>> +++ b/include/uapi/linux/vfio.h
>>>>>>>> @@ -902,6 +902,29 @@ struct vfio_iommu_type1_dma_unmap {
>>>>>>>>     #define VFIO_IOMMU_ENABLE	_IO(VFIO_TYPE, VFIO_BASE + 15)
>>>>>>>>     #define VFIO_IOMMU_DISABLE	_IO(VFIO_TYPE, VFIO_BASE + 16)
>>>>>>>>     
>>>>>>>> +/**
>>>>>>>> + * VFIO_IOMMU_GET_DIRTY_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 17,
>>>>>>>> + *                                     struct vfio_iommu_type1_dirty_bitmap)
>>>>>>>> + *
>>>>>>>> + * IOCTL to get dirty pages bitmap for IOMMU container during migration.
>>>>>>>> + * Get dirty pages bitmap of given IO virtual addresses range using
>>>>>>>> + * struct vfio_iommu_type1_dirty_bitmap. Caller sets argsz, which is size of
>>>>>>>> + * struct vfio_iommu_type1_dirty_bitmap. User should allocate memory to get
>>>>>>>> + * bitmap and should set size of allocated memory in bitmap_size field.
>>>>>>>> + * One bit is used to represent per page consecutively starting from iova
>>>>>>>> + * offset. Bit set indicates page at that offset from iova is dirty.
>>>>>>>> + */
>>>>>>>> +struct vfio_iommu_type1_dirty_bitmap {
>>>>>>>> +	__u32        argsz;
>>>>>>>> +	__u32        flags;
>>>>>>>> +	__u64        iova;                      /* IO virtual address */
>>>>>>>> +	__u64        size;                      /* Size of iova range */
>>>>>>>> +	__u64        bitmap_size;               /* in bytes */
>>>>>>>
>>>>>>> This seems redundant.  We can calculate the size of the bitmap based on
>>>>>>> the iova size.
>>>>>>>        
>>>>>>
>>>>>> But in kernel space, we need to validate the size of memory allocated by
>>>>>> user instead of assuming user is always correct, right?
>>>>>
>>>>> What does it buy us for the user to tell us the size?  They could be
>>>>> wrong, they could be malicious.  The argsz field on the ioctl is mostly
>>>>> for the handshake that the user is competent, we should get faults from
>>>>> the copy-user operation if it's incorrect.
>>>>>     
>>>>
>>>> It is to mainly fail safe.
>>>>    
>>>>>>>> +	void __user *bitmap;                    /* one bit per page */
>>>>>>>
>>>>>>> Should we define that as a __u64* to (a) help with the size
>>>>>>> calculation, and (b) assure that we can use 8-byte ops on it?
>>>>>>>
>>>>>>> However, who defines page size?  Is it necessarily the processor page
>>>>>>> size?  A physical IOMMU may support page sizes other than the CPU page
>>>>>>> size.  It might be more important to indicate the expected page size
>>>>>>> than the bitmap size.  Thanks,
>>>>>>>        
>>>>>>
>>>>>> I see in QEMU and in vfio_iommu_type1 module, page sizes considered for
>>>>>> mapping are CPU page size, 4K. Do we still need to have such argument?
>>>>>
>>>>> That assumption exists for backwards compatibility prior to supporting
>>>>> the iova_pgsizes field in vfio_iommu_type1_info.  AFAIK the current
>>>>> interface has no page size assumptions and we should not add any.
>>>>
>>>> So userspace has iova_pgsizes information, which can be input to this
>>>> ioctl. Bitmap should be considering smallest page size. Does that makes
>>>> sense?
>>>
>>> I'm not sure.  I thought I had an argument that the iova_pgsize could
>>> indicate support for sizes smaller than the processor page size, which
>>> would make the user responsible for using a different base for their
>>> page size, but vfio_pgsize_bitmap() already masks out sub-page sizes.
>>> Clearly the vendor driver is pinning based on processor sized pages,
>>> but that's independent of an IOMMU and not part of a user ABI.
>>>
>>> I'm tempted to say your bitmap_size field has a use here, but it seems
>>> to fail in validating the user page size at the low extremes.  For
>>> example if we have a single page mapping, the user can specify the iova
>>> size as 4K (for example), but the minimum bitmap_size they can indicate
>>> is 1 byte, would we therefore assume the user's bitmap page size is 512
>>> bytes (ie. they provided us with 8 bits to describe a 4K range)?  We'd
>>> need to be careful to specify that the minimum iova_pgsize indicated
>>> page size is our lower bound as well.  But then what do we do if the
>>> user provides us with a smaller buffer than we expect?  For example, a
>>> 128MB iova range and only an 8-byte buffer.  Do we go ahead and assume
>>> a 2MB page size and fill the bitmap accordingly or do we generate an
>>> error?  If the latter, might we support that at some point in time and
>>> is it sufficient to let the user perform trial and error to test if that
>>> exists?  Thanks,
>>>
>>> Alex
>>>    
>>
> 
