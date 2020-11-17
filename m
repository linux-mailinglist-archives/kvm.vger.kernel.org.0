Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17FF2B5B22
	for <lists+kvm@lfdr.de>; Tue, 17 Nov 2020 09:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgKQIj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Nov 2020 03:39:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgKQIj5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Nov 2020 03:39:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605602395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n1R2Oej2qk/ViRPwh0/U2GX+OhMC9Ake3lJNa//gEoY=;
        b=F4IycsIFgMf6hWr9KY6VEC/KRRNFwZj6RDLh/9U6Wp4VUuPIxxJ1+LxQdR8i2eo+33D/+v
        UCj0JeT7/kSl576AbCq6FejUzhXflJ5/JhRt5v2WQrU7iwNpxd4JPrE8uqXvVi7a2G4Jac
        M9zbKgB32zquNCqfxIi0PGcHPWS/tvQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-526-5KeOuAeIMG6pvM2MHmcMaw-1; Tue, 17 Nov 2020 03:39:49 -0500
X-MC-Unique: 5KeOuAeIMG6pvM2MHmcMaw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 706FC8030C7;
        Tue, 17 Nov 2020 08:39:47 +0000 (UTC)
Received: from [10.36.113.230] (ovpn-113-230.ams2.redhat.com [10.36.113.230])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A67925D9CC;
        Tue, 17 Nov 2020 08:39:39 +0000 (UTC)
Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        Zhangfei Gao <zhangfei.gao@linaro.org>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Cc:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "peter.maydell@linaro.org" <peter.maydell@linaro.org>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "bbhushan2@marvell.com" <bbhushan2@marvell.com>
References: <20200414150607.28488-1-eric.auger@redhat.com>
 <eb27f625-ad7a-fcb5-2185-5471e4666f09@linaro.org>
 <06fe02f7-2556-8986-2f1e-dcdf59773b8c@redhat.com>
 <c7786a2a314e4c4ab37ef157ddfa23af@huawei.com>
 <3858dd8c-ee55-b0d7-96cc-3c047ba8f652@redhat.com>
 <9e323c4668e94ea89beec3689376b893@huawei.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <a96395ff-09c2-8839-7a72-7b4031b5a5f4@redhat.com>
Date:   Tue, 17 Nov 2020 09:39:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <9e323c4668e94ea89beec3689376b893@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shameer,

On 5/13/20 5:57 PM, Shameerali Kolothum Thodi wrote:
> Hi Eric,
> 
>> -----Original Message-----
>> From: Auger Eric [mailto:eric.auger@redhat.com]
>> Sent: 13 May 2020 14:29
>> To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>;
>> Zhangfei Gao <zhangfei.gao@linaro.org>; eric.auger.pro@gmail.com;
>> iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
>> kvm@vger.kernel.org; kvmarm@lists.cs.columbia.edu; will@kernel.org;
>> joro@8bytes.org; maz@kernel.org; robin.murphy@arm.com
>> Cc: jean-philippe@linaro.org; alex.williamson@redhat.com;
>> jacob.jun.pan@linux.intel.com; yi.l.liu@intel.com; peter.maydell@linaro.org;
>> tn@semihalf.com; bbhushan2@marvell.com
>> Subject: Re: [PATCH v11 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
>>
> [...]
> 
>>>>> Yes that's normal this series is not meant to support vSVM at this stage.
>>>>>
>>>>> I intend to add the missing pieces during the next weeks.
>>>>
>>>> Thanks for that. I have made an attempt to add the vSVA based on
>>>> your v10 + JPBs sva patches. The host kernel and Qemu changes can
>>>> be found here[1][2].
>>>>
>>>> This basically adds multiple pasid support on top of your changes.
>>>> I have done some basic sanity testing and we have some initial success
>>>> with the zip vf dev on our D06 platform. Please note that the STALL event is
>>>> not yet supported though, but works fine if we mlock() guest usr mem.
>>>
>>> I have added STALL support for our vSVA prototype and it seems to be
>>> working(on our hardware). I have updated the kernel and qemu branches
>> with
>>> the same[1][2]. I should warn you though that these are prototype code and I
>> am pretty
>>> much re-using the VFIO_IOMMU_SET_PASID_TABLE interface for almost
>> everything.
>>> But thought of sharing, in case if it is useful somehow!.
>>
>> Thank you again for sharing the POC. I looked at the kernel and QEMU
>> branches.
>>
>> Here are some preliminary comments:
>> - "arm-smmu-v3: Reset S2TTB while switching back from nested stage":  as
>> you mentionned S2TTB reset now is featured in v11
> 
> Yes.
> 
>> - "arm-smmu-v3: Add support for multiple pasid in nested mode": I could
>> easily integrate this into my series. Update the iommu api first and
>> pass multiple CD info in a separate patch
> 
> Ok.
in v12, I added
[PATCH v12 14/15] iommu/smmuv3: Accept configs with more than one
context descriptor

I don't think you need to add s1cdmax addition as we already have
pasid_bits which should do the job.

>> - "arm-smmu-v3: Add support to Invalidate CD": CD invalidation should be
>> cascaded to host through the PASID cache invalidation uapi (no pb you
>> warned us for the POC you simply used VFIO_IOMMU_SET_PASID_TABLE). I
>> think I should add this support in my original series although it does
>> not seem to trigger any issue up to now.
> 
> Agree. Cache invalidation uapi is a better interface for this. Also I don’t think
> this matters for non-vsva cases as Guest kernel table/CD(pasid 0) will never
> get invalidated. 
in v12 I added [PATCH v12 15/15] iommu/smmuv3: Add PASID cache
invalidation per PASID. I have not tested it though.
> 
>> - "arm-smmu-v3: Remove duplication of fault propagation". I understand
>> the transcode is done somewhere else with SVA but we still need to do it
>> if a single CD is used, right? I will review the SVA code to better
>> understand.

Since I have rebase on 5.10-rc4 you will still have this duplication to
handle.
> 
> Hmm..not sure. Need to take another look to see whether we need a special
> handling for single CD or not.
> 
>> - for the STALL response injection I would tend to use a new VFIO region
>> for responses. At the moment there is a single VFIO region for reporting
>> the fault.

in v12 I added a new VFIO region to inject your fault. This was tested
with dummy event injection, this should work properly.

If we clearly identify all the public dependencies needed for vSVA/ARM I
can help you respinning on top of them

Thanks

Eric
> 
> Sure. That will be much cleaner and probably improve the context switch
> latency. Another thing I noted with STALL is that pasid_valid flag needs to be
> taken care in the SVA kernel path. 
> 
> "iommu: Remove pasid validity check for STALL model page response msg"
> Not sure this one is a proper way to handle this.
>  
>> On QEMU side:
>> - I am currently working on 3.2 range invalidation support which is
>> needed for DPDK/VFIO
>> - While at it I will look at how to incrementally introduce some of the
>> features you need in this series.
> 
> Ok. 
> 
> Thanks for taking a look at the POC.
> 
> Cheers,
> Shameer
> 

