Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7E4FAB40
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 08:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfKMHum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 02:50:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37697 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725908AbfKMHum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 02:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573631440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rnpa5U4sj3xZkQya2G1T7YqUyI/VJOSBWTsouefmHoI=;
        b=cWsqhCSmLBrG9shAulHOIza1N77STYNvX/Gb36ESW2spKvgzar2JQGqFQ+Wx3+6ueg77x9
        v1I+lLv8mKKIeBjIRqnSGK/9jTlJazX+g0uvjUGsGY7c+GAVQAMehvwh81Uq0obHWhrAz8
        jlW5CB5BhPQI4hsz/Qb22xDMOQefMaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-Jyvm9L0NP2iCu0hdi7tQUA-1; Wed, 13 Nov 2019 02:50:37 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 701A718C6305;
        Wed, 13 Nov 2019 07:50:35 +0000 (UTC)
Received: from [10.36.116.54] (ovpn-116-54.ams2.redhat.com [10.36.116.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C12C6019C;
        Wed, 13 Nov 2019 07:50:05 +0000 (UTC)
Subject: Re: [RFC v2 1/3] vfio: VFIO_IOMMU_CACHE_INVALIDATE
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "jean-philippe.brucker@arm.com" <jean-philippe.brucker@arm.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <1571919983-3231-1-git-send-email-yi.l.liu@intel.com>
 <1571919983-3231-2-git-send-email-yi.l.liu@intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D5D04AD@SHSMSX104.ccr.corp.intel.com>
 <A2975661238FB949B60364EF0F2C25743A0D7C23@SHSMSX104.ccr.corp.intel.com>
 <20191105154224.3b894a9c@x1.home>
 <A2975661238FB949B60364EF0F2C25743A0EED2E@SHSMSX104.ccr.corp.intel.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <e3bc03ba-8537-dd1f-135a-520a695dc2b9@redhat.com>
Date:   Wed, 13 Nov 2019 08:50:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A0EED2E@SHSMSX104.ccr.corp.intel.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: Jyvm9L0NP2iCu0hdi7tQUA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 11/6/19 2:31 AM, Liu, Yi L wrote:
>> From: Alex Williamson [mailto:alex.williamson@redhat.com]
>> Sent: Wednesday, November 6, 2019 6:42 AM
>> To: Liu, Yi L <yi.l.liu@intel.com>
>> Subject: Re: [RFC v2 1/3] vfio: VFIO_IOMMU_CACHE_INVALIDATE
>>
>> On Fri, 25 Oct 2019 11:20:40 +0000
>> "Liu, Yi L" <yi.l.liu@intel.com> wrote:
>>
>>> Hi Kevin,
>>>
>>>> From: Tian, Kevin
>>>> Sent: Friday, October 25, 2019 5:14 PM
>>>> To: Liu, Yi L <yi.l.liu@intel.com>; alex.williamson@redhat.com;
>>>> Subject: RE: [RFC v2 1/3] vfio: VFIO_IOMMU_CACHE_INVALIDATE
>>>>
>>>>> From: Liu, Yi L
>>>>> Sent: Thursday, October 24, 2019 8:26 PM
>>>>>
>>>>> From: Liu Yi L <yi.l.liu@linux.intel.com>
>>>>>
>>>>> When the guest "owns" the stage 1 translation structures,  the
>>>>> host IOMMU driver has no knowledge of caching structure updates
>>>>> unless the guest invalidation requests are trapped and passed down to=
 the host.
>>>>>
>>>>> This patch adds the VFIO_IOMMU_CACHE_INVALIDATE ioctl with aims at
>>>>> propagating guest stage1 IOMMU cache invalidations to the host.
>>>>>
>>>>> Cc: Kevin Tian <kevin.tian@intel.com>
>>>>> Signed-off-by: Liu Yi L <yi.l.liu@linux.intel.com>
>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
>>>>> ---
>>>>>  drivers/vfio/vfio_iommu_type1.c | 55
>>>>> +++++++++++++++++++++++++++++++++++++++++
>>>>>  include/uapi/linux/vfio.h       | 13 ++++++++++
>>>>>  2 files changed, 68 insertions(+)
>>>>>
>>>>> diff --git a/drivers/vfio/vfio_iommu_type1.c
>>>>> b/drivers/vfio/vfio_iommu_type1.c index 96fddc1d..cd8d3a5 100644
>>>>> --- a/drivers/vfio/vfio_iommu_type1.c
>>>>> +++ b/drivers/vfio/vfio_iommu_type1.c
>>>>> @@ -124,6 +124,34 @@ struct vfio_regions {
>>>>>  #define IS_IOMMU_CAP_DOMAIN_IN_CONTAINER(iommu)=09\
>>>>>  =09=09=09=09=09(!list_empty(&iommu->domain_list))
>>>>>
>>>>> +struct domain_capsule {
>>>>> +=09struct iommu_domain *domain;
>>>>> +=09void *data;
>>>>> +};
>>>>> +
>>>>> +/* iommu->lock must be held */
>>>>> +static int
>>>>> +vfio_iommu_lookup_dev(struct vfio_iommu *iommu,
>>>>> +=09=09      int (*fn)(struct device *dev, void *data),
>>>>> +=09=09      void *data)
>>>>
>>>> 'lookup' usually means find a device and then return. But the real
>>>> purpose here is to loop all the devices within this container and
>>>> then do something. Does it make more sense to be vfio_iommu_for_each_d=
ev?
>>
>> +1
>>
>>> yep, I can replace it.
>>>
>>>>
>>>>> +{
>>>>> +=09struct domain_capsule dc =3D {.data =3D data};
>>>>> +=09struct vfio_domain *d;
>>> [...]
>>>> 2315,6 +2352,24 @@
>>>>> static long vfio_iommu_type1_ioctl(void *iommu_data,
>>>>>
>>>>>  =09=09return copy_to_user((void __user *)arg, &unmap, minsz) ?
>>>>>  =09=09=09-EFAULT : 0;
>>>>> +=09} else if (cmd =3D=3D VFIO_IOMMU_CACHE_INVALIDATE) {
>>>>> +=09=09struct vfio_iommu_type1_cache_invalidate ustruct;
>>>>
>>>> it's weird to call a variable as struct.
>>>
>>> Will fix it.
>>>
>>>>> +=09=09int ret;
>>>>> +
>>>>> +=09=09minsz =3D offsetofend(struct
>>>>> vfio_iommu_type1_cache_invalidate,
>>>>> +=09=09=09=09    info);
>>>>> +
>>>>> +=09=09if (copy_from_user(&ustruct, (void __user *)arg, minsz))
>>>>> +=09=09=09return -EFAULT;
>>>>> +
>>>>> +=09=09if (ustruct.argsz < minsz || ustruct.flags)
>>>>> +=09=09=09return -EINVAL;
>>>>> +
>>>>> +=09=09mutex_lock(&iommu->lock);
>>>>> +=09=09ret =3D vfio_iommu_lookup_dev(iommu, vfio_cache_inv_fn,
>>>>> +=09=09=09=09=09    &ustruct);
>>>>> +=09=09mutex_unlock(&iommu->lock);
>>>>> +=09=09return ret;
>>>>>  =09}
>>>>>
>>>>>  =09return -ENOTTY;
>>>>> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
>>>>> index 9e843a1..ccf60a2 100644
>>>>> --- a/include/uapi/linux/vfio.h
>>>>> +++ b/include/uapi/linux/vfio.h
>>>>> @@ -794,6 +794,19 @@ struct vfio_iommu_type1_dma_unmap {
>>>>>  #define VFIO_IOMMU_ENABLE=09_IO(VFIO_TYPE, VFIO_BASE + 15)
>>>>>  #define VFIO_IOMMU_DISABLE=09_IO(VFIO_TYPE, VFIO_BASE + 16)
>>>>>
>>>>> +/**
>>>>> + * VFIO_IOMMU_CACHE_INVALIDATE - _IOWR(VFIO_TYPE, VFIO_BASE +
>>>>> 24,
>>
>> What's going on with these ioctl numbers?  AFAICT[1] we've used up throu=
gh
>> VFIO_BASE + 21, this jumps to 24, the next patch skips to 27, then the l=
ast patch fills
>> in 28 & 29.  Thanks,
>=20
> Hi Alex,
>=20
> I rebase my patch to Eric's nested stage translation patches. His base al=
so introduced
> IOCTLs. I should have made it better. I'll try to sync with Eric to seria=
lize the IOCTLs.
>=20
> [PATCH v6 00/22] SMMUv3 Nested Stage Setup by Eric Auger
> https://lkml.org/lkml/2019/3/17/124

Feel free to choose your IOCTL numbers without taking care of my series.
I will adapt to yours if my work gets unblocked at some point.

Thanks

Eric
>=20
> Thanks,
> Yi Liu
>=20
>> Alex
>>
>> [1] git grep -h VFIO_BASE | grep "VFIO_BASE +" | grep -e ^#define | \
>>     awk '{print $NF}' | tr -d ')' | sort -u -n
>=20

