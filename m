Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0206F49C52B
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 09:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238356AbiAZIW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 03:22:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14662 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238350AbiAZIWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 03:22:55 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20Q7khuc013832;
        Wed, 26 Jan 2022 08:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0HKj4vuGbcinAe1GzLh6aNEB1u8mvxh6oyXEwscZzS8=;
 b=je5oIOzCOR06K6HGBsLxjCBNMVMM8fm9Y8qPd+JibJiJ1gd1UDMm7gOhuLeQrGCtF/2d
 zJUeU5CWvObIohgb6Vll3EwdToUcgG4LAgWRaa2pXljuuo79qkyZ9jdtQTQWX4IidPzg
 QBClpp/KVsTJEM/UMXKo6GtTrUA85MspG9jNfZ1LFo5RefAPz+p/9mcilV1pbsq7A7zE
 xCi1QHrUjW+qux0rNjLpaKOvg5tOhPFnB7Lv+YTfZp7VPF6yO2wuKflyArMrcMwHsDoM
 f6m8YGzz5rMMZH3hOXKlUj+/0EdhiC2R69aMwaHFFl45TsPCsSdnDorzA2QWvjbSAEvG ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3du2758kyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 08:22:54 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20Q8FT5c014780;
        Wed, 26 Jan 2022 08:22:54 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3du2758ky0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 08:22:54 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20Q8L289025199;
        Wed, 26 Jan 2022 08:22:52 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9j9jhbp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 08:22:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20Q8MmHp47186372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 08:22:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCE13AE045;
        Wed, 26 Jan 2022 08:22:48 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A156DAE05A;
        Wed, 26 Jan 2022 08:22:47 +0000 (GMT)
Received: from [9.171.51.88] (unknown [9.171.51.88])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 08:22:47 +0000 (GMT)
Message-ID: <479f0342-f6f8-9bb5-6ee5-6d788dc25631@linux.ibm.com>
Date:   Wed, 26 Jan 2022 09:24:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v2 26/30] vfio-pci/zdev: wire up zPCI adapter interrupt
 forwarding support
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
 <20220114203145.242984-27-mjrosato@linux.ibm.com>
 <75c74f80-0a74-40dc-6797-473522ef2803@linux.ibm.com>
 <5f3797f7-e127-7de0-dc96-4b04e5ff839a@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <5f3797f7-e127-7de0-dc96-4b04e5ff839a@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0-qreF1s6gmw-5k7SUT5vQn5Mbw0U93G
X-Proofpoint-ORIG-GUID: kgeb6-9OH2SG9V8RsnCbafHxUt7-rDjT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_02,2022-01-25_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 lowpriorityscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 impostorscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201260044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/25/22 15:16, Matthew Rosato wrote:
> On 1/25/22 7:36 AM, Pierre Morel wrote:
>>
>>
>> On 1/14/22 21:31, Matthew Rosato wrote:
>>> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_AIF, which is a new
>>> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
>>> s390x vfio-pci device wishes to enable/disable zPCI adapter interrupt
>>> forwarding, which allows underlying firmware to deliver interrupts
>>> directly to the associated kvm guest.
>>>
>>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>>> ---
>>>   arch/s390/include/asm/kvm_pci.h  |  2 +
>>>   drivers/vfio/pci/vfio_pci_core.c |  2 +
>>>   drivers/vfio/pci/vfio_pci_zdev.c | 98 +++++++++++++++++++++++++++++++-
>>>   include/linux/vfio_pci_core.h    | 10 ++++
>>>   include/uapi/linux/vfio.h        |  7 +++
>>>   include/uapi/linux/vfio_zdev.h   | 20 +++++++
>>>   6 files changed, 138 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>>> b/arch/s390/include/asm/kvm_pci.h
>>> index dc00c3f27a00..dbab349a4a75 100644
>>> --- a/arch/s390/include/asm/kvm_pci.h
>>> +++ b/arch/s390/include/asm/kvm_pci.h
>>> @@ -36,6 +36,8 @@ struct kvm_zdev {
>>>       struct zpci_fib fib;
>>>       struct notifier_block nb;
>>>       bool interp;
>>> +    bool aif;
>>> +    bool fhost;
>>
>> Can we please have a comment on these booleans? > Can we have explicit 
>> naming to be able to follow their usage more easily?
>> May be aif_float and aif_host to match with the VFIO feature?
> 
> Sure, rename would be fine.
> 
> As for a comment, maybe something like
> 
> bool aif_float; /* Enabled for floating interrupt assist */
> bool aif_host;  /* Require host delivery */

good for me.


> 
> ...
> 
>>> diff --git a/include/uapi/linux/vfio_zdev.h 
>>> b/include/uapi/linux/vfio_zdev.h
>>> index 575f0410dc66..c574e23f9385 100644
>>> --- a/include/uapi/linux/vfio_zdev.h
>>> +++ b/include/uapi/linux/vfio_zdev.h
>>> @@ -90,4 +90,24 @@ struct vfio_device_zpci_interp {
>>>       __u32 fh;        /* Host device function handle */
>>>   };
>>> +/**
>>> + * VFIO_DEVICE_FEATURE_ZPCI_AIF
>>> + *
>>> + * This feature is used for enabling forwarding of adapter 
>>> interrupts directly
>>> + * from firmware to the guest.  When setting this feature, the flags 
>>> indicate
>>> + * whether to enable/disable the feature and the structure defined 
>>> below is
>>> + * used to setup the forwarding structures.  When getting this 
>>> feature, only
>>> + * the flags are used to indicate the current state.
>>> + */
>>> +struct vfio_device_zpci_aif {
>>> +    __u64 flags;
>>> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1
>>> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2
>>
>> I think we need more information on these flags.
>> What does AIF_FLOAT and what does AIF_HOST ?
>>
> 
> You actually asked for this already on Jan 19 :), here's a copy of that 
> response inline here:

:) I forgot

> 
> I can add a small line comment for each, like:
> 
>   AIF_FLOAT 1 /* Floating interrupts enabled */
>   AIF_HOST 2  /* Host delivery forced */
> 
> But here's a bit more detail:
> 
> On SET:
> AIF_FLOAT = 1 means enable the interrupt forwarding assist for floating 
> interrupt delivery
> AIF_FLOAT = 0 means to disable it.
> AIF_HOST = 1 means the assist will always deliver the interrupt to the 
> host and let the host inject it
> AIF_HOST = 0 host only gets interrupts when firmware can't deliver
> 
> on GET, we just indicate the current settings from the most recent SET, 
> meaning:
> AIF_FLOAT = 1 interrupt forwarding assist is currently active
> AIF_FLOAT = 0 interrupt forwarding assist is not currently active
> AIF_HOST = 1 interrupt forwarding will always go through host
> AIF_HOST = 0 interrupt forwarding will only go through the host when 
> necessary
> 
> My thought would be add the line comments in this patch and then the 
> additional detail in a follow-on patch that adds vfio zPCI to 
> Documentation/S390
> 

good for me.

-- 
Pierre Morel
IBM Lab Boeblingen
