Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BF546E5C9
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhLIJro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 04:47:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56840 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229505AbhLIJrn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 04:47:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639043050;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v7QNiQkm4JpmXjlb9xd1Ey78eIbVoq+bdtr4jOgwpkc=;
        b=a6t/vHwDeEY9OwEqCoQWOyk3lvLHQa7+HKp9of6dKK/zZ9Yc2k14MYIATuW0OT1i/TKvlA
        aNWPdDBuyR/CxJCLIYbaW83k4NCePlrTx9z0KPOlWvSU/JYqA3WuvpIiCHf9SLjy6rU308
        dB9+M5UuOgPBCIPPEJrrlz3vEpAn80E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-566-HupJl0zSM2ijwbRbVXNm7w-1; Thu, 09 Dec 2021 04:44:08 -0500
X-MC-Unique: HupJl0zSM2ijwbRbVXNm7w-1
Received: by mail-wm1-f72.google.com with SMTP id bg20-20020a05600c3c9400b0033a9300b44bso2250277wmb.2
        for <kvm@vger.kernel.org>; Thu, 09 Dec 2021 01:44:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=v7QNiQkm4JpmXjlb9xd1Ey78eIbVoq+bdtr4jOgwpkc=;
        b=LYg1hMIwuUDuV0I+7MaoTCZdGnei9KbLoPw6LVE3x0AAbsybckRzDk8Gv9dICYksUl
         vNV0UFdyMG1NMg6LAtBd/R3GtE66xkXj9llbzkt9XXdnjMNSCy3sOOfUgAt3a7x5xvz6
         /R2PpWMwY4tKUvMkAu5UnnaxeBOnbJvX1X5cQHEQI/ntZMRp6jfoUhm+jm/AU9V/lEO8
         6f6GcdzZ47h+E94sPuCX4ojKgdPFTfeM21SZDqydN4L30mcxAwnY2FrgLrj7Y8vleUip
         pLDJNEGRv44+hCIjUI7h6dq9O0WBwFEIROHcvaSaP98ZB42cY/iO7Aad+5ADGYYUBR3/
         ZWcQ==
X-Gm-Message-State: AOAM530rIkONe3Od7rcSwjcF23j4vyMMB5v+MH0HUp8gpF1sUhmtZhzO
        KnK42VtYa0eQAqnLGsV+piJ6blCfVyTUjQ+Ubtx2lgYzoD3L5lP/bAm4WeIxwk2iIh3GpVk0aNe
        MgXi40EyhocLa
X-Received: by 2002:adf:f602:: with SMTP id t2mr5135701wrp.539.1639043047493;
        Thu, 09 Dec 2021 01:44:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNkNDQt3yChW2LUPSakGrA3WpwiI2Mo0kl4bKJueL/Ht/+/n6Myy+zN8xmOe8F1FBXlSDz5Q==
X-Received: by 2002:adf:f602:: with SMTP id t2mr5135665wrp.539.1639043047277;
        Thu, 09 Dec 2021 01:44:07 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p27sm4984658wmi.28.2021.12.09.01.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 01:44:06 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "will@kernel.org" <will@kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
 <BN9PR11MB5276E882C5CC5946CA0D4C6A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <0dd640fc-18d9-9730-6210-1e4786290aec@redhat.com>
Date:   Thu, 9 Dec 2021 10:44:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <BN9PR11MB5276E882C5CC5946CA0D4C6A8C709@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kevin,

On 12/9/21 4:21 AM, Tian, Kevin wrote:
>> From: Jason Gunthorpe <jgg@nvidia.com>
>> Sent: Wednesday, December 8, 2021 8:56 PM
>>
>> On Wed, Dec 08, 2021 at 08:33:33AM +0100, Eric Auger wrote:
>>> Hi Baolu,
>>>
>>> On 12/8/21 3:44 AM, Lu Baolu wrote:
>>>> Hi Eric,
>>>>
>>>> On 12/7/21 6:22 PM, Eric Auger wrote:
>>>>> On 12/6/21 11:48 AM, Joerg Roedel wrote:
>>>>>> On Wed, Oct 27, 2021 at 12:44:20PM +0200, Eric Auger wrote:
>>>>>>> Signed-off-by: Jean-Philippe Brucker<jean-philippe.brucker@arm.com>
>>>>>>> Signed-off-by: Liu, Yi L<yi.l.liu@linux.intel.com>
>>>>>>> Signed-off-by: Ashok Raj<ashok.raj@intel.com>
>>>>>>> Signed-off-by: Jacob Pan<jacob.jun.pan@linux.intel.com>
>>>>>>> Signed-off-by: Eric Auger<eric.auger@redhat.com>
>>>>>> This Signed-of-by chain looks dubious, you are the author but the last
>>>>>> one in the chain?
>>>>> The 1st RFC in Aug 2018
>>>>> (https://lists.cs.columbia.edu/pipermail/kvmarm/2018-
>> August/032478.html)
>>>>> said this was a generalization of Jacob's patch
>>>>>
>>>>>
>>>>>    [PATCH v5 01/23] iommu: introduce bind_pasid_table API function
>>>>>
>>>>>
>>>>>
>>>>> https://lists.linuxfoundation.org/pipermail/iommu/2018-
>> May/027647.html
>>>>> So indeed Jacob should be the author. I guess the multiple rebases got
>>>>> this eventually replaced at some point, which is not an excuse. Please
>>>>> forgive me for that.
>>>>> Now the original patch already had this list of SoB so I don't know if I
>>>>> shall simplify it.
>>>> As we have decided to move the nested mode (dual stages)
>> implementation
>>>> onto the developing iommufd framework, what's the value of adding this
>>>> into iommu core?
>>> The iommu_uapi_attach_pasid_table uapi should disappear indeed as it is
>>> is bound to be replaced by /dev/iommu fellow API.
>>> However until I can rebase on /dev/iommu code I am obliged to keep it to
>>> maintain this integration, hence the RFC.
>> Indeed, we are getting pretty close to having the base iommufd that we
>> can start adding stuff like this into. Maybe in January, you can look
>> at some parts of what is evolving here:
>>
>> https://github.com/jgunthorpe/linux/commits/iommufd
>> https://github.com/LuBaolu/intel-iommu/commits/iommu-dma-ownership-
>> v2
>> https://github.com/luxis1999/iommufd/commits/iommufd-v5.16-rc2
>>
>> From a progress perspective I would like to start with simple 'page
>> tables in userspace', ie no PASID in this step.
>>
>> 'page tables in userspace' means an iommufd ioctl to create an
>> iommu_domain where the IOMMU HW is directly travesering a
>> device-specific page table structure in user space memory. All the HW
>> today implements this by using another iommu_domain to allow the IOMMU
>> HW DMA access to user memory - ie nesting or multi-stage or whatever.
> One clarification here in case people may get confused based on the
> current iommu_domain definition. Jason brainstormed with us on how
> to represent 'user page table' in the IOMMU sub-system. One is to
> extend iommu_domain as a general representation for any page table
> instance. The other option is to create new representations for user
> page tables and then link them under existing iommu_domain.
>
> This context is based on the 1st option. and As Jason said in the bottom
> we still need to sketch out whether it works as expected. 😊
>
>> This would come along with some ioctls to invalidate the IOTLB.
>>
>> I'm imagining this step as a iommu_group->op->create_user_domain()
>> driver callback which will create a new kind of domain with
>> domain-unique ops. Ie map/unmap related should all be NULL as those
>> are impossible operations.
>>
>> From there the usual struct device (ie RID) attach/detatch stuff needs
>> to take care of routing DMAs to this iommu_domain.
> Usage-wise this covers the guest IOVA requirements i.e. when the guest
> kernel enables vIOMMU for kernel DMA-API mappings or for device
> assignment to guest userspace.
>
> For intel this means optimization to the existing shadow-based vIOMMU
> implementation.
>
> For ARM this actually enables guest IOVA usage for the first time (correct
> me Eric?).
Yes that's correct. This is the scope of this series (single PASID)
>  IIRC SMMU doesn't support caching mode while write-protecting
> guest I/O page table was considered a no-go. So nesting is considered as
> the only option to support that.
that's correct too. No 'caching mode' provisionned in the SMMU spec. I
thought it would just be a matter of adding 1 bit in an ID reg though.

Thanks

Eric
>
> and once 'user pasid table' is installed, this actually means guest SVA usage
> can also partially work for ARM if I/O page fault is not incurred.
>
>> Step two would be to add the ability for an iommufd using driver to
>> request that a RID&PASID is connected to an iommu_domain. This
>> connection can be requested for any kind of iommu_domain, kernel owned
>> or user owned.
>>
>> I don't quite have an answer how exactly the SMMUv3 vs Intel
>> difference in PASID routing should be resolved.
> For kernel owned the iommufd interface should be generic as the
> vendor difference is managed by the kernel itself.
>
> For user owned we'll need new uAPIs for user to specify PASID. 
> As I replied in another thread only Intel currently requires it due to
> mdev. But other vendors could also do so when they decide to 
> support mdev one day.
>
>> to get answers I'm hoping to start building some sketch RFCs for these
>> different things on iommufd, hopefully in January. I'm looking at user
>> page tables, PASID, dirty tracking and userspace IO fault handling as
>> the main features iommufd must tackle.
> Make sense.
>
>> The purpose of the sketches would be to validate that the HW features
>> we want to exposed can work will with the choices the base is making.
>>
>> Jason
> Thanks
> Kevin

