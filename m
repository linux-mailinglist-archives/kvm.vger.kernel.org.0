Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB8B2FBA3C
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389266AbhASOsU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:48:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27868 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389487AbhASKFV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:05:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611050614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I/9Q+F90NAKj/f83iclQUQZ5P8dwgMK4bLugHzNFnF0=;
        b=Iz10g9z7rUR+q01jTfl1MBwH50r/GwBgj+962rE+d9Dpd1BFm8+4sgIXCafsnyh8Gr43VR
        wSvQ2N2kUeGAgiMQA2V7/039GhhmMokFwRSsrN27XRHFXHq9WN/9xxX/6tMCHCDXLD+6hs
        tuVTGF/AqcuxqwV00Ey6/aXD7rP2fjA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-JRJTFJ6mPZmwqk35DQVIIA-1; Tue, 19 Jan 2021 05:03:30 -0500
X-MC-Unique: JRJTFJ6mPZmwqk35DQVIIA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D424A612A3;
        Tue, 19 Jan 2021 10:03:28 +0000 (UTC)
Received: from [10.36.112.67] (ovpn-112-67.ams2.redhat.com [10.36.112.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7DE626062F;
        Tue, 19 Jan 2021 10:03:21 +0000 (UTC)
Subject: Re: [PATCH v7 02/16] iommu/smmu: Report empty domain nesting info
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Vivek Gautam <vivek.gautam@arm.com>
Cc:     "Sun, Yi Y" <yi.y.sun@intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@gmail.com" <stefanha@gmail.com>,
        Will Deacon <will@kernel.org>,
        "list@263.net:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Wu, Hao" <hao.wu@intel.com>, Robin Murphy <robin.murphy@arm.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>
References: <1599734733-6431-1-git-send-email-yi.l.liu@intel.com>
 <1599734733-6431-3-git-send-email-yi.l.liu@intel.com>
 <CAFp+6iFob_fy1cTgcEv0FOXBo70AEf3Z1UvXgPep62XXnLG9Gw@mail.gmail.com>
 <DM5PR11MB14356D5688CA7DC346AA32DBC3AA0@DM5PR11MB1435.namprd11.prod.outlook.com>
 <CAFp+6iEnh6Tce26F0RHYCrQfiHrkf-W3_tXpx+ysGiQz6AWpEw@mail.gmail.com>
 <DM5PR11MB1435D9ED79B2BE9C8F235428C3A90@DM5PR11MB1435.namprd11.prod.outlook.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <6bcd5229-9cd3-a78c-ccb2-be92f2add373@redhat.com>
Date:   Tue, 19 Jan 2021 11:03:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <DM5PR11MB1435D9ED79B2BE9C8F235428C3A90@DM5PR11MB1435.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi, Vivek,

On 1/13/21 6:56 AM, Liu, Yi L wrote:
> Hi Vivek,
> 
>> From: Vivek Gautam <vivek.gautam@arm.com>
>> Sent: Tuesday, January 12, 2021 7:06 PM
>>
>> Hi Yi,
>>
>>
>> On Tue, Jan 12, 2021 at 2:51 PM Liu, Yi L <yi.l.liu@intel.com> wrote:
>>>
>>> Hi Vivek,
>>>
>>>> From: Vivek Gautam <vivek.gautam@arm.com>
>>>> Sent: Tuesday, January 12, 2021 2:50 PM
>>>>
>>>> Hi Yi,
>>>>
>>>>
>>>> On Thu, Sep 10, 2020 at 4:13 PM Liu Yi L <yi.l.liu@intel.com> wrote:
>>>>>
>>>>> This patch is added as instead of returning a boolean for
>>>> DOMAIN_ATTR_NESTING,
>>>>> iommu_domain_get_attr() should return an iommu_nesting_info
>> handle.
>>>> For
>>>>> now, return an empty nesting info struct for now as true nesting is not
>>>>> yet supported by the SMMUs.
>>>>>
>>>>> Cc: Will Deacon <will@kernel.org>
>>>>> Cc: Robin Murphy <robin.murphy@arm.com>
>>>>> Cc: Eric Auger <eric.auger@redhat.com>
>>>>> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>>> Suggested-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>>>> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
>>>>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>>>> Reviewed-by: Eric Auger <eric.auger@redhat.com>
>>>>> ---
>>>>> v5 -> v6:
>>>>> *) add review-by from Eric Auger.
>>>>>
>>>>> v4 -> v5:
>>>>> *) address comments from Eric Auger.
>>>>> ---
>>>>>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 29
>>>> +++++++++++++++++++++++++++--
>>>>>  drivers/iommu/arm/arm-smmu/arm-smmu.c       | 29
>>>> +++++++++++++++++++++++++++--
>>>>>  2 files changed, 54 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> index 7196207..016e2e5 100644
>>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>>> @@ -3019,6 +3019,32 @@ static struct iommu_group
>>>> *arm_smmu_device_group(struct device *dev)
>>>>>         return group;
>>>>>  }
>>>>>
>>>>> +static int arm_smmu_domain_nesting_info(struct
>> arm_smmu_domain
>>>> *smmu_domain,
>>>>> +                                       void *data)
>>>>> +{
>>>>> +       struct iommu_nesting_info *info = (struct iommu_nesting_info
>>>> *)data;
>>>>> +       unsigned int size;
>>>>> +
>>>>> +       if (!info || smmu_domain->stage !=
>> ARM_SMMU_DOMAIN_NESTED)
>>>>> +               return -ENODEV;
>>>>> +
>>>>> +       size = sizeof(struct iommu_nesting_info);
>>>>> +
>>>>> +       /*
>>>>> +        * if provided buffer size is smaller than expected, should
>>>>> +        * return 0 and also the expected buffer size to caller.
>>>>> +        */
>>>>> +       if (info->argsz < size) {
>>>>> +               info->argsz = size;
>>>>> +               return 0;
>>>>> +       }
>>>>> +
>>>>> +       /* report an empty iommu_nesting_info for now */
>>>>> +       memset(info, 0x0, size);
>>>>> +       info->argsz = size;
>>>>> +       return 0;
>>>>> +}
>>>>> +
>>>>>  static int arm_smmu_domain_get_attr(struct iommu_domain
>> *domain,
>>>>>                                     enum iommu_attr attr, void *data)
>>>>>  {
>>>>> @@ -3028,8 +3054,7 @@ static int
>> arm_smmu_domain_get_attr(struct
>>>> iommu_domain *domain,
>>>>>         case IOMMU_DOMAIN_UNMANAGED:
>>>>>                 switch (attr) {
>>>>>                 case DOMAIN_ATTR_NESTING:
>>>>> -                       *(int *)data = (smmu_domain->stage ==
>>>> ARM_SMMU_DOMAIN_NESTED);
>>>>> -                       return 0;
>>>>> +                       return
>> arm_smmu_domain_nesting_info(smmu_domain,
>>>> data);
>>>>
>>>> Thanks for the patch.
>>>> This would unnecessarily overflow 'data' for any caller that's expecting
>> only
>>>> an int data. Dump from one such issue that I was seeing when testing
>>>> this change along with local kvmtool changes is pasted below [1].
>>>>
>>>> I could get around with the issue by adding another (iommu_attr) -
>>>> DOMAIN_ATTR_NESTING_INFO that returns (iommu_nesting_info).
>>>
>>> nice to hear from you. At first, we planned to have a separate iommu_attr
>>> for getting nesting_info. However, we considered there is no existing user
>>> which gets DOMAIN_ATTR_NESTING, so we decided to reuse it for iommu
>> nesting
>>> info. Could you share me the code base you are using? If the error you
>>> encountered is due to this change, so there should be a place which gets
>>> DOMAIN_ATTR_NESTING.
>>
>> I am currently working on top of Eric's tree for nested stage support [1].
>> My best guess was that the vfio_pci_dma_fault_init() method [2] that is
>> requesting DOMAIN_ATTR_NESTING causes stack overflow, and corruption.
>> That's when I added a new attribute.
> 
> I see. I think there needs a change in the code there. Should also expect
> a nesting_info returned instead of an int anymore. @Eric, how about your
> opinion?
> 
> 	domain = iommu_get_domain_for_dev(&vdev->pdev->dev);
> 	ret = iommu_domain_get_attr(domain, DOMAIN_ATTR_NESTING, &info);
> 	if (ret || !(info.features & IOMMU_NESTING_FEAT_PAGE_RESP)) {
> 		/*
> 		 * No need go futher as no page request service support.
> 		 */
> 		return 0;
> 	}
Sure I think it is "just" a matter of synchro between the 2 series. Yi,
do you have plans to respin part of
[PATCH v7 00/16] vfio: expose virtual Shared Virtual Addressing to VMs
or would you allow me to embed this patch in my series.

Thanks

Eric
> 
> https://github.com/luxis1999/linux-vsva/blob/vsva-linux-5.9-rc6-v8%2BPRQ/drivers/vfio/pci/vfio_pci.c
> 
> Regards,
> Yi Liu
> 
>> I will soon publish my patches to the list for review. Let me know
>> your thoughts.
>>
>> [1] https://github.com/eauger/linux/tree/5.10-rc4-2stage-v13
>> [2] https://github.com/eauger/linux/blob/5.10-rc4-2stage-
>> v13/drivers/vfio/pci/vfio_pci.c#L494
>>
>> Thanks
>> Vivek
>>
>>>
>>> Regards,
>>> Yi Liu
>>
>> [snip]

