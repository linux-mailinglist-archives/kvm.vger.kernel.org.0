Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92CF649B610
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 15:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1578552AbiAYOUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 09:20:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:18178 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357292AbiAYORA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Jan 2022 09:17:00 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20PDkY4s003547;
        Tue, 25 Jan 2022 14:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mYq5JDg13uDsrZMP6NRJGD5L60XAYIdStHtqqnfdoso=;
 b=q2EVJvRKgpdGLIUfrjffDmfUWyXv3z7UUZopsE4K6qSIDhX7Gd9LzXQn49CxP6HkAhZm
 nGmk7Uic4KWR3EkstIiInmA84WuutxN9XL4ELVDpD6KcPLgAgq2HaQKGZyoNztgt5BVg
 +R4/3AuCouregyIg5veCctWn+MAloPJyAf1SnDAPdqpucKkjLa6cADwpOPx79FL/aIs4
 7URgIRHKUDEaY2Syero83k3x53wcGIvpIwUsFEJVbrVTg1sSk58yc7afzA3FJyc80TKq
 gcHVGF17su4ElvMtCDJ+er8PAr1JYUU1L7iVlbhTOEkHZoxQMMnMjA88rsUHK6FzxOdq Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtjcwrs0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:16:56 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20PDxF4p023352;
        Tue, 25 Jan 2022 14:16:56 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dtjcwrs0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:16:56 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20PEDXRL001736;
        Tue, 25 Jan 2022 14:16:55 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3dr9jau4ep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jan 2022 14:16:55 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20PEGrYM14746196
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jan 2022 14:16:53 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 965E1C6057;
        Tue, 25 Jan 2022 14:16:53 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8058C6059;
        Tue, 25 Jan 2022 14:16:51 +0000 (GMT)
Received: from [9.163.21.206] (unknown [9.163.21.206])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 25 Jan 2022 14:16:51 +0000 (GMT)
Message-ID: <5f3797f7-e127-7de0-dc96-4b04e5ff839a@linux.ibm.com>
Date:   Tue, 25 Jan 2022 09:16:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2 26/30] vfio-pci/zdev: wire up zPCI adapter interrupt
 forwarding support
Content-Language: en-US
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
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
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <75c74f80-0a74-40dc-6797-473522ef2803@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: b4LTNCYgYA8sIBFki02fcmAy9HooTZ1l
X-Proofpoint-ORIG-GUID: ShlgW-cZmxT6p6N-TXtYw82vyYmY-keJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-25_02,2022-01-25_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201250092
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/25/22 7:36 AM, Pierre Morel wrote:
> 
> 
> On 1/14/22 21:31, Matthew Rosato wrote:
>> Introduce support for VFIO_DEVICE_FEATURE_ZPCI_AIF, which is a new
>> VFIO_DEVICE_FEATURE ioctl.  This interface is used to indicate that an
>> s390x vfio-pci device wishes to enable/disable zPCI adapter interrupt
>> forwarding, which allows underlying firmware to deliver interrupts
>> directly to the associated kvm guest.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h  |  2 +
>>   drivers/vfio/pci/vfio_pci_core.c |  2 +
>>   drivers/vfio/pci/vfio_pci_zdev.c | 98 +++++++++++++++++++++++++++++++-
>>   include/linux/vfio_pci_core.h    | 10 ++++
>>   include/uapi/linux/vfio.h        |  7 +++
>>   include/uapi/linux/vfio_zdev.h   | 20 +++++++
>>   6 files changed, 138 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h 
>> b/arch/s390/include/asm/kvm_pci.h
>> index dc00c3f27a00..dbab349a4a75 100644
>> --- a/arch/s390/include/asm/kvm_pci.h
>> +++ b/arch/s390/include/asm/kvm_pci.h
>> @@ -36,6 +36,8 @@ struct kvm_zdev {
>>       struct zpci_fib fib;
>>       struct notifier_block nb;
>>       bool interp;
>> +    bool aif;
>> +    bool fhost;
> 
> Can we please have a comment on these booleans? > Can we have explicit naming to be able to follow their usage more easily?
> May be aif_float and aif_host to match with the VFIO feature?

Sure, rename would be fine.

As for a comment, maybe something like

bool aif_float; /* Enabled for floating interrupt assist */
bool aif_host;  /* Require host delivery */

...

>> diff --git a/include/uapi/linux/vfio_zdev.h 
>> b/include/uapi/linux/vfio_zdev.h
>> index 575f0410dc66..c574e23f9385 100644
>> --- a/include/uapi/linux/vfio_zdev.h
>> +++ b/include/uapi/linux/vfio_zdev.h
>> @@ -90,4 +90,24 @@ struct vfio_device_zpci_interp {
>>       __u32 fh;        /* Host device function handle */
>>   };
>> +/**
>> + * VFIO_DEVICE_FEATURE_ZPCI_AIF
>> + *
>> + * This feature is used for enabling forwarding of adapter interrupts 
>> directly
>> + * from firmware to the guest.  When setting this feature, the flags 
>> indicate
>> + * whether to enable/disable the feature and the structure defined 
>> below is
>> + * used to setup the forwarding structures.  When getting this 
>> feature, only
>> + * the flags are used to indicate the current state.
>> + */
>> +struct vfio_device_zpci_aif {
>> +    __u64 flags;
>> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1
>> +#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2
> 
> I think we need more information on these flags.
> What does AIF_FLOAT and what does AIF_HOST ?
> 

You actually asked for this already on Jan 19 :), here's a copy of that 
response inline here:

I can add a small line comment for each, like:

  AIF_FLOAT 1 /* Floating interrupts enabled */
  AIF_HOST 2  /* Host delivery forced */

But here's a bit more detail:

On SET:
AIF_FLOAT = 1 means enable the interrupt forwarding assist for floating 
interrupt delivery
AIF_FLOAT = 0 means to disable it.
AIF_HOST = 1 means the assist will always deliver the interrupt to the 
host and let the host inject it
AIF_HOST = 0 host only gets interrupts when firmware can't deliver

on GET, we just indicate the current settings from the most recent SET, 
meaning:
AIF_FLOAT = 1 interrupt forwarding assist is currently active
AIF_FLOAT = 0 interrupt forwarding assist is not currently active
AIF_HOST = 1 interrupt forwarding will always go through host
AIF_HOST = 0 interrupt forwarding will only go through the host when 
necessary

My thought would be add the line comments in this patch and then the 
additional detail in a follow-on patch that adds vfio zPCI to 
Documentation/S390

