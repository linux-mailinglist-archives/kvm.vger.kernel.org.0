Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A7A447F6A
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbhKHMWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:22:38 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18884 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238145AbhKHMWh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Nov 2021 07:22:37 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CJfHO012249
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:19:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=XE2acagL4XX7hn/OmzGsKQcUd4HWdVz87iMv5l8OnpA=;
 b=lB5y5mSc+njtV7U9/4t/geHYYrqAicfuSpWIGtfEof/mh7UYYazBttIvUn1WjoL9xDaA
 w4kWi893yvj/rDfKlyQ9NuAHXN2mV4DH6bwPZundBOoW11J4gkoZlOda4XKX9SY9rW8N
 8jhTD606E6wJMqT8E/mIhjTyEKcf/EN20PY0RgewX8YeMbAR4MFVIf9ZQ516cJTTxxMA
 hxuW2Ivw7ovHguB3BuhR2+QG5jxr7L9msfXIW9eYGVvMyB0WICf6UL6piWd7lxRnWW0F
 DYmi0GTjPpQ8QLA9kCdo8XuTNG++mwJxPMEzduEkrzht4Boa/uNqIgRsfBU6Np+krdmO 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c641sgtd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 12:19:52 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1A8BsaWc024017
        for <kvm@vger.kernel.org>; Mon, 8 Nov 2021 12:19:52 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c641sgtc5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:19:52 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1A8CAOg3009525;
        Mon, 8 Nov 2021 12:19:49 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3c5hb9mkks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Nov 2021 12:19:49 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1A8CJk6v66126330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Nov 2021 12:19:46 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74E3A4204B;
        Mon,  8 Nov 2021 12:19:46 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB0814204F;
        Mon,  8 Nov 2021 12:19:45 +0000 (GMT)
Received: from [9.171.49.228] (unknown [9.171.49.228])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  8 Nov 2021 12:19:45 +0000 (GMT)
Message-ID: <01ae5d24-8c9f-eed4-2023-ecd80938736e@linux.ibm.com>
Date:   Mon, 8 Nov 2021 13:20:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [kvm-unit-tests PATCH 1/7] arm: virtio: move VIRTIO transport
 initialization inside virtio-mmio
Content-Language: en-US
To:     Andrew Jones <drjones@redhat.com>, Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com
References: <1630059440-15586-1-git-send-email-pmorel@linux.ibm.com>
 <1630059440-15586-2-git-send-email-pmorel@linux.ibm.com>
 <43587c22-e9c9-545d-1dad-5877b683a75c@redhat.com>
 <20211103074114.45cv5mkdcksxg4az@gator.home>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20211103074114.45cv5mkdcksxg4az@gator.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: dYwq5x4a3lXwUQuS1mrC5bdY_Clg3WdS
X-Proofpoint-ORIG-GUID: y4idOYtKaBNlSrWvZBs5t7Zln2rPTlEn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-08_03,2021-11-08_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 bulkscore=0 clxscore=1011 mlxscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 adultscore=0 lowpriorityscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111080076
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/21 08:41, Andrew Jones wrote:
> On Wed, Nov 03, 2021 at 08:00:09AM +0100, Thomas Huth wrote:
>> Sorry for the late reply - still trying to get my Inbox under control again ...
>>
>> On 27/08/2021 12.17, Pierre Morel wrote:
>>> To be able to use different VIRTIO transport in the future we need
>>> the initialisation entry call of the transport to be inside the
>>> transport file and keep the VIRTIO level transport agnostic.
>>>
>>> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
>>> ---
>>>    lib/virtio-mmio.c | 2 +-
>>>    lib/virtio-mmio.h | 2 --
>>>    lib/virtio.c      | 5 -----
>>>    3 files changed, 1 insertion(+), 8 deletions(-)
>>>
>>> diff --git a/lib/virtio-mmio.c b/lib/virtio-mmio.c
>>> index e5e8f660..fb8a86a3 100644
>>> --- a/lib/virtio-mmio.c
>>> +++ b/lib/virtio-mmio.c
>>> @@ -173,7 +173,7 @@ static struct virtio_device *virtio_mmio_dt_bind(u32 devid)
>>>    	return &vm_dev->vdev;
>>>    }
>>> -struct virtio_device *virtio_mmio_bind(u32 devid)
>>> +struct virtio_device *virtio_bind(u32 devid)
>>>    {
>>>    	return virtio_mmio_dt_bind(devid);
>>>    }
>>> diff --git a/lib/virtio-mmio.h b/lib/virtio-mmio.h
>>> index 250f28a0..73ddbd23 100644
>>> --- a/lib/virtio-mmio.h
>>> +++ b/lib/virtio-mmio.h
>>> @@ -60,6 +60,4 @@ struct virtio_mmio_device {
>>>    	void *base;
>>>    };
>>> -extern struct virtio_device *virtio_mmio_bind(u32 devid);
>>> -
>>>    #endif /* _VIRTIO_MMIO_H_ */
>>> diff --git a/lib/virtio.c b/lib/virtio.c
>>> index 69054757..e10153b9 100644
>>> --- a/lib/virtio.c
>>> +++ b/lib/virtio.c
>>> @@ -123,8 +123,3 @@ void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
>>>    	return ret;
>>>    }
>>> -
>>> -struct virtio_device *virtio_bind(u32 devid)
>>> -{
>>> -	return virtio_mmio_bind(devid);
>>> -}
>>>
>>
>> I agree that this needs to be improved somehow, but I'm not sure whether
>> moving the function to virtio-mmio.c is the right solution. I guess the
>> original idea was that virtio_bind() could cope with multiple transports,
>> i.e. when there is support for virtio-pci, it could choose between mmio and
>> pci on ARM, or between CCW and PCI on s390x.
> 
> That's right. If we wanted to use virtio-pci on ARM, then, after
> implementing virtio_pci_bind(), we'd change this to
> 
>    struct virtio_device *virtio_bind(u32 devid)
>    {
>        struct virtio_device *dev = virtio_mmio_bind(devid);
> 
>        if (!dev)
>            dev = virtio_pci_bind(devid);
> 
>        return dev;
>    }
> 
> Then, we'd use config selection logic in the test harness to decide how to
> construct the QEMU command line in order to choose between mmio and pci.

OK, I understand.

> 
>>
>> So maybe this should rather get an "#if defined(__arm__) ||
>> defined(__aarch64__)" instead? Drew, what's your opinion here?
> 
> Yup, but I think I'd prefer we do it in the header, like below, and
> then also implement something like the above for virtio_bind().
> 
> diff --git a/lib/virtio-mmio.h b/lib/virtio-mmio.h
> index 250f28a0d300..a0a3bf827156 100644
> --- a/lib/virtio-mmio.h
> +++ b/lib/virtio-mmio.h
> @@ -60,6 +60,13 @@ struct virtio_mmio_device {
>          void *base;
>   };
>   
> +#if defined(__arm__) || defined(__aarch64__)
>   extern struct virtio_device *virtio_mmio_bind(u32 devid);
> +#else
> +static inline struct virtio_device *virtio_mmio_bind(u32 devid)
> +{
> +        return NULL;
> +}
> +#endif
>   
>   #endif /* _VIRTIO_MMIO_H_ */
> 
> 
> Thanks,
> drew
> 

Thanks, I will modify accordingly.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
