Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694EDFCE33
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 19:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfKNS4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 13:56:40 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:12242 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfKNS4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 13:56:40 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dcda32f0000>; Thu, 14 Nov 2019 10:55:43 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 14 Nov 2019 10:56:38 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 14 Nov 2019 10:56:38 -0800
Received: from [10.25.73.195] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 14 Nov
 2019 18:56:30 +0000
Subject: Re: [PATCH v9 Kernel 3/5] vfio iommu: Add ioctl defination to unmap
 IOVA and return dirty bitmap
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <cjia@nvidia.com>, <kevin.tian@intel.com>, <ziye.yang@intel.com>,
        <changpeng.liu@intel.com>, <yi.l.liu@intel.com>,
        <mlevitsk@redhat.com>, <eskultet@redhat.com>, <cohuck@redhat.com>,
        <dgilbert@redhat.com>, <jonathan.davies@nutanix.com>,
        <eauger@redhat.com>, <aik@ozlabs.ru>, <pasic@linux.ibm.com>,
        <felipe@nutanix.com>, <Zhengxiao.zx@Alibaba-inc.com>,
        <shuangtai.tst@alibaba-inc.com>, <Ken.Xue@amd.com>,
        <zhi.a.wang@intel.com>, <yan.y.zhao@intel.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
References: <1573578220-7530-1-git-send-email-kwankhede@nvidia.com>
 <1573578220-7530-4-git-send-email-kwankhede@nvidia.com>
 <20191112153017.3c792673@x1.home>
 <a148c5e2-ad34-6973-de50-eab472ed38fb@nvidia.com>
 <20191113132219.5075b32e@x1.home>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <1f8fc51f-8bdc-7c0c-43ce-1b252f429260@nvidia.com>
Date:   Fri, 15 Nov 2019 00:26:26 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191113132219.5075b32e@x1.home>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573757743; bh=RzP5/om5XG5pGSmOVBYlwV5sCsgmfeCMPT39QGUesb0=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=o9HYxalqYdkkHGXwDHCRRDRucZY3lMbmDhelNmnPAFa7ZhMacDlbBVpTEdvFdnzBb
         WE4qO9+AN0ERHqjVO1zVN1ZszH/+4Vj/mdi6D7H3szAn0itk4QP7UGgRn289A2F9Mt
         CumlBaDhzUU6NCuY03DLDUnlQh8M7l3I70nONNNqyZdSmkC6B+erEtFsE8S+XSbae5
         vezDUDkYDE11Vv4RwGc2iOLb5QsUpHrlgPZn71c+EWtvK8rjVPAqsIElmEM6BlIa0+
         JroAH14UM0NSFwqbYDeKZunNaCaau9YAfVWWz1XcWHjOQRqHbu93h7gupbYxQIFPI1
         t+IItY8JedRMw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/14/2019 1:52 AM, Alex Williamson wrote:
> On Thu, 14 Nov 2019 01:22:39 +0530
> Kirti Wankhede <kwankhede@nvidia.com> wrote:
> 
>> On 11/13/2019 4:00 AM, Alex Williamson wrote:
>>> On Tue, 12 Nov 2019 22:33:38 +0530
>>> Kirti Wankhede <kwankhede@nvidia.com> wrote:
>>>    
>>>> With vIOMMU, during pre-copy phase of migration, while CPUs are still
>>>> running, IO virtual address unmap can happen while device still keeping
>>>> reference of guest pfns. Those pages should be reported as dirty before
>>>> unmap, so that VFIO user space application can copy content of those pages
>>>> from source to destination.
>>>>
>>>> IOCTL defination added here add bitmap pointer, size and flag. If flag
>>>
>>> definition, adds
>>>    
>>>> VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set and bitmap memory is allocated
>>>> and bitmap_size of set, then ioctl will create bitmap of pinned pages and
>>>
>>> s/of/is/
>>>    
>>>> then unmap those.
>>>>
>>>> Signed-off-by: Kirti Wankhede <kwankhede@nvidia.com>
>>>> Reviewed-by: Neo Jia <cjia@nvidia.com>
>>>> ---
>>>>    include/uapi/linux/vfio.h | 33 +++++++++++++++++++++++++++++++++
>>>>    1 file changed, 33 insertions(+)
>>>>
>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>> index 6fd3822aa610..72fd297baf52 100644
>>>> --- a/include/uapi/linux/vfio.h
>>>> +++ b/include/uapi/linux/vfio.h
>>>> @@ -925,6 +925,39 @@ struct vfio_iommu_type1_dirty_bitmap {
>>>>    
>>>>    #define VFIO_IOMMU_GET_DIRTY_BITMAP             _IO(VFIO_TYPE, VFIO_BASE + 17)
>>>>    
>>>> +/**
>>>> + * VFIO_IOMMU_UNMAP_DMA_GET_BITMAP - _IOWR(VFIO_TYPE, VFIO_BASE + 18,
>>>> + *				      struct vfio_iommu_type1_dma_unmap_bitmap)
>>>> + *
>>>> + * Unmap IO virtual addresses using the provided struct
>>>> + * vfio_iommu_type1_dma_unmap_bitmap.  Caller sets argsz.
>>>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get dirty bitmap
>>>> + * before unmapping IO virtual addresses. If this flag is not set, only IO
>>>> + * virtual address are unmapped without creating pinned pages bitmap, that
>>>> + * is, behave same as VFIO_IOMMU_UNMAP_DMA ioctl.
>>>> + * User should allocate memory to get bitmap and should set size of allocated
>>>> + * memory in bitmap_size field. One bit in bitmap is used to represent per page
>>>> + * consecutively starting from iova offset. Bit set indicates page at that
>>>> + * offset from iova is dirty.
>>>> + * The actual unmapped size is returned in the size field and bitmap of pages
>>>> + * in the range of unmapped size is returned in bitmap if flag
>>>> + * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP is set.
>>>> + *
>>>> + * No guarantee is made to the user that arbitrary unmaps of iova or size
>>>> + * different from those used in the original mapping call will succeed.
>>>> + */
>>>> +struct vfio_iommu_type1_dma_unmap_bitmap {
>>>> +	__u32        argsz;
>>>> +	__u32        flags;
>>>> +#define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
>>>> +	__u64        iova;                        /* IO virtual address */
>>>> +	__u64        size;                        /* Size of mapping (bytes) */
>>>> +	__u64        bitmap_size;                 /* in bytes */
>>>> +	void __user *bitmap;                      /* one bit per page */
>>>> +};
>>>> +
>>>> +#define VFIO_IOMMU_UNMAP_DMA_GET_BITMAP _IO(VFIO_TYPE, VFIO_BASE + 18)
>>>> +
>>>
>>> Why not extend VFIO_IOMMU_UNMAP_DMA to support this rather than add an
>>> ioctl that duplicates the functionality and extends it??
>>
>> We do want old userspace applications to work with new kernel and
>> vice-versa, right?
>>
>> If I try to change existing VFIO_IOMMU_UNMAP_DMA ioctl structure, say if
>> add 'bitmap_size' and 'bitmap' after 'size', with below code in old
>> kernel, old kernel & new userspace will work.
>>
>>           minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, size);
>>
>>           if (copy_from_user(&unmap, (void __user *)arg, minsz))
>>                   return -EFAULT;
>>
>>           if (unmap.argsz < minsz || unmap.flags)
>>                   return -EINVAL;
>>
>>
>> With new kernel it would change to:
>>           minsz = offsetofend(struct vfio_iommu_type1_dma_unmap, bitmap);
> 
> No, the minimum structure size still ends at size, we interpret flags
> and argsz to learn if the user understands those fields and optionally
> include them.  Therefore old userspace on new kernel continues to work.
> 
>>           if (copy_from_user(&unmap, (void __user *)arg, minsz))
>>                   return -EFAULT;
>>
>>           if (unmap.argsz < minsz || unmap.flags)
>>                   return -EINVAL;
>>
>> Then old userspace app will fail because unmap.argsz < minsz and might
>> be copy_from_user would cause seg fault because userspace sdk doesn't
>> contain new member variables.
>> We can't change the sequence to keep 'size' as last member, because then
>> new userspace app on old kernel will interpret it wrong.
> 
> If we have new userspace on old kernel, that userspace needs to be able
> to learn that this feature exists (new flag in the
> vfio_iommu_type1_info struct as suggested below) and only make use of it
> when available.  This is why the old kernel checks argsz against minsz.
> So long as the user passes something at least minsz in size, we have
> compatibility.  The old kernel doesn't understand the GET_DIRTY_BITMAP
> flag and will return an error if the user attempts to use it.  Thanks,
> 

Ok. So then VFIO_IOMMU_UNMAP_DMA_GET_BITMAP ioctl is not needed. I'll do 
the change. Again bitmap will be created considering smallest page size 
of iova_pgsizes

But VFIO_IOMMU_GET_DIRTY_BITMAP ioctl will still required, right?

Thanks,
Kirti

> Alex
>   
>>> Otherwise
>>> same comments as previous, in fact it's too bad we can't use this ioctl
>>> for both, but a DONT_UNMAP flag on the UNMAP_DMA ioctl seems a bit
>>> absurd.
>>>
>>> I suspect we also want a flags bit in VFIO_IOMMU_GET_INFO to indicate
>>> these capabilities are supported.
>>>    
>>
>> Ok. I'll add that.
>>
>>> Maybe for both ioctls we also want to define it as the user's
>>> responsibility to zero the bitmap, requiring the kernel to only set
>>> bits as necessary.
>>
>> Ok. Updating comment.
>>
>> Thanks,
>> Kirti
>>
>>> Thanks,
>>>
>>> Alex
>>>    
>>>>    /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
>>>>    
>>>>    /*
>>>    
>>
> 
