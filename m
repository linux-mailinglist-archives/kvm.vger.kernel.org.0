Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C460215A44
	for <lists+kvm@lfdr.de>; Mon,  6 Jul 2020 17:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgGFPDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jul 2020 11:03:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50746 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729121AbgGFPDy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Jul 2020 11:03:54 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066F3NNF033785;
        Mon, 6 Jul 2020 11:03:49 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322nun44sv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 11:03:48 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 066F3l7X035838;
        Mon, 6 Jul 2020 11:03:47 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322nun43mu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 11:03:46 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066F0He2008635;
        Mon, 6 Jul 2020 15:01:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 322hd82f05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 15:01:51 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066F1mTZ29556810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 15:01:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C093B52050;
        Mon,  6 Jul 2020 15:01:48 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.49.44])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id DA42A52059;
        Mon,  6 Jul 2020 15:01:47 +0000 (GMT)
Subject: Re: [PATCH v3 1/1] s390: virtio: let arch accept devices without
 IOMMU feature
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, jasowang@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, thomas.lendacky@amd.com,
        david@gibson.dropbear.id.au, linuxram@us.ibm.com,
        heiko.carstens@de.ibm.com, gor@linux.ibm.com
References: <1592390637-17441-1-git-send-email-pmorel@linux.ibm.com>
 <1592390637-17441-2-git-send-email-pmorel@linux.ibm.com>
 <20200629115651-mutt-send-email-mst@kernel.org>
 <20200629180526.41d0732b.cohuck@redhat.com>
 <26ecd4c6-837b-1ce6-170b-a0155e4dd4d4@linux.ibm.com>
 <a677decc-5be3-8095-bc33-0f95634011f6@linux.ibm.com>
 <20200706163340.2ce7a5f2.cohuck@redhat.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <42f3733d-9f68-91b3-29f9-e88dd4495886@linux.ibm.com>
Date:   Mon, 6 Jul 2020 17:01:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200706163340.2ce7a5f2.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_11:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0
 cotscore=-2147483648 lowpriorityscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007060111
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-07-06 16:33, Cornelia Huck wrote:
> On Mon, 6 Jul 2020 15:37:37 +0200
> Pierre Morel <pmorel@linux.ibm.com> wrote:
> 
>> On 2020-07-02 15:03, Pierre Morel wrote:
>>>
>>>
>>> On 2020-06-29 18:05, Cornelia Huck wrote:
>>>> On Mon, 29 Jun 2020 11:57:14 -0400
>>>> "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>>>   
>>>>> On Wed, Jun 17, 2020 at 12:43:57PM +0200, Pierre Morel wrote:
>>>>>> An architecture protecting the guest memory against unauthorized host
>>>>>> access may want to enforce VIRTIO I/O device protection through the
>>>>>> use of VIRTIO_F_IOMMU_PLATFORM.
>>>>>>
>>>>>> Let's give a chance to the architecture to accept or not devices
>>>>>> without VIRTIO_F_IOMMU_PLATFORM.
>>>>>>
>>>>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>>>>> Acked-by: Jason Wang <jasowang@redhat.com>
>>>>>> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>>>> ---
>>>>>>    arch/s390/mm/init.c     |  6 ++++++
>>>>>>    drivers/virtio/virtio.c | 22 ++++++++++++++++++++++
>>>>>>    include/linux/virtio.h  |  2 ++
>>>>>>    3 files changed, 30 insertions(+)
>>>>   
>>>>>> @@ -179,6 +194,13 @@ int virtio_finalize_features(struct
>>>>>> virtio_device *dev)
>>>>>>        if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>>>>>>            return 0;
>>>>>> +    if (arch_needs_virtio_iommu_platform(dev) &&
>>>>>> +        !virtio_has_feature(dev, VIRTIO_F_IOMMU_PLATFORM)) {
>>>>>> +        dev_warn(&dev->dev,
>>>>>> +             "virtio: device must provide VIRTIO_F_IOMMU_PLATFORM\n");
>>>>>> +        return -ENODEV;
>>>>>> +    }
>>>>>> +
>>>>>>        virtio_add_status(dev, VIRTIO_CONFIG_S_FEATURES_OK);
>>>>>>        status = dev->config->get_status(dev);
>>>>>>        if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>>
>>>>> Well don't you need to check it *before* VIRTIO_F_VERSION_1, not after?
>>>>
>>>> But it's only available with VERSION_1 anyway, isn't it? So it probably
>>>> also needs to fail when this feature is needed if VERSION_1 has not been
>>>> negotiated, I think.
>>
>>
>> would be something like:
>>
>> -       if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
>> -               return 0;
>> +       if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1)) {
>> +               ret = arch_accept_virtio_features(dev);
>> +               if (ret)
>> +                       dev_warn(&dev->dev,
>> +                                "virtio: device must provide
>> VIRTIO_F_VERSION_1\n");
>> +               return ret;
>> +       }
> 
> That looks wrong; I think we want to validate in all cases. What about:
> 
> ret = arch_accept_virtio_features(dev); // this can include checking for
>                                          // older or newer features
> if (ret)
> 	// assume that the arch callback moaned already
> 	return ret;
> 
> if (!virtio_has_feature(dev, VIRTIO_F_VERSION_1))
> 	return 0;
> 
> // do the virtio-1 only FEATURES_OK dance

hum, you are right, I was too focused on keeping my simple 
arch_accept_virtio_features() function unchanged.
It must be more general.

> 
>>
>>
>> just a thought on the function name:
>> It becomes more general than just IOMMU_PLATFORM related.
>>
>> What do you think of:
>>
>> arch_accept_virtio_features()
> 
> Or maybe arch_validate_virtio_features()?

OK validated.

Thanks,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
