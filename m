Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA62351E03
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbhDASdx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:33:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237569AbhDASXI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 1 Apr 2021 14:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617301388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZiqbkW+fsGYOXlnxQRppzJEJzKV895R44yHk0nQoUrI=;
        b=XkxtYrS3Uh62myAQaCiuKLnUw4SG+cPWEDk0Vfz0X/816CglBRH8a+2SmTlomHlTPL4dvR
        zalhIWz6k35DBZ0EKCGzhDgZfeyulOQqxrsngiQ6jh7DYq0X2NDQK1qjyViBkqAEEl2JIz
        rgKajs4DzO7kcUTnj0OENAEVGMlqb78=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-427-beXxze8UPcWqRglpKTpo3A-1; Thu, 01 Apr 2021 09:20:38 -0400
X-MC-Unique: beXxze8UPcWqRglpKTpo3A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CA0483DD26;
        Thu,  1 Apr 2021 13:20:35 +0000 (UTC)
Received: from [10.36.112.13] (ovpn-112-13.ams2.redhat.com [10.36.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3BD9C5C1A1;
        Thu,  1 Apr 2021 13:20:25 +0000 (UTC)
Subject: Re: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than one
 context descriptor
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        yuzenghui <yuzenghui@huawei.com>
Cc:     "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        zhukeqian <zhukeqian1@huawei.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        wangxingang <wangxingang5@huawei.com>,
        jiangkunkun <jiangkunkun@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        lushenming <lushenming@huawei.com>,
        "vsethi@nvidia.com" <vsethi@nvidia.com>,
        "Wanghaibin (D)" <wanghaibin.wang@huawei.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
 <20210223205634.604221-14-eric.auger@redhat.com>
 <86614466-3c74-3a38-5f2e-6ac2f55c309a@huawei.com>
 <bf928484-b9da-a4bc-b761-e73483cb2323@redhat.com>
 <27a474c325fc46a092c2e11854baaccc@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ceaa8c69-abc8-50fa-6ae9-95217b1b7c4e@redhat.com>
Date:   Thu, 1 Apr 2021 15:20:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <27a474c325fc46a092c2e11854baaccc@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,
On 4/1/21 2:38 PM, Shameerali Kolothum Thodi wrote:
> 
> 
>> -----Original Message-----
>> From: Auger Eric [mailto:eric.auger@redhat.com]
>> Sent: 01 April 2021 12:49
>> To: yuzenghui <yuzenghui@huawei.com>
>> Cc: eric.auger.pro@gmail.com; iommu@lists.linux-foundation.org;
>> linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
>> kvmarm@lists.cs.columbia.edu; will@kernel.org; maz@kernel.org;
>> robin.murphy@arm.com; joro@8bytes.org; alex.williamson@redhat.com;
>> tn@semihalf.com; zhukeqian <zhukeqian1@huawei.com>;
>> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; wangxingang
>> <wangxingang5@huawei.com>; jiangkunkun <jiangkunkun@huawei.com>;
>> jean-philippe@linaro.org; zhangfei.gao@linaro.org; zhangfei.gao@gmail.com;
>> vivek.gautam@arm.com; Shameerali Kolothum Thodi
>> <shameerali.kolothum.thodi@huawei.com>; nicoleotsuka@gmail.com;
>> lushenming <lushenming@huawei.com>; vsethi@nvidia.com; Wanghaibin (D)
>> <wanghaibin.wang@huawei.com>
>> Subject: Re: [PATCH v14 13/13] iommu/smmuv3: Accept configs with more than
>> one context descriptor
>>
>> Hi Zenghui,
>>
>> On 3/30/21 11:23 AM, Zenghui Yu wrote:
>>> Hi Eric,
>>>
>>> On 2021/2/24 4:56, Eric Auger wrote:
>>>> In preparation for vSVA, let's accept userspace provided configs
>>>> with more than one CD. We check the max CD against the host iommu
>>>> capability and also the format (linear versus 2 level).
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>> Signed-off-by: Shameer Kolothum
>> <shameerali.kolothum.thodi@huawei.com>
>>>> ---
>>>>   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 13 ++++++++-----
>>>>   1 file changed, 8 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> index 332d31c0680f..ab74a0289893 100644
>>>> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
>>>> @@ -3038,14 +3038,17 @@ static int
>> arm_smmu_attach_pasid_table(struct
>>>> iommu_domain *domain,
>>>>           if (smmu_domain->s1_cfg.set)
>>>>               goto out;
>>>>   -        /*
>>>> -         * we currently support a single CD so s1fmt and s1dss
>>>> -         * fields are also ignored
>>>> -         */
>>>> -        if (cfg->pasid_bits)
>>>> +        list_for_each_entry(master, &smmu_domain->devices,
>>>> domain_head) {
>>>> +            if (cfg->pasid_bits > master->ssid_bits)
>>>> +                goto out;
>>>> +        }
>>>> +        if (cfg->vendor_data.smmuv3.s1fmt ==
>>>> STRTAB_STE_0_S1FMT_64K_L2 &&
>>>> +                !(smmu->features &
>> ARM_SMMU_FEAT_2_LVL_CDTAB))
>>>>               goto out;
>>>>             smmu_domain->s1_cfg.cdcfg.cdtab_dma = cfg->base_ptr;
>>>> +        smmu_domain->s1_cfg.s1cdmax = cfg->pasid_bits;
>>>> +        smmu_domain->s1_cfg.s1fmt =
>> cfg->vendor_data.smmuv3.s1fmt;
>>>
>>> And what about the SIDSS field?
>>>
>> I added this patch upon Shameer's request, to be more vSVA friendly.
>> Hower this series does not really target multiple CD support. At the
>> moment the driver only supports STRTAB_STE_1_S1DSS_SSID0 (0x2) I think.
>> At this moment maybe I can only check the s1dss field is 0x2. Or simply
>> removes this patch?
>>
>> Thoughts?
> 
> Right. This was useful for vSVA tests. But yes, to properly support multiple CDs
> we need to pass the S1DSS from Qemu. And that requires further changes.
> So I think it's better to remove this patch and reject S1CDMAX != 0 cases.
OK I will remove it

Thanks

Eric
> 
> Thanks,
> Shameer
>    
>>
>> Eric
> 

